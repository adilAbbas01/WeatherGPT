import { useState } from "react";
import { sendMessage as sendChatMessage } from "../services/chatApi";

function ChatBox() {
  const [message, setMessage] = useState("");
  const [messages, setMessages] = useState([]);
  const [error, setError] = useState("");

  const sendMessage = async () => {
    if (!message.trim()) return;
    const question = message;
    setMessages((items) => [...items, { role: "user", text: question }]);
    setMessage("");
    try { const reply = await sendChatMessage(question); setMessages((items) => [...items, { role: "bot", text: reply.response }]); } catch (err) { setError(err.message); }
  };

  const handleKeyDown = (e) => {
    if (e.key === "Enter" && !e.shiftKey) {
      e.preventDefault();
      sendMessage();
    }
  };

  return (
    <div className="chat-container">
      <div className="chat-header">
        <div className="bot-icon">🤖</div>

        <div>
          <h2>Chat with WeatherGPT</h2>
          <p>
            Ask questions, forecast, travel advice,
            farming tips and more.
          </p>
        </div>
      </div>

      <div className="messages">
        {error && <p role="alert">{error}</p>}
        <div className="message bot-message">
          <div className="avatar">🤖</div>

          <div>
            <p>
              Hi! I'm WeatherGPT 🌦️
            </p>

            <p>
              You can ask me anything about the weather,
              forecasts, travel conditions, farming advice,
              or even how the weather might affect your plans.
            </p>

            <div className="suggestions">
              <button>
                What's the weather in Agra tomorrow?
              </button>

              <button>
                Will it rain in Delhi?
              </button>

              <button>
                Is it safe to travel today?
              </button>
            </div>
          </div>
        </div>
        {messages.map((item, index) => <div className={`message ${item.role === "user" ? "user-message" : "bot-message"}`} key={index}><p>{item.text}</p></div>)}

        <div className="message user-message">
          <p>
            Tomorrow in Agra, the weather is expected to be
            sunny with a high of 32°C and a low of 23°C.
            There is a 20% chance of rain.
          </p>
        </div>

        <div className="message bot-message">
          <div className="avatar">🤖</div>

          <div>
            <p>
              Tomorrow in Agra should be mostly sunny
              with pleasant conditions.
            </p>

            <div className="mini-weather">
              ☀️ <strong>32°C</strong>
              <span>23°C</span>
            </div>
          </div>
        </div>
      </div>

      <div className="chat-input">
        <textarea
          placeholder="Ask me anything about the weather..."
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          onKeyDown={handleKeyDown}
          rows="1"
        />

        <button onClick={sendMessage}>
          ➤
        </button>
      </div>
    </div>
  );
}

export default ChatBox;
