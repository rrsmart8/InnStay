import React, { useEffect, useState } from "react";
import { useSearchParams, useNavigate } from "react-router-dom";
import axios from "./api/axios";
import Header from "./Header";
import "./Search.css";

function Search() {
  const [searchParams] = useSearchParams();
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  const [destination, setDestination] = useState(searchParams.get("destination") || "");
  const [checkin, setCheckin] = useState(searchParams.get("checkin") || "");
  const [checkout, setCheckout] = useState(searchParams.get("checkout") || "");
  const [roomType, setRoomType] = useState(searchParams.get("room_type") || "Standard Room");

  const handleSearch = () => {
    navigate(`/search?destination=${destination}&checkin=${checkin}&checkout=${checkout}&room_type=${encodeURIComponent(roomType)}`);
  };

  useEffect(() => {
    const fetchResults = async () => {
      try {
        const res = await axios.get("/search", {
          params: { destination, checkin, checkout, room_type: roomType },
        });
        setResults(res.data);
      } catch (error) {
        console.error("Search error:", error);
      } finally {
        setLoading(false);
      }
    };

    fetchResults();
  }, [destination, checkin, checkout, roomType]);

  return (
    <>
      <Header />

      {/* Search Bar duplicated from App.jsx but WITHOUT heading/subtitle */}
      <section className="search-section">
        <div className="search-bar">
          <input type="text" placeholder="Destination" value={destination} onChange={(e) => setDestination(e.target.value)} />
          <input type="date" value={checkin} onChange={(e) => setCheckin(e.target.value)} />
          <input type="date" value={checkout} onChange={(e) => setCheckout(e.target.value)} />
          <select value={roomType} onChange={(e) => setRoomType(e.target.value)}>
            <option value="Standard Room">Standard Room</option>
            <option value="Deluxe Room">Deluxe Room</option>
            <option value="Superior Room">Superior Room</option>
            <option value="Family Room">Family Room</option>
          </select>
          <button className="primary" onClick={handleSearch}>Search</button>
        </div>
      </section>

      <div className="search-results-container">
        <h2>Search Results</h2>
        {loading ? (
          <p>Loading...</p>
        ) : results.length === 0 ? (
          <p>No results found for your search.</p>
        ) : (
          <div className="results-grid">
            {results.map((hotel) => (
              <div className="result-card" key={hotel.id}>
                {hotel.image ? (
                  <img
                    src={`http://localhost:5000${hotel.image}`}
                    alt={hotel.name}
                    style={{ width: "100%", height: "180px", objectFit: "cover" }}
                  />
                ) : (
                  <div className="image-placeholder" />
                )}
                <div className="card-details">
                  <h3>{hotel.name}</h3>
                  <p>{hotel.location}</p>
                  <p>{hotel.description}</p>
                  <button className="view-btn" onClick={() => navigate(`/hotel/${hotel.id}`)}>
                    View
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </>
  );
}

export default Search;