-- DEMONSTRATION DATA ONLY. It is synthetic and is not official IMD or operational weather data.
BEGIN;

INSERT INTO locations (city, state, country, latitude, longitude) VALUES
('Agra', 'Uttar Pradesh', 'India', 27.17667, 78.00807),
('Delhi', 'Delhi', 'India', 28.61389, 77.20900),
('Mumbai', 'Maharashtra', 'India', 19.07600, 72.87770),
('Chennai', 'Tamil Nadu', 'India', 13.08270, 80.27070),
('Bengaluru', 'Karnataka', 'India', 12.97160, 77.59460);

INSERT INTO data_sources (source_name, source_type, api_endpoint, description, is_active) VALUES
('WeatherGPT Demonstration Feed', 'demo', NULL, 'Synthetic demonstration records for WeatherGPT; not official IMD data.', TRUE),
('Historical Climate Demonstration Feed', 'historical', NULL, 'Synthetic historical climate samples for demonstrations only.', TRUE);

INSERT INTO users (name, email, password_hash, preferred_language) VALUES
('Aarav Sharma', 'aarav@example.test', '$2b$12$demo_hash_not_for_production_aarav', 'en'),
('Priya Iyer', 'priya@example.test', '$2b$12$demo_hash_not_for_production_priya', 'en'),
('Rohan Das', 'rohan@example.test', '$2b$12$demo_hash_not_for_production_rohan', 'hi');

WITH s AS (SELECT source_id FROM data_sources WHERE source_name = 'WeatherGPT Demonstration Feed'),
rows(city, observed_at, temperature, feels_like, humidity, pressure, wind_speed, wind_direction, rainfall, condition) AS (
 VALUES
 ('Agra', CURRENT_TIMESTAMP - INTERVAL '2 hours', 34.20, 36.10, 43, 1007.2, 12.5, 250, 0.0, 'Clear'),
 ('Agra', CURRENT_TIMESTAMP - INTERVAL '26 hours', 32.10, 33.00, 48, 1008.0, 10.2, 240, 0.0, 'Partly Cloudy'),
 ('Delhi', CURRENT_TIMESTAMP - INTERVAL '2 hours', 35.80, 38.00, 40, 1006.5, 15.0, 260, 0.0, 'Haze'),
 ('Delhi', CURRENT_TIMESTAMP - INTERVAL '26 hours', 33.40, 35.20, 45, 1007.1, 11.5, 250, 0.0, 'Clear'),
 ('Mumbai', CURRENT_TIMESTAMP - INTERVAL '2 hours', 29.10, 33.20, 78, 1004.6, 20.0, 220, 8.4, 'Moderate Rain'),
 ('Mumbai', CURRENT_TIMESTAMP - INTERVAL '26 hours', 28.30, 31.40, 82, 1005.3, 17.0, 210, 14.2, 'Rain'),
 ('Chennai', CURRENT_TIMESTAMP - INTERVAL '2 hours', 31.40, 37.00, 76, 1005.8, 18.3, 160, 2.1, 'Cloudy'),
 ('Chennai', CURRENT_TIMESTAMP - INTERVAL '26 hours', 30.80, 35.10, 79, 1006.2, 14.6, 150, 0.0, 'Partly Cloudy'),
 ('Bengaluru', CURRENT_TIMESTAMP - INTERVAL '2 hours', 24.70, 25.20, 63, 1011.4, 9.8, 120, 0.0, 'Partly Cloudy'),
 ('Bengaluru', CURRENT_TIMESTAMP - INTERVAL '26 hours', 23.90, 24.50, 67, 1012.0, 8.1, 110, 0.0, 'Cloudy')
)
INSERT INTO weather_observations (location_id, source_id, temperature, feels_like, humidity, pressure, wind_speed, wind_direction, rainfall, weather_condition, observation_time)
SELECT l.location_id, s.source_id, r.temperature, r.feels_like, r.humidity, r.pressure, r.wind_speed, r.wind_direction, r.rainfall, r.condition, r.observed_at
FROM rows r JOIN locations l ON l.city = r.city CROSS JOIN s;

WITH s AS (SELECT source_id FROM data_sources WHERE source_name = 'WeatherGPT Demonstration Feed'),
base(city, min_t, max_t, humidity, rain_prob, rain_mm, wind, condition) AS (
 VALUES ('Agra', 24, 36, 42, 5, 0, 13, 'Sunny'), ('Delhi', 25, 37, 40, 8, 0, 15, 'Haze'),
        ('Mumbai', 25, 30, 80, 70, 14, 22, 'Rain'), ('Chennai', 27, 33, 74, 35, 3, 18, 'Cloudy'),
        ('Bengaluru', 19, 27, 65, 25, 1, 11, 'Partly Cloudy')
)
INSERT INTO weather_forecasts (location_id, source_id, forecast_date, min_temperature, max_temperature, humidity, rainfall_probability, expected_rainfall, wind_speed, weather_condition)
SELECT l.location_id, s.source_id, CURRENT_DATE + d.day_offset,
       b.min_t + (d.day_offset % 3), b.max_t + (d.day_offset % 3), b.humidity,
       LEAST(100, b.rain_prob + (d.day_offset * 2)), b.rain_mm + (d.day_offset % 2), b.wind, b.condition
FROM base b JOIN locations l ON l.city = b.city CROSS JOIN s CROSS JOIN generate_series(0, 6) AS d(day_offset);

