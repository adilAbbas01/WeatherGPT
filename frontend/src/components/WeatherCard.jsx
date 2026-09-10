function WeatherCard({ weather }) {
  return (
    <div className="weather-card glass-card">
      <div className="card-heading">
        <div>
          <span className="small-label">Current Weather</span>

          <h3>
            📍 {weather.city}
          </h3>

          <p className="updated">
            {weather.time ? new Date(weather.time).toLocaleString() : "Updated now"}
          </p>
        </div>

        <button className="close-button">×</button>
      </div>

      <div className="current-weather">
        <div className="weather-main">
          <div className="sun-icon">{weather.icon || "🌡️"}</div>

          <div>
            <div className="temperature">
              {weather.temperature}°C
            </div>

            <div className="condition">
              {weather.condition}
            </div>
          </div>
        </div>

        <div className="weather-stats">
          <div>
            <span>💧</span>
            <p>Humidity</p>
            <strong>{weather.humidity}%</strong>
          </div>

          <div>
            <span>💨</span>
            <p>Wind Speed</p>
            <strong>{weather.wind}</strong>
          </div>

          <div>
            <span>🌡️</span>
            <p>Pressure</p>
            <strong>{weather.pressure}</strong>
          </div>

          <div>
            <span>👁️</span>
            <p>Visibility</p>
            <strong>{weather.visibility}</strong>
          </div>

          <div>
            <span>☀️</span>
            <p>UV Index</p>
            <strong>{weather.uv}</strong>
          </div>
        </div>
      </div>
    </div>
  );
}

export default WeatherCard;
