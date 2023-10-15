import threading
from locals import local
import json
from modes import run_live, run_websocket
from logs import logger
from utils import push_in_board, Arg

# this is the global board every currency update gets saved to this board
global_board = {"latests": [], "limit": 20}
crypto_board = {"latests": [], "limit": 20}
boards = {}

# since every task (thread) might change the value of global_board
# we will create a lock to ensure no conflict
lock = threading.Lock()

# all running tasks list
tasks = []


class Task:
    """
    ## the import live task class\n
    upon creation it will create and start a thread\n
    it also has a `users` list to have more control on it
    """

    def __init__(self, code, currency_type=None, loop=None, channel_index=0):
        """
        TODO : this might return error or None as memory limit reaches
        """
        self.main_loop = loop
        self.args = Arg(
            code,
            websocket_currency_type=currency_type,
            loop=loop,
            channel_index=channel_index,
        )

        self.ws_users = {}
        self.users = []

        self.stop_event = threading.Event()
        self.lastprice = None

        try:
            # creates a new Thread and pass it required arguments
            self.task = self.create_task()
        except:
            logger.critical("error creating thread maybe low memory")
            return None

        # automatically append its task to the list of tasks
        tasks.append(self)
        # and start it
        self.start_task()

    def create_task(self):
        if self.args.channel_info["type"] == "wbsock":
            mode = run_websocket
            call_back = ws_call_back
        else:
            mode = run_live
            call_back = success_callback
        return threading.Thread(
            target=mode,
            args=(call_back, error_callback, self.stop_event, self.args),
        )

    def start_task(self):
        if self.task:
            self.task.start()
        else:
            self.task = self.create_task()
            self.task.start()

    def stop(self):
        if self in tasks:
            self.stop_event.set()
            try:
                # wait for it to fully close
                self.task.join()
            except Exception as e:
                print(e)
                print("cant stop current thread")
            logger.info(f"removing {self.task.name} because no one is using it")

            tasks.remove(self)
        else:
            print("already closed or doesnt even exist")


def get_task(code) -> Task:
    """
    Returns:
        returns the existing task based on `code`
    """
    for task in tasks:
        if task.args.code == code:
            return task
    return None


def get_all_tasks_subbed_in(user):
    all_tasks = []
    for task in tasks:
        if user in task.users:
            all_tasks.append(task)
    return all_tasks


def disconnect_websocket(websocket, user_type=None, task=None):
    """
    removes the user from the specified task if one is mention
    and removes the user from every task available if no task
    is mentioned
    """
    user_tasks = []
    if not task:
        # if not specified which task to unsubscribe from unsub it from every task
        user_tasks = get_all_tasks_subbed_in(websocket)
    else:
        user_tasks.append(task)

    for task in user_tasks:
        task.users.remove(websocket)
        logger.info(
            f"removing {websocket.client.host}:{websocket.client.port} from {task.args.code}"
        )
        if len(task.users) < 1 and not task.args.channel_info["nonstop"]:
            task.stop()

    websocket_task = get_task("TGJU")

    # if not websocket_task.ws_users.get(user_type):
    #    return

    if user_type:
        task.ws_users[user_type].remove(websocket)
        logger.info(
            f"removing {websocket.client.host}:{websocket.client.port} from TGJU {user_type}"
        )

    else:
        for key, users in websocket_task.ws_users.items():
            if websocket in users:
                websocket_task.ws_users[key].remove(websocket)
                logger.info(
                    f"removing {websocket.client.host}:{websocket.client.port} from TGJU {key}"
                )


def baked_data(local_board, is_crypto):
    """
    creates a nice output data for the user this is the last place we make change to the data
    its the thing user will see at the front
    """
    # indicating which board to use based on the is crypto value
    g_board = crypto_board if is_crypto else global_board
    return json.dumps({"global": g_board, "local": local_board})


async def send_data_to_clients(data, clients):
    for client in clients:
        await client.send_text(data)


async def notify_error_to_all(error_msg, all_clients):
    for client in all_clients:
        await client.send_text(error_msg)


def error_callback(code):
    task = get_task(code)

    # disconnect_websocket(,task=task)
    # task.stop()

    if task.main_loop:
        task.main_loop.create_task(notify_error_to_all("wrong id bruh", task.users))


def ws_call_back(price, type):
    task = get_task("TGJU")

    boards.setdefault(type, [])
    select_board = boards.get(type)

    if len(select_board) > 20:
        select_board.pop(0)
        select_board.append(price)
    else:
        select_board.append(price)

    data = json.dumps({type: select_board})

    # task.ws_users.setdefault(type,[])
    if task.main_loop:
        task.main_loop.create_task(send_data_to_clients(data, task.ws_users[type]))


def success_callback(local_board, channel):
    task = get_task(channel)
    is_crypto = local.args.currency_info.get("is_crypto")
    new_price = local_board["latests"][-1]

    # only log if its not crypto because it updates so much
    if not is_crypto:
        logger.info(f"request:\n{new_price} from channel {channel}")

    task.lastprice = local_board

    g_board = crypto_board if is_crypto else global_board
    with lock:
        push_in_board(new_price, g_board)
    users = task.users

    if task.main_loop:
        task.main_loop.create_task(
            send_data_to_clients(baked_data(local_board, is_crypto), users)
        )
    else:
        logger.debug("new data recieved but there is to give it to ")
    # this was the previous approach use this if the current one conflicts
    # asyncio.run(send_data_to_clients(local_board, users))
