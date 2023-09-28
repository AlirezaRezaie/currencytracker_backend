import threading
from locals import local
import json
from modes import run_live
from logs import logger
from utils import push_in_board, Arg

# this is the global board every currency update gets saved to this board
global_board = {"latests": [], "limit": 20}
crypto_board = {"latests": [], "limit": 20}
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

    def __init__(self, code, loop=None, channel_index=0):
        """
        TODO : this might return error or None as memory limit reaches
        """
        self.main_loop = loop
        self.args = Arg(code, channel_index=channel_index)
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
        return threading.Thread(
            target=run_live,
            args=(success_callback, error_callback, self.stop_event, self.args),
        )

    def start_task(self):
        if self.task:
            self.task.start()
        else:
            self.task = self.create_task()
            self.task.start()

    def stop(self):
        self.stop_event.set()
        try:
            # wait for it to fully close
            self.task.join()
        except:
            print("cant stop current thread")
        logger.info(f"removing {self.task.name} because no one is using it")
        tasks.remove(self)


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


def disconnect_websocket(websocket, task=None):
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
        logger.info(f"removing the user from {task.args.code}")
        task.users.remove(websocket)

        if len(task.users) < 1 and not task.args.channel_info["nonstop"]:
            task.stop()


def baked_data(local_board, is_crypto):
    """
    creates a nice output data for the user this is the last place we make change to the data
    its the thing user will see at the front
    """
    # indicating which board to use based on the is crypto value
    g_board = crypto_board if is_crypto else global_board
    print(g_board)
    return json.dumps({"global": g_board, "local": local_board})


async def send_data_to_clients(data, clients):
    for client in clients:
        await client.send_text(data)


async def notify_error_to_all(error_msg, all_clients):
    for client in all_clients:
        await client.send_text(error_msg)


def error_callback(code):
    task = get_task(code)
    task.stop()

    if task.main_loop:
        task.main_loop.create_task(notify_error_to_all("wrong id bruh", task.users))


def success_callback(local_board, channel):
    task = get_task(channel)
    is_crypto = local.args.currency_info.get("is_crypto")

    # only log if its not crypto because it updates so much
    if not is_crypto:
        logger.info(f"request:\n{local_board} from channel {channel}")

    new_price = local_board["latests"][-1]
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
