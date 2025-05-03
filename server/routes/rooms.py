from flask import Blueprint, jsonify, request
from models import Room, Hotel
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
        "room_number": room.room_number,
        "room_type": room.room_type,
        "price": room.price,
        "status": room.availability
    } for room in rooms]
    return jsonify(rooms_list), 200
