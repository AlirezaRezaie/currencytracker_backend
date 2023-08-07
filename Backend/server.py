from fastapi import FastAPI, WebSocket
import asyncio
from modes import run_counter, run_live
import threading
from price import priceInfo
import os
import json

from network import network_stability_check

app = FastAPI()

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

    t1 = threading.Thread(target=run_live, args=(price_callback, id1))
    t2 = threading.Thread(target=run_live, args=(price_callback, id2))

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
