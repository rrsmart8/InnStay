import React, { useEffect, useState } from "react";
import { useSearchParams } from "react-router-dom";
import axios from "./api/axios";
import Header from "./Header";  // 🔥 nou
import "./Search.css";

function Search() {
  const [searchParams] = useSearchParams();
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(true);

  const destination = searchParams.get("destination") || "";
  const checkin = searchParams.get("checkin") || "";
  const checkout = searchParams.get("checkout") || "";
  const roomType = searchParams.get("room_type") || "Standard Room";

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
                  <button className="view-btn" disabled>
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
