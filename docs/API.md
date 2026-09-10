# API

| Method | Endpoint | Purpose |
| --- | --- | --- |
| GET | `/api/health` | API and PostgreSQL connectivity status |
| GET | `/api/locations/search?q=` | Nominatim city search |
| GET | `/api/weather/current?city=` | Current Open-Meteo weather |
| GET | `/api/weather/hourly?city=` | Next 24 hourly periods |
| GET | `/api/weather/forecast?city=` | Seven-day forecast |
| GET | `/api/air-quality?city=` | Open-Meteo air-quality readings |
| GET | `/api/alerts?city=` | Rule-based alert detection |
| GET | `/api/risk?city=` | Rule-based weather risks |
| GET | `/api/agriculture/advisory?city=&crop=` | Prototype crop advisory |
| POST | `/api/chat` | Rule-based conversational reply |
| GET | `/api/chat/history` | Reserved chat history endpoint |
