import os
import socket
import json

# Define a hardcoded admin username and password (for demonstration purposes)
ADMIN_USERNAME = "admin"
ADMIN_PASSWORD = "admin_password"


def get_host():
    return socket.gethostname()


def get_port():
    return os.getenv("PORT", default=5000)


def get_defaults():
    # read the json file
    with open("default-channels.json", "r") as f:
        return json.load(f)
