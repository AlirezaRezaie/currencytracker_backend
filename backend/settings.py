import os
import socket

# Define a hardcoded admin username and password (for demonstration purposes)
ADMIN_USERNAME = "admin"
ADMIN_PASSWORD = "admin_password"
HOST = socket.gethostname()
PORT = os.getenv("PORT", default=5000)
