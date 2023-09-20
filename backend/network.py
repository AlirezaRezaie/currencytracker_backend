import requests
import ast
from bs4 import BeautifulSoup
import os
from time import time
from logs import logger
from locals import local
from requests import Session

session = Session()


def network_stability_check(proxy=None):
    proxy_list = ["no proxy", proxy, "http://localhost:20171"]

    for proxy in proxy_list:
        try:
            if proxy and not proxy == "no proxy":
                os.environ["HTTPS_PROXY"] = proxy
                os.environ["HTTP_PROXY"] = proxy
            elif not proxy:
                print(
                    "You didn't set the --proxy argument. Choosing a custom proxy for you ❤️"
                )
                raise
            print(
                f"Checking internet connection with {proxy} (Please wait for a maximum of 10 seconds...)"
            )

            requests.get(
                "https://t.me",
                timeout=10,
            )
            print("Internet is working")
            break
        except:
            print(
                f"Failed connecting 😢 (Picking{' another' if proxy_list.index(proxy) > 0 else ''} proxy...)"
            )
            if proxy_list.index(proxy) == len(proxy_list) - 1:
                exit(0)


class FetchRate:
    reqs = 0
    time = 0

    # calculate how many request to t.me per 5 seconds
    def set_rate(self, per_req_time):
        if self.time < 5:
            self.time += per_req_time
            self.reqs += 1
        else:
            # based on latest test's over 10 is good number
            print(self.reqs)
            if self.reqs < 10:
                print("slow network")
            self.reqs = 0
            self.time = 0


fr = FetchRate()


def is_connection_stable(server, timeout):
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


def fetch_price_data_u_preview_page(
    server_mode,
):
    global session

    timeout = local.args.timeout if local.args.timeout else 10
    retry_limit = local.args.retry if local.args.retry else 10
    fetchrate = local.args.fetchrate if local.args.fetchrate else False

    headers = {
        "Accept": "text/javascript",
        "X-Requested-With": "XMLHttpRequest",
        "Accept-Language": "en-US,en;q=0.5",
        "accept-encoding": "gzip, deflate, br",
        "Connection": "keep-alive",
        "Content-Length": "0",
    }

    postnumber = local.last_post_number

    if server_mode == "count":
        session = requests

    for retry_count in range(retry_limit):
        try:
            # TODO: handle network resets and minor error that might cause the whole connection
            # to close
            logger.info("connecting...")
            t1 = int(time())
            response = session.post(
                f"https://t.me/s/{local.channel_id}?before={str(postnumber)}",
                headers=headers,
                timeout=timeout,
            ).text
            logger.info("connected successfully +++")
            t2 = int(time())
            if fetchrate:
                fr.set_rate(t2 - t1)
            break
        except requests.exceptions.RequestException as e:
            # TODO : change this retry method to also fit the server
            logger.error(e)
            logger.info("failed to connect ---")
            # Continuously check the connection stability
            if not is_connection_stable("t.me", timeout=timeout):
                logger.critical("Connection is not stable. Retrying in 5 seconds...")
                if retry_count + 1 >= retry_limit:
                    exit(1)

    # Decompress the compressed data (gzip encoding)
    # doesnt actually decodes gzip to html but it works for now
    try:
        evaluated_data = ast.literal_eval(response)
    except Exception as e:
        evaluated_data = response
        logger.info("parser info: " + str(type(e)))
        # print("parser error critical!!!!!!!!!!!!1")
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

    if len(messages) > 0:
        local.last_post_number = messages[0]["number"]

    return messages
