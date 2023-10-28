import re
from logs import logger
from locals import local
import time
from utils import create_json_data

known_channels = ["dollar_tehran3bze", "nerkhedollarr"]


# TODO : the price code gets channel from args.channel_id
# change it to also operate with server incoming data of id

# TODO : probably need to add this feature that prevents from the host blocking our
# ip because of request flood
# we need to connect and then disconnect to the host or switch proxy

# TODO : a mechanism that checks the channels authenticity of being a currency channel

# TODO: add rate of change to new values according to previous one 50,070 rial / + 125 rial (0.25%)

# TODO: check if latest message has been edited


class priceInfo:
    def __init__(self, raw_price_obj) -> None:
        # each type should be treated respectivly
        if local.channel_info["type"] == "api":
            self.postnumber = None
            self.action = None
            self.exchtype = None
            self.posttime = int(time.time() % 86_400)
            self.text = raw_price_obj
            self.persian_name = local.args.currency_info["name"]
            info = local.channel_info["currency_list"]
            self.full_name = info[local.args.code]["fullname"]
            self.rate_of_change = None
            self.price = float(raw_price_obj["price"])

            self.image_link = local.channel_info["image_link"].format(
                full_name=self.full_name,
                symbol=local.args.code,
            )

        elif local.channel_info["type"] == "tg":
            self.postnumber = raw_price_obj["number"]
            self.posttime = raw_price_obj["info"]
            self.text = raw_price_obj["text"]
            self.persian_name = local.args.currency_info["name"]
            self.rate_of_change = None
            self.image_link = f"/static/currency_images/{local.args.code}.png"
            parsed = self.parse_price_info(raw_price_obj["text"])

            # if its a valid price text
            if parsed:
                exchtype, price, action = parsed
            else:
                raise ValueError("Invalid data. Object cannot be created.")

            self.action = action
            self.exchtype = exchtype

            if local.args.currency_info:
                self.price = int(price.replace(",", ""))
            else:
                # might not be a price
                self.price = price
                self.persian_name = None
        else:
            return None

    def __eq__(self, other):
        if isinstance(other, priceInfo):
            if local.channel_info["type"] == "tg":
                return self.postnumber == other.postnumber
            elif local.channel_info["type"] == "api":
                return self.price == other.price
            return False

    def get_data(self):
        return (self.text, self.posttime, self.postnumber)

    def get_json_data(self):
        data = {
            "code": local.args.code,
            "action": self.action,
            "price": self.price,
            "persian_name": self.persian_name,
            "image_link": self.image_link,
            "exchtype": self.exchtype,
            "posttime": self.posttime,
            "rateofchange": self.rate_of_change,
        }

        data = create_json_data(
            local.args.code,
            self.price,
            self.persian_name,
            f"/static/currency_images/{local.args.code}.png",
            self.posttime,
            self.rate_of_change,
            self.action,
            self.exchtype,
        )

        return data

    def calculate_and_set_rate_of_change(self, last_price):
        if last_price and local.args.currency_info:
            prev_prc = last_price.price
            new_prc = self.price
            calculated_rate_of_change = round(
                ((new_prc - prev_prc) / prev_prc) * 100, 7
            )
            self.rate_of_change = calculated_rate_of_change

    def parse_price_info(self, price_text) -> tuple:
        groups = None
        checked_parsed = None
        # code = local.code
        regex = local.channel_info["regex"]
        if regex:
            if local.channel_info.get("findall"):
                groups = re.findall(regex, price_text)
                # print(groups)

            elif "پایان" in price_text:
                # the currency prices has ended we can halt this task for now"
                groups = None
            else:
                groups = re.search(regex, price_text)

        else:
            # use the default regex
            groups = re.findall(r"(\d{1,3}(?:,\d{3})*)", price_text)

        # exit()
        if groups:
            try:
                checked_parsed = groups.groups()

            except Exception as e:
                price = groups[0]
                checked_parsed = ("none", price, "none")

        return checked_parsed


# accepts raw messages and returns price objects
def extract_prices(messages, count=10, reverse=False):
    if not messages or messages == "INVALID":
        return "id is not valid"

    # print(messages)
    parsed_prices = []
    latest = len(messages) - 1

    for price in reversed(messages[: latest + 1]):
        try:
            parsed_price_obj = priceInfo(price)
            parsed_prices.append(parsed_price_obj)
            count -= 1
            if count == 0:
                break
        except ValueError as e:
            # keep in mind that this exception is not an actual error
            # its my way of handling data text and non-data text
            logger.debug(e)

    if reverse:
        parsed_prices.reverse()

    return parsed_prices
