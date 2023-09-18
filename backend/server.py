from fastapi import FastAPI

from fastapi.staticfiles import StaticFiles

from network import network_stability_check
from logs import logger
from routes import counter, live, news
from tasks import get_task
from settings import *

import locale

locale.setlocale(locale.LC_ALL, "fa_IR")

app = FastAPI()
# Mount the "static" directory as a static resources route
app.mount("/static", StaticFiles(directory="static"), name="static")

app.include_router(live.router, prefix="/api", tags=["live"])
app.include_router(counter.router, prefix="/counter", tags=["counter"])
app.include_router(news.router, prefix="/news", tags=["news"])


@app.get("/get_hosts")
def get_hosts() -> dict:
    url = f"{get_host()}:{get_port()}"
    paths = {
        "http": f"http://{url}",
        "ws": f"ws://{url}",
        "lastprice": str(get_task("nerkhedollarr").lastprice),
    }
    return paths


if __name__ == "__main__":
    import uvicorn

    network_stability_check()

    logger.info(f"env port is set to: {get_port()}")
    uvicorn.run(
        "server:app",
        host=get_host(),
        port=get_port(),
    )
