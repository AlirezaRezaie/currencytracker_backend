from modes import run_counter
from locals import local
from fastapi import APIRouter


router = APIRouter()


@router.get("/get_last/{code}/{channel}/{count}")
def get_live_counter(code: str, channel: str, count: int) -> str:
    get_channel = local.default_channels[code][channel]
    local.channel_info = get_channel
    local.channel_id = get_channel["channel_name"]
    local.count = count
    local.code = code
    return str(run_counter())


@router.get("/get_supported")
def get_live_counter() -> list:
    return list(local.default_channels.values())
