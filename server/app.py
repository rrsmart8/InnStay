from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from config import Config

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    
    # Initialize extensions
    db.init_app(app)
    CORS(app)
    
    # Create database tables within application context
    with app.app_context():
        db.create_all()
    
    from routes.hotels import hotels_bp
    app.register_blueprint(hotels_bp, url_prefix="/api/hotels")
    
    return app

if __name__ == '__main__':
    app = create_app()
    app.run(debug=True)