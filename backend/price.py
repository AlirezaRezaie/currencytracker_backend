import re
from logs import logger
from locals import local

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
        parsed = self.parse_price_info(raw_price_obj["text"])
        # if its a valid price text
        if parsed:
            action, price, exchtype = parsed
        else:
            raise ValueError("Invalid data. Object cannot be created.")

        self.price = int(price.replace(",", ""))
        self.action = action
        self.exchtype = exchtype
        # TODO: it gives UTC turn it into iran local time
        self.posttime = raw_price_obj["info"]
        self.text = raw_price_obj["text"]
        self.postnumber = raw_price_obj["number"]
        self.rate_of_change = None

    def __eq__(self, other):
        if isinstance(other, priceInfo):
            return self.postnumber == other.postnumber
        return False

    def get_data(self):
        return (self.text, self.posttime, self.postnumber)

    def get_json_data(self):
        return {
            "action": self.action,
            "price": self.text if self.action == "پایان معاملات" else self.price,
            "exchtype": self.exchtype,
            "posttime": self.posttime,
            "rateofchange": self.rate_of_change,
        }

    def calculate_and_set_rate_of_change(self, last_price):
        if last_price:
            prev_prc = last_price.price
            new_prc = self.price
            calculated_rate_of_change = round(
                ((new_prc - prev_prc) / prev_prc) * 100, 3
            )
            self.rate_of_change = calculated_rate_of_change

    def parse_price_info(self, price_text) -> tuple:
        groups = None
        checked_parsed = None
        # code = local.code
        regex = local.channel_info["regex"]
        if regex:
            groups = re.search(regex, price_text)
        else:
            # use the default regex
            groups = re.findall(r"(\d{1,3}(?:,\d{3})*)", price_text)

        if groups:
            try:
                checked_parsed = groups.groups()
            except:
                price = groups[0]
                checked_parsed = ("none", price, "none")

        return checked_parsed


# accepts raw messages and returns price objects
def extract_prices(messages, count=10, reverse=False):
    if not messages:
        return "id is not valid"
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
