from fastapi import FastAPI, WebSocket
import asyncio
from modes import run_counter, run_live
import threading
import queue
from price import priceInfo
import os
from pydantic import BaseModel, conint


app = FastAPI()


class Item(BaseModel):
    value: conint(ge=10)


change_queue = queue.Queue()
connected_clients = set()


async def send_data_to_clients(new_data):
    for client in connected_clients:
        await client.send_text(new_data)


def price_callback(price):
    priceInfo.lastprice = price
    print(price)
    asyncio.run(send_data_to_clients(price))


@app.websocket("/live")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        connected_clients.add(websocket)
        await websocket.send_text(str(priceInfo.lastprice))
        while True:
            _ = await websocket.receive_text()
    except Exception as e:
        connected_clients.remove(websocket)
        print(f"server error {e}")


@app.get("/counter")
async def get_live_counter(count: Item) -> str:
    return str(run_counter(count.value))


@app.on_event("startup")
async def startup_event():
    t = threading.Thread(target=run_live, args=(price_callback,))
    t.start()


if __name__ == "__main__":
    import uvicorn

    print(os.getenv("PORT"))
    uvicorn.run(
        "server:app",
        host="0.0.0.0",
        port=os.getenv("PORT", default=5000),
    )
