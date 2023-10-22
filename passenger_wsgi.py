from a2wsgi import ASGIMiddleware
from server import app  # Import your FastAPI app.
import uvicorn

application = ASGIMiddleware(app)
uvicorn.run(
    "server:app",
    host="0.0.0.0",
    port=5000,
    # reload=True
)
