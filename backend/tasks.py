import threading
import asyncio
import json
from modes import run_live
from logs import logger
from locals import local
from settings import get_defaults
tasks = []


# args object for task configs
class Arg:
    def __init__(self, code,count=None, timeout=None, retry=None, fetchrate=None):
        self.code = code
        self.timeout = timeout
        self.retry = retry
        self.fetchrate = fetchrate
        self.count = count

        try:
            default_channels = local.default_channels
        except:
            default_channels = get_defaults()

        self.channel_info = default_channels[code][0]
        self.channel_id = self.channel_info["channel_name"]


class Task:
    def __init__(self, code, loop=None):
        """
        TODO : this might return error or None as memory limit reaches
        """
        self.main_loop = loop
        self.args = Arg(code)
        self.users = []
        self.stop_event = threading.Event()
        self.lastprice = None

        try:
            self.task = self.create_task()
        except:
            logger.critical("error creating thread maybe low memory")
            return None

        tasks.append(self)
        self.start_task()

    def create_task(self):
        return threading.Thread(
            target=run_live,
            args=(price_callback, error_callback, self.stop_event, self.args),
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
            self.task.join()
        except:
            print("cant stop current thread")
        logger.info(f"removing {self.task.name} because no one is using it")
        self.task = None
        tasks.remove(self)


def get_task(code):
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


async def send_data_to_clients(new_data, clients):
    for client in clients:
        await client.send_text(json.dumps(new_data))


async def notify_error_to_all(error_msg, all_clients):
    for client in all_clients:
        await client.send_text(error_msg)


def error_callback(code):
    task = get_task(code)
    task.stop()
    task.main_loop.create_task(notify_error_to_all("wrong id bruh", task.users))


def price_callback(price, channel):
    task = get_task(channel)
    logger.info(f"request:\n{price} from channel {channel}")
    task.lastprice = price
    users = task.users
    asyncio.run(send_data_to_clients(price, users))
