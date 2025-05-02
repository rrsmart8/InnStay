from flask import Blueprint, jsonify
from models import Hotel
from app import db

hotels_bp = Blueprint("hotels", __name__)

@hotels_bp.route("/", methods=["GET"])
def get_hotels():
    hotels = Hotel.query.all()
    if not hotels:
        return jsonify({"message": "No hotels found"}), 404
    hotels_list = [{"id": hotel.id, "name": hotel.name, "location": hotel.location} for hotel in hotels]
    return jsonify(hotels_list), 200