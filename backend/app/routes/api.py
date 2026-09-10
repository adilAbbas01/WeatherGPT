from fastapi import APIRouter,HTTPException
from pydantic import BaseModel,Field
from ..database import database_is_available
from ..api.clients.nominatim import search_city
from ..api.clients.air_quality import get_air_quality
from ..services.weather_service import location_and_weather,current_payload,hourly_payload,forecast_payload
from ..services.intelligence_service import alerts,risks,agriculture
router=APIRouter(prefix="/api")
def error(exc):
    if isinstance(exc,ValueError): raise HTTPException(404,{"success":False,"message":str(exc)})
    raise HTTPException(502,{"success":False,"message":"Weather data is temporarily unavailable."})
@router.get("/health")
def health(): return {"success":True,"service":"WeatherGPT API","database":"connected" if database_is_available() else "unavailable"}
@router.get("/locations/search")
async def locations_search(q:str):
    try: return {"success":True,"locations":await search_city(q)}
    except Exception as exc: error(exc)
@router.get("/weather/current")
async def weather_current(city:str):
    try:
        location,weather=await location_and_weather(city); return current_payload(location,weather)
    except Exception as exc: error(exc)
@router.get("/weather/hourly")
async def weather_hourly(city:str):
    try:
        location,weather=await location_and_weather(city); return {"success":True,"city":location["city"],"hourly":hourly_payload(weather)}
    except Exception as exc: error(exc)
@router.get("/weather/forecast")
async def weather_forecast(city:str):
    try:
        location,weather=await location_and_weather(city); return {"success":True,"city":location["city"],"forecast":forecast_payload(weather)}
    except Exception as exc: error(exc)
@router.get("/air-quality")
async def air_quality(city:str):
    try:
        location,_=await location_and_weather(city); c=(await get_air_quality(location["latitude"],location["longitude"]))["current"]; aqi=c.get("us_aqi"); status="Good" if aqi<=50 else "Moderate" if aqi<=100 else "Unhealthy"
        return {"success":True,"city":location["city"],"aqi":aqi,"pm2_5":c.get("pm2_5"),"pm10":c.get("pm10"),"ozone":c.get("ozone"),"no2":c.get("nitrogen_dioxide"),"status":status}
    except Exception as exc: error(exc)
async def intelligence(city):
    location,weather=await location_and_weather(city); return location,current_payload(location,weather),forecast_payload(weather)
@router.get("/alerts")
async def weather_alerts(city:str):
    try:
        location,current,forecast=await intelligence(city); return {"success":True,"city":location["city"],"alerts":alerts(current,forecast),"disclaimer":"These are rule-based alerts, not official warnings."}
    except Exception as exc: error(exc)
@router.get("/risk")
async def weather_risk(city:str):
    try:
        location,current,forecast=await intelligence(city); return {"success":True,"city":location["city"],"risks":risks(current,forecast)}
    except Exception as exc: error(exc)
@router.get("/agriculture/advisory")
async def agriculture_advisory(city:str,crop:str):
    try:
        _,current,forecast=await intelligence(city); return agriculture(current,forecast,crop)
    except Exception as exc: error(exc)
class ChatRequest(BaseModel): message:str=Field(min_length=1,max_length=1000); city:str|None=None
@router.post("/chat")
async def chat(request:ChatRequest):
    city=request.city or next((w.strip("?.!,") for w in request.message.split() if w.lower() in {"agra","delhi","mumbai","bengaluru","chennai"}),"Agra")
    try:
        location,current,forecast=await intelligence(city); text=request.message.lower()
        if any(w in text for w in ["rain","tomorrow","forecast"]):
            day=forecast[1] if len(forecast)>1 else forecast[0]; answer=f"{day['day']} in {location['city']} is expected to be {day['condition'].lower()}, with {day['temp']}°C / {day['low']}°C and a {day['rainProbability']}% chance of rain."
        elif any(w in text for w in ["alert","safe","travel"]):
            found=alerts(current,forecast); answer=found[0]["message"]+" "+found[0]["recommendation"] if found else f"No significant rule-based weather alert is detected for {location['city']}. Check local official advice before travel."
        elif any(w in text for w in ["irrigate","crop","wheat","rice","maize","cotton","soybean"]):
            crop=next((c for c in ["wheat","rice","maize","cotton","soybean"] if c in text),"wheat"); answer=agriculture(current,forecast,crop)["advisory"]
        else: answer=f"In {location['city']}, it is {current['condition'].lower()} and {current['temperature']}°C. Humidity is {current['humidity']}% and wind is {current['wind']}."
        return {"success":True,"intent":"weather","city":location["city"],"response":answer}
    except Exception as exc: error(exc)
@router.get("/chat/history")
def chat_history(): return {"success":True,"history":[],"message":"Chat persistence becomes available when PostgreSQL is configured."}
