import React, { useEffect, useState } from "react";
import axios from "./api/axios"; // sau "./axios" dacă nu e într-un folder separat
import { BrowserRouter as Router, Routes, Route, useNavigate, Link } from "react-router-dom";
import reactLogo from './assets/react.svg'
import mountainImg from '../../photos/mountainsideretreat(74).jpg'
import apartmentImg from '../../photos/shoe.creek.5d6d12d3-85b5-4a41-b310-8b8931ca9a72.jpg'
import villaImg from '../../photos/swimming_pool_sunset_beach_villa_baglioni_resort_maldives_4662fcb309.jpg'
import BeachVillas from "./BeachVillas";
import MountainCabins from "./MountainCabins";
import CentralApartments from "./CentralApartments";
import Login from "./Login";
import Register from "./Register";
import './App.css'
import Search from "./Search";


function Home() {
  const navigate = useNavigate();
  const [hotels, setHotels] = useState([]);

  useEffect(() => {
    axios.get("/hotels")
      .then((res) => {
        setHotels(res.data);
      })
      .catch((err) => {
        console.error("Eroare la încărcarea hotelurilor:", err);
      });
  }, []);


  return (
    <div className="home-container">
      {/* Header */}
      <header className="header">
        <Link to="/" className="logo" style={{ textDecoration: "none" }}>
          <img src={reactLogo} alt="InnStay logo" />
          <span>InnStay</span>
        </Link>
        <nav>
          <a href="#">Discover</a>
          <a href="#">Favorites</a>
          <a href="#">Help</a>
        </nav>
        <div className="auth-buttons">
          <button className="secondary" onClick={() => navigate("/login")}>Log in</button>
          <button className="primary" onClick={() => navigate("/register")}>Sign up</button>
        </div>
      </header>

      {/* Search Bar */}
      <section className="search-section">
        <h1>Find your perfect stay</h1>
        <p className="subtitle">Book unique places to stay and things to do.</p>
        <div className="search-bar">
          <input type="text" placeholder="Destination" />
          <input type="date" />
          <input type="date" />
          <input type="number" min="1" placeholder="Guests" />
          <button className="primary" onClick={() => navigate("/search")}>Search</button>
        </div>
      </section>

     

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
      </Routes>
    </Router>
  );
}
