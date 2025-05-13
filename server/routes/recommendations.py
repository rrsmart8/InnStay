from flask import Blueprint, jsonify
from models import Room, Booking, Recommendation
from extensions import db
from flask_jwt_extended import jwt_required, get_jwt_identity

recommendation_bp = Blueprint("recommendation", __name__)

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

# 🔹 Ruta generală: returnează TOATE recomandările
@recommendation_bp.route("/", methods=["GET"])
def get_all_recommendations():
    recommendations = Recommendation.query.all()

    if not recommendations:
        return jsonify({"message": "No recommendations found"}), 404

    recommendations_list = [{
        "id": rec.id,
        "user_id": rec.user_id,
        "place": rec.place,
        "name_place": rec.name_place,
        "description_place": rec.description_place,
        "location_place": rec.location_place,
        "created_at": rec.created_at
    } for rec in recommendations]

    return jsonify(recommendations_list), 200


