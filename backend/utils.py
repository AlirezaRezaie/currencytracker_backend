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
        channel_index=0,
        count=None,
        timeout=None,
        retry=None,
        fetchrate=None,
    ):
        self.code = code
        self.timeout = timeout
        self.retry = retry
        self.fetchrate = fetchrate
        self.count = count

        if hasattr(local, "default_channels"):
            default_channels = local.default_channels
        else:
            default_channels = get_defaults()

        currency_obj = default_channels[code]
        self.currency_info = currency_obj.get("currency_info")
        self.channel_info = currency_obj.get("list_of_channels")[channel_index]
        self.channel_id = self.channel_info.get("channel_name")


def get_host():
    return socket.gethostname()


def get_port():
    return os.getenv("PORT", default=5000)


def get_defaults():
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
