# WeatherGPT

WeatherGPT is a React and FastAPI weather companion. The frontend gets live current weather, a seven-day forecast and air quality from the FastAPI service; it does not use the former synthetic display constants.

The backend uses only Open-Meteo Weather, Open-Meteo Air Quality and Nominatim/OpenStreetMap. PostgreSQL remains the database schema and persistence target; run the existing SQL scripts before configuring `backend/.env`.

See [setup instructions](docs/SETUP.md) and the [API reference](docs/API.md).
