import React, { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import axios from "./api/axios";
import "./View.css";

function View() {
  const { id } = useParams();
  const [hotel, setHotel] = useState(null);
  const [loading, setLoading] = useState(true);
  const [selectedRoomId, setSelectedRoomId] = useState(null);
  const [checkIn, setCheckIn] = useState(new Date().toISOString().split("T")[0]);
  const [checkOut, setCheckOut] = useState(
    new Date(Date.now() + 5 * 86400000).toISOString().split("T")[0]
  );

  useEffect(() => {
    axios.get(`/hotels/${id}/details`)
      .then(res => {
        setHotel(res.data);
        if (res.data.rooms?.length) {
          setSelectedRoomId(res.data.rooms[0].id);
        }
      })
      .catch(err => console.error("Error loading hotel details:", err))
      .finally(() => setLoading(false));
  }, [id]);

  const selectedRoom = hotel?.rooms.find(r => r.id === selectedRoomId);
  const nights = Math.max(
    1,
    Math.ceil((new Date(checkOut) - new Date(checkIn)) / (1000 * 60 * 60 * 24))
  );
  const subtotal = selectedRoom ? selectedRoom.price_per_night * nights : 0;
  const cleaning = Math.round(subtotal * 0.05);
  const service = Math.round(subtotal * 0.15);
  const total = subtotal + cleaning + service;

  if (loading) return <div className="loading">Loading...</div>;
  if (!hotel) return <div className="error">Hotel not found.</div>;

  return (
    <div className="hotel-view-container">
      <div className="hotel-header">
        <h2>{hotel.name}</h2>
        <p className="location">{hotel.location}</p>
      </div>

      <img className="main-image" src={`http://localhost:5000${hotel.image}`} alt={hotel.name} />

      <p className="description">{hotel.description}</p>

      <div className="main-content">
        {/* Left: Available rooms */}
        <div className="left-column">
          <h3 className="section-title">Available rooms</h3>
          <div className="rooms-grid">
            {hotel.rooms.map(room => (
              <div
                key={room.id}
                className={`room-card ${room.id === selectedRoomId ? "selected" : ""}`}
                onClick={() => setSelectedRoomId(room.id)}
              >
                <img
                  className="room-image"
                  src={`http://localhost:5000${room.image}`}
                  alt={room.room_type}
                />
                <div className="room-info">
                  <h4>{room.room_type}</h4>
                  <p className="room-price">{room.price_per_night} RON <span>/night</span></p>
                  <p className="room-facilities">{room.facilities}</p>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Right: Booking card */}
        <div className="right-column">
          <div className="reservation-box">
            <h3 className="booking-title">Booking</h3>

            <div className="date-pickers">
              <div className="date-field">
                <label>Check-in</label>
                <input type="date" value={checkIn} onChange={(e) => setCheckIn(e.target.value)} />
              </div>

              <div className="date-field">
                <label>Check-out</label>
                <input type="date" value={checkOut} onChange={(e) => setCheckOut(e.target.value)} />
              </div>
            </div>

            <div className="price-summary">
              <div className="price-row">
                <span>{selectedRoom?.price_per_night} RON × {nights} nights</span>
                <span>{subtotal} RON</span>
              </div>
              <div className="price-row">
                <span>Cleaning fee</span>
                <span>{cleaning} RON</span>
              </div>
              <div className="price-row">
                <span>Service fee</span>
                <span>{service} RON</span>
              </div>
              <div className="price-row total">
                <span>Total</span>
                <span>{total} RON</span>
              </div>
            </div>

            <button className="book-btn">Reserve</button>
          </div>
        </div>
      </div>
    </div>
  );
}

export default View;
