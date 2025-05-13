from flask import Blueprint, jsonify, request
from models import Hotel, Room
from extensions import db
from flask_jwt_extended import jwt_required, get_jwt_identity
from functools import wraps

hotels_bp = Blueprint("hotels", __name__)

def require_role(*roles):
    def wrapper(fn):
        @wraps(fn)
        @jwt_required()
        def decorated(*args, **kwargs):
            identity = get_jwt_identity()
            if identity.get("role") not in roles:
                return jsonify({"msg": "Forbidden"}), 403
            return fn(*args, **kwargs)
        return decorated
    return wrapper

@hotels_bp.route("/", methods=["GET"])
def get_hotels():
    hotels = Hotel.query.all()
    hotels_list = []

    for hotel in hotels:
        print("Loaded image:", hotel.image)  # debug
        hotels_list.append({
            "id": hotel.id,
            "name": hotel.name,
            "location": hotel.location,
            "description": hotel.description,
            "image": f"/static/hotels/{hotel.image}" if hotel.image else None
        })

    return jsonify(hotels_list), 200

@hotels_bp.route("/<int:hotel_id>/details", methods=["GET"])
def get_hotel_details(hotel_id):
    hotel = Hotel.query.get_or_404(hotel_id)
    rooms = Room.query.filter_by(hotel_id=hotel_id).all()

    return jsonify({
        "id": hotel.id,
        "name": hotel.name,
        "location": hotel.location,
        "description": hotel.description,
        "image": f"/static/hotels/{hotel.image}" if hotel.image else None,
        "rooms": [
            {
                "id": room.id,
                "room_no": room.room_no,
                "room_type": room.room_type,
                "price_per_night": room.price_per_night,
                "image": f"/static/rooms/{room.image}" if room.image else None,
                "facilities": room.facilities.split(", ")
            }
            for room in rooms
        ]
    }), 200
