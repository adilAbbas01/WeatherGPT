import { Link } from "react-router-dom";

function ChatSidebar() {
  return (
    <aside className="chat-sidebar">
      <Link to="/" className="chat-logo">
        🌤️ WeatherGPT
      </Link>

      <nav>
        <Link to="/">⌂ Home</Link>

        <Link to="/chat" className="selected">
          💬 Chat
        </Link>

        <a href="#history">◷ History</a>

        <a href="#saved">☆ Saved Locations</a>

        <a href="#settings">⚙ Settings</a>
      </nav>

      <div className="sidebar-promo">
        <span>🌱</span>

        <strong>
          Let's build a
          <br />
          Weather-Ready World
          <br />
          Together
        </strong>
      </div>
    </aside>
  );
}

export default ChatSidebar;