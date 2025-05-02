from app import create_app
from extensions import db
from models import Hotel, Room, User

def seed_database():
    app = create_app()
    with app.app_context():
        # Clear existing data
        db.session.query(Hotel).delete()
        
        # Add sample hotel
        hotel1 = Hotel(name="Grand Hotel", location="New York", description="A luxurious hotel in the heart of the city.")
        hotel2 = Hotel(name="Beach Resort", location="Miami", description="A beautiful resort by the beach.")

        room1 = Room(hotel=hotel1, room_number="101", room_type="Single", price=150.00, availability=True)
        room2 = Room(hotel=hotel1, room_number="102", room_type="Double", price=200.00, availability=True)

        room3 = Room(hotel=hotel2, room_number="201", room_type="Suite", price=300.00, availability=True)
        room4 = Room(hotel=hotel2, room_number="202", room_type="Double", price=250.00, availability=False)

        db.session.add(hotel1)
        db.session.add(hotel2)
        db.session.add(room1)
        db.session.add(room2)
        db.session.add(room3)
        db.session.add(room4)

        db.session.commit()
        print("Database seeded with sample data.")


def seed_users():
    app = create_app()
    with app.app_context():
        # Clear existing users
        db.session.query(User).delete()

        # Add sample users
        user1 = User(username="admin", role="db_admin")
        user1.set_password("adminpass")

        user2 = User(username="hotel_admin", role="hotel_admin")
        user2.set_password("hotelpass")

        user3 = User(username="user", role="user")
        user3.set_password("userpass")

        db.session.add(user1)
        db.session.add(user2)
        db.session.add(user3)

        db.session.commit()
        print("Database seeded with sample users.")

if __name__ == "__main__":
    # seed_database()
    seed_users()