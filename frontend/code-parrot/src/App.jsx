import React, { useEffect, useState } from "react";
import { BrowserRouter as Router, Routes, Route, useNavigate } from "react-router-dom";
import axios from "./api/axios";

import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";


import Login from "./Login";
import Register from "./Register";
import Search from "./Search";
import View from "./View";
import Header from "./Header";
import MyBookings from "./MyBookings";
import AdminSettings from "./AdminSettings";
import SearchBar from "./components/SearchBar";

import './App.css';

function Home() {
  const navigate = useNavigate();
  const [hotels, setHotels] = useState([]);

  const [destination, setDestination] = useState("");
  const [checkin, setCheckin] = useState(null); // Date
  const [checkout, setCheckout] = useState(null); // Date
  const [roomType, setRoomType] = useState("Standard Room");

  useEffect(() => {
    axios.get("/hotels")
      .then((res) => setHotels(res.data))
      .catch((err) => console.error("Eroare la încărcarea hotelurilor:", err));
  }, []);

  const formatDate = (date) => date
    ? `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
    : "";
  const checkinStr = formatDate(checkin);
  const checkoutStr = formatDate(checkout);

  const handleSearch = () => {
    navigate(`/search?destination=${destination}&checkin=${checkinStr}&checkout=${checkoutStr}&room_type=${encodeURIComponent(roomType)}`);
  };

  return (
    <div className="home-container">
      <Header />

      {/* Search Bar */}
      <section className="search-section">
        <h1>Find your perfect stay</h1>
        <p className="subtitle">Book unique places to stay and things to do.</p>
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

      {/* Available Hotels */}
      <section className="popular-listings">
        <h2>Available Hotels</h2>
        <div className="listings">
          {hotels.length === 0 ? (
            <p>Loading hotels...</p>
          ) : (
            hotels.map((hotel) => {
              // Determină prețul minim
              const minPrice = hotel.min_price
                ?? (hotel.rooms && hotel.rooms.length > 0
                  ? Math.min(...hotel.rooms.map(r => r.price_per_night))
                  : null);
              return (
                <div className="listing-card" key={hotel.id}>
                  <img src={`http://localhost:5000${hotel.image}`} alt={hotel.name} />
                  <div className="listing-info">
                    <h3>{hotel.name}</h3>
                    {minPrice !== null && minPrice !== undefined && (
                      <p style={{ color: "#ff385c", fontWeight: 600, margin: 0 }}>
                        From: {minPrice} RON / night
                      </p>
                    )}
                    <p style={{ color: "#ff385c", fontWeight: 600 }}>{hotel.location}</p>
                    <p style={{ color: "#444", fontSize: "0.95rem", marginTop: 8 }}>{hotel.description}</p>
                  </div>
                </div>
              );
            })
          )}
        </div>
      </section>
    </div>
  );
}

export default function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/search" element={<Search />} />
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/hotel/:id" element={<View />} />
        <Route path="/my-bookings" element={<MyBookings />} />
        <Route path="/admin-settings" element={<AdminSettings />} />
      </Routes>
    </Router>
  );
}

/*
.date-picker-input {
  padding: 14px 18px;
  border-radius: 14px;
  border: 1.5px solid #eee;
  font-size: 1.08rem;
  background: #fff;
  color: #222;
  min-width: 170px;
  box-shadow: 0 1px 4px #0001;
  transition: border 0.2s, box-shadow 0.2s;
  cursor: pointer;
}
.date-picker-input:focus {
  border: 1.5px solid #ff385c;
  outline: none;
  box-shadow: 0 2px 8px #ff385c22;
}
*/
