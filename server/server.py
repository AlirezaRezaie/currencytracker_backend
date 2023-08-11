from fastapi import FastAPI, WebSocket
import asyncio
import threading
import os
import json

import sys
import os

parent_directory = os.path.abspath(
    ".."
)  # Get the absolute path of the parent directory
contents = os.listdir(parent_directory)  # List the contents of the parent directory

print(contents)
sys.path.append("../")
print(sys.path)
from core.network import network_stability_check
from core.price import priceInfo
from core.modes import run_counter, run_live

app = FastAPI()


class Arg:
    def __init__(self, channel_id, timeout=None, retry=None, fetchrate=None):
        self.channel_id = channel_id
        self.timeout = timeout
        self.retry = retry
        self.fetchrate = fetchrate


clients_in_channels = {}
# TODO : have a mechanism to close the threads (channels) that noone uses


async def send_data_to_clients(new_data, channel):
    for client in clients_in_channels[channel]:
        await client.send_text(json.dumps(new_data))


def price_callback(price, channel):
    priceInfo.channels[channel]["last_price"] = price
    print(price)
    asyncio.run(send_data_to_clients(price, channel))


@app.websocket("/live/{id}")
async def websocket_endpoint(websocket: WebSocket, id: str):
    await websocket.accept()
    try:
        clients_in_channels[id].add(websocket)
        await websocket.send_text(json.dumps(priceInfo.channels[id]["last_price"]))
        while True:
            _ = await websocket.receive_text()
    except Exception as e:
        clients_in_channels[id].remove(websocket)
        print(f"server error {e}")


@app.get("/counter")
async def get_live_counter(count: int) -> str:
    return str(run_counter(count))


@app.on_event("startup")
async def startup_event():
    id1 = "dollar_tehran3bze"
    id2 = "nerkhedollarr"

    arg1 = Arg(id1)
    arg2 = Arg(id2)

    t1 = threading.Thread(target=run_live, args=(price_callback, arg1))
    t2 = threading.Thread(target=run_live, args=(price_callback, arg2))

    clients_in_channels[id1] = set()
    clients_in_channels[id2] = set()

    t1.start()
    t2.start()


if __name__ == "__main__":
    import uvicorn

    network_stability_check()

    print("env port is set to:", os.getenv("PORT"))
    uvicorn.run(
        "server:app",
        host="0.0.0.0",
        port=os.getenv("PORT", default=5000),
    )
