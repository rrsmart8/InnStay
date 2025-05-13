from flask import Flask, send_from_directory
from flask_cors import CORS
from config import Config
from extensions import db, jwt
from models import Hotel
import os

def init_database(app):
    """Initialize database and verify connection"""
    db_path = os.path.join(os.path.dirname(app.root_path), 'database', 'innstayDB1.sqlite')

    if not os.path.exists(db_path):
        print(f"⚠️ Database file not found at: {db_path}")
        return False

    try:
        with app.app_context():
            hotels_count = db.session.query(db.func.count(Hotel.id)).scalar()
            print(f"✅ Connected to SQLite database")
            print(f"📊 Found {hotels_count} hotels")
        return True
    except Exception as e:
        print(f"❌ Database connection failed: {str(e)}")
        return False

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # Initialize extensions
    db.init_app(app)
    jwt.init_app(app)
    CORS(app, supports_credentials=True)

    # Initialize database
    if not init_database(app):
        raise Exception("❌ Failed to initialize database")

    # Register blueprints
    from routes.hotels import hotels_bp
    from routes.auth import auth_bp
    from routes.rooms import rooms_bp
    from routes.bookings import bookings_bp
    from routes.reviews import reviews_bp
    from routes.recommendations import recommendation_bp
    from routes.search import search_bp

    app.register_blueprint(hotels_bp, url_prefix="/api/hotels")
    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(rooms_bp, url_prefix="/api/rooms")
    app.register_blueprint(bookings_bp, url_prefix="/api/bookings")
    app.register_blueprint(reviews_bp, url_prefix="/api/reviews")
    app.register_blueprint(recommendation_bp, url_prefix="/api/recommendations")
    app.register_blueprint(search_bp, url_prefix="/api/search")

    # Serve hotel images
    @app.route('/static/hotels/<path:filename>')
    def serve_hotel_image(filename):
        return send_from_directory(os.path.join(app.root_path, 'hotels_images'), filename)

    # Serve room images
    @app.route('/static/rooms/<path:filename>')
    def serve_room_image(filename):
        return send_from_directory(os.path.join(app.root_path, 'rooms_images'), filename)

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)
