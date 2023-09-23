from modes import run_counter
from locals import local
from fastapi import APIRouter
from settings import get_defaults
from tasks import Arg

default_currencies = get_defaults()
router = APIRouter()

@router.get("/get_last/{code}/{channel}/{count}")
def get_live_counter(code: str, channel: int, count: int) -> str:
    local.count = count
    arg = Arg(code)
    return str(run_counter(arg))


@router.get("/get_supported")
def get_live_counter() -> dict:
    formatted = {}
    for currency,channel_list in default_currencies.items():
        if len(channel_list) >= 1:
            for channel in channel_list:
                if channel["regex"]:
                    formatted[currency] = "supported-default"
                    break
                else:
                    formatted[currency] = "not-default"
        else:
            print(currency)
            formatted[currency] = "not-supported"
    return formatted
