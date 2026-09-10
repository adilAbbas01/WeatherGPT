-- Parameters use PostgreSQL positional placeholders ($1, $2, ...).

-- 1. Current weather for location $1.
SELECT * FROM latest_weather WHERE location_id = $1;

-- 2. Seven-day forecast for location $1.
SELECT f.forecast_date, f.min_temperature, f.max_temperature, f.humidity,
       f.rainfall_probability, f.expected_rainfall, f.wind_speed, f.weather_condition,
       ds.source_name
FROM weather_forecasts f JOIN data_sources ds ON ds.source_id = f.source_id
WHERE f.location_id = $1 AND f.forecast_date BETWEEN CURRENT_DATE AND CURRENT_DATE + 6
ORDER BY f.forecast_date;

-- 3. Currently active high/severe alerts (optional location filter is $1; NULL means all locations).
SELECT * FROM active_weather_alerts
WHERE severity IN ('HIGH', 'SEVERE') AND (location_id = $1 OR $1 IS NULL)
ORDER BY severity DESC, start_time DESC;

-- 4. Latest risk assessment for location $1.
SELECT risk_type, risk_level, probability, description, assessment_time
FROM risk_assessments WHERE location_id = $1
ORDER BY assessment_time DESC, risk_id DESC LIMIT 1;

-- 5. Current agricultural advisories: location $1 and crop $2.
SELECT crop_name, advisory_type, advisory_text, severity, valid_from, valid_until
FROM agriculture_advisories
WHERE location_id = $1 AND lower(crop_name) = lower($2)
  AND CURRENT_TIMESTAMP BETWEEN valid_from AND valid_until
ORDER BY severity DESC, valid_from DESC;

-- 6. Historical climate series for location $1.
SELECT year, month, average_temperature, minimum_temperature, maximum_temperature, rainfall, humidity
FROM climate_data WHERE location_id = $1 ORDER BY year, month;

-- 7. Previous user queries for user $1.
SELECT q.query_id, q.query_text, q.detected_intent, q.language, q.created_at, l.city
FROM chat_queries q LEFT JOIN locations l ON l.location_id = q.location_id
WHERE q.user_id = $1 ORDER BY q.created_at DESC;

-- 8. Observation history for location $1 from $2 through $3 (TIMESTAMPTZ).
SELECT observation_time, temperature, feels_like, humidity, pressure, wind_speed, rainfall, weather_condition
FROM weather_observations
WHERE location_id = $1 AND observation_time >= $2 AND observation_time < $3
ORDER BY observation_time;

-- 9. Rainfall analysis for location $1 over optional time bounds $2 and $3.
SELECT location_id, count(*) AS observation_count, sum(rainfall) AS total_rainfall_mm,
       round(avg(rainfall), 2) AS average_rainfall_mm
FROM weather_observations
WHERE location_id = $1 AND observation_time >= $2 AND observation_time < $3
GROUP BY location_id;

-- 10. Monthly temperature analysis for location $1.
SELECT EXTRACT(YEAR FROM observation_time)::INTEGER AS year,
       EXTRACT(MONTH FROM observation_time)::INTEGER AS month,
       round(avg(temperature), 2) AS average_temperature_c,
       min(temperature) AS minimum_observed_c, max(temperature) AS maximum_observed_c
FROM weather_observations WHERE location_id = $1
GROUP BY 1, 2 ORDER BY 1, 2;

-- 11. Rank locations by their latest observed temperature (window-function example).
SELECT city, state, temperature, observation_time,
       dense_rank() OVER (ORDER BY temperature DESC) AS temperature_rank
FROM latest_weather;
