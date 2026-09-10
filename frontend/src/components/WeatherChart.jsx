function WeatherChart({ temperatures }) {
  if (!temperatures.length) return null;
  const max = Math.max(...temperatures);
  const min = Math.min(...temperatures);

  const points = temperatures
    .map((temp, index) => {
      const x = 20 + index * 42;
      const y =
        90 - ((temp - min) / (max - min || 1)) * 60;

      return `${x},${y}`;
    })
    .join(" ");

  return (
    <div className="chart-card glass-card">
      <div className="card-heading">
        <span className="small-label">Temperature Trend</span>

        <select>
          <option>Temperature</option>
          <option>Humidity</option>
          <option>Wind</option>
        </select>
      </div>

      <div className="chart-wrapper">
        <svg
          viewBox="0 0 280 120"
          preserveAspectRatio="none"
        >
          <polyline
            points={points}
            fill="none"
            stroke="currentColor"
            strokeWidth="3"
          />

          {temperatures.map((temp, index) => {
            const x = 20 + index * 42;
            const y =
              90 -
              ((temp - min) / (max - min || 1)) * 60;

            return (
              <circle
                key={index}
                cx={x}
                cy={y}
                r="3"
                fill="currentColor"
              />
            );
          })}
        </svg>
      </div>

      <div className="chart-days">
        {["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map(
          (day) => (
            <span key={day}>{day}</span>
          )
        )}
      </div>
    </div>
  );
}

export default WeatherChart;
