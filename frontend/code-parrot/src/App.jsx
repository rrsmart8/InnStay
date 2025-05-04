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

function Home() {
  const navigate = useNavigate();
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
          <button className="primary">Search</button>
        </div>
      </section>

      {/* Popular Listings */}
      <section className="popular-listings">
        <h2>Popular stays</h2>
        <div className="listings">
          <div
            className="listing-card"
            style={{ cursor: "pointer" }}
            onClick={() => navigate("/mountain-cabins")}
          >
            <img src={mountainImg} alt="Mountain Cabin" />
            <div className="listing-info">
              <h3>Mountain Cabin</h3>
              <p>From 200 RON/night</p>
            </div>
          </div>
          <div
            className="listing-card"
            style={{ cursor: "pointer" }}
            onClick={() => navigate("/central-apartments")}
          >
            <img src={apartmentImg} alt="Central Apartment" />
            <div className="listing-info">
              <h3>Central Apartment</h3>
              <p>From 300 RON/night</p>
            </div>
          </div>
          <div
            className="listing-card"
            style={{ cursor: "pointer" }}
            onClick={() => navigate("/beach-villas")}
          >
            <img src={villaImg} alt="Beach Villa" />
            <div className="listing-info">
              <h3>Beach Villa</h3>
              <p>From 500 RON/night</p>
            </div>
          </div>
        </div>
      </section>

      {/* Benefits */}
      <section className="benefits">
        <h2>Why choose InnStay?</h2>
        <ul>
          <li>Fast & secure booking</li>
          <li>Options for every budget</li>
          <li>24/7 customer support</li>
        </ul>
      </section>

      {/* Footer */}
      <footer className="footer">
        <p>&copy; 2024 InnStay. All rights reserved.</p>
      </footer>
    </div>
  );
}

export default function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/beach-villas" element={<BeachVillas />} />
        <Route path="/mountain-cabins" element={<MountainCabins />} />
        <Route path="/central-apartments" element={<CentralApartments />} />
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
      </Routes>
    </Router>
  );
}
