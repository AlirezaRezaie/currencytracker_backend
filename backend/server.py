from fastapi import (
    FastAPI,
    WebSocket,
    Depends,
    Request,
    UploadFile,
    Form,
    HTTPException,
)
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from starlette.websockets import WebSocketDisconnect

from sqlalchemy.orm import Session
from db.database import get_db
from db.models import News

from network import network_stability_check
from modes import run_counter
from tasks import *
from logs import logger
import asyncio

from locals import local
from settings import *
from fastapi.security import HTTPBasic, HTTPBasicCredentials

app = FastAPI()
# Mount the "static" directory as a static resources route
app.mount("/static", StaticFiles(directory="static"), name="static")
security = HTTPBasic()

# Define a Jinja2 template directory
templates = Jinja2Templates(directory="templates")
# Check if the directory exists
uploads_path = "static/uploads"
if not os.path.exists(uploads_path):
    # If it doesn't exist, create it
    os.makedirs(uploads_path)
else:
    print(f"Directory '{uploads_path}' already exists.")


# Define a function to check user credentials
def authenticate_user(credentials: HTTPBasicCredentials = Depends(security)):
    correct_username = "bachekhoob"  # Replace with your desired username
    correct_password = "kirkhar92"  # Replace with your desired password

    if (
        credentials.username != correct_username
        or credentials.password != correct_password
    ):
        raise HTTPException(status_code=401, detail="Incorrect credentials")


@app.websocket("/live/{id}")
async def websocket_endpoint(websocket: WebSocket, id: str):
    await websocket.accept()
    logger.info(f"client {websocket.client.host}:{websocket.client.port} connected 🔌🔌")
    try:
        loop = asyncio.get_event_loop()
        task = get_task(id)
        if not task:
            task = Task(id, loop)
        else:
            logger.info(f"task {id} exists")

        task.users.append(websocket)
        if task.lastprice:
            await websocket.send_text(json.dumps(task.lastprice))
        while True:
            await websocket.receive_text()
    except WebSocketDisconnect:
        disconnect_websocket(task, websocket)
    except Exception as e:
        logger.error(
            f"Custome Exception Occurred: {e}\nException from client {websocket.client.host}:{websocket.client.port}\ncheck the logs to see who that was"
        )
        await websocket.send_text(str(e))
        await websocket.close(1012)


@app.get("/counter/{id}/{count}")
async def get_live_counter(id: str, count: int) -> str:
    args = Arg(id, count=count)
    local.args = args
    return str(run_counter(args))


# Create a route to serve the HTML form
@app.get("/add/", response_class=HTMLResponse)
async def serve_form(
    request: Request, credentials: HTTPBasicCredentials = Depends(authenticate_user)
):
    return templates.TemplateResponse(
        "news.html", {"request": request, "token": credentials}
    )


# Dependency function for user authentication


@app.post("/upload/")
async def upload_file(
    request: Request,
    title: str = Form(...),
    topic: str = Form(...),
    description: str = Form(...),
    photo: UploadFile = Form(...),
    time_to_read: int = Form(...),
    db: Session = Depends(get_db),
):
    if not photo.file.read() or not photo.filename.endswith(".jpg"):
        raise HTTPException(status_code=400, detail="please provide a photo")

    photo.file.seek(0)  # Set the file pointer to the beginning
    # Do something with the uploaded image, like saving it
    # You can access the image data via 'photo.file' and save it to a location
    image_path = os.path.join("static", "uploads", photo.filename)
    with open(image_path, "wb") as image_file:
        while True:
            chunk = await photo.read(1024)
            image_file.write(chunk)
            # Read a chunk of bytes
            if not chunk:
                print("ok?")
                break

    new_entry = News(
        title=title,
        topic=topic,
        description=description,
        image_link=f"http://{get_host()}:{get_port()}/{image_path}",
        time_to_read=time_to_read,
    )
    db.add(new_entry)
    db.commit()
    # Here, I'm just returning a message with the received data
    return {"status": "ok"}


@app.get("/get_news")
def get_all_people(db: Session = Depends(get_db)):
    news = db.query(News).all()
    return news


@app.get("/get_hosts")
def get_hosts() -> dict:
    url = f"{get_host()}:{get_port()}"
    paths = {
        "http": f"http://{url}",
        "ws": f"ws://{url}",
    }
    return paths


if __name__ == "__main__":
    import uvicorn

    # network_stability_check()

    logger.info(f"env port is set to: {get_port()}")
    uvicorn.run(
        "server:app",
        host=get_host(),
        port=get_port(),
    )
