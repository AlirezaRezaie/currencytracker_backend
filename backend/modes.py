from network import fetch_price_data_u_preview_page as fetch_function
from network import priceInfo
from price import extract_prices
from logs import logger


def run_live(emmitter_callback, args=None):
    server_mode = "live"
    prev_fetch = []
    last_price = None
    while True:
        try:
            curr_fetch = extract_prices(fetch_function(server_mode, args))
            if not prev_fetch:
                prev_fetch = curr_fetch
            # determine last message in the current fetch
            for price in curr_fetch:
                if price == prev_fetch[-1]:
                    last_price_in_curr_fetch = curr_fetch.index(price)

            # last_price_in_curr_fetch = get_index(curr_fetch, prev_fetch[-1])

            if last_price_in_curr_fetch:
                new_prices = curr_fetch[last_price_in_curr_fetch:]

                for price in new_prices:
                    if not price == last_price:
                        to_user = price.get_json_data()
                        # check if end transaction
                        if price.action == "پایان معاملات":
                            to_user = price.text
                        emmitter_callback(to_user, args.channel_id)
                        last_price = price

            else:
                logger.error("something went wrong")

            prev_fetch = curr_fetch

        except Exception as e:
            print("run live mode error:", e)


def run_counter(args):
    priceInfo.channels[args.channel_id]["last_price_post_number"] = 0
    server_mode = "count"
    full_prices = []
    while True:
        msgs = extract_prices(fetch_function(server_mode, args))

        for msg in msgs:
            full_prices.insert(0, msg)
            logger.info(f"accumulated {len(full_prices)} prices")

            if args.count == len(full_prices):
                break

        if args.count == len(full_prices):
            break

    server_ret = list(map(lambda price: price.get_data(), full_prices))
    return server_ret
