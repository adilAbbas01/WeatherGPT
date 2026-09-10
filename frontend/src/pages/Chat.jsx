import ChatSidebar from "../components/ChatSidebar";
import ChatBox from "../components/ChatBox";

function Chat() {
  return (
    <div className="chat-page">
      <ChatSidebar />

      <main className="chat-main">
        <div className="chat-topbar">
          <span>WeatherGPT</span>

          <div>
            🔍 &nbsp; ◐ &nbsp; 👤
          </div>
        </div>

        <ChatBox />
      </main>

      <aside className="recent-chats">
        <h3>Recent Chats</h3>

        <div className="recent-item">
          Weather in Agra tomorrow
        </div>

        <div className="recent-item">
          Best time to visit Rajasthan
        </div>

        <div className="recent-item">
          Will it rain this weekend?
        </div>

        <div className="recent-item">
          Farming advice for September
        </div>

        <div className="recent-item">
          Weather in Delhi
        </div>

        <div className="recent-item">
          UV index meaning
        </div>

        <div className="recent-item">
          Travel tips for hill stations
        </div>
      </aside>
    </div>
  );
}

export default Chat;