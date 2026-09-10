import httpx
from ...config import get_settings
async def search_city(query: str) -> list[dict]:
    s = get_settings()
    async with httpx.AsyncClient(timeout=10, headers={"User-Agent": s.nominatim_user_agent}) as client:
        response = await client.get(f"{s.nominatim_base_url}/search", params={"q": query, "format": "jsonv2", "addressdetails": 1, "limit": 5})
        response.raise_for_status()
    return [{"city": i.get("address", {}).get("city") or i.get("address", {}).get("town") or i.get("address", {}).get("village") or i["display_name"].split(",")[0], "state": i.get("address", {}).get("state", ""), "country": i.get("address", {}).get("country", ""), "latitude": float(i["lat"]), "longitude": float(i["lon"])} for i in response.json()]
