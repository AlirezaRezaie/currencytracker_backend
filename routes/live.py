# live.py
from fastapi import APIRouter, WebSocket
from starlette.websockets import WebSocketDisconnect
import asyncio
from logs import logger
from tasks import *
from utils import get_tgju_data, get_pickle_data

router = APIRouter()


def command_parser(msg):
    """
    a custom made command parser most probably gets updated
    in later version because of its simplicity
    """
    supported_commands = {
        "SUBSCRIBE": 1,
        "UNSUBSCRIBE": 1,
        "CONNECT": 1,
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
            out["channel_name"] = raw[index_of_arguments:]
        else:
            out["channel_name"] = []
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
                full_commands = parse_command["channel_name"]
                channel_code = None
                # only set currency_type and channel_code if its a SUB or UNSUB command
                if full_commands:
                    channel_code = full_commands[0]
                    if channel_code == "CRYPTO":
                        currency_type = full_commands[1]
                        task_code = currency_type
                    elif channel_code == "TGJU":
                        currency_type = full_commands[1]
                        task_code = channel_code
                    else:
                        currency_type = full_commands[0]
                        task_code = channel_code
                        # currency_obj = local.default_channels[]

                    # converting a normal telegram command to a tgju command (its brilliant i know :))
                    tgju_eq_code = get_tgju_data("CURRENCY", currency_type)
                    if tgju_eq_code:
                        channel_code = "TGJU"
                        task_code = "TGJU"
                        currency_type = tgju_eq_code

                if channel_code:
                    # get the task if exists
                    task = get_task(task_code)
                    if not task:
                        # if it doesn't create a brand new one
                        # note that we have to pass the websocket event loop
                        # because we will use it to create notification tasks
                        # please refer to the notes in the tasks.py file in the
                        # notify
                        task = Task(
                            task_code,
                            currency_obj=dict(),
                            loop=loop,
                            channel_code=channel_code,
                        )
                    else:
                        # log that task exist's
                        # setting it's loop value to the websocket event loop
                        # as mentioned why in the loop declaration
                        task.main_loop = loop
                        logger.info(f"task {task_code} exists")

                # this chain of if statement sets the channel list of the user type
                # and also sets the text_data (last price of the price type)
                if full_commands:
                    if channel_code == "TGJU":
                        task.ws_users.setdefault(currency_type, [])
                        # logger.info(f"selected {task.ws_users}")
                        select_user_list = task.ws_users[currency_type]
                        # means its the type selector command (either TGJU or CRYPTO)
                        existing_board = get_pickle_data(currency_type)

                        data = {currency_type: existing_board}
                        text_data = json.dumps(data)
                    elif channel_code == "CRYPTO":
                        task.ws_users.setdefault(currency_type, [])
                        # logger.info(f"selected {task.ws_users}")
                        select_user_list = task.users
                        # means its the type selector command (either TGJU or CRYPTO)
                        existing_board = get_pickle_data(currency_type)

                        data = {currency_type: existing_board}
                        text_data = json.dumps(data)

                    else:
                        select_user_list = task.users
                        # is_crypto = task.args.currency_info.get("is_crypto")
                        board = get_pickle_data(currency_type)

                        text_data = None
                        if task.lastprice:
                            text_data = json.dumps(board)

                # read the parsed data
                match parse_command["command"]:
                    # makes the user recieve updates on the subscried channel
                    case "SUBSCRIBE":
                        # if the user is not already subscribed and is inside the
                        # users we will add it to the users
                        # Get the user type based on the channel code

                        # Check if the WebSocket is already in the list
                        if websocket not in select_user_list and text_data:
                            logger.info(
                                f"add user {websocket.client.host}:{websocket.client.port} to {channel_code}"
                            )
                            select_user_list.append(websocket)
                            await websocket.send_text(text_data)
                        else:
                            # Notify the user that they are already subscribed
                            await websocket.send_text(
                                f"you have already subscribed to {channel_code}"
                            )

                    # makes the user no longer recieve updates on that channel
                    case "UNSUBSCRIBE":
                        # check if the user havnt already unsubscried from this channel
                        if websocket in select_user_list:
                            # call the disconnect function it will also remove the user from the list
                            # of the active task users
                            disconnect_websocket(
                                websocket, currency_type, select_user_list
                            )
                        else:
                            # notify the user that already been unsubbed
                            await websocket.send_text(
                                "your are not subscribed to any channel silly"
                            )
                    # returns the list of subscried channels to the user
                    case "CHANNELS":
                        channels_subbed_in = []
                        lists_user_joined = get_lists_user_joined(websocket)
                        print(lists_user_joined)
                        for user_obj in lists_user_joined:
                            channels_subbed_in.append(user_obj.get("type"))

                        # return a list of their codes to the user
                        print(channels_subbed_in)
                        await websocket.send_text(str(channels_subbed_in))

                    # returns the number of active tasks in the server
                    case "TASKS":
                        await websocket.send_text(str(len(tasks)))

                    # ping pong connection test
                    case "PING":
                        await websocket.send_text("PONG")
            else:
                # return the parser info on not ok status
                await websocket.send_text(str(parse_command))

    # Socket Exceptions
    # dissconnect exception handler
    except WebSocketDisconnect:
        log_message = (
            f"client {websocket.client.host}:{websocket.client.port} disconnected ❌❌"
        )
        if task:
            logger.info(log_message + f" from {channel_code}")
            # ensure disconnect and remove the user from the active users
            disconnect_websocket(websocket, user_type=currency_type)

            if len(task.users) < 1 and not task.args.channel_info["nonstop"]:
                task.stop()
        else:
            logger.info(log_message)

    # except Exception as e:
    #    logger.error(
    #        f"Custome Exception Occurred: {e}\nException from client {websocket.client.host}:{websocket.client.port}\ncheck the logs to see who that was"
    #    )
    #    await websocket.send_text(str(e))
    #    await websocket.close(1012)

    # general exception handler simply print the error
    # and return it to the user and close the connection
