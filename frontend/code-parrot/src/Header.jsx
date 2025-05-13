import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import reactLogo from "./assets/react.svg";
import "./App.css";

function Header() {
  const navigate = useNavigate();
  const [menuOpen, setMenuOpen] = useState(false);

  const token = localStorage.getItem("accessToken");
  const user = JSON.parse(localStorage.getItem("user"));

  const handleLogout = () => {
    localStorage.removeItem("accessToken");
    localStorage.removeItem("user");
    navigate("/");
    window.location.reload();
  };

  return (
    <header className="header">
      <Link to="/" className="logo" style={{ textDecoration: "none" }}>
        <img src={reactLogo} alt="InnStay logo" />
        <span>InnStay</span>
      </Link>

      <nav>
        {!token ? (
          <>
            <a href="#">Discover</a>
            <a href="#">Favorites</a>
            <a href="#">Help</a>
          </>
        ) : (
          <>
            <Link to="/my-bookings">Bookings</Link>
            <Link to="/my-reviews">Reviews</Link>
            <Link to="/recommendations">Recommendations</Link>
          </>
        )}
      </nav>

      <div className="auth-buttons">
        {!token ? (
          <>
            <button className="secondary" onClick={() => navigate("/login")}>Log in</button>
            <button className="primary" onClick={() => navigate("/register")}>Sign up</button>
          </>
        ) : (
          <div className="profile-container">
            <img
              src="/profile-icon.png"
              alt="Profile"
              className="profile-icon"
              onClick={() => setMenuOpen(!menuOpen)}
              onError={(e) => {
                e.target.onerror = null;
                e.target.src = "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png";
              }}
            />
            {menuOpen && (
              <div className="dropdown-menu">
                <p>Hello, {user?.username || "User"}!</p>
                <button onClick={handleLogout}>Log out</button>
              </div>
            )}
          </div>
        )}
      </div>
    </header>
  );
}

export default Header;
