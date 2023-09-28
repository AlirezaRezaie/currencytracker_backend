from network import *
from price import extract_prices
from logs import logger
from locals import local
from utils import push_in_board, Arg

# How To Use:

# the run_live and the counter_live functions must have a an args instance
# passed to them its some general configs for the tasks


def get_fetch_function():
    match local.channel_info["type"]:
        case "api":
            func = fetch_price_data_u_public_api
        case "tg":
            func = fetch_price_data_u_preview_page
        case "web":
            func = fetch_price_data_u_web_scrape

    return func


def run_live(success_callback, error_callback, stop_event, args: Arg):
    local.channel_id = args.channel_info["channel_name"]
    local.channel_info = args.channel_info
    local.args = args

    fetch_function = get_fetch_function()

    local_board = {"latests": [], "code": args.code, "limit": 20}
    server_mode = "live"
    prev_fetch = []
    last_price = None
    patience = 4
    while not stop_event.is_set():
        curr_fetch = None
        local.last_post_number = 0

        # we fetch untill we reach some prices we can change the patience to be more it will search more messages
        for _ in range(patience):
            curr_fetch_nullable = extract_prices(
                fetch_function(server_mode), reverse=True
            )

            if curr_fetch_nullable:
                # print(curr_fetch_nullable)
                curr_fetch = curr_fetch_nullable
                break

        if not type(curr_fetch) == list:
            # stop_event.set()
            error_callback(args.channel_id)
            break

        if not prev_fetch:
            prev_fetch = curr_fetch

        # determine last message in the current fetch
        for price in curr_fetch:
            if price == prev_fetch[-1]:
                last_price_in_curr_fetch = curr_fetch.index(price)

        if last_price_in_curr_fetch is not None:
            new_prices = curr_fetch[last_price_in_curr_fetch:]
            for price in new_prices:
                if not price == last_price:
                    price.calculate_and_set_rate_of_change(last_price)
                    to_user = price.get_json_data()
                    push_in_board(to_user, local_board)
                    success_callback(local_board, args.code)
                    last_price = price

        else:
            logger.error("something went wrong")

        prev_fetch = curr_fetch
    print("FINISH LOOP")


def run_counter(args: Arg):
    local.channel_id = args.channel_info["channel_name"]
    local.channel_info = args.channel_info
    local.args = args

    fetch_function = get_fetch_function()

    local.last_post_number = 0
    server_mode = "count"
    full_prices = []
    previous_price = None
    while True:
        msgs = extract_prices(fetch_function(server_mode))
        for msg in msgs:
            msg.calculate_and_set_rate_of_change(previous_price)
            full_prices.insert(0, msg)
            logger.info(f"accumulated {len(full_prices)} prices")
            previous_price = msg
            if local.args.count == len(full_prices):
                break

        if local.args.count == len(full_prices):
            break

    server_ret = list(map(lambda price: price.get_json_data(), full_prices))
    return server_ret
