import React, { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import innstayLogo from "./assets/innstay-logo.png";
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
        <img src={innstayLogo} alt="InnStay logo" />
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
              src={user?.role === "admin"
                ? "http://localhost:5000/static/admin/admin.jpg"
                : "/profile-icon.png"}
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
                {user?.role === "admin" ? (
                  <p>Hello, Buzzila!</p>
                ) : (
                  <p>Hello, {user?.role === "admin" ? "Buzzila" : (user?.username || "User")}!</p>
                )}
                {user?.role === "admin" && (
                  <button style={{ display: 'block', marginBottom: 8 }} onClick={() => navigate("/admin-settings")}>Settings</button>
                )}
                <button style={{ display: 'block' }} onClick={handleLogout}>Log out</button>
              </div>
            )}
          </div>
        )}
      </div>
    </header>
  );
}

export default Header;
