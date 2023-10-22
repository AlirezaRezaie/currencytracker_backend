from tasks import get_task
from utils import get_host, get_port
from fastapi import APIRouter


router = APIRouter()

# some utility functions and routes


# return the current host name using the os
@router.get("/get_hosts")
def get_hosts() -> dict:
    url = f"{get_host()}:{get_port()}"
    paths = {
        "http": f"http://{url}",
        "ws": f"ws://{url}",
    }
    return paths
