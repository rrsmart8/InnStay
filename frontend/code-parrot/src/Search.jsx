import React, { useEffect, useState } from "react";
import { useSearchParams, useNavigate } from "react-router-dom";
import axios from "./api/axios";
import Header from "./Header";
import SearchBar from "./components/SearchBar";
import "react-datepicker/dist/react-datepicker.css";
import "./Search.css";

function parseDate(str) {
  if (!str) return null;
  const d = new Date(str);
  return isNaN(d) ? null : d;
}

function Search() {
  const [searchParams] = useSearchParams();
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  const [destination, setDestination] = useState(searchParams.get("destination") || "");
  const [checkin, setCheckin] = useState(parseDate(searchParams.get("checkin")));
  const [checkout, setCheckout] = useState(parseDate(searchParams.get("checkout")));
  const [roomType, setRoomType] = useState(searchParams.get("room_type") || "Standard Room");

  const handleSearch = () => {
    const checkinStr = checkin ? checkin.toISOString().split('T')[0] : "";
    const checkoutStr = checkout ? checkout.toISOString().split('T')[0] : "";
    navigate(`/search?destination=${destination}&checkin=${checkinStr}&checkout=${checkoutStr}&room_type=${encodeURIComponent(roomType)}`);
  };

  useEffect(() => {
    const fetchResults = async () => {
      try {
        const checkinStr = checkin ? checkin.toISOString().split('T')[0] : "";
        const checkoutStr = checkout ? checkout.toISOString().split('T')[0] : "";
        const res = await axios.get("/search", {
          params: { destination, checkin: checkinStr, checkout: checkoutStr, room_type: roomType },
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

  // Adaug funcția de formatat data local
  const formatDate = (date) =>
    date
      ? `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
      : "";

  return (
    <>
      <Header />
      {/* Search Bar */}
      <section className="search-section">
        <SearchBar
          destination={destination}
          setDestination={setDestination}
          checkin={checkin}
          setCheckin={setCheckin}
          checkout={checkout}
          setCheckout={setCheckout}
          roomType={roomType}
          setRoomType={setRoomType}
          onSearch={handleSearch}
        />
      </section>
      <div className="search-results-container">
        <h2>Search Results</h2>
        {loading ? (
          <p>Loading...</p>
        ) : results.length === 0 ? (
          <p>No results found for your search.</p>
        ) : (
          <div className="results-grid">
            {results.map((hotel) => {
              // Determină prețul minim
              const minPrice = hotel.min_price
                ?? (hotel.rooms && hotel.rooms.length > 0
                  ? Math.min(...hotel.rooms.map(r => r.price_per_night))
                  : null);
              return (
                <div className="result-card" key={hotel.id}>
                  {hotel.image ? (
                    <img
                      src={`http://127.0.0.15000${hotel.image}`}
                      alt={hotel.name}
                      style={{ width: "100%", height: "180px", objectFit: "cover" }}
                    />
                  ) : (
                    <div className="image-placeholder" />
                  )}
                  <div className="card-details">
                    <h3>{hotel.name}</h3>
                    <div className="price-location">
                      {minPrice && (
                        <p style={{ color: "#ff385c", fontWeight: 600, margin: 0 }}>
                          From: {minPrice} RON / noapte
                        </p>
                      )}
                      <p style={{ color: "#ff385c", fontWeight: 600, margin: 0, marginBottom: 4 }}>
                        {hotel.location}
                      </p>
                    </div>
                    <p>{hotel.description}</p>
                    <button
                      className="view-btn"
                      onClick={() => {
                        const checkinStr = formatDate(checkin);
                        const checkoutStr = formatDate(checkout);
                        navigate(`/hotel/${hotel.id}?checkin=${checkinStr}&checkout=${checkoutStr}`);
                      }}
                    >
                      View
                    </button>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>
    </>
  );
}

export default Search;