# live.py
from fastapi import APIRouter, WebSocket
from starlette.websockets import WebSocketDisconnect
import asyncio
from logs import logger
from tasks import *

router = APIRouter()


def command_parser(msg):
    supported_commands = {
        "SUBSCRIBE": 1,
        "UNSUBSCRIBE": 1,
        "CHANNELS": 0,
        "PING": 0,
        "TASKS": 0,
    }
    out = {"command": "", "channel_name": "", "status": "pending", "error": ""}
    raw = msg.split(" ")
    cmd = raw[0]
    if cmd in supported_commands:
        index_of_arguments = supported_commands.get(cmd)
        out["command"] = cmd
        out["status"] = "ok"

        if index_of_arguments > 0:
            out["channel_name"] = "".join(raw[index_of_arguments:])
        else:
            out["channel_name"] = None
    else:
        out["status"] = "error"
        out["error"] = "no such command or invalid"
    return out


@router.websocket("/")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    await websocket.send_text("CONNECTED")
    logger.info(f"client {websocket.client.host}:{websocket.client.port} connected 🔌🔌")
    loop = asyncio.get_event_loop()
    task = None
    try:
        while True:
            rec_msg = await websocket.receive_text()
            try:
                parse_command = command_parser(rec_msg)
            except:
                await websocket.send_text("parser error bruh")
                continue

            if parse_command["status"] == "ok":
                channel_code = parse_command["channel_name"]
                if channel_code:
                    task = get_task(channel_code)
                    if not task:
                        task = Task(channel_code, loop)
                    else:
                        logger.info(f"task {channel_code} exists")
                match parse_command["command"]:
                    case "SUBSCRIBE":
                        if not websocket in task.users:
                            task.users.append(websocket)
                        else:
                            await websocket.send_text(
                                f"you have already subscribed to {channel_code}"
                            )
                        if task.lastprice:
                            await websocket.send_text(baked_data({"latests":[task.lastprice],"limit":20}))

                    case "UNSUBSCRIBE":
                        if websocket in task.users:
                            disconnect_websocket(websocket, task)
                        else:
                            await websocket.send_text(
                                "your are not subscribed to any channel silly"
                            )
                    case "CHANNELS":
                        channels_subbed_in = []
                        for task in tasks:
                            if websocket in task.users:
                                channels_subbed_in.append(task.args.code)
                        await websocket.send_text(str(channels_subbed_in))

                    case "TASKS":
                        await websocket.send_text(str(len(tasks)))
                    case "PING":
                        await websocket.send_text("PONG")
            else:
                await websocket.send_text(str(parse_command))

    except WebSocketDisconnect:
        logger.info(
            f"client {websocket.client.host}:{websocket.client.port} disconnected ❌❌"
        )
        disconnect_websocket(websocket)
    except Exception as e:
        logger.error(
            f"Custome Exception Occurred: {e}\nException from client {websocket.client.host}:{websocket.client.port}\ncheck the logs to see who that was"
        )
        await websocket.send_text(str(e))
        await websocket.close(1012)
