"""Endpoint contracts with external API calls replaced by deterministic fixtures."""
from fastapi.testclient import TestClient
from app.main import app
from app.routes import api

WEATHER = {"current": {"time": "2026-09-11T10:00", "temperature_2m": 30, "relative_humidity_2m": 60, "apparent_temperature": 32, "weather_code": 0, "pressure_msl": 1010, "wind_speed_10m": 10, "wind_direction_10m": 180, "visibility": 10000, "uv_index": 5, "rain": 0}, "hourly": {"time": ["2026-09-11T10:00"] * 24, "temperature_2m": [30] * 24, "precipitation_probability": [0] * 24, "precipitation": [0] * 24, "weather_code": [0] * 24, "wind_speed_10m": [10] * 24}, "daily": {"time": [f"2026-09-{11+i:02d}" for i in range(7)], "weather_code": [0] * 7, "temperature_2m_max": [32] * 7, "temperature_2m_min": [22] * 7, "precipitation_probability_max": [10] * 7, "precipitation_sum": [0] * 7, "wind_speed_10m_max": [12] * 7, "sunrise": ["2026-09-11T06:00"], "sunset": ["2026-09-11T18:00"]}}

async def fake_location(city): return {"city": city, "state": "Test State", "country": "India", "latitude": 1.0, "longitude": 2.0}, WEATHER
async def fake_search(city): return [(await fake_location(city))[0]]
async def fake_air(lat, lon): return {"current": {"us_aqi": 30, "pm2_5": 5, "pm10": 10, "ozone": 20, "nitrogen_dioxide": 3}}

def setup_module():
    api.location_and_weather = fake_location
    api.search_city = fake_search
    api.get_air_quality = fake_air

client = TestClient(app)

def test_health(): assert client.get("/api/health").json()["success"]
def test_weather_endpoints():
    assert client.get("/api/weather/current?city=Agra").json()["temperature"] == 30
    assert len(client.get("/api/weather/hourly?city=Agra").json()["hourly"]) == 24
    assert len(client.get("/api/weather/forecast?city=Agra").json()["forecast"]) == 7
def test_other_core_endpoints():
    assert client.get("/api/locations/search?q=Agra").json()["locations"]
    assert client.get("/api/air-quality?city=Agra").json()["aqi"] == 30
    assert client.get("/api/alerts?city=Agra").json()["success"]
    assert client.get("/api/risk?city=Agra").json()["success"]
    assert client.get("/api/agriculture/advisory?city=Agra&crop=wheat").json()["success"]
    assert client.post("/api/chat", json={"message": "weather in Agra"}).json()["success"]
