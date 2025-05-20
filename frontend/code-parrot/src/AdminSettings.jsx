import React, { useEffect, useState } from "react";
import axios from "axios";

const BACKEND_URL = "http://localhost:5000"; // modifică dacă backendul rulează pe alt port

function AdminSettings() {
  const [bookings, setBookings] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [removingId, setRemovingId] = useState(null);
  const [modalId, setModalId] = useState(null); // id-ul rezervării pentru care e deschis modalul

  const fetchBookings = async () => {
    setLoading(true);
    setError(null);
    try {
      const token = localStorage.getItem("accessToken");
      const res = await fetch(`${BACKEND_URL}/api/bookings/admin/all`, {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      });
      if (!res.ok) throw new Error("Not authorized or error fetching bookings");
      const data = await res.json();
      setBookings(data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchBookings();
    // eslint-disable-next-line
  }, []);

  const handleAction = async (id, action) => {
    setRemovingId(id);
    setModalId(null);
    const token = localStorage.getItem("accessToken");
    try {
      const res = await fetch(`${BACKEND_URL}/api/bookings/${id}/status`, {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({ status: action === "Approve" ? "confirmed" : "cancelled" }),
      });
      if (!res.ok) throw new Error("Failed to update booking status");
      setTimeout(() => {
        setRemovingId(null);
        fetchBookings();
      }, 400);
    } catch (err) {
      setRemovingId(null);
      alert("Error updating status: " + err.message);
    }
  };

  // Fade-out style
  const fadeOutStyle = {
    opacity: 0,
    transition: "opacity 0.4s"
  };

  // Modal component
  const ActionModal = ({ open, onClose, onApprove, onReject }) => {
    if (!open) return null;
    return (
      <div style={{
        position: "fixed", top: 0, left: 0, width: "100vw", height: "100vh", background: "rgba(0,0,0,0.18)", zIndex: 1000,
        display: "flex", alignItems: "center", justifyContent: "center"
      }}>
        <div style={{ background: "#fff", borderRadius: 16, padding: 36, minWidth: 320, boxShadow: "0 8px 32px #0002", textAlign: "center", position: "relative" }}>
          <button onClick={onClose} style={{ position: "absolute", top: 16, right: 18, background: "none", border: "none", fontSize: 22, color: "#aaa", cursor: "pointer" }}>&times;</button>
          <h3 style={{ margin: "0 0 18px 0", fontWeight: 700, fontSize: 22, color: "#222" }}>Manage Booking</h3>
          <p style={{ color: "#666", marginBottom: 28 }}>Choose an action for this booking:</p>
          <div style={{ display: "flex", justifyContent: "center", gap: 18 }}>
            <button
              style={{ background: "#1bbf4c", color: "#fff", border: "none", borderRadius: 7, padding: "10px 28px", fontWeight: 700, fontSize: 17, cursor: "pointer", boxShadow: "0 2px 8px #1bbf4c22", transition: "background 0.2s" }}
              onClick={onApprove}
            >Approve</button>
            <button
              style={{ background: "#e74c3c", color: "#fff", border: "none", borderRadius: 7, padding: "10px 28px", fontWeight: 700, fontSize: 17, cursor: "pointer", boxShadow: "0 2px 8px #e74c3c22", transition: "background 0.2s" }}
              onClick={onReject}
            >Reject</button>
          </div>
        </div>
      </div>
    );
  };

  if (loading) return <div style={{ padding: 32 }}>Loading...</div>;
  if (error) return <div style={{ color: "red", padding: 32 }}>{error}</div>;

  return (
    <div style={{ maxWidth: 1100, margin: "40px auto", padding: 0, background: "#f8f9fb", borderRadius: 18, boxShadow: "0 4px 32px #0001" }}>
      {/* Header modern */}
      <div style={{ textAlign: "center", padding: "36px 40px 18px 40px", borderBottom: "1px solid #eee", background: "#fff", borderTopLeftRadius: 18, borderTopRightRadius: 18 }}>
        <span style={{ fontSize: 48, color: "#3f51b5", filter: "drop-shadow(0 2px 2px #b3bfff)", display: "inline-block", marginBottom: 8 }}>🗂️</span>
        <h2 style={{ margin: 0, fontWeight: 800, fontSize: 36, letterSpacing: 0.5, color: "#222" }}>Booking Management</h2>
        <p style={{ margin: "8px 0 0 0", color: "#666", fontSize: 18 }}>Review, approve or reject all user booking requests below.</p>
        <button
          style={{
            marginTop: 22,
            background: "#3f51b5",
            color: "#fff",
            border: "none",
            borderRadius: 7,
            padding: "10px 32px",
            fontWeight: 700,
            fontSize: 17,
            cursor: "pointer",
            boxShadow: "0 2px 8px #3f51b522",
            transition: "background 0.2s"
          }}
          onClick={() => window.location.href = "/"}
        >
          Back to Home
        </button>
      </div>
      {/* Table */}
      <div style={{ padding: 40 }}>
        {bookings.length === 0 ? (
          <p style={{ color: "#888", textAlign: "center", fontSize: 18 }}>No booking requests found.</p>
        ) : (
          <div style={{ overflowX: "auto" }}>
            <table style={{ width: "100%", borderCollapse: "collapse", fontSize: 17, background: "#fff", borderRadius: 12, boxShadow: "0 2px 12px #0001" }}>
              <thead>
                <tr style={{ background: "#f3f3f3" }}>
                  <th style={{ padding: 14, border: "1px solid #eee", fontWeight: 700, color: "#888", fontSize: 16, position: "sticky", top: 0, background: "#f3f3f3", zIndex: 2 }}>User Email</th>
                  <th style={{ padding: 14, border: "1px solid #eee", fontWeight: 700, color: "#888", fontSize: 16, position: "sticky", top: 0, background: "#f3f3f3", zIndex: 2 }}>Hotel</th>
                  <th style={{ padding: 14, border: "1px solid #eee", fontWeight: 700, color: "#888", fontSize: 16, position: "sticky", top: 0, background: "#f3f3f3", zIndex: 2 }}>Period</th>
                  <th style={{ padding: 14, border: "1px solid #eee", fontWeight: 700, color: "#888", fontSize: 16, position: "sticky", top: 0, background: "#f3f3f3", zIndex: 2 }}>Price/night</th>
                  <th style={{ padding: 14, border: "1px solid #eee", fontWeight: 700, color: "#888", fontSize: 16, position: "sticky", top: 0, background: "#f3f3f3", zIndex: 2 }}>Status</th>
                  <th style={{ padding: 14, border: "1px solid #eee", fontWeight: 700, color: "#888", fontSize: 16, position: "sticky", top: 0, background: "#f3f3f3", zIndex: 2 }}>Actions</th>
                </tr>
              </thead>
              <tbody>
                {bookings.map((b) => (
                  <tr
                    key={b.id}
                    style={{
                      background: b.status === "pending" ? "#fffbe7" : b.status === "confirmed" ? "#e7fff0" : "#ffe7e7",
                      transition: "background 0.2s",
                      ...(removingId === b.id ? fadeOutStyle : {})
                    }}
                  >
                    <td style={{ padding: 14, border: "1px solid #eee", color: b.user_email === "guest@innstay.com" ? "#e11d48" : "#222", fontWeight: 500 }}>
                      {b.user_email}
                      {b.user_email === "guest@innstay.com" && <span style={{ fontSize: 12, marginLeft: 6, color: "#e11d48" }}>(guest)</span>}
                    </td>
                    <td style={{ padding: 14, border: "1px solid #eee", color: "#222", fontWeight: 500 }}>{b.hotel}</td>
                    <td style={{ padding: 14, border: "1px solid #eee", color: "#222" }}>{b.perioada}</td>
                    <td style={{ padding: 14, border: "1px solid #eee", color: "#222" }}>{b.pret} €</td>
                    <td style={{ padding: 14, border: "1px solid #eee" }}>
                      <span style={{
                        display: "inline-block",
                        padding: "4px 14px",
                        borderRadius: 12,
                        fontWeight: 700,
                        fontSize: 15,
                        background: b.status === "pending" ? "#fff3cd" : b.status === "confirmed" ? "#d4edda" : "#f8d7da",
                        color: b.status === "pending" ? "#ffb300" : b.status === "confirmed" ? "#1bbf4c" : "#e74c3c",
                        border: b.status === "pending" ? "1px solid #ffe082" : b.status === "confirmed" ? "1px solid #b7e4c7" : "1px solid #f5c6cb"
                      }}>{b.status}</span>
                    </td>
                    <td style={{ padding: 14, border: "1px solid #eee" }}>
                      <button
                        style={{
                          background: "#3f51b5",
                          color: "#fff",
                          border: "none",
                          borderRadius: 7,
                          padding: "10px 28px",
                          cursor: "pointer",
                          fontWeight: 700,
                          fontSize: 16,
                          boxShadow: "0 2px 8px #3f51b522",
                          transition: "background 0.2s"
                        }}
                        onClick={() => setModalId(b.id)}
                        disabled={removingId === b.id}
                      >
                        Manage
                      </button>
                      {/* Modal pentru această rezervare */}
                      {modalId === b.id && (
                        <ActionModal
                          open={true}
                          onClose={() => setModalId(null)}
                          onApprove={() => handleAction(b.id, "Approve")}
                          onReject={() => handleAction(b.id, "Reject")}
                        />
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>
      <div style={{ margin: "0 0 18px 0", textAlign: "center", color: "#aaa", fontSize: 15, letterSpacing: 0.2 }}>
        <span>Admin panel &middot; Manage all booking requests</span>
      </div>
    </div>
  );
}

export default AdminSettings; 