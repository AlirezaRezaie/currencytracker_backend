from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
from db.models import Base

# from db.test_db import add_news
# Create the tables in your database
engine = create_engine("sqlite:///./db/your_database.db")
Base.metadata.create_all(engine)

# Now that the tables are created, configure your engine and metadata
Session = sessionmaker(bind=engine)

# You can now start using your database session
session = Session()


def get_db():
    db = Session()
    try:
        yield db
    finally:
        db.close()
