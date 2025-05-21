from flask import Blueprint, jsonify, request
from models import Room, Hotel, Review
from extensions import db
from flask_jwt_extended import jwt_required, get_jwt_identity

rooms_bp = Blueprint("rooms", __name__)

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

@rooms_bp.route("/", methods=["GET"])
def get_all_rooms():
    rooms = Room.query.all()
    if not rooms:
        return jsonify({"message": "No rooms found"}), 404

    rooms_list = [{
        "id": room.id,
        "hotel_id": room.hotel_id,
        "room_number": room.room_no,
        "room_type": room.room_type,
        "price_per_night": room.price_per_night,
        "status": room.status,
        "image": room.image,
        "facilities": room.facilities
    } for room in rooms]

    return jsonify(rooms_list), 200

@rooms_bp.route("/get_rooms", methods=["GET"])
def get_rooms_by_hotel():
    rooms = Room.query.all()
    if not rooms:
        return jsonify({"message": "No rooms found"}), 404

    ret_list = []
    for room in rooms:
        hotel = Hotel.query.filter_by(id=room.hotel_id).first()

        # Get all room_ids from this hotel
        hotel_rooms = Room.query.filter_by(hotel_id=hotel.id).all()
        room_ids = [r.id for r in hotel_rooms]

        # Get all reviews for these rooms
        reviews = Review.query.filter(Review.room_id.in_(room_ids)).all()
        average_rating = round(sum(r.rating for r in reviews) / len(reviews), 2) if reviews else None

        if hotel:
            ret_list.append({
                "id": room.id,
                "hotel_id": room.hotel_id,
                "hotel_name": hotel.name,
                "hotel_location": hotel.location,
                "room_number": room.room_no,
                "room_type": room.room_type,
                "price_per_night": room.price_per_night,
                "status": room.status,
                "image": f"/static/rooms/{room.image}" if room.image else None,
                "average_rating": average_rating  # 🔥 new field
            })

    return jsonify(ret_list), 200