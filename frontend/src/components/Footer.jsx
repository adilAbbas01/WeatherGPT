import { Link } from "react-router-dom";

function Footer() {
  return (
    <footer className="site-footer">

      <div className="footer-container">

        {/* BRAND */}
        <div className="footer-brand">

          <div className="footer-logo">

            <div className="footer-logo-icon">
              🌤️
            </div>

            <div>
              <strong>
                ClimeX
              </strong>

              <small>
                AI Powered Weather Companion
              </small>
            </div>

          </div>

          <p>
            Smarter weather insights for
            safer decisions, better planning,
            and a weather-ready world.
          </p>

          <div className="footer-socials">

            <a href="#whatsapp">☎</a>
            <a href="#youtube">▶</a>
            <a href="#twitter">𝕏</a>
            <a href="#instagram">◎</a>
            <a href="#linkedin">in</a>

          </div>

        </div>


        {/* QUICK LINKS */}
        <div className="footer-column">

          <h3>
            QUICK LINKS
          </h3>

          <Link to="/">
            Home
          </Link>

          <Link to="/chat">
            AI Chat
          </Link>

          <a href="#features">
            Features
          </a>

          <a href="#faqs">
            FAQs
          </a>

          <a href="#about">
            About Us
          </a>

        </div>


        {/* CONTACT */}
        <div className="footer-column">

          <h3>
            CONTACT US
          </h3>

          <p>
            📍 ClimeX Team
          </p>

          <p>
            📧 mohdadilabbas01@gmail.com
        shubhamgoyal92004@gamil.com
          </p>

          <p>
            ☎ +91 9568046390
          </p>

          <p>
            🕒 Mon – Fri | 9:00 AM – 6:00 PM
          </p>

        </div>


        {/* WEATHER READY */}
        <div className="footer-visual">

          <h3>
            WEATHER READY
          </h3>

          <div className="footer-weather-card">

            <div className="footer-sun">
              ☀️
            </div>

            <div>
              <strong>
                32°C
              </strong>

              <span>
                Clear Sky
              </span>

              <small>
                Agra, India
              </small>
            </div>

          </div>

          <p>
            Plan Better.
            <br />
            Live Safer.
          </p>

        </div>

      </div>


      {/* DISCLAIMER */}
      <div className="footer-disclaimer">

        <div>
          <span>
            ⚠️
          </span>

          <p>
            Weather information and AI
            recommendations are provided
            for informational purposes.
            Always verify critical weather
            information with official sources.
          </p>

        </div>

        <div>
          <span>
            ⓘ
          </span>

          <p>
           Climex does not replace
            professional emergency or
            safety services.
          </p>

        </div>

      </div>


      {/* COPYRIGHT */}
      <div className="footer-bottom">

        <p>
          © 2026 WeatherGPT.
          All Rights Reserved.
        </p>

        <div className="footer-links">

          <a href="#privacy">
            Privacy
          </a>

          <a href="#terms">
            Terms
          </a>

          <Link to="/chat">
            AI Assistant
          </Link>

        </div>

        <button
          className="back-to-top"
          onClick={() =>
            window.scrollTo({
              top: 0,
              behavior: "smooth",
            })
          }
        >
          ↑
        </button>

      </div>

    </footer>
  );
}

export default Footer;