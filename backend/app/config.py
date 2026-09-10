from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    database_url: str = "postgresql+psycopg2://postgres:password@localhost:5432/weathergpt"
    frontend_url: str = "http://localhost:5173"
    open_meteo_base_url: str = "https://api.open-meteo.com"
    air_quality_base_url: str = "https://air-quality-api.open-meteo.com"
    nominatim_base_url: str = "https://nominatim.openstreetmap.org"
    nominatim_user_agent: str = "WeatherGPT-SIH-2026/1.0 (contact@example.com)"
    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

@lru_cache
def get_settings() -> Settings: return Settings()
