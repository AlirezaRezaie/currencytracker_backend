import threading
import asyncio
import json
from modes import run_live

tasks = []


# args object for task configs
class Arg:
    def __init__(
        self, channel_id, count=None, timeout=None, retry=None, fetchrate=None
    ):
        self.channel_id = channel_id
        self.timeout = timeout
        self.retry = retry
        self.fetchrate = fetchrate
        self.count = count


class Task:
    def __init__(self, channel_id, loop=None):
        """
        TODO : this might return error or None as memory limit reaches
        """
        self.main_loop = loop
        self.channel_id = channel_id
        self.args = Arg(channel_id)
        self.users = []
        self.stop_event = threading.Event()
        self.lastprice = None
        try:
            self.task = self.create_task()
        except:
            print("error creating thread maybe low memory")
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
        self.task.join()
        self.task = None
        tasks.remove(self)
        print("task removed because lack of users")


def get_task(id):
    for task in tasks:
        if task.channel_id == id:
            return task
    return None


def disconnect_websocket(task, websocket):
    task.users.remove(websocket)
    if len(task.users) < 1:
        task.stop()


async def send_data_to_clients(new_data, clients):
    for client in clients:
        await client.send_text(json.dumps(new_data))


async def disconnect_clients(task, clients):
    for client in clients:
        await client.send_text("wrong id")
        await client.close()
        disconnect_websocket(task, client)


def error_callback(id):
    task = get_task(id)
    users = task.users
    loop = task.main_loop
    loop.create_task(disconnect_clients(task, users))


def price_callback(price, channel):
    print(price, channel)
    task = get_task(channel)
    task.lastprice = price
    users = task.users
    asyncio.run(send_data_to_clients(price, users))
