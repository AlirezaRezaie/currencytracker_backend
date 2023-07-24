from fastapi import FastAPI, WebSocket
import asyncio
from modes import run_counter, run_live
import threading
import queue

# from starlette.concurrency import run_in_threadpool

app = FastAPI()
change_queue = queue.Queue()
connected_clients = set()


async def send_data_to_clients(new_data):
    # Send the new data to all connected WebSocket clients
    for client in connected_clients:
        await client.send_text(new_data)


def price_callback(price):
    # print(price)
    asyncio.run(send_data_to_clients(price))


@app.websocket("/live")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    # websocket_clients.append(websocket)

    try:
        connected_clients.add(websocket)
        while True:
            # maybe for each person check if they sent the data and have a small variable
            _ = await websocket.receive_text()
    except Exception as e:
        connected_clients.remove(websocket)
        print(f"server error {e}")


@app.get("/counter/")
async def get_live_counter(count: int) -> str:
    print(count)
    return str(run_counter(count))


@app.on_event("startup")
async def startup_event():
    t = threading.Thread(target=run_live, args=(price_callback, change_queue))
    t.start()


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8000)
