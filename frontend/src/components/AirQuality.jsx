function AirQuality({ data }) {
  return (
    <div className="small-weather-card glass-card">
      <span className="small-label">Air Quality</span>

      <div className="aq-content">
        <div className="aq-circle">
          <strong>{data.value}</strong>
        </div>

        <div>
          <h4>{data.status}</h4>
          <p>{data.description}</p>
        </div>
      </div>
    </div>
  );
}

export default AirQuality;