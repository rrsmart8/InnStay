import React, { useEffect, useState } from "react";
import { BrowserRouter as Router, Routes, Route, useNavigate } from "react-router-dom";
import axios from "./api/axios";

import reactLogo from './assets/react.svg';
import mountainImg from '../../photos/mountainsideretreat(74).jpg';
import apartmentImg from '../../photos/shoe.creek.5d6d12d3-85b5-4a41-b310-8b8931ca9a72.jpg';
import villaImg from '../../photos/swimming_pool_sunset_beach_villa_baglioni_resort_maldives_4662fcb309.jpg';

import BeachVillas from "./BeachVillas";
import MountainCabins from "./MountainCabins";
import CentralApartments from "./CentralApartments";
import Login from "./Login";
import Register from "./Register";
import Search from "./Search";
import View from "./View";
import Header from "./Header"; // ✅ ADĂUGAT

import './App.css';

function Home() {
  const navigate = useNavigate();
  const [hotels, setHotels] = useState([]);

  // 🔍 Search states
  const [destination, setDestination] = useState("");
  const [checkin, setCheckin] = useState("");
  const [checkout, setCheckout] = useState("");
  const [roomType, setRoomType] = useState("Standard Room");

  useEffect(() => {
    axios.get("/hotels")
      .then((res) => setHotels(res.data))
      .catch((err) => console.error("Eroare la încărcarea hotelurilor:", err));
  }, []);

  const handleSearch = () => {
    navigate(`/search?destination=${destination}&checkin=${checkin}&checkout=${checkout}&room_type=${encodeURIComponent(roomType)}`);
  };

  return (
    <div className="home-container">
      {/* ✅ Înlocuim header-ul hardcodat */}
      <Header />

      {/* Search Bar */}
      <section className="search-section">
        <h1>Find your perfect stay</h1>
        <p className="subtitle">Book unique places to stay and things to do.</p>
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

      {/* Available Hotels */}
      <section className="popular-listings">
        <h2>Available Hotels</h2>
        <div className="listings">
          {hotels.length === 0 ? (
            <p>Loading hotels...</p>
          ) : (
            hotels.map((hotel) => (
              <div className="listing-card" key={hotel.id}>
                <img src={`http://localhost:5000${hotel.image}`} alt={hotel.name} />
                <div className="listing-info">
                  <h3>{hotel.name}</h3>
                  <p style={{ color: "#ff385c", fontWeight: 600 }}>{hotel.location}</p>
                  <p style={{ color: "#444", fontSize: "0.95rem", marginTop: 8 }}>{hotel.description}</p>
                </div>
              </div>
            ))
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
        <Route path="/beach-villas" element={<BeachVillas />} />
        <Route path="/mountain-cabins" element={<MountainCabins />} />
        <Route path="/central-apartments" element={<CentralApartments />} />
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
        <Route path="/hotel/:id" element={<View />} />
      </Routes>
    </Router>
  );
}
