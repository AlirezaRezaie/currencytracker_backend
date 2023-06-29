import argparse

parser = argparse.ArgumentParser(
    prog="livedollar",
    description="The livedollar \
    is a simple and convenient tool that provides users \
    with the live exchange rate of the US dollar in Iranian Rials (IRR) \
    right from their terminal. It allows users to quickly check the \
    current conversion rate and stay up-to-date with the latest changes \
    in the exchange market.",
    epilog="happy checking the currency :)",
)

parser.add_argument(
    "-v", "--verbose", dest="verbose", action="store_true", help="Enable verbose mode"
)

parser.add_argument("-live", action="store_true", help="Run in live mode")

parser.add_argument("-count", type=int, help="Run counter with the specified number")


parser.add_argument(
    "--channel-id",
    type=str,
    metavar="ID",
    help="which dollar Telegram channel to use [optional]",
)

parser.add_argument(
    "--retry",
    type=int,
    metavar="TIMES",
    help="times to retry the connection before exiting program (for slow networks default:5 ) [optional]",
)
parser.add_argument(
    "--use-api",
    action="store_true",
    help="Uses Telegram's official API as the fetch method instead of web scrape [optional]",
)

parser.add_argument(
    "--save-results",
    action="store_true",
    help="Saves results in json format [optional]",
)

args = parser.parse_args()
