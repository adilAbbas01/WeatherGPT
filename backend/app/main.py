from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .config import get_settings
from .routes.api import router
settings=get_settings(); app=FastAPI(title="WeatherGPT API",version="1.0.0",description="Real weather, air quality, and rule-based weather intelligence.")
app.add_middleware(CORSMiddleware,allow_origins=[settings.frontend_url],allow_credentials=True,allow_methods=["*"],allow_headers=["*"])
app.include_router(router)
