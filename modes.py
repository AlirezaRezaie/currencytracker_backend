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
def run_live():
    # calls when new price received
    def update_price_printer(latest_price):
        print(latest_price.text + "\07")

    prev_fetch = []
    last_price = None
    while True:
        curr_fetch = extract_prices(fetch_func())
        if not prev_fetch:
            prev_fetch = curr_fetch

        # determine last message

        last_price_in_curr_fetch = get_index(curr_fetch, prev_fetch[-1])

        if last_price_in_curr_fetch:
            new_prices = curr_fetch[last_price_in_curr_fetch:]

            for price in new_prices:
                if not price == last_price:
                    update_price_printer(price)
                    last_price = price

        else:
            logging.error("something went wrong")

        """
        if "پایان معاملات" in last[-1].text:
            print("deals closed good night")
            break
        """
        prev_fetch = curr_fetch


def run_counter(count):
    full_prices = []

    while True:
        msgs = extract_prices(fetch_func())
        for msg in msgs:
            full_prices.insert(0, msg)
            logger.info(f"accumulated {len(full_prices)} prices")

            if count == len(full_prices):
                break

        if count == len(full_prices):
            break

    for price in full_prices:
        print(price.get_data())
