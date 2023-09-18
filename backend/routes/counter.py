from modes import run_counter
from tasks import *
from locals import local
from fastapi import APIRouter

router = APIRouter()


@router.get("/get_last/{id}/{count}")
async def get_live_counter(id: str, count: int) -> str:
    args = Arg(id, count=count)
    local.args = args
    return str(run_counter(args))
