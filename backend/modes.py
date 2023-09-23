from network import fetch_price_data_u_preview_page as fetch_function
from price import extract_prices
from logs import logger
from locals import local


def run_live(emmitter_callback, error_callback, stop_event, args=None):
    local.channel_id = args.channel_info["channel_name"]
    local.channel_info = args.channel_info
    local.args = args

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
                    emmitter_callback(to_user, args.code)
                    last_price = price

        else:
            logger.error("something went wrong")

        prev_fetch = curr_fetch
    print("FINISH LOOP")


def run_counter(args):
    local.channel_id = args.channel_info["channel_name"]
    local.channel_info = args.channel_info
    local.last_post_number = 0
    local.args = args

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
            if local.count == len(full_prices):
                break

        if local.count == len(full_prices):
            break

    server_ret = list(map(lambda price: price.get_json_data(), full_prices))
    return server_ret
