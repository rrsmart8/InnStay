from flask import Flask
from flask_cors import CORS
from config import Config
from extensions import db, jwt

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    
    # Initialize extensions
    db.init_app(app)
    jwt.init_app(app)
    CORS(app)
    
    # Create database tables within application context
    with app.app_context():
        db.create_all()
    
    from routes.hotels import hotels_bp
    app.register_blueprint(hotels_bp, url_prefix="/api/hotels")

    from routes.auth import auth_bp
    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    
    with app.app_context():
        db.create_all()
        print("Database tables created.")

        from models import Hotel, Room
        hotels_count = Hotel.query.count()
        print(f"Number of hotels in the database: {hotels_count}")

    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)