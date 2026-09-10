function SunMoon({ data }) {
  return (
    <div className="small-weather-card glass-card">
      <span className="small-label">Sun & Moon</span>

      <div className="sunmoon-item">
        <span>🌅</span>
        <div>
          <small>Sunrise</small>
          <strong>{data.sunrise}</strong>
        </div>
      </div>

      <div className="sunmoon-item">
        <span>🌇</span>
        <div>
          <small>Sunset</small>
          <strong>{data.sunset}</strong>
        </div>
      </div>

      <div className="moon-phase">
        🌙 {data.moonPhase}
      </div>
    </div>
  );
}

export default SunMoon;