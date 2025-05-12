// src/components/Search.jsx
import React from "react";
import "./Search.css"; // Stil separat pentru pagină

function Search() {
  return (
    <div className="search-results-container">
      <h2>Search Results</h2>
      <p>Showing search results... (backend not yet implemented)</p>
      
      <div className="results-grid">
        {[...Array(6)].map((_, idx) => (
          <div className="result-card" key={idx}>
            <div className="image-placeholder" />
            <div className="card-details">
              <h3>Listing Title Placeholder</h3>
              <p>City, Country</p>
              <p>From XXX RON/night</p>
              <button className="view-btn" disabled>View</button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

export default Search;