WITH s AS (SELECT source_id FROM data_sources WHERE source_name = 'WeatherGPT Demonstration Feed'),
rows(city, alert_type, severity, title, description, starts, ends) AS (
 VALUES
 ('Delhi', 'Heatwave', 'HIGH', 'Heatwave watch', 'Avoid prolonged afternoon exposure and maintain hydration.', CURRENT_TIMESTAMP - INTERVAL '3 hours', CURRENT_TIMESTAMP + INTERVAL '24 hours'),
 ('Mumbai', 'Heavy Rain', 'SEVERE', 'Heavy rainfall warning', 'Localized waterlogging and travel disruption are possible.', CURRENT_TIMESTAMP - INTERVAL '1 hour', CURRENT_TIMESTAMP + INTERVAL '18 hours'),
 ('Chennai', 'Thunderstorm', 'HIGH', 'Thunderstorm advisory', 'Secure loose outdoor objects and avoid open areas during lightning.', CURRENT_TIMESTAMP - INTERVAL '2 hours', CURRENT_TIMESTAMP + INTERVAL '10 hours'),
 ('Agra', 'Strong Wind', 'MEDIUM', 'Strong wind advisory', 'Use caution around temporary structures and while driving.', CURRENT_TIMESTAMP - INTERVAL '1 hour', CURRENT_TIMESTAMP + INTERVAL '8 hours'),
 ('Bengaluru', 'Flood', 'LOW', 'Urban flooding watch', 'Monitor local drainage conditions during rainfall.', CURRENT_TIMESTAMP - INTERVAL '1 hour', CURRENT_TIMESTAMP + INTERVAL '12 hours')
)
INSERT INTO weather_alerts (location_id, source_id, alert_type, severity, title, description, start_time, end_time)
SELECT l.location_id, s.source_id, r.alert_type, r.severity, r.title, r.description, r.starts, r.ends FROM rows r JOIN locations l ON l.city=r.city CROSS JOIN s;

WITH rows(city, risk_type, risk_level, probability, description) AS (
 VALUES ('Delhi','Heatwave','HIGH',72,'High daytime heat stress expected.'), ('Mumbai','Flood','SEVERE',81,'Heavy rain may cause localized flooding.'), ('Chennai','Thunderstorm','HIGH',64,'Convective storm activity is possible.'), ('Agra','Strong Wind','MEDIUM',45,'Gusty winds may affect outdoor activities.'), ('Bengaluru','Fog','LOW',18,'Low probability of early-morning visibility reduction.')
)
INSERT INTO risk_assessments (location_id, risk_type, risk_level, probability, description, assessment_time)
SELECT l.location_id, r.risk_type, r.risk_level, r.probability, r.description, CURRENT_TIMESTAMP FROM rows r JOIN locations l ON l.city=r.city;

WITH rows(city, crop, advisory_type, text, severity) AS (
 VALUES ('Agra','Wheat','Irrigation','Irrigate in the early morning and monitor heat stress.','MEDIUM'), ('Delhi','Rice','Heat management','Maintain adequate field moisture during hot periods.','HIGH'), ('Mumbai','Maize','Drainage','Clear field drains before persistent rain.','HIGH'), ('Chennai','Cotton','Pest monitoring','Inspect foliage after humid weather and use locally approved controls.','MEDIUM'), ('Bengaluru','Soybean','Field inspection','Inspect low-lying plots for standing water after rainfall.','LOW')
)
INSERT INTO agriculture_advisories (location_id, crop_name, advisory_type, advisory_text, severity, valid_from, valid_until)
SELECT l.location_id, r.crop, r.advisory_type, r.text, r.severity, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '7 days' FROM rows r JOIN locations l ON l.city=r.city;

WITH s AS (SELECT source_id FROM data_sources WHERE source_name = 'Historical Climate Demonstration Feed'),
rows(city, yr, mon, avg_t, min_t, max_t, rain, humidity) AS (
 VALUES ('Agra',2024,7,31.2,26.1,37.4,186.5,68), ('Delhi',2024,7,32.8,27.0,38.9,155.2,64), ('Mumbai',2024,7,28.4,25.1,31.0,840.6,84), ('Chennai',2024,7,30.3,26.4,34.2,112.8,72), ('Bengaluru',2024,7,23.1,19.4,27.6,108.3,70),
        ('Agra',2025,7,30.8,25.7,36.8,201.4,70), ('Delhi',2025,7,32.1,26.4,38.1,172.9,66), ('Mumbai',2025,7,28.1,24.9,30.7,802.1,85), ('Chennai',2025,7,30.0,26.2,33.8,126.4,74), ('Bengaluru',2025,7,22.8,19.1,27.0,115.6,72)
)
INSERT INTO climate_data (location_id, source_id, year, month, average_temperature, minimum_temperature, maximum_temperature, rainfall, humidity)
SELECT l.location_id, s.source_id, r.yr, r.mon, r.avg_t, r.min_t, r.max_t, r.rain, r.humidity FROM rows r JOIN locations l ON l.city=r.city CROSS JOIN s;

INSERT INTO chat_queries (user_id, location_id, query_text, detected_intent, response_text, language)
SELECT u.user_id, l.location_id, 'What is the weather in Mumbai?', 'current_weather', 'Demonstration response stored for query-history testing.', 'en' FROM users u CROSS JOIN locations l WHERE u.email='aarav@example.test' AND l.city='Mumbai'
UNION ALL SELECT u.user_id, l.location_id, 'Will it rain in Delhi this week?', 'forecast', 'Demonstration response stored for query-history testing.', 'en' FROM users u CROSS JOIN locations l WHERE u.email='priya@example.test' AND l.city='Delhi'
UNION ALL SELECT u.user_id, NULL, 'Show my active weather alerts', 'alerts', 'Demonstration response stored for query-history testing.', 'hi' FROM users u WHERE u.email='rohan@example.test';

COMMIT;
