import httpx
from ...config import get_settings
async def get_air_quality(latitude: float, longitude: float) -> dict:
    s = get_settings()
    async with httpx.AsyncClient(timeout=10) as client:
        response = await client.get(f"{s.air_quality_base_url}/v1/air-quality", params={"latitude": latitude, "longitude": longitude, "current": "us_aqi,pm2_5,pm10,ozone,nitrogen_dioxide"}); response.raise_for_status(); return response.json()
