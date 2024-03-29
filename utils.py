import os
import socket
import json
from locals import local
import pickle
import datetime
import glob

# Define a hardcoded admin username and password (for demonstration purposes)
ADMIN_USERNAME = "admin"
ADMIN_PASSWORD = "admin_password"

time_of_day = 0

def create_json_data(
    code,
    price,
    persian_name,
    image_link,
    posttime,
    rateofchange,
    action=None,
    exchtype=None,
    change=None,
):
    data = {
        "code": code,
        "action": action,
        "price": price,
        "persian_name": persian_name,
        "image_link": image_link,
        "exchtype": exchtype,
        "posttime": posttime,
        "rateofchange": rateofchange,
        "change": change,
    }
    return data


# args object for task configs
class Arg:
    def __init__(
        self,
        code,
        currency_obj,
        channel_code=None,
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
            self.channel_info = currency_obj
            self.channel_id = self.channel_info.get("channel_name")

        except IndexError:
            self.channel_info = ""
            self.channel_id = ""


def get_host():
    return socket.gethostname()


def get_port():
    return os.getenv("PORT", default=5228)


def get_defaults():
    print(get_port())
    print("reading the default configs!!!!")
    # read the json file
    with open("default-channels.json", "r") as f:
        return json.load(f)


def add_price_to_pickle(pickle_name, price, code=None):
    """
    adds a price to the specified pickle file
    returns the latest changed pickle object
    """

    if not code:
        code = pickle_name

    try:
        with open(f"pickles/{pickle_name}.pkl", "rb") as file:
            board = pickle.load(file)
    except:
        board = {}

    board.setdefault(code, [])
    select_board = board.get(code)

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
    
def get_all_pickles():
    except_crypto = list(local.default_channels["CRYPTO"]["currency_list"].keys())
    all_pickle_files = glob.glob("pickles/*.pkl")
    all_pickles_data = []
    # Read each file one by one
    for file_name in all_pickle_files:
        only_name = os.path.splitext(os.path.basename(file_name))[0]
        if only_name in except_crypto: continue
        with open(file_name, 'rb') as file:
            data = pickle.load(file)
            # Do something with the data from the file
            # For example, print it or process it further

            all_pickles_data.append(list(data.values())[0][-1])

    return  all_pickles_data


def convert_tgju_data(code, persian_name, image_link, data):
    parsed_data = data.split("|")

    price = float(parsed_data[1].replace(",", ""))
    rate_of_change = float(parsed_data[6])
    change = parsed_data[7]
    time = parsed_data[8]
    print(time)
    json_data = create_json_data(
        code, price, persian_name, image_link, time, rate_of_change, change=change
    )

    return json_data


def push_in_board(item, board):
    latests = board["latests"]
    limit = board["limit"]

    if len(latests) > limit:
        latests.pop(0)
        latests.append(item)
    else:
        latests.append(item)


