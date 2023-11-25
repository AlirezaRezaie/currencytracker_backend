from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from network import network_stability_check
from logs import logger
from tasks import Task, tasks
from utils import *
import locale
import sys

# import each router to include them
from routes import counter, live, news, utils, calculator


locale.setlocale(locale.LC_ALL, "fa_IR")

# main fastapi app instance
app = FastAPI()

# Mount the "static" directory as a static resources route
app.mount("/static", StaticFiles(directory="static"), name="static")

# include each module's router
app.include_router(live.router, prefix="/api", tags=["live"])
app.include_router(counter.router, prefix="/counter", tags=["counter"])
app.include_router(news.router, prefix="/news", tags=["news"])
app.include_router(utils.router, prefix="/utils", tags=["utils"])
app.include_router(calculator.router, prefix="/calculator", tags=["calculator"])


@app.on_event("startup")
async def startup_event():
    # network_stability_check()
    # start the default channels on startup
    local.default_channels = get_defaults()
    currencies = local.default_channels

    for currency_code, currency_obj in currencies.items():
        if not currency_obj or not type(currency_obj) == dict:
            # dont start empty currency channels
            continue
        if not currency_obj.get("currency_info"):
            # dont start no currency channels
            continue

        channel_list = currency_obj["list_of_channels"]
        for channel in channel_list:
            task_codes = []
            if currency_code == "CRYPTO":
                task_codes = list(channel.get("currency_list").keys())
            else:
                task_codes.append(currency_code)

            if channel["nonstop"]:
                for code in task_codes:
                    # only start the ones which have specified nonstop in their config
                    Task(
                        code,
                        currency_obj,
                        channel_index=channel_list.index(channel),
                        channel_code=currency_code,
                    )


@app.on_event("shutdown")
async def shutdown_event():
    print("shutting down please wait...")
    print(f"closing {len(tasks)} tasks...")
    # loop through all running tasks
    for task in tasks.copy():
        # set the stop event (it will break the task while loop therefore exit the task)
        task.stop()

    print("stopping all tasks complete")


if __name__ == "__main__":
    # only run python server.py for development
    # for the production use the uvicorn command
    import uvicorn

    try:
        # a simple net check test for unstable networks
        network_stability_check()
        logger.info(f"env port is set to: {get_port()}")
        uvicorn.run(
            "server:app",
            host="localhost",
            port=get_port(),
            # reload=True
        )
    except KeyboardInterrupt:
        sys.exit()
