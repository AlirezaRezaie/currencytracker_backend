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


def add_price_to_pickle(pickle_name, price, code=None):
    global time_of_day
    """
    adds a price to the specified pickle file
    returns the latest changed pickle object
    """
    
    # reset the usd pickle if day changed
    new_day = datetime.datetime.today().weekday()
    if new_day > time_of_day:
        # means the day changed so we reset the pickle
        os.remove("pickles/USD.pkl")
        time_of_day = new_day

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
    all_pickle_files = glob.glob("pickles/*.pkl")
    all_pickles_data = []
    # Read each file one by one
    for file_name in all_pickle_files:
        with open(file_name, 'rb') as file:
            data = pickle.load(file)
            # Do something with the data from the file
            # For example, print it or process it further

            all_pickles_data.append(list(data.values())[0][-1])

    return  all_pickles_data



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


def convert_tgju_data(code, persian_name, image_link, data):
    parsed_data = data.split("|")

    price = float(parsed_data[1].replace(",", ""))
    rate_of_change = float(parsed_data[6])
    change = parsed_data[7]
    time = parsed_data[8]

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


