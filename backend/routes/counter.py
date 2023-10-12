from modes import run_counter
from fastapi import APIRouter
from utils import get_defaults
from tasks import Arg


default_currencies = get_defaults()
router = APIRouter()


@router.get("/get_last/{code}/{channel}/{count}")
def get_live_counter(code: str, channel: int, count: int) -> list[dict]:
    """
    run the counter with the user specified arguments

    Retruns:
        the last `count` of the specified channel `code`

    """
    arg = Arg(code, channel_index=channel, count=count)
    return run_counter(arg)


@router.get("/get_supported/{}")
def get_supported(type: str) -> dict:
    # formats the json data by checking their currency_info and regex
    # and returns a json of information about each channel supportivity

    formatted = {}
    for currency_code, currency_obj in default_currencies.items():
        if not currency_obj or not type(currency_obj) == dict:
            # not a dictionary means its not even a price
            continue
        if not currency_obj.get("currency_info"):
            # no currency_info property means its not supported
            formatted[currency_code] = "not-supported"
            continue
        if currency_code == "TGJU":
            formatted[currency_code] = currency_obj["list_of_channels"][0][
                "currency_list"
            ][type]

        channel_list = currency_obj["list_of_channels"]
        # it should have at least one channel to be considered as a supported currency
        if len(channel_list) >= 1:
            for channel in channel_list:
                if channel["regex"]:
                    # regex means its supported-default
                    formatted[currency_code] = "supported-default"
                    break
                else:
                    # and not regex means supported-not-default
                    formatted[currency_code] = "not-default"
        else:
            # no channel means its not supported currency
            formatted[currency_code] = "not-supported"

    return formatted
