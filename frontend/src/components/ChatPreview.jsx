import { Link } from "react-router-dom";

function ChatPreview() {
  return (
    <div className="chat-preview glass-card">
      <div className="bot-icon">🤖</div>

      <div>
        <h3>Chat with WeatherGPT</h3>

        <p>
          Ask anything about the weather, forecasts,
          travel and recommendations.
        </p>
      </div>

      <Link to="/chat" className="chat-button">
        Start Chatting →
      </Link>
    </div>
  );
}

export default ChatPreview;