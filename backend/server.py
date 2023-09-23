from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from network import network_stability_check
from logs import logger
from routes import counter, live, news, utils,calculator
from tasks import Task, tasks
from utils import *
import locale

locale.setlocale(locale.LC_ALL, "fa_IR")

app = FastAPI()
# Mount the "static" directory as a static resources route
app.mount("/static", StaticFiles(directory="static"), name="static")

app.include_router(live.router, prefix="/api", tags=["live"])
app.include_router(counter.router, prefix="/counter", tags=["counter"])
app.include_router(news.router, prefix="/news", tags=["news"])
app.include_router(utils.router, prefix="/utils", tags=["utils"])
app.include_router(calculator.router, prefix="/calculator", tags=["calculator"])

@app.on_event("startup")
async def startup_event():
    # start the default channels on startup :O
    currencies = get_defaults()
    for currency,channel_list in currencies.items():
        for channel in channel_list:
            if channel["nonstop"]:
                Task(currency,channel_index=channel_list.index(channel))


@app.on_event("shutdown")
async def shutdown_event():
    print("shutting down please wait...")
    print(f"closing {len(tasks)} tasks...")
    for task in tasks:
        task.stop_event.set()
        while True:
            task.task.join()
            break
    print("stopping all tasks complete")


if __name__ == "__main__":
    import uvicorn

    network_stability_check()
    logger.info(f"env port is set to: {get_port()}")
    uvicorn.run(
        "server:app",
        host=get_host(),
        port=get_port(),
        reload=True
    )
