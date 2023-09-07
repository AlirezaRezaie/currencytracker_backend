from fastapi import FastAPI, WebSocket
import os
from starlette.websockets import WebSocketDisconnect
from network import network_stability_check
from modes import run_counter
from tasks import *
from logs import logger
import asyncio

app = FastAPI()


@app.websocket("/live/{id}")
async def websocket_endpoint(websocket: WebSocket, id: str):
    await websocket.accept()
    try:
        loop = asyncio.get_event_loop()
        task = get_task(id)
        if not task:
            task = Task(id, loop)
        else:
            print(f"task {id} exists")

        task.users.append(websocket)
        if task.lastprice:
            await websocket.send_text(json.dumps(task.lastprice))
        while True:
            await websocket.receive_text()
    except WebSocketDisconnect:
        print("client dissconnect")
        disconnect_websocket(task, websocket)
        logger.info("client disconnected")
    except Exception as e:
        print("hello")
        logger.error(f"An error occurred: {e}")
        await websocket.send_text(str(e))
        await websocket.close(1012)


@app.get("/counter/{id}/{count}")
async def get_live_counter(id: str, count: int) -> str:
    args = Arg(id, count=count)
    return str(run_counter(args))


if __name__ == "__main__":
    import uvicorn

    network_stability_check()

    print("env port is set to:", os.getenv("PORT"))
    uvicorn.run(
        "server:app",
        host="0.0.0.0",
        port=os.getenv("PORT", default=5000),
    )
