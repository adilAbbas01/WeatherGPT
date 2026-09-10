import Navbar from "../components/Navbar";
import SearchBar from "../components/SearchBar";
import WeatherCard from "../components/WeatherCard";
import ForecastCard from "../components/ForecastCard";
import WeatherChart from "../components/WeatherChart";
import AirQuality from "../components/AirQuality";
import SunMoon from "../components/SunMoon";
import ChatPreview from "../components/ChatPreview";
import { useWeather } from "../hooks/useWeather";
import Footer from "../components/Footer";


function Home() {
  const { weather, loading, error, searchWeather } = useWeather();
  const handleSearch = (city) => {
    searchWeather(city);
  };

  return (
    <div className="app">
      <Navbar />

      <main>
        {/* HERO */}
        <section className="hero">
          <div className="hero-content">
            <div className="hero-text">
              <h1>
                Your AI-Powered
                <br />
                <span>Weather Companion</span>
              </h1>

              <p>
                Get real-time weather updates, forecasts,
                and AI-driven insights from a smarter,
                safer tomorrow.
              </p>

              <SearchBar onSearch={handleSearch} />

              <button className="location-button">
                📍 Use my location
              </button>

              <div className="popular">
                Popular:
                <span>Agra</span>
                <span>Delhi</span>
                <span>Mumbai</span>
                <span>Bengaluru</span>
              </div>
            </div>

            <div className="hero-slogan">
              <span>Plan Better</span>
              <span>Live Safer</span>
            </div>
          </div>
        </section>

        {/* WEATHER */}
        <section className="dashboard">
          <div className="top-weather-grid">
            {loading && <p>Loading live weather…</p>}
            {error && <p role="alert">{error}</p>}
            {weather && <WeatherCard weather={weather} />}
            {weather && <ForecastCard forecast={weather.forecast} />}
          </div>

          <div className="bottom-weather-grid">
            <WeatherChart
              temperatures={weather?.temperatures || []}
            />

            {weather && <AirQuality data={weather.airQuality} />}

            {weather && <SunMoon data={weather.sunMoon} />}

            <ChatPreview />
          </div>
        </section>

        {/* FEATURES */}
        <section className="features" id="features">
          <div className="section-heading">
            <span>WHY WEATHERGPT?</span>

            <h2>
              More than weather.
              <br />
              Your intelligent companion.
            </h2>
          </div>

          <div className="feature-grid">
            <div className="feature-card">
              <div>🌦️</div>
              <h3>Real-Time Weather</h3>
              <p>
                Get accurate current conditions
                and forecasts.
              </p>
            </div>

            <div className="feature-card">
              <div>🤖</div>
              <h3>AI Weather Assistant</h3>
              <p>
                Ask natural questions about weather
                and travel.
              </p>
            </div>

            <div className="feature-card">
              <div>🛡️</div>
              <h3>Weather Alerts</h3>
              <p>
                Stay informed about dangerous
                weather conditions.
              </p>
            </div>

            <div className="feature-card">
              <div>✈️</div>
              <h3>Smart Planning</h3>
              <p>
                Plan trips and activities around
                weather conditions.
              </p>
            </div>
          </div>
        </section>

      {/* FAQ */}
      <section
  className="faq-section"
  id="faqs"
>
  <div className="section-heading">
    <span className="section-tag">
      FAQs
    </span>

    <h2>
      Frequently Asked Questions
    </h2>

    <p>
      Find answers to common questions
      about WeatherGPT.
    </p>
  </div>

  <div className="faq-list">

    <details>
      <summary>
        <span>
          What is WeatherGPT?
        </span>
        <span className="faq-icon">
          +
        </span>
      </summary>

      <p>
        WeatherGPT is an AI-powered weather
        companion that helps you understand
        current weather, forecasts, air quality,
        and weather-related insights in one place.
      </p>
    </details>

    <details>
      <summary>
        <span>
          How do I check the weather for a city?
        </span>
        <span className="faq-icon">
          +
        </span>
      </summary>

      <p>
        Enter the name of a city in the search
        bar, such as Agra, Delhi, Mumbai or
        London, and WeatherGPT will display the
        available weather information.
      </p>
    </details>

    <details>
      <summary>
        <span>
          Can I use WeatherGPT on my mobile phone?
        </span>
        <span className="faq-icon">
          +
        </span>
      </summary>

      <p>
        Yes. The WeatherGPT interface is fully
        responsive and designed to work on
        desktops, tablets and mobile devices.
      </p>
    </details>

    <details>
      <summary>
        <span>
          What information does WeatherGPT provide?
        </span>
        <span className="faq-icon">
          +
        </span>
      </summary>

      <p>
        WeatherGPT can display current
        temperature, weather conditions,
        humidity, wind speed, pressure,
        visibility, UV index, forecasts,
        temperature trends and air quality.
      </p>
    </details>

    <details>
      <summary>
        <span>
          Can WeatherGPT help me plan a trip?
        </span>
        <span className="faq-icon">
          +
        </span>
      </summary>

      <p>
        Yes. The AI assistant can help you
        understand weather conditions and provide
        useful suggestions for travel and outdoor
        activities.
      </p>
    </details>

    <details>
      <summary>
        <span>
          Can I chat with the WeatherGPT AI?
        </span>
        <span className="faq-icon">
          +
        </span>
      </summary>

      <p>
        Yes. Open the Chat section to ask
        weather-related questions and receive
        AI-powered responses.
      </p>
    </details>

    <details>
      <summary>
        <span>
          Can I switch between Light and Dark mode?
        </span>
        <span className="faq-icon">
          +
        </span>
      </summary>

      <p>
        Yes. Click the theme button in the
        navigation bar to switch between Light
        Mode and Dark Mode. Your selected theme
        is saved automatically.
      </p>
    </details>

    <details>
      <summary>
        <span>
          Is WeatherGPT a replacement for official
          weather warnings?
        </span>
        <span className="faq-icon">
          +
        </span>
      </summary>

      <p>
        No. WeatherGPT is intended to provide
        helpful information and insights. For
        severe weather, emergencies or safety
        decisions, always verify information with
        official weather and emergency services.
      </p>
    </details>

  </div>
</section>
      </main>
      <Footer />
    </div>
  );
}

export default Home;
