import os
import socket

# Define a hardcoded admin username and password (for demonstration purposes)
ADMIN_USERNAME = "admin"
ADMIN_PASSWORD = "admin_password"


def get_host():
    return socket.gethostname()


def get_port():
    return os.getenv("PORT", default=5000)
