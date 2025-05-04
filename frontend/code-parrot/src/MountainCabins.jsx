import React from "react";
import { useNavigate } from "react-router-dom";

// Imagini locale din folderul mountain
import longreads from "../../mountain/longreads.webp";
import rocky from "../../mountain/rocky mountain.jpg";
import smoky from "../../mountain/smoky mountain.jpeg";
import heaven from "../../mountain/heaven's mountain lodge.jfif";
import gatlinburg from "../../mountain/gatlinburg.jfif";

const cabins = [
    {
        name: "Longreads Retreat",
        price: "400 RON/night",
        img: longreads,
        desc: "A cozy cabin with panoramic mountain views and a rustic fireplace. Perfect for reading and relaxation.",
    },
    {
        name: "Rocky Mountain Cabin",
        price: "350 RON/night",
        img: rocky,
        desc: "Traditional wooden cabin nestled in the heart of the Rocky Mountains. Great for hiking lovers.",
    },
    {
        name: "Smoky Mountain Escape",
        price: "420 RON/night",
        img: smoky,
        desc: "Modern amenities in a classic setting, surrounded by the misty Smoky Mountains.",
    },
    {
        name: "Heaven's Mountain Lodge",
        price: "600 RON/night",
        img: heaven,
        desc: "Luxury lodge with hot tub, large terrace, and breathtaking sunrise views.",
    },
    {
        name: "Gatlinburg Hideaway",
        price: "380 RON/night",
        img: gatlinburg,
        desc: "Charming cabin close to Gatlinburg, with easy access to trails and local attractions.",
    },
];

export default function MountainCabins() {
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
                <h2>Mountain Cabins</h2>
                <div className="listings">
                    {cabins.map((cabin, idx) => (
                        <div className="listing-card" key={idx}>
                            <img src={cabin.img} alt={cabin.name} />
                            <div className="listing-info">
                                <h3>{cabin.name}</h3>
                                <p style={{ color: "#ff385c", fontWeight: 600 }}>From {cabin.price}</p>
                                <p style={{ color: "#444", fontSize: "0.98rem", marginTop: 8 }}>{cabin.desc}</p>
                            </div>
                        </div>
                    ))}
                </div>
            </section>
        </div>
    );
} 