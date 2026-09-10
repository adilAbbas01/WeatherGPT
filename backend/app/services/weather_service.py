from datetime import datetime
from ..api.clients.nominatim import search_city
from ..api.clients.open_meteo import get_weather
WEATHER_CODES={0:("Clear sky","☀️"),1:("Mainly clear","🌤️"),2:("Partly cloudy","⛅"),3:("Overcast","☁️"),45:("Fog","🌫️"),51:("Light drizzle","🌦️"),61:("Rain","🌧️"),63:("Moderate rain","🌧️"),65:("Heavy rain","🌧️"),71:("Snow","❄️"),80:("Rain showers","🌦️"),95:("Thunderstorm","⛈️")}
def condition(code): return WEATHER_CODES.get(code,("Unknown","🌡️"))
async def location_and_weather(city):
    locations=await search_city(city)
    if not locations: raise ValueError("City not found")
    return locations[0],await get_weather(locations[0]["latitude"],locations[0]["longitude"])
def current_payload(location,weather):
    c=weather["current"]; label,icon=condition(c.get("weather_code")); d=weather.get("daily",{})
    return {"success":True,"city":location["city"],"state":location["state"],"country":location["country"],"latitude":location["latitude"],"longitude":location["longitude"],"temperature":c.get("temperature_2m"),"feelsLike":c.get("apparent_temperature"),"condition":label,"icon":icon,"humidity":c.get("relative_humidity_2m"),"wind":f"{c.get('wind_speed_10m',0)} km/h","windSpeed":c.get("wind_speed_10m"),"windDirection":c.get("wind_direction_10m"),"pressure":f"{c.get('pressure_msl','—')} hPa","visibility":f"{round((c.get('visibility') or 0)/1000,1)} km","uv":c.get("uv_index"),"rainfall":c.get("rain",c.get("precipitation",0)),"time":c.get("time"),"sunrise":d.get("sunrise",[None])[0],"sunset":d.get("sunset",[None])[0]}
def forecast_payload(weather):
    d=weather["daily"]; output=[]
    for i,date in enumerate(d["time"]):
        label,icon=condition(d["weather_code"][i]); parsed=datetime.fromisoformat(date)
        output.append({"day":parsed.strftime("%a"),"date":f"{parsed.day} {parsed.strftime('%b')}","temp":d["temperature_2m_max"][i],"low":d["temperature_2m_min"][i],"rainProbability":d["precipitation_probability_max"][i],"rainfall":d["precipitation_sum"][i],"wind":d["wind_speed_10m_max"][i],"condition":label,"icon":icon})
    return output
def hourly_payload(weather):
    h=weather["hourly"]; start=next((i for i,t in enumerate(h["time"]) if t>=weather["current"]["time"]),0); output=[]
    for i in range(start,min(start+24,len(h["time"]))):
        label,icon=condition(h["weather_code"][i]); output.append({"time":h["time"][i],"temperature":h["temperature_2m"][i],"rainProbability":h["precipitation_probability"][i],"rainfall":h["precipitation"][i],"wind":h["wind_speed_10m"][i],"condition":label,"icon":icon})
    return output
