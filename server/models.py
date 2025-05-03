from extensions import db
from werkzeug.security import generate_password_hash, check_password_hash

class User(db.Model):
    __tablename__ = 'Users'
    id = db.Column('ID', db.Integer, primary_key=True)
    username = db.Column('Username', db.String(50), nullable=False)
    password = db.Column('Password_User', db.String(128), nullable=False)
    email = db.Column('Email', db.String(100), nullable=False)
    role = db.Column('Role_User', db.String(20), nullable=False)
    created_at = db.Column('Created_at', db.DateTime, server_default=db.func.now())

    def set_password(self, password):
        self.password = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password, password)

class Hotel(db.Model):
    __tablename__ = 'Hotels'
    id = db.Column('ID', db.Integer, primary_key=True)
    name = db.Column('Name_Hotel', db.String(100), nullable=False)
    location = db.Column('Location_Hotel', db.String(150), nullable=False)
    description = db.Column('Description_Hotel', db.Text)
    rooms = db.relationship('Room', backref='hotel', lazy=True)

class Room(db.Model):
    __tablename__ = 'Rooms'
    id = db.Column('ID', db.Integer, primary_key=True)
    hotel_id = db.Column('Hotel_ID', db.Integer, db.ForeignKey('Hotels.ID'), nullable=False)
    room_number = db.Column('Room_no', db.String(10), nullable=False)
    room_type = db.Column('Room_type', db.String(50), nullable=False)
    price = db.Column('Price_per_night', db.Float, nullable=False)
    availability = db.Column('Status_Room', db.String(20), nullable=False)

class Booking(db.Model):
    __tablename__ = 'Bookings'
    id = db.Column('ID', db.Integer, primary_key=True)
    user_id = db.Column('User_ID', db.Integer, db.ForeignKey('Users.ID'), nullable=False)
    room_id = db.Column('Room_ID', db.Integer, db.ForeignKey('Rooms.ID'), nullable=False)
    check_in_date = db.Column('Check_in_date', db.Date, nullable=False)
    check_out_date = db.Column('Check_out_date', db.Date, nullable=False)
    status = db.Column('Status_Booking', db.String(20), nullable=False)
    created_at = db.Column('Created_at', db.DateTime, server_default=db.func.now())

class Review(db.Model):
    __tablename__ = 'Reviews'
    id = db.Column('ID', db.Integer, primary_key=True)
    user_id = db.Column('User_ID', db.Integer, db.ForeignKey('Users.ID'), nullable=False)
    room_id = db.Column('Room_ID', db.Integer, db.ForeignKey('Rooms.ID'), nullable=False)
    rating = db.Column('Rating', db.Integer, nullable=False)
    comment = db.Column('Comment', db.Text)
    created_at = db.Column('Created_at', db.DateTime, server_default=db.func.now())

class Recommendation(db.Model):
    __tablename__ = 'Recommendations'
    id = db.Column('ID', db.Integer, primary_key=True)
    user_id = db.Column('User_ID', db.Integer, db.ForeignKey('Users.ID'), nullable=False)
    place = db.Column('Place', db.String(100), nullable=False)
    name_place = db.Column('Name_Place', db.String(100), nullable=False)
    description_place = db.Column('Description_Place', db.Text)
    location_place = db.Column('Location_Place', db.String(150), nullable=False)
    created_at = db.Column('Created_at', db.DateTime, server_default=db.func.now())
