from flask import Blueprint, request, jsonify
from models import Hotel, Room
from sqlalchemy import func

search_bp = Blueprint("search", __name__)

# Define intervale de tipuri de cameră acceptate
room_type_order = {
    "Standard Room": 1,
    "Deluxe Room": 2,
    "Superior Room": 3,
    "Family Room": 4
}

@search_bp.route("/", methods=["GET"])
def search_hotels():
    destination = request.args.get("destination", "")
    checkin = request.args.get("checkin")
    checkout = request.args.get("checkout")
    requested_type = request.args.get("room_type", "Standard Room")

    # Include camere cu același tip sau mai mare
    requested_level = room_type_order.get(requested_type, 1)

    hotels = Hotel.query.filter(Hotel.location.ilike(f"%{destination}%")).all()

    results = []
    for hotel in hotels:
        matching_rooms = Room.query.filter_by(hotel_id=hotel.id).all()
        
        # Calculate minimum price for matching rooms
        min_price = None
        for room in matching_rooms:
            room_level = room_type_order.get(room.room_type, 0)
            if room_level >= requested_level:
                if min_price is None or room.price_per_night < min_price:
                    min_price = room.price_per_night

        if min_price is not None:  # Only include hotels with matching rooms
            results.append({
                "id": hotel.id,
                "name": hotel.name,
                "location": hotel.location,
                "description": hotel.description,
                "image": f"/static/hotels/{hotel.image}" if hotel.image else None,
                "min_price": min_price
            })

    return jsonify(results), 200