from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, scoped_session
from sqlalchemy.ext.declarative import declarative_base
from db.models import Base
from logs import logger

# from db.test_db import add_news
# Create the tables in your database


new_enigne = create_engine("sqlite:///db/your_database.db")
engine = new_enigne
Base.metadata.create_all(engine)

# Now that the tables are created, configure your engine and metadata
Session = sessionmaker(bind=engine)

# You can now start using your database session
session = Session()


# yields the currenct instance of the session
def get_db():
    db = scoped_session(Session)
    try:
        yield db
    finally:
        db.close()
