from modes import run_counter
from fastapi import APIRouter
from utils import get_defaults
from tasks import Arg
from modes import currency_map_rev
import pickle


default_currencies = get_defaults()
router = APIRouter()

def get_data(code,count):
    
    default_currencies = get_defaults()
    # only for tgju related ones
    try:
        pickle_name = currency_map_rev[code]
    except KeyError:
        pickle_name = None

    # only for telegram ones
    currency_obj = default_currencies.get(code)

    # if tgju we use its pickle file to return the data
    if pickle_name:
        try:
            with open(f"pickles/{pickle_name}.pkl", "rb") as file:
                read_pickle = pickle.load(file)
                print(read_pickle[code])
                print(count)
                return read_pickle[code]
        except:
            return ["error pickle data not found"]
    # and if telegram we run the counter function that fetches from telegram
    elif currency_obj:
        arg = Arg(code, currency_obj, count=count)
        return run_counter(arg)

    else:
        return "error code not found anywhere"

@router.get("/get_last/{code}/{count}")
def get_live_counter(code: str, count: int) -> list[dict] | list[str]:
    """
    run the counter with the user specified arguments

    Retruns:
        the last `count` of the specified channel `code`
    """

    return get_data(code,count)


@router.get("/get_supported")
def get_supported(q: str = None) -> dict | list[dict]:
    # formats the json data by checking their currency_info and regex
    # and returns a json of information about each channel supportivity
    if q == "CRYPTO":
        data = {}
        crypto_supported = default_currencies.get("CRYPTO")[
            "currency_list"
        ]
        for symbol, name in crypto_supported.items():
            data[symbol] = name
        return data

    elif q == "GOLD":
        data = {}
        gold_supported = default_currencies.get("TGJU")[
            "currency_list"
        ]["GOLD"]
        for currency in gold_supported:
            data[currency["code"]] = currency["name"]
        return data
    
    else:
        data = {}
        currency_supported = default_currencies.get("TGJU")["currency_list"][
            "CURRENCY"
        ]

        for currency in currency_supported:
            print(currency)
            symbol = currency["currency_symbol"]
            data[symbol] = currency
            data[symbol]["link"] = f"http://aryasweb.ir/static/images/{symbol}.png"
        return data
