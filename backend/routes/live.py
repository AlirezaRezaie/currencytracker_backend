# live.py
from fastapi import APIRouter, WebSocket
from starlette.websockets import WebSocketDisconnect
import asyncio
from logs import logger
from tasks import *

router = APIRouter()


def command_parser(msg):
    """
    a custom made command parser most probably gets updated
    in later version because of its simplicity
    """
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
    """
    the main task manager of the live websocket
    it processes the recieved commands and sends data accordingly
    """
    # accepting the connection from user
    await websocket.accept()
    # send an initial test (it is used to check the websocket connection in the frontend)
    await websocket.send_text("CONNECTED")
    logger.info(f"client {websocket.client.host}:{websocket.client.port} connected 🔌🔌")

    # getting the event loop that router.websocket made because
    # we want to use it to pass data to multiple users
    # Note:
    #   this should be passed either to the newly created Task object or
    #   ultimetly gets set to an exsisting Task object
    #   if not no data will be broadcasted to the users
    loop = asyncio.get_event_loop()
    # the currenct task that is started
    task = None
    try:
        while True:
            # wait for the user to send a command
            rec_msg = await websocket.receive_text()
            try:
                # if its a real command
                parse_command = command_parser(rec_msg)
            except:
                # if its not send an error message and continue listening
                await websocket.send_text("parser error bruh")
                continue

            if parse_command["status"] == "ok":
                # continue if ok
                # get the channel code from the parser info
                channel_code = parse_command["channel_name"]
                if channel_code:
                    # get the task if exists
                    task = get_task(channel_code)
                    if not task:
                        # if it doesn't create a brand new one
                        # note that we have to pass the websocket event loop
                        # because we will use it to create notification tasks
                        # please refer to the notes in the tasks.py file in the
                        # notify
                        task = Task(channel_code, loop)
                    else:
                        # log that task exist's
                        # setting it's loop value to the websocket event loop
                        # as mentioned why in the loop declaration
                        task.main_loop = loop
                        logger.info(f"task {channel_code} exists")

                # read the parsed data
                match parse_command["command"]:
                    case "SUBSCRIBE":
                        if not websocket in task.users:
                            task.users.append(websocket)
                        else:
                            await websocket.send_text(
                                f"you have already subscribed to {channel_code}"
                            )
                        if task.lastprice:
                            is_crypto = task.args.currency_info.get("is_crypto")
                            await websocket.send_text(
                                baked_data(task.lastprice, is_crypto)
                            )

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
                # return the parser info on not ok status
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
