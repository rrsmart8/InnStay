// Header.jsx
import React from "react";
import { Link, useNavigate } from "react-router-dom";
import reactLogo from "./assets/react.svg";
import "./App.css";

function Header() {
  const navigate = useNavigate();

  return (
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
  );
}

export default Header;
