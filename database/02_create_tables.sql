-- Run while connected to the weathergpt database.

CREATE TABLE users (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(254) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    preferred_language VARCHAR(10) NOT NULL DEFAULT 'en',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE locations (
    location_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    city VARCHAR(120) NOT NULL,
    state VARCHAR(120) NOT NULL,
    country VARCHAR(120) NOT NULL,
    latitude NUMERIC(8,5) NOT NULL,
    longitude NUMERIC(8,5) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_locations_geography UNIQUE (city, state, country, latitude, longitude)
);

CREATE TABLE data_sources (
    source_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    source_name VARCHAR(150) NOT NULL UNIQUE,
    source_type VARCHAR(30) NOT NULL,
    api_endpoint TEXT,
    description TEXT NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE weather_observations (
    observation_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location_id BIGINT NOT NULL REFERENCES locations(location_id) ON DELETE RESTRICT,
    source_id BIGINT NOT NULL REFERENCES data_sources(source_id) ON DELETE RESTRICT,
    temperature NUMERIC(5,2) NOT NULL,
    feels_like NUMERIC(5,2),
    humidity NUMERIC(5,2) NOT NULL,
    pressure NUMERIC(7,2),
    wind_speed NUMERIC(6,2),
    wind_direction NUMERIC(5,2),
    rainfall NUMERIC(8,2) NOT NULL DEFAULT 0,
    weather_condition VARCHAR(100) NOT NULL,
    observation_time TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_observation_source_time UNIQUE (location_id, source_id, observation_time)
);

CREATE TABLE weather_forecasts (
    forecast_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location_id BIGINT NOT NULL REFERENCES locations(location_id) ON DELETE RESTRICT,
    source_id BIGINT NOT NULL REFERENCES data_sources(source_id) ON DELETE RESTRICT,
    forecast_date DATE NOT NULL,
    min_temperature NUMERIC(5,2) NOT NULL,
    max_temperature NUMERIC(5,2) NOT NULL,
    humidity NUMERIC(5,2),
    rainfall_probability NUMERIC(5,2) NOT NULL DEFAULT 0,
    expected_rainfall NUMERIC(8,2) NOT NULL DEFAULT 0,
    wind_speed NUMERIC(6,2),
    weather_condition VARCHAR(100) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_forecast_source_date UNIQUE (location_id, source_id, forecast_date)
);

CREATE TABLE weather_alerts (
    alert_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location_id BIGINT NOT NULL REFERENCES locations(location_id) ON DELETE RESTRICT,
    source_id BIGINT NOT NULL REFERENCES data_sources(source_id) ON DELETE RESTRICT,
    alert_type VARCHAR(80) NOT NULL,
    severity VARCHAR(10) NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT NOT NULL,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE risk_assessments (
    risk_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location_id BIGINT NOT NULL REFERENCES locations(location_id) ON DELETE RESTRICT,
    risk_type VARCHAR(80) NOT NULL,
    risk_level VARCHAR(10) NOT NULL,
    probability NUMERIC(5,2) NOT NULL,
    description TEXT NOT NULL,
    assessment_time TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE agriculture_advisories (
    advisory_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location_id BIGINT NOT NULL REFERENCES locations(location_id) ON DELETE RESTRICT,
    crop_name VARCHAR(100) NOT NULL,
    advisory_type VARCHAR(100) NOT NULL,
    advisory_text TEXT NOT NULL,
    severity VARCHAR(10) NOT NULL,
    valid_from TIMESTAMPTZ NOT NULL,
    valid_until TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE climate_data (
    climate_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    location_id BIGINT NOT NULL REFERENCES locations(location_id) ON DELETE RESTRICT,
    source_id BIGINT NOT NULL REFERENCES data_sources(source_id) ON DELETE RESTRICT,
    year SMALLINT NOT NULL,
    month SMALLINT NOT NULL,
    average_temperature NUMERIC(5,2) NOT NULL,
    minimum_temperature NUMERIC(5,2) NOT NULL,
    maximum_temperature NUMERIC(5,2) NOT NULL,
    rainfall NUMERIC(9,2) NOT NULL DEFAULT 0,
    humidity NUMERIC(5,2),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_climate_source_period UNIQUE (location_id, source_id, year, month)
);

CREATE TABLE chat_queries (
    query_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
    location_id BIGINT REFERENCES locations(location_id) ON DELETE SET NULL,
    query_text TEXT NOT NULL,
    detected_intent VARCHAR(100),
    response_text TEXT,
    language VARCHAR(10) NOT NULL DEFAULT 'en',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
