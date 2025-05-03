import sqlite3
import os
<<<<<<< HEAD

def read_data():
    db_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'database', 'innstayDB.sqlite')

    if not os.path.isfile(db_path):
        print("❌ Baza de date cu date reale nu există.")
        return

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    print("📋 Users:")
    for row in cursor.execute("SELECT ID, Username, Email, Role_User FROM Users"):
        print(row)

    print("\n🏨 Hotels:")
    for row in cursor.execute("SELECT ID, Name_Hotel, Location_Hotel FROM Hotels"):
        print(row)

    conn.close()
    print("\n✅ Datele au fost citite cu succes.")

if __name__ == "__main__":
    read_data()
=======
from werkzeug.security import generate_password_hash
from datetime import datetime

def init_db():
    # Get database path
    db_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'database', 'innstayDB.sqlite')
    
    print(f"🔄 Initializing database at: {db_path}")
    
    # Create database directory if it doesn't exist
    os.makedirs(os.path.dirname(db_path), exist_ok=True)
    
    # Remove existing database file
    if os.path.exists(db_path):
        os.remove(db_path)
        print("🗑️ Removed existing database")
    
    # Create new database
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
    
    # Enable foreign keys
    cursor.execute("PRAGMA foreign_keys = ON")
    
    # Create tables
    cursor.executescript('''
    CREATE TABLE Users (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        Username TEXT NOT NULL,
        Password_User TEXT NOT NULL,
        Email TEXT NOT NULL,
        Role_User TEXT NOT NULL,
        Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

    CREATE TABLE Hotels (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        Name_Hotel TEXT NOT NULL,
        Location_Hotel TEXT NOT NULL,
        Description_Hotel TEXT
    );

    CREATE TABLE Rooms (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        Hotel_ID INTEGER NOT NULL,
        Room_no TEXT NOT NULL,
        Room_type TEXT NOT NULL,
        Price_per_night REAL NOT NULL,
        Status_Room TEXT NOT NULL,
        FOREIGN KEY (Hotel_ID) REFERENCES Hotels(ID)
    );

    CREATE TABLE Bookings (
        ID INTEGER PRIMARY KEY AUTOINCREMENT,
        User_ID INTEGER NOT NULL,
        Room_ID INTEGER NOT NULL,
        Check_in_date DATE NOT NULL,
        Check_out_date DATE NOT NULL,
        Status_Booking TEXT NOT NULL,
        Created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (User_ID) REFERENCES Users(ID),
        FOREIGN KEY (Room_ID) REFERENCES Rooms(ID)
    );
    ''')
    
    # Insert sample data
    cursor.execute('''
    INSERT INTO Users (Username, Password_User, Email, Role_User) VALUES 
    (?, ?, 'admin@innstay.com', 'admin'),
    (?, ?, 'user1@example.com', 'user')
    ''', ('admin', generate_password_hash('admin123'), 'user1', generate_password_hash('user123')))

    cursor.execute('''
    INSERT INTO Hotels (Name_Hotel, Location_Hotel, Description_Hotel) VALUES 
    ('Grand Hotel', 'New York', 'Luxury hotel in downtown'),
    ('Beach Resort', 'Miami', 'Beachfront paradise'),
    ('Mountain Lodge', 'Denver', 'Scenic mountain views')
    ''')

    cursor.execute('''
    INSERT INTO Rooms (Hotel_ID, Room_no, Room_type, Price_per_night, Status_Room) VALUES 
    (1, '101', 'Standard', 100.00, 'Available'),
    (1, '102', 'Deluxe', 200.00, 'Available'),
    (2, '201', 'Suite', 300.00, 'Available')
    ''')
    
    # Commit and close
    conn.commit()
    conn.close()
    
    print("✅ Database initialized successfully!")

if __name__ == "__main__":
    init_db()
>>>>>>> 3a455251fcecd675375f399a5185f2541e78b98d
