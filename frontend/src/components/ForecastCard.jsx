function ForecastCard({ forecast }) {
  return (
    <div className="forecast-card glass-card">
      <div className="card-heading">
        <span className="small-label">7-Day Forecast</span>

        <button className="view-more">
          View More →
        </button>
      </div>

      <div className="forecast-list">
        {forecast.map((item) => (
          <div className="forecast-item" key={item.day}>
            <strong>{item.day}</strong>

            <span className="forecast-date">
              {item.date}
            </span>

            <span className="forecast-icon">
              {item.icon}
            </span>

            <strong>{item.temp}°</strong>

            <span className="forecast-low">
              {item.low}°
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}

export default ForecastCard;