from flask import Blueprint, jsonify
from models import Booking
from extensions import db
from flask_jwt_extended import jwt_required, get_jwt_identity

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
