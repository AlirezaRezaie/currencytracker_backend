from fastapi import (
    Depends,
    Request,
    UploadFile,
    Form,
    HTTPException,
)

from enum import Enum
from fastapi.responses import HTMLResponse

from sqlalchemy.orm import Session
from db.database import get_db
from db.models import News

from tasks import *

from utils import *
from fastapi.security import HTTPBasic, HTTPBasicCredentials

import jdatetime
from fastapi.templating import Jinja2Templates
from fastapi import APIRouter
import os

router = APIRouter()

# this is for the pop up login page built-in browser
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

    # simple authentication
    if (
        credentials.username != correct_username
        or credentials.password != correct_password
    ):
        raise HTTPException(status_code=401, detail="Incorrect credentials")


# Create a route to serve the HTML form
@router.get("/add/", response_class=HTMLResponse)
async def serve_form(
    request: Request, credentials: HTTPBasicCredentials = Depends(authenticate_user)
):
    return templates.TemplateResponse(
        "news.html", {"request": request, "token": credentials}
    )


# upload handler
@router.post("/upload/")
async def upload_file(
    request: Request,
    title: str = Form(...),
    topic: str = Form(...),
    description: str = Form(...),
    photo: UploadFile = Form(...),
    time_to_read: int = Form(...),
    db: Session = Depends(get_db),
):
    valid_extensions = (".jpg", ".jpeg", ".png")

    # check the extension of the uploaded file to ensure its picture
    if not photo.file.read() or not photo.filename.lower().endswith(valid_extensions):
        raise HTTPException(status_code=400, detail="please provide a photo")

    photo.file.seek(0)  # Set the file pointer to the beginning

    # set the image save path to the uploads directory
    image_path = os.path.join("static", "uploads", photo.filename)

    with open(image_path, "wb") as image_file:
        while True:
            # read and save to the uplaods 1kb until we have read all of the file
            chunk = await photo.read(1024)
            image_file.write(chunk)
            if not chunk:
                print("ok?")
                break

    # create a new news entry
    new_entry = News(
        title=title,
        topic=topic,
        description=description,
        image_link=f"http://{get_host()}:{get_port()}/{image_path}",
        created_at=jdatetime.datetime.now().strftime("%a, %d %b %Y %H:%M"),
        time_to_read=time_to_read,
    )

    # save it in th
    db.add(new_entry)
    db.commit()
    db.close()
    # Here, I'm just returning a message with the received data
    return {"status": "ok"}


# query mode enum
class QueryMode(str, Enum):
    LATEST = "latest"
    ALL = "all"


# returns all or latest news from the news table in the db
@router.get("/get_news/{value}")
def get_all_people(value: QueryMode, db: Session = Depends(get_db)):
    # the db query object
    db_query = db.query(News)
    # its latest mode return the first db object
    if value == QueryMode.LATEST:
        news = db_query.order_by(News.id.desc()).first()

    # its all so return every news to the user
    elif value == QueryMode.ALL:
        news = db_query.all()

    db.close()
    return news
