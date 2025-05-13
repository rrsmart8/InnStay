from flask import Blueprint, request, jsonify
from models import User
from extensions import db
from flask_jwt_extended import (
    create_access_token, jwt_required, get_jwt_identity
)

auth_bp = Blueprint("auth", __name__)

@auth_bp.route("/register", methods=["POST"])
def register():
    data = request.get_json()
    required_fields = ["username", "email", "password", "role"]
    if not data or not all(field in data for field in required_fields):
        return jsonify({"msg": "Missing fields"}), 400

    if User.query.filter_by(username=data["username"]).first():
        return jsonify({"msg": "Username already exists"}), 409
    if User.query.filter_by(email=data["email"]).first():
        return jsonify({"msg": "Email already registered"}), 409

    user = User(username=data["username"], email=data["email"], role=data["role"])
    user.set_password(data["password"])
    db.session.add(user)
    db.session.commit()

    return jsonify({"msg": "User registered"}), 201


@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    print("Received login:", data)

    user = User.query.filter_by(email=data["email"]).first()
    if not user:
        print("No user with that email")
    elif not user.check_password(data["password"]):
        print("Wrong password")

    if user and user.check_password(data["password"]):
        token = create_access_token(identity={"id": user.id, "role": user.role})
        return jsonify(
            access_token=token,
            user={
                "id": user.id,
                "username": user.username,
                "email": user.email,
                "role": user.role
            }
        )
    return jsonify({"msg": "Invalid credentials"}), 401

