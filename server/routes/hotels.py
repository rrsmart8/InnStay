from flask import Blueprint, jsonify, request
from models import Hotel, Room
from extensions import db
from flask_jwt_extended import jwt_required, get_jwt_identity

hotels_bp = Blueprint("hotels", __name__)

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

@hotels_bp.route("/", methods=["GET"])
def get_hotels():
    hotels = Hotel.query.all()
    if not hotels:
        return jsonify({"message": "No hotels found"}), 404
    hotels_list = [{"id": hotel.id, "name": hotel.name, "location": hotel.location, "description": hotel.description} for hotel in hotels]
    return jsonify(hotels_list), 200

# @hotels_bp.route("/hotel/<string:hotel_name>", methods=["GET"])
# def get_hotel_by_name(hotel_name):
#     hotel = Hotel.query.filter_by(name=hotel_name).first()
#     if not hotel:
#         return jsonify({"message": "Hotel not found"}), 404
#     return jsonify({
#         "id": hotel.id,
#         "name": hotel.name,
#         "location": hotel.location,
#         "description": hotel.description
#     }), 200

# #TODO: Make it work
# @hotels_bp.route("/filter/<parameter>/<value>", methods=["GET"])
# def get_hotel_by_query(query):
#     parameter = query["parameter"]
#     value = query["value"]
#     if parameter == "location":
#         hotels = Hotel.query.filter_by(location=value).all()
#     elif parameter == "name":
#         hotels = Hotel.query.filter_by(name=value).all()
#     else:
#         return jsonify({"message": "Invalid filter parameter"}), 400
#     if not hotels:
#         return jsonify({"message": "No hotels found"}), 404
#     hotels_list = [{"id": hotel.id, "name": hotel.name, "location": hotel.location} for hotel in hotels]
#     return jsonify(hotels_list), 200

# @hotels_bp.route("/<string:hotel_name>/rooms", methods=["GET"])
# def get_available_rooms(hotel_name):
#     hotel = Hotel.query.filter_by(name=hotel_name).first()
#     if not hotel:
#         return jsonify({"message": "Hotel not found"}), 404
#     rooms = [{"id": room.id, "number": room.room_number, "type": room.room_type, "price": room.price} 
#              for room in hotel.rooms if room.availability]
#     return jsonify(rooms), 200

# @hotels_bp.route("/<string:hotel_name>/rooms/<int:room_id>", methods=["GET"])
# def get_room_details(hotel_name, room_id):
#     hotel = Hotel.query.filter_by(name=hotel_name).first()
#     if not hotel:
#         return jsonify({"message": "Hotel not found"}), 404
#     room = next((r for r in hotel.rooms if r.id == room_id), None)
#     if not room:
#         return jsonify({"message": "Room not found"}), 404
#     return jsonify({
#         "id": room.id,
#         "number": room.room_number,
#         "type": room.room_type,
#         "price": room.price,
#         "available": room.availability
#     }), 200

# @hotels_bp.route("/hotel/add", methods=["POST"])
# @require_role("hotel_admin", "db_admin")
# def add_hotel():
#     data = request.get_json()
    
#     if not data or 'name' not in data or 'location' not in data:
#         return jsonify({"message": "Missing required fields"}), 400
        
#     new_hotel = Hotel(
#         name=data['name'],
#         location=data['location']
#     )
    
#     try:
#         db.session.add(new_hotel)
#         db.session.commit()
#         return jsonify({
#             "message": "Hotel added successfully",
#             "hotel": {
#                 "id": new_hotel.id,
#                 "name": new_hotel.name,
#                 "location": new_hotel.location
#             }
#         }), 201
#     except Exception as e:
#         db.session.rollback()
#         return jsonify({"message": "Error adding hotel", "error": str(e)}), 500

# @hotels_bp.route("/rooms/add", methods=["POST"])
# @require_role("hotel_admin", "db_admin")
# def add_room():
#     data = request.get_json()
    
#     if not data or 'hotel_id' not in data or 'room_number' not in data or 'room_type' not in data:
#         return jsonify({"message": "Missing required fields"}), 400
        
#     new_room = Room(
#         hotel_id=data['hotel_id'],
#         room_number=data['room_number'],
#         room_type=data['room_type'],
#         price=data.get('price', 0.0),
#         availability=data.get('availability', True)
#     )
    
#     try:
#         db.session.add(new_room)
#         db.session.commit()
#         return jsonify({
#             "message": "Room added successfully",
#             "room": {
#                 "id": new_room.id,
#                 "number": new_room.room_number,
#                 "type": new_room.room_type,
#                 "price": new_room.price,
#                 "available": new_room.availability
#             }
#         }), 201
#     except Exception as e:
#         db.session.rollback()
#         return jsonify({"message": "Error adding room", "error": str(e)}), 500
    
# @hotels_bp.route("/rooms/delete/<int:room_id>", methods=["DELETE"])
# @require_role("hotel_admin", "db_admin")
# def delete_room(room_id):
#     room = Room.query.get(room_id)
#     if not room:
#         return jsonify({"message": "Room not found"}), 404
    
#     pass

# @hotels_bp.route("/hotel/delete/<int:hotel_id>", methods=["DELETE"])
# @require_role("hotel_admin", "db_admin")
# def delete_hotel(hotel_id):
#     hotel = Hotel.query.get(hotel_id)
#     if not hotel:
#         return jsonify({"message": "Hotel not found"}), 404
    
#     pass