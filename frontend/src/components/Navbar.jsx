import { Link, useLocation } from "react-router-dom";
import { useTheme } from "../context/ThemeContext";

function Navbar() {
  const location = useLocation();

  const { theme, toggleTheme } = useTheme();

  return (
    <header className="navbar">
      <Link to="/" className="logo">
        <span className="logo-icon">
          🌤️
        </span>

        <span>
        <span>ClimeX</span>
        </span>
      </Link>

      <nav className="nav-links">
        <Link
          to="/"
          className={
            location.pathname === "/"
              ? "active"
              : ""
          }
        >
          Home
        </Link>

        <Link
          to="/chat"
          className={
            location.pathname === "/chat"
              ? "active"
              : ""
          }
        >
          Chat
        </Link>

        <a href="#about">
          About
        </a>

        <a href="#features">
          Features
        </a>

        <a href="#faqs">
          FAQs
        </a>
      </nav>

      <div className="navbar-right">
        <button
          className="icon-button"
          aria-label="Search"
        >
          🔍
        </button>

        <button
          className="theme-button"
          onClick={toggleTheme}
          aria-label="Toggle theme"
          title={`Switch to ${
            theme === "light"
              ? "dark"
              : "light"
          } mode`}
        >
          {theme === "light"
            ? "🌙"
            : "☀️"}
        </button>

        <button
          className="profile-button"
          aria-label="Profile"
        >
          👤
        </button>
      </div>
    </header>
  );
}

export default Navbar;