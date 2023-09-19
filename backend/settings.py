import os
import socket

# Define a hardcoded admin username and password (for demonstration purposes)
ADMIN_USERNAME = "admin"
ADMIN_PASSWORD = "admin_password"


def get_host():
    return socket.gethostname()


def get_port():
    return os.getenv("PORT", default=5000)


def get_defaults(code=None):
    default_channels = {
        "USD": "nerkhedollarr",
        "EUR": "sarafha_rate",
        # "JPY": "",
        # "GDP": "",
        "DHS": "DHS_Dirham",
    }
    if not code:
        return default_channels

    if code in default_channels:
        return default_channels[code]
    else:
        None
