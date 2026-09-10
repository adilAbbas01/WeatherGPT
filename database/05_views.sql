CREATE VIEW latest_weather AS
SELECT DISTINCT ON (o.location_id)
    o.location_id, l.city, l.state, l.country, o.source_id, ds.source_name,
    o.temperature, o.feels_like, o.humidity, o.pressure, o.wind_speed,
    o.wind_direction, o.rainfall, o.weather_condition, o.observation_time
FROM weather_observations o
JOIN locations l ON l.location_id = o.location_id
JOIN data_sources ds ON ds.source_id = o.source_id
ORDER BY o.location_id, o.observation_time DESC, o.observation_id DESC;

CREATE VIEW active_weather_alerts AS
SELECT a.alert_id, a.location_id, l.city, l.state, a.source_id, ds.source_name,
       a.alert_type, a.severity, a.title, a.description, a.start_time, a.end_time
FROM weather_alerts a
JOIN locations l ON l.location_id = a.location_id
JOIN data_sources ds ON ds.source_id = a.source_id
WHERE CURRENT_TIMESTAMP >= a.start_time AND CURRENT_TIMESTAMP < a.end_time;

CREATE VIEW location_weather_summary AS
SELECT l.location_id, l.city, l.state, l.country, lw.temperature, lw.humidity,
       lw.weather_condition, lw.observation_time,
       (SELECT count(*) FROM active_weather_alerts awa WHERE awa.location_id = l.location_id) AS active_alert_count,
       (SELECT ra.risk_level FROM risk_assessments ra WHERE ra.location_id = l.location_id ORDER BY ra.assessment_time DESC, ra.risk_id DESC LIMIT 1) AS latest_risk_level
FROM locations l
LEFT JOIN latest_weather lw ON lw.location_id = l.location_id;
