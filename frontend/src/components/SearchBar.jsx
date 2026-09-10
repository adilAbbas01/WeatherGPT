import { useState } from "react";

function SearchBar({ onSearch }) {
  const [city, setCity] = useState("");

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!city.trim()) return;

    onSearch?.(city);
  };

  return (
    <form className="search-bar" onSubmit={handleSubmit}>
      <span className="search-icon">⌕</span>

      <input
        type="text"
        placeholder="Search for a city (e.g. Agra, Delhi, London...)"
        value={city}
        onChange={(e) => setCity(e.target.value)}
      />

      <button type="submit">Search</button>
    </form>
  );
}

export default SearchBar;