from a2wsgi import ASGIMiddleware
from server import app  # Import your FastAPI app.
import uvicorn

uvicorn.run(
    "server:app",
    host="0.0.0.0",
    port=5000,
    # reload=True
)


application = ASGIMiddleware(app)
