import React from "react";
import { useNavigate } from "react-router-dom";

// Imagini locale din folderul beach
import dubai from "../../beach/dubai.jpg";
import inasia from "../../beach/inasia.jpg";
import phangnga from "../../beach/phang nga.jpg";
import danna from "../../beach/danna.jpg";
import bali from "../../beach/bali.webp";

const villas = [
    {
        name: "Dubai Beach Villa",
        price: "1200 RON/night",
        img: dubai,
        desc: "A luxury villa with a private pool and direct beach access in Dubai. Perfect for families and groups.",
    },
    {
        name: "Inasia Beachfront",
        price: "950 RON/night",
        img: inasia,
        desc: "Modern beachfront villa with stunning sea views and a large terrace. Ideal for relaxing getaways.",
    },
    {
        name: "Phang Nga Paradise",
        price: "1100 RON/night",
        img: phangnga,
        desc: "Exotic villa surrounded by tropical gardens, just steps from the white sand beach.",
    },
    {
        name: "Danna Resort Villa",
        price: "1350 RON/night",
        img: danna,
        desc: "Elegant villa in a 5-star resort, with infinity pool and spa access.",
    },
    {
        name: "Bali Dream Villa",
        price: "1000 RON/night",
        img: bali,
        desc: "Balinese-style villa with open-air living spaces and a private garden, close to the ocean.",
    },
];

export default function BeachVillas() {
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
                <h2>Beach Villas</h2>
                <div className="listings">
                    {villas.map((villa, idx) => (
                        <div className="listing-card" key={idx}>
                            <img src={villa.img} alt={villa.name} />
                            <div className="listing-info">
                                <h3>{villa.name}</h3>
                                <p style={{ color: "#ff385c", fontWeight: 600 }}>From {villa.price}</p>
                                <p style={{ color: "#444", fontSize: "0.98rem", marginTop: 8 }}>{villa.desc}</p>
                            </div>
                        </div>
                    ))}
                </div>
            </section>
        </div>
    );
} 