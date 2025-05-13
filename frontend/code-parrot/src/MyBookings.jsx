import React, { useEffect, useState } from "react";
import axios from "./api/axios";
import Header from "./Header";
import "./Bookings.css"; // creează dacă nu ai



function MyBookings() {
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const token = localStorage.getItem("accessToken");
    if (!token) return;

    axios.get("/bookings/my", {
      headers: {
        Authorization: `Bearer ${token}`
      }
    })
    .then(res => setBookings(res.data))
    .catch(err => console.error("Failed to load bookings", err))
    .finally(() => setLoading(false));
  }, []);

  return (
    <>
      <Header />
      <div className="my-bookings-container">
        <h2>Your Bookings</h2>
        {loading ? (
          <p>Loading...</p>
        ) : bookings.length === 0 ? (
          <p>You haven't booked any rooms yet.</p>
        ) : (
          <div className="booking-list">
            {bookings.map(booking => (
              <div className="booking-card" key={booking.id}>
                <img
                  src={`http://localhost:5000${booking.room_image}`}
                  alt={booking.room_type}
                  className="booking-image"
                />
                <div className="booking-info">
                  <h4>{booking.hotel}</h4>
                  <p>{booking.hotel_location}</p>
                  <p>Room: {booking.room_type}</p>
                  <p>Check-in: {booking.check_in_date}</p>
                  <p>Check-out: {booking.check_out_date}</p>
                  <p>Status: {booking.status}</p>
                  <p>Price/night: {booking.price_per_night} RON</p>
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </>
  );
}

export default MyBookings;
