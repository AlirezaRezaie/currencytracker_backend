import os
import socket
import json
from locals import local
import pickle

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

        try:
            self.currency_info = currency_obj.get("currency_info")
            self.channel_info = currency_obj.get("list_of_channels", [])[channel_index]
            self.channel_id = self.channel_info.get("channel_name")

        except IndexError:
            self.channel_info = ""
            self.channel_id = ""


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


def add_price_to_pickle(pickle_name, price, scope_type=None):
    """
    adds a price to the specified pickle file
    returns the latest changed pickle object
    """

    try:
        with open(f"pickles/{pickle_name}.pkl", "rb") as file:
            board = pickle.load(file)
    except:
        if scope_type:
            board = {"local": [], "global": []}
        else:
            board = {}

    if scope_type:
        select_board = board[scope_type]
    else:
        board.setdefault(pickle_name, [])
        select_board = board.get(pickle_name)

    # print(len(select_board))
    if len(select_board) > 20:
        select_board.pop(0)
    select_board.append(price)

    # Save the updated data back to the file
    with open(f"pickles/{pickle_name}.pkl", "wb") as file:
        pickle.dump(board, file)

    return select_board


def get_pickle_data(pickle_file_name):
    try:
        with open(f"pickles/{pickle_file_name}.pkl", "rb") as file:
            existing_board = pickle.load(file)
            return existing_board
    except:
        return {}


def get_tgju_data(asset_type, currency_symbol, data=None):
    defaults_data = None
    if hasattr(local, "default_channels"):
        defaults_data = local.default_channels
    elif data:
        defaults_data = data
    else:
        raise ValueError(
            "please specify the default data since there is no data in local"
        )

    tgju_currency_list = defaults_data["TGJU"]["list_of_channels"][0]["currency_list"][
        asset_type
    ]

    currency_data = defaults_data.get(currency_symbol)
    if (currency_data and not currency_data["list_of_channels"]) or (not currency_data):
        for currency in tgju_currency_list:
            if currency.get("currency_symbol") == currency_symbol:
                return currency.get("code")

    return None


def get_running_tg_obj(currency_data):
    if not currency_data:
        return None
    channel_list = currency_data.get("list_of_channels", [])
    for obj in channel_list:
        if obj["nonstop"] and obj["type"] == "tg":
            return obj
    return None


def push_in_board(item, board):
    latests = board["latests"]
    limit = board["limit"]

    if len(latests) > limit:
        latests.pop(0)
        latests.append(item)
    else:
        latests.append(item)
