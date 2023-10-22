from a2wsgi import ASGIMiddleware
from server import app  # Import your FastAPI app.
import uvicorn
import multiprocessing


def start_server():
    uvicorn.run(
        "server:app",
        host="0.0.0.0",
        port=5000,
    )


multiprocessing.Process(target=start_server).start()
application = ASGIMiddleware(app)
