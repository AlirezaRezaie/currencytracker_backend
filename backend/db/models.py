from sqlalchemy import Column, Integer, String, DateTime
from sqlalchemy.ext.declarative import declarative_base
import jdatetime
import locale

locale.setlocale(locale.LC_ALL, "fa_IR")

Base = declarative_base()


class News(Base):
    __tablename__ = "news"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255, collation="utf8mb4_unicode_ci"), index=True)
    topic = Column(String(255, collation="utf8mb4_unicode_ci"), index=True)
    description = Column(String(2000, collation="utf8mb4_unicode_ci"), index=True)
    image_link = Column(String(255), index=True)
    time_to_read = Column(Integer, index=True)
    created_at = Column(
        String(30, collation="utf8mb4_unicode_ci"),
        default=jdatetime.datetime.now().strftime("%a, %d %b %Y %H:%M"),
    )