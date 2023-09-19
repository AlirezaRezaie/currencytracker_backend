from modes import run_counter
from tasks import Arg
from settings import get_defaults
from locals import local
from fastapi import APIRouter


router = APIRouter()


@router.get("/get_last/{code}/{count}")
async def get_live_counter(code: str, count: int) -> str:
    default_id = get_defaults(code)
    args = Arg(default_id, count=count)
    local.args = args
    return str(run_counter(args))


@router.get("/get_supported")
async def get_live_counter(code: str, count: int) -> list:
    defaults = get_defaults()
    return list(defaults.values())
