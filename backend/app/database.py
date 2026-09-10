from sqlalchemy import create_engine, text
from sqlalchemy.exc import SQLAlchemyError
from .config import get_settings
engine = create_engine(get_settings().database_url, pool_pre_ping=True)
def database_is_available() -> bool:
    try:
        with engine.connect() as connection: connection.execute(text("SELECT 1"))
        return True
    except SQLAlchemyError: return False
