from price import *
from parse import args
import logging

logger = logging.getLogger("dolarlog")
if args.use_api:
    fetch_func = fetch_price_data_u_tg_api
else:
    fetch_func = fetch_price_data_u_preview_page


def get_index(list, item):
    for element in list:
        if element == item:
            return list.index(element)
    return False


# TODO : write an extra method which both modes can share
def run_live(emmitter_callback):
    server_mode = "live"
    prev_fetch = []
    last_price = None
    while True:
        try:
            curr_fetch = extract_prices(fetch_func(server_mode=server_mode))
            if not prev_fetch:
                prev_fetch = curr_fetch

            # determine last message
            last_price_in_curr_fetch = get_index(curr_fetch, prev_fetch[-1])

            if last_price_in_curr_fetch:
                new_prices = curr_fetch[last_price_in_curr_fetch:]

                for price in new_prices:
                    if not price == last_price:
                        emmitter_callback(price)
                        last_price = price

            else:
                logging.error("something went wrong")

            """
            if "پایان معاملات" in last[-1].text:
                print("deals closed good night")
                break
            """
            prev_fetch = curr_fetch

        except Exception as e:
            print("run live mode error:", e)


def run_counter(
    count,
):
    priceInfo.lastpricepostnumber = 0
    server_mode = "count"
    full_prices = []
    while True:
        msgs = extract_prices(fetch_func(server_mode=server_mode))

        for msg in msgs:
            full_prices.insert(0, msg)
            logger.info(f"accumulated {len(full_prices)} prices")

            if count == len(full_prices):
                break

        if count == len(full_prices):
            break

    server_ret = list(map(lambda price: price.get_data(), full_prices))
    for i in server_ret:
        print(i)
    # TODO: to the price class add a method that gives json formatted data
    return server_ret
