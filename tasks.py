import threading
import json
from modes import run_live, run_websocket
from logs import logger
from utils import (
    push_in_board,
    add_price_to_pickle,
    Arg,
)
import asyncio
from queue import Queue
import websockets.exceptions  # Import the specific exception

# this is the global board every currency update gets saved to this board
global_board = {"latests": [], "limit": 20}
crypto_board = {}
ws_boards = {}

# initializing the symbol map

# since every task (thread) might change the value of global_board
# we will create a lock to ensure no conflict
lock = threading.Lock()

# all running tasks list
tasks = []

# all users 
global_users = []

class Task:
    """
    ## the import live task class\n
    upon creation it will create and start a thread\n
    it also has a `users` list to have more control on it
    """
    global_loop = None
    def __init__(
        self, code, currency_obj, channel_code=None, loop=None
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
        )

        self.ws_users = {}
        self.users = []
        self.queue = Queue()
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
                args = (
                    ws_call_back,
                    error_callback,
                    self.stop_event,
                    self.args,
                )
            case "CRYPTO":
                mode = run_live
                args = (
                    crypto_call_back,
                    error_callback,
                    self.stop_event,
                    True,
                    self.args,
                )

            case _:
                mode = run_live
                args = (
                    success_callback,
                    error_callback,
                    self.stop_event,
                    False,
                    self.args,
                )

        return threading.Thread(
            target=mode,
            args=args,
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
            logger.info(f"removing {self.args.code} because no one is using it")

            tasks.remove(self)
        else:
            print("already closed or doesnt even exist")


def get_all_user_list():
    all_user_lists = []
    for task in tasks:
        if task.users:
            all_user_lists.append(
                {
                    "type": f"{task.args.code}",
                    "users": task.users}
                )
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


async def send_to_all(msg, all_clients):
    data = json.dumps(msg)
    tasks = [client.send_text(data) for client in all_clients]

    try:
        await asyncio.gather(*tasks, return_exceptions=True)
    except websockets.exceptions.ConnectionClosedError as e:
        # Handle the error, log it, or perform any necessary actions
        print(f"Connection closed error: {e}")
    except Exception as e:
        # Handle other exceptions if needed
        print(f"An error occurred: {e}")


def error_callback(code):
    task = get_task(code)

    # disconnect_websocket(,task=task)
    # task.stop()

    if Task.global_loop:
        Task.global_loop.create_task(send_to_all("wrong id", task.users))


def crypto_call_back(price, type):
    task = get_task(type)
    select_board = add_price_to_pickle(type, price)

    json_data = {type: select_board}

    if Task.global_loop:
        Task.global_loop.create_task(send_to_all(json_data, task.users))


def ws_call_back(price, type):
    task = get_task("TGJU")
    currency_code = price["code"]
    select_board = add_price_to_pickle(type, price, code=currency_code)

    # we should also create a task that saves the entry inside the sqlite for later usage
    json_data = {currency_code: select_board}
    global_data ={"global":[select_board[-1]]}
    if Task.global_loop:
        # send to channel subscribed users
        Task.global_loop.create_task(send_to_all(global_data,global_users))
        Task.global_loop.create_task(send_to_all(json_data, task.ws_users[type]))


def success_callback(local_board, channel):
    task = get_task(channel)
    new_price = local_board["latests"][-1]

    task.lastprice = local_board

    with lock:
        push_in_board(new_price, global_board)
    users = task.users

    # data = json.dumps({"global": global_board, "local": local_board})
    select_board = add_price_to_pickle(channel, new_price)

    json_data = {channel: select_board}
    global_data ={"global":[select_board[-1]]}
    

    if Task.global_loop:
        Task.global_loop.create_task(send_to_all(global_data,global_users))
        Task.global_loop.create_task(send_to_all(json_data, users))
    else:
        logger.debug("new data recieved but there is to give it to ")
    # this was the previous approach use this if the current one conflicts
    # asyncio.run(send_data_to_clients(local_board, users))
