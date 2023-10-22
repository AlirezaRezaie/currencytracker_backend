import os
import socket
import json
from locals import local

# Define a hardcoded admin username and password (for demonstration purposes)
ADMIN_USERNAME = "admin"
ADMIN_PASSWORD = "admin_password"


# args object for task configs
class Arg:
    def __init__(
        self,
        code,
        currency_obj,
        channel_code=None,
        channel_index=0,
        loop=None,
        count=None,
        timeout=None,
        retry=None,
        fetchrate=None,
    ):
        self.code = code
        self.channel_code = channel_code
        self.loop = loop
        self.timeout = timeout
        self.retry = retry
        self.fetchrate = fetchrate
        self.count = count
        self.websocket_currency_type = None

        if hasattr(local, "default_channels"):
            default_channels = local.default_channels
        else:
            default_channels = get_defaults()

        self.currency_info = currency_obj.get("currency_info")
        self.channel_info = currency_obj.get("list_of_channels")[channel_index]
        self.channel_id = self.channel_info.get("channel_name")


def get_host():
    return socket.gethostname()


def get_port():
    return os.getenv("PORT", default=5000)


def get_defaults():
    print(get_port())
    print("reading the default configs!!!!")
    # read the json file
    with open("default-channels.json", "r") as f:
        return json.load(f)


def push_in_board(item, board):
    latests = board["latests"]
    limit = board["limit"]

    if len(latests) > limit:
        latests.pop(0)
        latests.append(item)
    else:
        latests.append(item)
