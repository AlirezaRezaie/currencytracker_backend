from a2wsgi import ASGIMiddleware
from server import app  # Import your FastAPI app.
import subprocess
import psutil

server_proc_exist = False
for process in psutil.process_iter(attrs=["pid", "name"]):
    if "uvicorn" in process.info["name"]:
        print("process uvicorn exists")
        server_proc_exist = True
        break

if not server_proc_exist:
    script_path = "run_server.sh"
    print("creating a new uvicorn process")
    subprocess.call(["sh", script_path])

application = ASGIMiddleware(app)
