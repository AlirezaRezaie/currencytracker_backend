import re
import logging


logger = logging.getLogger("dolarlog")


known_channels = ["dollar_tehran3bze", "nerkhedollarr"]


# TODO : the price code gets channel from args.channel_id
# change it to also operate with server incoming data of id

# TODO : probably need to add this feature that prevents from the host blocking our
# ip because of request flood
# we need to connect and then disconnect to the host or switch proxy

# TODO : a mechanism that checks the channels authenticity of being a currency channel


class priceInfo:
    channels = dict()

    # innitializing channel info
    for channel in known_channels:
        channels[channel] = {"last_price_post_number": 0, "last_price": None}

    def __init__(self, parsed, fulltext, posttime, postnumber) -> None:
        action, price, exchtype = parsed
        self.price = price
        self.action = action
        self.exchtype = exchtype
        # TODO: it gives UTC turn it into iran local time
        self.posttime = posttime
        self.text = fulltext
        self.postnumber = postnumber

    def __eq__(self, other):
        if isinstance(other, priceInfo):
            return self.postnumber == other.postnumber
        return False

    def get_data(self):
        return (self.text, self.posttime, self.postnumber)

    def get_json_data(self):
        return {
            "action": self.action,
            "price": self.price,
            "exchtype": self.exchtype,
            "posttime": self.posttime,
        }

    @staticmethod
    def parse_price_info(price_text) -> tuple:
        groups = re.search(
            r"(فردایی|نقدی|نـــقـدی|نـــقـدۍ|پایان معاملات).*?(\d{1,3}(?:,\d{3})*).(\w*)",
            price_text,
        )
        return groups


# accepts raw messages and returns price objects
def extract_prices(messages, count=10):
    prices = []
    latest = len(messages) - 1

    for price in reversed(messages[: latest + 1]):
        parsed = priceInfo.parse_price_info(price["text"])

        if parsed:
            price_info_obj = priceInfo(
                parsed.groups(), price["text"], price["info"], price["number"]
            )
            prices.append(price_info_obj)
            count -= 1

            if count == 0:
                break
        else:
            logger.debug(f"{price['text']} is not a price message")
    return list(reversed(prices))
