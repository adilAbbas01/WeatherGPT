import httpx
from ...config import get_settings
async def get_weather(latitude: float, longitude: float) -> dict:
    s = get_settings()
    params = {"latitude": latitude, "longitude": longitude, "current": "temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,rain,weather_code,pressure_msl,wind_speed_10m,wind_direction_10m,visibility,uv_index", "hourly": "temperature_2m,precipitation_probability,precipitation,weather_code,wind_speed_10m", "daily": "weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,precipitation_sum,wind_speed_10m_max,sunrise,sunset", "forecast_days": 7, "timezone": "auto"}
    async with httpx.AsyncClient(timeout=12) as client:
        response = await client.get(f"{s.open_meteo_base_url}/v1/forecast", params=params); response.raise_for_status(); return response.json()
