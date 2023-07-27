import re
import requests
import re
import ast
from bs4 import BeautifulSoup
from parse import args
from requests import Session
import logging
import os

logger = logging.getLogger("dolarlog")

session = Session()

http_proxy = "http://localhost:20171" if not args.proxy else args.proxy

os.environ["HTTPS_PROXY"] = http_proxy
os.environ["HTTP_PROXY"] = http_proxy

try:
    check_proxy = requests.get("https://example.com")
    print("proxy is working")
except requests.exceptions.ProxyError:
    print(f"proxy {http_proxy} is not working")
    exit(0)


known_channels = ["dollar_tehran3bze", "nerkhedollarr"]

timeout = args.timeout if args.timeout else 10
retry_limit = args.retry if args.retry else 10  # default to ten
channel_id = args.channel_id if args.channel_id else known_channels[1]


# TODO : the price code gets channel from args.channel_id
# change it to also operate with server incoming data of id

# TODO : probably need to add this feature that prevents from the host blocking our
# ip because of request flood
# we need to connect and then disconnect to the host or switch proxy


class priceInfo:
    lastpricepostnumber = 0
    lastprice = None

    def __init__(self, parsed, fulltext, posttime, postnumber) -> None:
        action, price, exchtype = parsed
        self.price = price
        self.action = action
        self.action = exchtype
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

    @staticmethod
    def parse_price_info(price_text) -> tuple:
        groups = re.search(
            r"(فردایی|نقدی|نـــقـدی|نـــقـدۍ).*?(\d{1,3}(?:,\d{3})*).(\w*)",
            price_text,
        )
        return groups


def is_connection_stable(server):
    try:
        logger.info("testing")
        requests.head(
            "https://" + server,
            timeout=timeout,
        )
        return True
    except:
        return False


def fetch_price_data_u_tg_api(apikey=""):
    raise NotImplementedError


def fetch_price_data_u_preview_page(server_mode=None, postnumber=0):
    global session
    headers = {
        "Accept": "text/javascript",
        "X-Requested-With": "XMLHttpRequest",
        "Accept-Language": "en-US,en;q=0.5",
        "accept-encoding": "gzip, deflate, br",
        "Connection": "keep-alive",
        "Content-Length": "0",
    }
    mode = args.mode if args.mode else server_mode
    if mode == "count":
        postnumber = priceInfo.lastpricepostnumber
        session = requests

    for retry_count in range(retry_limit):
        try:
            # TODO: handle network resets and minor error that might cause the whole connection
            # to close
            logger.info("connecting...")
            response = session.post(
                f"https://t.me/s/{channel_id}?before={str(postnumber)}",
                headers=headers,
                timeout=timeout,
            ).text

            break
        except requests.exceptions.RequestException as e:
            # TODO : change this retry method to also fit the server
            logger.error(e)
            logger.info("failed to connect")
            # Continuously check the connection stability
            if not is_connection_stable("t.me"):
                logger.critical("Connection is not stable. Retrying in 5 seconds...")
                if retry_count + 1 >= retry_limit:
                    exit(1)

    # Decompress the compressed data (gzip encoding)
    # doesnt actually decodes gzip to html but it works for now
    evaluated_data = ast.literal_eval(response)
    html_data = evaluated_data.replace("\\", "")
    soup = BeautifulSoup(html_data, "html.parser")

    # whole message element
    tg_messages = soup.find_all(
        "div", {"class": "tgme_widget_message_wrap js-widget_message_wrap"}
    )
    messages = []
    for msg in tg_messages:
        tg_message_obj = {}
        try:
            msg_text = msg.find(
                "div", {"class": "tgme_widget_message_text js-message_text"}
            ).get_text()
            msg_number = msg.find(
                "div",
                {
                    "class": "tgme_widget_message text_not_supported_wrap js-widget_message",
                },
            )["data-post"].split("/")[1]
            msg_info = msg.find("time", {"class": "time"}).get_text()
            tg_message_obj["text"] = msg_text
            tg_message_obj["number"] = msg_number
            tg_message_obj["info"] = msg_info
            logger.debug(msg_text)
            messages.append(tg_message_obj)
        except Exception as e:
            logger.debug("is not desired format")

    if mode == "count":
        priceInfo.lastpricepostnumber = messages[0]["number"]

    return messages


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
