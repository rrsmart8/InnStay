import React from "react";
import DatePicker from "react-datepicker";
import "react-datepicker/dist/react-datepicker.css";

function addOneDay(date) {
    const d = new Date(date);
    d.setDate(d.getDate() + 1);
    return d;
}

const SearchBar = ({
    destination,
    setDestination,
    checkin,
    setCheckin,
    checkout,
    setCheckout,
    roomType,
    setRoomType,
    onSearch
}) => {
    // Când selectezi check-in, setează automat check-out dacă nu e valid
    const handleCheckin = (date) => {
        setCheckin(date);
        if (!date) {
            setCheckout(null);
            return;
        }
        if (!checkout || checkout <= date) {
            setCheckout(addOneDay(date));
        }
    };

    return (
        <div className="search-bar">
            <input
                type="text"
                placeholder="Destination"
                value={destination}
                onChange={e => setDestination(e.target.value)}
            />
            <DatePicker
                selected={checkin}
                onChange={handleCheckin}
                placeholderText="Check-in date"
                dateFormat="dd/MM/yyyy"
                className="date-picker-input"
                popperPlacement="bottom"
                showPopperArrow={false}
                isClearable
            />
            <DatePicker
                selected={checkout}
                onChange={date => setCheckout(date)}
                placeholderText="Check-out date"
                dateFormat="dd/MM/yyyy"
                className="date-picker-input"
                popperPlacement="bottom"
                showPopperArrow={false}
                isClearable
                minDate={checkin ? addOneDay(checkin) : null}
            />
            <select value={roomType} onChange={e => setRoomType(e.target.value)}>
                <option value="Standard Room">Standard Room</option>
                <option value="Deluxe Room">Deluxe Room</option>
                <option value="Superior Room">Superior Room</option>
                <option value="Family Room">Family Room</option>
            </select>
            <button className="primary" onClick={onSearch}>Search</button>
        </div>
    );
};

export default SearchBar; 