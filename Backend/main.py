from modes import *
from clparser import args, parser
from network import network_stability_check, FetchRate
import logging

# Create a logger instance
logger = logging.getLogger("dolarlog")
logger.setLevel(logging.NOTSET)

# Create a console handler and set its log level to DEBUG
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.NOTSET)

# Create a formatter to define the log message format
formatter = logging.Formatter("%(message)s")  # Only includes the message
console_handler.setFormatter(formatter)

# Add the console handler to the logger
logger.addHandler(console_handler)

if args.verbose:
    logger.setLevel(logging.INFO)


if args.use_api:
    logger.info("--use-api option enabled")

if args.save_results:
    logger.info("--save-results option enabled")

network_stability_check(args.proxy)


def simple_price_logger(price, channel):
    print(price)


# TODO : instead of sending all args seperatly send an args object
# handle keyboard interrupt
try:
    if args.mode == "live":
        logger.info("Running in live mode")
        run_live(simple_price_logger, args)
    elif args.mode == "count":
        prices = run_counter(args)
        for price in prices:
            print(price)
    else:
        parser.print_help()
except KeyboardInterrupt:
    print("\nok bye")
