from sqlalchemy import Column, Integer, String, DateTime, TypeDecorator
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()


class News(Base):
    __tablename__ = "news"

    id = Column(Integer, primary_key=True, index=True)
    # collation="utf8mb4_unicode_ci" is for specifying its a persian text
    title = Column(String(255, collation="utf8mb4_unicode_ci"), index=True)
    topic = Column(String(255, collation="utf8mb4_unicode_ci"), index=True)
    description = Column(String(2000, collation="utf8mb4_unicode_ci"), index=True)
    image_link = Column(String(255), index=True)
    time_to_read = Column(Integer, index=True)

    created_at = Column(
        String(50, collation="utf8mb4_unicode_ci")
    )  # Use String type to store the formatted time
