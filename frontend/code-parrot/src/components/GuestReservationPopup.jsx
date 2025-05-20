import React, { useState } from 'react';
import './GuestReservationPopup.css';

const GuestReservationPopup = ({ isOpen, onClose, onSubmit, roomDetails }) => {
    const [formData, setFormData] = useState({
        guest_name: '',
        guest_email: '',
        guests: 1
    });

    const handleChange = (e) => {
        const { name, value } = e.target;
        setFormData(prev => ({
            ...prev,
            [name]: value
        }));
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        onSubmit(formData);
    };

    if (!isOpen) return null;

    return (
        <div className="guest-reservation-overlay">
            <div className="guest-reservation-popup">
                <button className="close-button" onClick={onClose}>×</button>
                <h2>Guest Reservation</h2>
                <p className="room-info">
                    {roomDetails?.room_type} - {roomDetails?.price_per_night} RON/night
                </p>
                <form onSubmit={handleSubmit}>
                    <div className="form-group">
                        <label htmlFor="guest_name">Full Name</label>
                        <input
                            type="text"
                            id="guest_name"
                            name="guest_name"
                            value={formData.guest_name}
                            onChange={handleChange}
                            required
                            placeholder="Enter your full name"
                        />
                    </div>
                    <div className="form-group">
                        <label htmlFor="guest_email">Email</label>
                        <input
                            type="email"
                            id="guest_email"
                            name="guest_email"
                            value={formData.guest_email}
                            onChange={handleChange}
                            required
                            placeholder="Enter your email"
                        />
                    </div>
                    <div className="form-group">
                        <label htmlFor="guests">Number of Guests</label>
                        <input
                            type="number"
                            id="guests"
                            name="guests"
                            value={formData.guests}
                            onChange={handleChange}
                            required
                            min="1"
                            max="4"
                        />
                    </div>
                    <button type="submit" className="submit-button">
                        Submit Reservation
                    </button>
                </form>
            </div>
        </div>
    );
};

export default GuestReservationPopup; 