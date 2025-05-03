from flask import Blueprint, jsonify, request
from models import Hotel, Review, Room
from extensions import db
from flask_jwt_extended import jwt_required, get_jwt_identity

reviews_bp = Blueprint("reviews", __name__)

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

@reviews_bp.route("/", methods=["GET"])
def get_all_reviews():
    reviews = Review.query.all()
    if not reviews:
        return jsonify({"message": "No reviews found"}), 404
    reviews_list = [{
        "id": review.id,
        "user_id": review.user_id,
        "room_id": review.room_id,
        "rating": review.rating,
        "comment": review.comment,
    } for review in reviews]
    return jsonify(reviews_list), 200