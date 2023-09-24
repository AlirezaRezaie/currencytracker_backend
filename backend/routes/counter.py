from modes import run_counter
from locals import local
from fastapi import APIRouter
from utils import get_defaults
from tasks import Arg

default_currencies = get_defaults()
router = APIRouter()

@router.get("/get_last/{code}/{channel}/{count}")
def get_live_counter(code: str, channel: int, count: int) -> list[dict]:
    arg = Arg(code,channel_index=channel,count=count)
    return run_counter(arg)


@router.get("/get_supported")
def get_supported() -> dict:
    formatted = {}
    for currency_code,currency_obj in default_currencies.items():
        if not currency_obj or not type(currency_obj) == dict:
            continue
        if not currency_obj.get("currency_info"):
            formatted[currency_code] = "not-supported"
            continue
        
        channel_list = currency_obj["list_of_channels"]
        if len(channel_list) >= 1:
            for channel in channel_list:
                if channel["regex"]:
                    formatted[currency_code] = "supported-default"
                    break
                else:
                    formatted[currency_code] = "not-default"
        else:
            print(currency_code)
            formatted[currency_code] = "not-supported"
    return formatted
