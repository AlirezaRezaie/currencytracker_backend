from a2wsgi import ASGIMiddleware
from server import app  # Import your FastAPI app.

application = ASGIMiddleware(app)
