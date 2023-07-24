from modes import *
from parse import args, parser
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

# handle keyboard interrupt
try:
    if args.mode == "live":
        logger.info("Running in live mode")
        run_live()
    elif args.mode == "count":
        run_counter(args.count)
    else:
        parser.print_help()
except KeyboardInterrupt:
    print("\nok bye")
