from network import *
from price import extract_prices
from logs import logger
from locals import local
from utils import push_in_board, convert_tgju_data, Arg
import threading
import websocket

gold_map = {}
currency_map = {}
currency_map_rev = {}

# How To Use:

# the run_live and the counter_live functions must have a an args instance
# passed to them its some general configs for the tasks


# each currency has a type of either these three
# API TG or WEB
# since they are completly different i have to use a different fetch
# method for each of them
def get_fetch_function():
    match local.channel_info["type"]:
        case "api":
            func = fetch_price_data_u_public_api
        case "tg":
            func = fetch_price_data_u_preview_page
        case "web":
            func = fetch_price_data_u_web_scrape
    return func


# the type websocket needs a whole another task for itself
def run_websocket(success_callback, error_callback, stop_event, args: Arg):
    endpoint = args.channel_info["endpoint"]
    currency_list = args.channel_info["currency_list"]

    tgju_currencies = currency_list["CURRENCY"]
    tgju_golds = currency_list["GOLD"]

    for currency, gold in zip(tgju_currencies, tgju_golds):
        currency_map[currency["code"]] = currency["currency_symbol"]
        currency_map_rev[currency["currency_symbol"]] = currency["code"]
        gold_map[gold["code"]] = gold["name"]

    def websocket_terminator_sub_task(event, ws):
        while True:
            if event.is_set() or ws.has_done_teardown:
                print("tear down")
                ws.close()
                break

    def on_message(ws, message):
        json_data = json.loads(message)
        data = json_data["result"]["data"]["data"]

        for item in data:
            name, price = item.split("|||")
            _, _, channel = name.split("|")

            currency_symbol = currency_map.get(channel)
            gold_name = gold_map.get(channel)

            if currency_symbol:
                for obj in tgju_currencies:
                    if obj.get("code") == channel: currency_info = obj

                symbol = currency_symbol
                name = currency_info["name"]
                image_link =  args.channel_info["image_link"]
            elif gold_name:
                symbol = channel
                name = gold_name
                image_link = ""
            else:
                symbol = None
                image_link = ""

            if symbol and name:
                data = convert_tgju_data(symbol, name, image_link, price)
                success_callback(data, channel)

    def on_error(ws, error):
        # print(f"Error: {error}")
        logger.error(error)
        # error_callback(args.code)

    def on_close(ws, close_status_code, close_msg):
        logger.info("Websocket Connection Closed")
        logger.info(f"close code: {close_status_code}, close message: {close_msg}")

    def on_open(ws):
        logger.info("Connected to WebSocket")
        # You can send a message here if needed
        ws.send('{"params":{"name":"js"},"id":1}')
        ws.send('{"method":1,"params":{"channel":"tgju:stream"},"id":2}')

    while not stop_event.is_set():
        try:
            # Create a WebSocket instance
            ws = websocket.WebSocketApp(
                endpoint,
                on_message=on_message,
                on_close=on_close,
                # on_error=on_error,
                on_open=on_open,
            )
            terminator = threading.Thread(
                target=websocket_terminator_sub_task, args=(stop_event, ws)
            )
            terminator.start()
            ws.run_forever()
            terminator.join()
        except:
            print("error accoured in webscoket task")
    # print("exit websocket")


# run live task the main inner workings of the app is in here
# recieves success and error callback and sends data to them
# respectivly.
# the stop event could be turned on everywhere in the code
# therefore stop the task immedietly
def run_live(success_callback, error_callback, stop_event, only_price, args: Arg):
    # storing important data about the channel in the thread local
    local.channel_id = args.channel_id
    local.channel_info = args.channel_info
    local.args = args
    local.server_mode = "live"
    local.stop_event = stop_event

    fetch_function = get_fetch_function()

    # the local board will be used to push data in it and send it to user
    # (you can try to change its limit and it will cause it to store more prices)
    local_board = {"latests": [], "code": args.code, "limit": 20}

    # this store the previous batch of prices that had been fetched
    # it is used to determine if there were price update between the
    # current and prev batch
    prev_batch = []
    last_price = None
    # search patience its an integer that determines how much to search the channel for a price
    patience = 4

    while not stop_event.is_set():
        # we use this to reset the fetch function every time to fetch the latest cause its live
        local.last_post_number = 0
        current_batch = None
        # we fetch untill we reach some prices we can change the patience to be
        # more it will search more messages
        for _ in range(patience):
            current_batch = extract_prices(fetch_function(), reverse=True)
            if current_batch:
                break

        # if its not a list or the list is empty then its not
        # a valid channel and we should report it via error callback
        if not type(current_batch) == list:
            error_callback(args.code)
            break

        # if there is no previous batch assign it to the current batch
        if not prev_batch:
            prev_batch = current_batch

        # determine last message in the current batch because of this:
        # ex. [78,98,23,(64,18,56,21)] first batch
        #     [(64,18,56,21),12,65,74]  second batch
        #     now we will use the the fisrt batch last price to determine the new updates in the second batch
        #     the new updates are after the fist batch last price in the second batch like this:
        #              12 , 65 , 74 NEW UPDATES :)
        for price in current_batch:
            if price == prev_batch[-1]:
                last_price_in_current_batch = current_batch.index(price)

        # if the last price of the prev batch is also in the current batch
        if last_price_in_current_batch is not None:
            # get the new prices
            new_prices = current_batch[last_price_in_current_batch:]
            # loop through them
            for price in new_prices:
                # send it to the user only if the price is not the last price that has been sent
                if not price == last_price:
                    # based on previous price we set the rate of change for current price
                    price.calculate_and_set_rate_of_change(last_price)
                    # create json data
                    to_user = price.get_json_data()
                    if only_price:
                        data = to_user
                    else:
                        data = local_board
                        # push the json data in the local board
                        push_in_board(to_user, local_board)
                    # send off the local board
                    success_callback(data, args.code)
                    # and now this will be the last price for the next iteration
                    last_price = price

                # the else of this statement would be if the price hasnt changed
        else:
            # since we must have a last price this should never happen
            logger.error("something went wrong")

        # and also set the prev batch for next iteration
        prev_batch = current_batch

    logger.info(f"{args.code} task exited the loop")


def run_counter(args: Arg):
    # storing important data about the channel in the thread local
    local.channel_id = args.channel_info["channel_name"]
    local.channel_info = args.channel_info
    local.args = args
    local.server_mode = "count"

    # get the fetch function
    fetch_function = get_fetch_function()
    # we set the this only once for the counter because it will increment based on the `count`
    local.last_post_number = 0
    # prices to be returned (should be `count` sized)
    full_prices = []
    # used for calculating the rate of change
    previous_price = None
    while not (local.args.count == len(full_prices)):
        # get prices
        msgs = extract_prices(fetch_function())
        for msg in msgs:
            # set the ret of change for each price based on its previous price
            msg.calculate_and_set_rate_of_change(previous_price)
            # insert the prices in the list
            full_prices.append(msg.get_json_data())
            logger.info(f"accumulated {len(full_prices)} prices")
            previous_price = msg
            if local.args.count == len(full_prices):
                break
    return full_prices
