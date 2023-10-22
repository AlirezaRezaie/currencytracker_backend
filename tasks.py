import threading
from locals import local
import json
from modes import run_live, run_websocket
from logs import logger
from utils import push_in_board, Arg
import asyncio
import pickle

# this is the global board every currency update gets saved to this board
global_board = {"latests": [], "limit": 20}
crypto_board = {}
ws_boards = {}

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

    def __init__(
        self, code, currency_obj, channel_code=None, loop=None, channel_index=0
    ):
        """
        TODO : this might return error or None as memory limit reaches
        """
        self.main_loop = loop
        self.args = Arg(
            code,
            currency_obj,
            channel_code=channel_code,
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
        match self.args.channel_code:
            case "TGJU":
                mode = run_websocket
                call_back = ws_call_back
            case "CRYPTO":
                mode = run_live
                call_back = crypto_call_back

            case _:
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


def get_all_user_list():
    all_user_lists = []
    for task in tasks:
        if task.users:
            all_user_lists.append({"type": "TGCURRENCY", "users": task.users})
        elif task.ws_users:
            for channel_name, channel_list in task.ws_users.items():
                all_user_lists.append(
                    {
                        "type": f"{task.args.code}:{channel_name}",
                        "users": channel_list,
                    }
                )
        # else:
        #    logger.info(f"task {task.args.code} doesnt have any users")
    return all_user_lists


def get_lists_user_joined(websocket):
    user_lists = []
    all_lists = get_all_user_list()
    for users_obj in all_lists:
        if websocket in users_obj.get("users"):
            user_lists.append(users_obj)
    return user_lists


def get_task(code) -> Task:
    """
    Returns:
        returns the existing task based on `code`
    """
    for task in tasks:
        if task.args.code == code:
            return task
    return None


# def get_all_tasks_subbed_in(user):
#    all_user_lists = []
#    for task in tasks:
#        if user in task.users:
#            all_tasks.append(task)
#    return all_tasks


def disconnect_websocket(websocket, user_type=None, user_list=None):
    """
    removes the user from the specified task if one is mention
    and removes the user from every task available if no task
    is mentioned
    """
    if not user_list:
        # if not specified which task to unsubscribe from unsub it from every task
        all_lists = get_lists_user_joined(websocket)
        for list_of_users in all_lists:
            users = list_of_users.get("users")
            task_name = list_of_users.get("type")
            users.remove(websocket)
            logger.info(
                f"removing {websocket.client.host}:{websocket.client.port} from {task_name}"
            )
    else:
        user_list.remove(websocket)
        logger.info(
            f"removing {websocket.client.host}:{websocket.client.port} from {user_type}"
        )


def baked_data(local_board):
    """
    creates a nice output data for the user this is the last place we make change to the data
    its the thing user will see at the front
    """
    # indicating which board to use based on the is crypto value
    return json.dumps({"global": global_board, "local": local_board})


async def send_to_all(error_msg, all_clients):
    tasks = [client.send_text(error_msg) for client in all_clients]
    await asyncio.gather(*tasks)


def error_callback(code):
    task = get_task(code)

    # disconnect_websocket(,task=task)
    # task.stop()

    if task.main_loop:
        task.main_loop.create_task(send_to_all("wrong id bruh", task.users))


def crypto_call_back(price, type):
    task = get_task(type)
    crypto_board.setdefault(type, [])
    select_board = crypto_board.get(type)

    # print(len(select_board))
    if len(select_board) > 20:
        select_board.pop(0)
        select_board.append(price)
    else:
        select_board.append(price)

    # Save the updated data back to the file
    with open("CRYPTO.pkl", "wb") as file:
        pickle.dump(crypto_board, file)

    json_data = {type: select_board}
    data = json.dumps(json_data)
    if task.main_loop:
        task.main_loop.create_task(send_to_all(data, task.users))


def ws_call_back(price, type):
    task = get_task("TGJU")

    ws_boards.setdefault(type, [])
    select_board = ws_boards.get(type)

    if len(select_board) > 20:
        select_board.pop(0)
        select_board.append(price)
    else:
        select_board.append(price)

    # Load the existing data from the file
    # with open("my_objects.pkl", "rb") as file:
    #    existing_data = pickle.load(file)

    # Save the updated data back to the file
    with open("TGJU.pkl", "wb") as file:
        pickle.dump(ws_boards, file)

    # we should also create a task that saves the entry inside the sqlite for later usage
    json_data = {type: select_board}
    data = json.dumps(json_data)

    # task.ws_users.setdefault(type,[])
    if task.main_loop:
        task.main_loop.create_task(send_to_all(data, task.ws_users[type]))


def success_callback(local_board, channel):
    task = get_task(channel)
    new_price = local_board["latests"][-1]

    task.lastprice = local_board

    with lock:
        push_in_board(new_price, global_board)
    users = task.users

    data = json.dumps({"global": global_board, "local": local_board})

    if task.main_loop:
        task.main_loop.create_task(send_to_all(baked_data(local_board), users))
    else:
        logger.debug("new data recieved but there is to give it to ")
    # this was the previous approach use this if the current one conflicts
    # asyncio.run(send_data_to_clients(local_board, users))
