from tasks import get_task
from fastapi import APIRouter
from .counter import get_data

router = APIRouter()


@router.get("/{from_currency_code}:{to_currency_code}")
def get_last_prices(from_currency_code: str, to_currency_code: str) -> dict:
    # getting the (from) and (to) data's from the tasks list according to their code name
    # and returning the latest price of each code name to be calculated in the frontend for
    # exchange currencies
    from_last_price = get_data(from_currency_code,0,1)[0]["price"]
    to_last_price = get_data(to_currency_code,0,1)[0]["price"]

    return {"from": from_last_price, "to": to_last_price}
