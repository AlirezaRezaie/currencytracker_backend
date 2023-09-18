from fastapi import (
    Depends,
    Request,
    UploadFile,
    Form,
    HTTPException,
)
from fastapi.responses import HTMLResponse

from sqlalchemy.orm import Session
from db.database import get_db
from db.models import News

from tasks import *

from settings import *
from fastapi.security import HTTPBasic, HTTPBasicCredentials

import jdatetime
from fastapi.templating import Jinja2Templates
from fastapi import APIRouter

router = APIRouter()

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


# Create a route to serve the HTML form
@router.get("/add/", response_class=HTMLResponse)
async def serve_form(
    request: Request, credentials: HTTPBasicCredentials = Depends(authenticate_user)
):
    return templates.TemplateResponse(
        "news.html", {"request": request, "token": credentials}
    )


# Dependency function for user authentication


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

    if not photo.file.read() or not photo.filename.lower().endswith(valid_extensions):
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
        created_at=jdatetime.datetime.now().strftime("%a, %d %b %Y %H:%M"),
        time_to_read=time_to_read,
    )
    db.add(new_entry)
    db.commit()
    db.close()
    # Here, I'm just returning a message with the received data
    return {"status": "ok"}


@router.get("/get_news")
def get_all_people(db: Session = Depends(get_db)):
    news = db.query(News).all()
    db.close()
    return news
