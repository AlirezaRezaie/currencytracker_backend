from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

from network import network_stability_check
from logs import logger
from routes import counter, live, news, utils
from tasks import Task, tasks
from settings import *
import locale

locale.setlocale(locale.LC_ALL, "fa_IR")

app = FastAPI()
# Mount the "static" directory as a static resources route
app.mount("/static", StaticFiles(directory="static"), name="static")

app.include_router(live.router, prefix="/api", tags=["live"])
app.include_router(counter.router, prefix="/counter", tags=["counter"])
app.include_router(news.router, prefix="/news", tags=["news"])
app.include_router(utils.router, prefix="/utils", tags=["utils"])


@app.on_event("startup")
async def startup_event():
    # start the default channels on startup :O
    usd = Task("USD")
    dhs = Task("DHS")


@app.on_event("shutdown")
async def shutdown_event():
    # start the default channels on startup :O
    print("bye")
    print(len(tasks))
    for task in tasks:
        task.stop_event.set()
        while True:
            task.task.join()
            break


if __name__ == "__main__":
    import uvicorn

    network_stability_check()
    logger.info(f"env port is set to: {get_port()}")
    uvicorn.run(
        "server:app",
        host=get_host(),
        port=get_port(),
    )
