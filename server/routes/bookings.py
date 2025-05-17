from flask import Blueprint, jsonify, request
from models import Booking, User, Room, Hotel
from extensions import db
from flask_jwt_extended import jwt_required, get_jwt_identity
from datetime import datetime

bookings_bp = Blueprint("bookings", __name__)

def require_role(*roles):
    def wrapper(fn):
        @jwt_required()
        def decorated(*args, **kwargs):
            identity = get_jwt_identity()
            if identity["role"] not in roles:
                return jsonify({"msg": "Forbidden"}), 403
            return fn(*args, **kwargs)
        decorated.__name__ = fn.__name__
        return decorated
    return wrapper

# ✅ GET all bookings
@bookings_bp.route("/", methods=["GET"])
def get_all_bookings():
    bookings = Booking.query.all()
    if not bookings:
        return jsonify({"message": "No bookings found"}), 404

    bookings_list = [{
        "id": booking.id,
        "user_id": booking.user_id,
        "room_id": booking.room_id,
        "guests": booking.guests,
        "check_in_date": booking.check_in_date.isoformat(),
        "check_out_date": booking.check_out_date.isoformat(),
        "status": booking.status,
        "created_at": booking.created_at.isoformat() if booking.created_at else None
    } for booking in bookings]

    return jsonify(bookings_list), 200

# ✅ POST new booking (cu verificare de suprapunere)
@bookings_bp.route("/", methods=["POST"])
@jwt_required()
def create_booking():
    data = request.get_json()

    try:
        user_id = int(get_jwt_identity())
        room_id = data["room_id"]
        check_in = datetime.strptime(data["check_in_date"], "%Y-%m-%d")
        check_out = datetime.strptime(data["check_out_date"], "%Y-%m-%d")

        # 🔐 Verifică dacă deja e rezervată
        overlapping = Booking.query.filter(
            Booking.room_id == room_id,
            Booking.status != "cancelled",
            Booking.check_out_date > check_in,
            Booking.check_in_date < check_out
        ).first()

        if overlapping:
            return jsonify({
                "error": "Room is already booked for the selected dates."
            }), 409

        booking = Booking(
            user_id=user_id,
            room_id=room_id,
            check_in_date=check_in,
            check_out_date=check_out,
            guests=data.get("guests", 1),
            status="pending"
        )
        db.session.add(booking)
        db.session.commit()

        return jsonify({
            "message": "Booking created successfully",
            "booking_id": booking.id
        }), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 400

# ✅ GET unavailable rooms (pentru View.js)
@bookings_bp.route("/unavailable-rooms", methods=["GET"])
def get_unavailable_rooms():
    try:
        check_in = request.args.get("check_in")
        check_out = request.args.get("check_out")

        if not check_in or not check_out:
            return jsonify({"error": "Missing check_in or check_out"}), 400

        check_in = datetime.strptime(check_in, "%Y-%m-%d")
        check_out = datetime.strptime(check_out, "%Y-%m-%d")

        bookings = Booking.query.filter(
            Booking.status != "cancelled",
            Booking.check_out_date > check_in,
            Booking.check_in_date < check_out
        ).all()

        room_ids = list({booking.room_id for booking in bookings})
        return jsonify({"unavailable": room_ids}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 400

@bookings_bp.route("/my", methods=["GET"])
@jwt_required()
def get_user_bookings():
    user_id = int(get_jwt_identity())

    bookings = Booking.query.filter_by(user_id=user_id).all()

    result = []
    for booking in bookings:
        room = booking.room
        hotel = room.hotel

        result.append({
            "id": booking.id,
            "room_id": booking.room_id,
            "check_in_date": booking.check_in_date.isoformat(),
            "check_out_date": booking.check_out_date.isoformat(),
            "status": booking.status,
            "created_at": booking.created_at.isoformat() if booking.created_at else None,
            "hotel": hotel.name,
            "hotel_location": hotel.location,
            "room_type": room.room_type,
            "room_image": f"/static/rooms/{room.image}" if room.image else None,
            "price_per_night": room.price_per_night
        })

    return jsonify(result), 200

# GET all bookings for admin (with user email, hotel, perioada, pret, status, id)
@bookings_bp.route("/admin/all", methods=["GET"])
@jwt_required()
def get_all_bookings_admin():
    identity = get_jwt_identity()
    # Verifică dacă userul e admin
    if isinstance(identity, dict):
        role = identity.get("role")
    else:
        # fallback pentru id simplu
        user = User.query.get(int(identity))
        role = user.role if user else None
    if role != "admin":
        return jsonify({"msg": "Forbidden"}), 403

    bookings = Booking.query.all()
    result = []
    for booking in bookings:
        user = booking.user
        room = booking.room
        hotel = room.hotel
        result.append({
            "id": booking.id,
            "user_email": user.email,
            "hotel": hotel.name,
            "perioada": f"{booking.check_in_date.strftime('%d/%m/%Y')} - {booking.check_out_date.strftime('%d/%m/%Y')}",
            "pret": room.price_per_night,
            "status": booking.status
        })
    return jsonify(result), 200

@bookings_bp.route("/<int:booking_id>/status", methods=["PATCH"])
@jwt_required()
def update_booking_status(booking_id):
    identity = get_jwt_identity()
    # Verifică dacă userul e admin
    if isinstance(identity, dict):
        role = identity.get("role")
    else:
        user = User.query.get(int(identity))
        role = user.role if user else None
    if role != "admin":
        return jsonify({"msg": "Forbidden"}), 403

    data = request.get_json()
    status = data.get("status")
    if status not in ["confirmed", "cancelled"]:
        return jsonify({"msg": "Invalid status"}), 400

    booking = Booking.query.get_or_404(booking_id)
    booking.status = status
    db.session.commit()
    return jsonify({"msg": f"Booking {booking_id} status updated to {status}"}), 200