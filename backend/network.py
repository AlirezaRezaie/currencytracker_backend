import requests
import ast
from bs4 import BeautifulSoup
import os
from time import time
from logs import logger
from locals import local
from requests import Session
import json
import websocket

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


def fetch_price_data_u_websocket():
    endpoint = local.channel_info["endpoint"]
    messages = []

    def on_message(ws, message):
        if local.stop_event.is_set():
            ws.close()
        json_data = json.loads(message)
        data = json_data["result"]["data"]["data"]
        messages.append("")
        for i in data:
            print(i)
        print("----------------------------------")

    def on_error(ws, error):
        print(f"Error: {error}")

    def on_close(ws, close_status_code, close_msg):
        print("Closed")

    def on_open(ws):
        print("Connected to WebSocket")
        # You can send a message here if needed
        ws.send('{"params":{"name":"js"},"id":1}')
        ws.send('{"method":1,"params":{"channel":"tgju:stream"},"id":2}')

    # Create a WebSocket instance
    ws = websocket.WebSocketApp(
        endpoint, on_message=on_message, on_error=on_error, on_close=on_close
    )

    ws.on_open = on_open
    ws.run_forever()


def fetch_price_data_u_web_scrape(apikey=""):
    raise NotImplementedError


def fetch_price_data_u_public_api(apikey=""):
    if "endpoint" in local.channel_info:
        endpoint = local.channel_info["endpoint"]
        connected = False
        while not connected:
            try:
                res = requests.get(endpoint).text
                connected = True
            except:
                logger.info("api failed to connect bro")

        obj = json.loads(res)

        return [obj]

    else:
        # this will be later caught by the run_live function as error as it thinks its not a valid channel
        logger.error(
            "you should specify a 'endpoint' key and value in the configs json if you have type 'api' "
        )
        return []


def fetch_price_data_u_preview_page():
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
    endpoint = f"https://t.me/s/{local.channel_id}?before={str(postnumber)}"

    if local.server_mode == "count":
        session = requests

    while True:
        try:
            # TODO: handle network resets and minor error that might cause the whole connection
            # to close
            # logger.info("connecting...")
            t1 = int(time())
            response = session.post(
                endpoint,
                headers=headers,
                timeout=timeout,
            ).text
            # logger.info("connected successfully +++")
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
