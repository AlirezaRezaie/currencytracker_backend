from tasks import get_task
from settings import get_host, get_port
from fastapi import APIRouter

router = APIRouter()


@router.get("/get_hosts")
def get_hosts() -> dict:
    url = f"{get_host()}:{get_port()}"
    paths = {
        "http": f"http://{url}",
        "ws": f"ws://{url}",
        "lastprice": str(get_task("nerkhedollarr").lastprice),
    }
    return paths
