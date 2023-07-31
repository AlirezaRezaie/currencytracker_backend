from fastapi import FastAPI, WebSocket
import asyncio
from modes import run_counter, run_live
import threading
from price import priceInfo
import os
import json

app = FastAPI()


connected_clients = set()


async def send_data_to_clients(new_data):
    for client in connected_clients:
        await client.send_text(json.dumps(new_data.get_json_data()))


def price_callback(price):
    priceInfo.lastprice = price
    print(price.get_data())
    asyncio.run(send_data_to_clients(price))


@app.websocket("/live")
async def websocket_endpoint(websocket: WebSocket):
    print("hi")
    await websocket.accept()
    print("accept user")
    try:
        connected_clients.add(websocket)
        await websocket.send_text(json.dumps(priceInfo.lastprice.get_json_data()))
        while True:
            _ = await websocket.receive_text()
    except Exception as e:
        connected_clients.remove(websocket)
        print(f"server error {e}")


@app.get("/counter")
async def get_live_counter(count: int) -> str:
    return str(run_counter(count))


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
