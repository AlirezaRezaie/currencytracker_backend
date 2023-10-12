import logging

# Set up a custom logger with your desired name
logger = logging.getLogger("dolarlog")
logger.setLevel(logging.INFO)

# Create a stream handler to direct log messages to the console
handler = logging.StreamHandler()
handler.setLevel(logging.INFO)

# Create a formatter for the log messages
formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)

# Add the handler to your custom logger
logger.addHandler(handler)
