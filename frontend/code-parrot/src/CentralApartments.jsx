import React from "react";
import { useNavigate } from "react-router-dom";

// Imagini locale din folderul apartament
import london from "../../apartament/London.jpg";
import la from "../../apartament/Los Angeles.jpg";
import phoenix from "../../apartament/Phoenix.avif";
import bucharest from "../../apartament/Bucharest.jpg";
import stpaul from "../../apartament/St. Paul's Bay.jpg";

const apartments = [
    {
        name: "London City Apartment",
        price: "700 RON/night",
        img: london,
        desc: "Modern apartment in the heart of London, close to all major attractions and public transport.",
    },
    {
        name: "Los Angeles Downtown",
        price: "650 RON/night",
        img: la,
        desc: "Spacious apartment with a great view of LA skyline, perfect for business or leisure.",
    },
    {
        name: "Phoenix Urban Loft",
        price: "500 RON/night",
        img: phoenix,
        desc: "Cozy loft in Phoenix, ideal for couples or solo travelers, with easy access to nightlife.",
    },
    {
        name: "Bucharest Central Flat",
        price: "400 RON/night",
        img: bucharest,
        desc: "Comfortable flat in downtown Bucharest, walking distance to Old Town and museums.",
    },
    {
        name: "St. Paul's Bay Residence",
        price: "600 RON/night",
        img: stpaul,
        desc: "Seaside apartment in Malta, with balcony and stunning bay views.",
    },
];

export default function CentralApartments() {
    const navigate = useNavigate();
    return (
        <div className="home-container">
            <button
                className="back-home-btn"
                onClick={() => navigate("/")}
            >
                ← Back to Home
            </button>
            <section className="popular-listings">
                <h2>Central Apartments</h2>
                <div className="listings">
                    {apartments.map((ap, idx) => (
                        <div className="listing-card" key={idx}>
                            <img src={ap.img} alt={ap.name} />
                            <div className="listing-info">
                                <h3>{ap.name}</h3>
                                <p style={{ color: "#ff385c", fontWeight: 600 }}>From {ap.price}</p>
                                <p style={{ color: "#444", fontSize: "0.98rem", marginTop: 8 }}>{ap.desc}</p>
                            </div>
                        </div>
                    ))}
                </div>
            </section>
        </div>
    );
} 