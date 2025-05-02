from app import db

class Hotel(db.Model):
    __tablename__ = 'hotel'
    
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    location = db.Column(db.String(200), nullable=False)
    description = db.Column(db.Text)
    rating = db.Column(db.Float)
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'location': self.location,
            'description': self.description,
            'rating': self.rating
        }

    def __repr__(self):
        return f'<Hotel {self.name}>'