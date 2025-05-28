import React, { useEffect, useState } from "react";
import { useParams, useSearchParams } from "react-router-dom";
import axios from "./api/axios";
import "./View.css";
import Header from "./Header";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";
import GuestReservationPopup from "./components/GuestReservationPopup";

function addOneDay(date) {
  const d = new Date(date);
  d.setDate(d.getDate() + 1);
  return d;
}
function parseDate(str) {
  if (!str) return null;
  const d = new Date(str);
  return isNaN(d) ? null : d;
}

function View() {
  const { id } = useParams();
  const [searchParams] = useSearchParams();
  const [hotel, setHotel] = useState(null);
  const [loading, setLoading] = useState(true);
  const [selectedRoomId, setSelectedRoomId] = useState(null);
  // Inițializare robustă pentru date:
  const checkinParam = searchParams.get("checkin");
  const checkoutParam = searchParams.get("checkout");
  const defaultCheckIn = new Date();
  const defaultCheckOut = addOneDay(defaultCheckIn);
  const [checkIn, setCheckIn] = useState(
    checkinParam === null
      ? defaultCheckIn
      : checkinParam === ""
        ? null
        : parseDate(checkinParam)
  );
  const [checkOut, setCheckOut] = useState(
    checkoutParam === null
      ? defaultCheckOut
      : checkoutParam === ""
        ? null
        : parseDate(checkoutParam)
  );
  const [unavailableRoomIds, setUnavailableRoomIds] = useState([]);
  const [showGuestPopup, setShowGuestPopup] = useState(false);
  const [showSuccess, setShowSuccess] = useState(false);
  const [successMessage, setSuccessMessage] = useState("");

  // Load hotel details
  useEffect(() => {
    axios
      .get(`/hotels/${id}/details`)
      .then((res) => {
        setHotel(res.data);
        if (res.data.rooms?.length) {
          setSelectedRoomId(res.data.rooms[0].id);
        }
      })
      .catch((err) => console.error("Error loading hotel details:", err))
      .finally(() => setLoading(false));
  }, [id]);

  // Fetch unavailable rooms for current check-in/out
  useEffect(() => {
    if (!checkIn || !checkOut) return;
    axios
      .get(`/bookings/unavailable-rooms`, {
        params: {
          check_in: `${checkIn.getFullYear()}-${String(checkIn.getMonth() + 1).padStart(2, '0')}-${String(checkIn.getDate()).padStart(2, '0')}`,
          check_out: `${checkOut.getFullYear()}-${String(checkOut.getMonth() + 1).padStart(2, '0')}-${String(checkOut.getDate()).padStart(2, '0')}`,
        },
      })
      .then((res) => {
        setUnavailableRoomIds(res.data.unavailable || []);
      })
      .catch((err) => {
        console.error("Error fetching unavailable rooms:", err);
      });
  }, [checkIn, checkOut]);

  // Auto-set checkOut dacă e invalid
  const handleCheckIn = (date) => {
    setCheckIn(date);
    if (!date) {
      setCheckOut(null);
      return;
    }
    if (!checkOut || checkOut <= date) {
      setCheckOut(addOneDay(date));
    }
  };

  const selectedRoom = hotel?.rooms.find((r) => r.id === selectedRoomId);
  const nights = checkIn && checkOut ? Math.max(1, Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24))) : 1;
  const subtotal = selectedRoom ? selectedRoom.price_per_night * nights : 0;
  const cleaning = Math.round(subtotal * 0.05);
  const service = Math.round(subtotal * 0.15);
  const total = subtotal + cleaning + service;

  const handleReserve = async () => {
    const token = localStorage.getItem("accessToken");
    if (!token) {
      setShowGuestPopup(true);
      return;
    }

    try {
      const response = await axios.post(
        "/bookings/",
        {
          room_id: selectedRoomId,
          check_in_date: checkIn ? `${checkIn.getFullYear()}-${String(checkIn.getMonth() + 1).padStart(2, '0')}-${String(checkIn.getDate()).padStart(2, '0')}` : null,
          check_out_date: checkOut ? `${checkOut.getFullYear()}-${String(checkOut.getMonth() + 1).padStart(2, '0')}-${String(checkOut.getDate()).padStart(2, '0')}` : null,
          guests: 1,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      setShowSuccess(true);
      setSuccessMessage("Booking successful!");
      setTimeout(() => setShowSuccess(false), 2500);
    } catch (error) {
      if (error.response?.status === 409) {
        alert("This room is already booked for the selected dates.");
      } else {
        console.error("Booking error:", error.response?.data || error.message);
        alert("Failed to book the room. Please try again.");
      }
    }
  };

  const handleGuestReservation = async (guestData) => {
    try {
      const response = await axios.post("/bookings/guest", {
        room_id: selectedRoomId,
        guest_name: guestData.guest_name,
        guest_email: guestData.guest_email,
        guests: guestData.guests,
        check_in_date: checkIn ? `${checkIn.getFullYear()}-${String(checkIn.getMonth() + 1).padStart(2, '0')}-${String(checkIn.getDate()).padStart(2, '0')}` : null,
        check_out_date: checkOut ? `${checkOut.getFullYear()}-${String(checkOut.getMonth() + 1).padStart(2, '0')}-${String(checkOut.getDate()).padStart(2, '0')}` : null,
      });

      setShowGuestPopup(false);
      setShowSuccess(true);
      setSuccessMessage("Reservation request submitted successfully! We'll contact you soon.");
      setTimeout(() => setShowSuccess(false), 2500);
    } catch (error) {
      console.error("Guest reservation error:", error.response?.data || error.message);
      alert("Failed to submit reservation request. Please try again.");
    }
  };

  if (loading) return <div className="loading">Loading...</div>;
  if (!hotel) return <div className="error">Hotel not found.</div>;

  return (
    <>
      <Header />
      {showSuccess && (
        <div className="booking-success-popup" onClick={() => setShowSuccess(false)}>
          {successMessage}
        </div>
      )}
      <GuestReservationPopup
        isOpen={showGuestPopup}
        onClose={() => setShowGuestPopup(false)}
        onSubmit={handleGuestReservation}
        roomDetails={selectedRoom}
      />
      <div className="hotel-view-container">
        <div className="hotel-header">
          <h2>{hotel.name}</h2>
          <p className="location">{hotel.location}</p>
        </div>

        <img
          className="main-image"
          src={`http://127.0.0.1:5000${hotel.image}`}
          alt={hotel.name}
        />

        <p className="description">{hotel.description}</p>

        <div className="main-content">
          {/* Left: Available rooms */}
          <div className="left-column">
            <h3 className="section-title">Available rooms</h3>
            <div className="rooms-grid">
              {hotel.rooms.map((room) => {
                const isUnavailable = unavailableRoomIds.includes(room.id);
                return (
                  <div
                    key={room.id}
                    className={`room-card ${room.id === selectedRoomId ? "selected" : ""} ${isUnavailable ? "disabled" : ""}`}
                    onClick={() => !isUnavailable && setSelectedRoomId(room.id)}
                  >
                    <img
                      className="room-image"
                      src={`http://127.0.0.1:5000${room.image}`}
                      alt={room.room_type}
                    />
                    <div className="room-info">
                      <h4>{room.room_type}</h4>
                      <p className="room-price">
                        {room.price_per_night} RON <span>/night</span>
                      </p>
                      <p className="room-facilities">{room.facilities}</p>
                      {isUnavailable && (
                        <p className="room-unavailable">Unavailable</p>
                      )}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Right: Booking card */}
          <div className="right-column">
            <div className="reservation-box">
              <h3 className="booking-title">Booking</h3>
              <div className="date-pickers">
                <div className="date-field">
                  <label>Check-in</label>
                  <DatePicker
                    selected={checkIn}
                    onChange={handleCheckIn}
                    placeholderText="Check-in date"
                    dateFormat="dd/MM/yyyy"
                    className="date-picker-input"
                    popperPlacement="bottom"
                    showPopperArrow={false}
                    isClearable
                  />
                </div>
                <div className="date-field">
                  <label>Check-out</label>
                  <DatePicker
                    selected={checkOut}
                    onChange={date => setCheckOut(date)}
                    placeholderText="Check-out date"
                    dateFormat="dd/MM/yyyy"
                    className="date-picker-input"
                    popperPlacement="bottom"
                    showPopperArrow={false}
                    isClearable
                    minDate={checkIn ? addOneDay(checkIn) : null}
                  />
                </div>
              </div>
              <div className="price-summary">
                <div className="price-row">
                  <span>
                    {selectedRoom?.price_per_night} RON × {nights} nights
                  </span>
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
              <button className="book-btn" onClick={handleReserve}>
                Reserve
              </button>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}

export default View;
