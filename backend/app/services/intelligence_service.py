def alerts(current, forecast):
    found=[]
    def add(kind,severity,message,recommendation): found.append({"type":kind,"severity":severity,"message":message,"recommendation":recommendation,"time":current["time"]})
    if current["temperature"]>=40: add("Extreme Heat","HIGH","Temperature is at least 40°C.","Limit strenuous outdoor activity and stay hydrated.")
    if current["windSpeed"]>=40: add("Strong Wind","HIGH","Strong winds are occurring.","Secure loose objects and use care while driving.")
    if "Thunderstorm" in current["condition"]: add("Thunderstorm","HIGH","Thunderstorm conditions are occurring.","Avoid open areas and seek shelter.")
    if forecast and (forecast[0]["rainfall"]>=20 or forecast[0]["rainProbability"]>=80): add("Heavy Rain","MEDIUM","Heavy rain is possible today.","Allow extra travel time and avoid flooded roads.")
    return found
def risks(current,forecast):
    output=[]
    for alert in alerts(current,forecast):
        score={"HIGH":80,"MEDIUM":55}.get(alert["severity"],30)
        output.append({"risk_type":alert["type"],"risk_score":score,"risk_level":"High" if score>=70 else "Moderate","reason":alert["message"],"recommendation":alert["recommendation"]})
    return output or [{"risk_type":"General weather","risk_score":15,"risk_level":"Low","reason":"No significant rule-based weather risk detected.","recommendation":"Check the forecast before outdoor activities."}]
def agriculture(current,forecast,crop):
    if crop.lower() not in {"wheat","rice","maize","cotton","soybean"}: raise ValueError("Invalid crop. Choose wheat, rice, maize, cotton, or soybean.")
    if forecast and forecast[0]["rainfall"]>=5: advice="Rain is expected; avoid unnecessary irrigation and make sure field drainage is clear."
    elif current["temperature"]>=35: advice="High temperature may stress crops; irrigate during cooler hours and monitor moisture."
    else: advice="Conditions do not trigger a specific weather warning; inspect soil moisture before irrigating."
    return {"success":True,"crop":crop.lower(),"advisory":advice,"disclaimer":"This is a rule-based prototype advisory, not professional agricultural advice."}
