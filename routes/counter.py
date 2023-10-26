from modes import run_counter
from fastapi import APIRouter
from utils import get_defaults, get_tgju_data, get_running_tg_obj
from tasks import Arg
import pickle

default_currencies = get_defaults()
router = APIRouter()


@router.get("/get_last/{code}/{channel}/{count}")
def get_live_counter(code: str, channel: int, count: int) -> list[dict] | list[str]:
    """
    run the counter with the user specified arguments

    Retruns:
        the last `count` of the specified channel `code`

    """

    # only for tgju related ones
    pickle_name = get_tgju_data("CURRENCY", code, default_currencies)

    # only for telegram ones
    currency_obj = default_currencies.get(code)

    # if tgju we use its pickle file to return the data
    if pickle_name:
        try:
            with open(f"pickles/{pickle_name}.pkl", "rb") as file:
                read_pickle = pickle.load(file)
                return read_pickle[pickle_name]
        except:
            return ["error pickle data not found"]
    # and if telegram we run the counter function that fetches from telegram
    elif currency_obj:
        arg = Arg(code, currency_obj, channel_index=channel, count=count)
        return run_counter(arg)

    else:
        return ["error code not found anywhere"]


@router.get("/get_supported")
def get_supported(q: str = None) -> dict | list[dict]:
    # formats the json data by checking their currency_info and regex
    # and returns a json of information about each channel supportivity
    if q == "CRYPTO":
        data = {}
        crypto_supported = default_currencies.get("CRYPTO")["list_of_channels"][0][
            "currency_list"
        ]
        for symbol, name in crypto_supported.items():
            data[symbol] = name
        return data

    elif q == "GOLD":
        data = {}
        gold_supported = default_currencies.get("TGJU")["list_of_channels"][0][
            "currency_list"
        ]["GOLD"]
        for currency in gold_supported:
            data[currency["code"]] = currency["name"]
        return data

    not_cur = ("TGJU", "CRYPTO", "VPN")
    formatted = {}
    for code, obj in default_currencies.items():
        if (not code in not_cur) and (
            not get_tgju_data("CURRENCY", code, default_currencies)
        ):
            formatted[code] = obj["currency_info"]

    tgju_obj = default_currencies.get("TGJU")["list_of_channels"][0]["currency_list"][
        "CURRENCY"
    ]

    for currency in tgju_obj:
        formatted[currency["currency_symbol"]] = currency

    return formatted
