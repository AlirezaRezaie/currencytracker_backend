from tasks import get_task
from utils import get_host, get_port
from fastapi import APIRouter

router = APIRouter()


@router.get("/{from_currency_code}:{to_currency_code}")
def get_last_prices(from_currency_code:str,to_currency_code:str) -> dict:
    from_last_price = get_task(from_currency_code).lastprice['price']
    to_last_price = get_task(to_currency_code).lastprice['price']

    return {"from":from_last_price,"to":to_last_price}
