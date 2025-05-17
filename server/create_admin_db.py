from werkzeug.security import generate_password_hash
import sqlite3
from datetime import datetime

def create_tables(cursor):
    # Create users table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        role TEXT NOT NULL CHECK (role IN ('user', 'admin', 'db_admin')),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )
    """)


def create_admin():
    # Generate password hash
    password = 'Grasu123'
    hashed_password = generate_password_hash(password)
    print(f"Generated hash for password '{password}':")
    print(hashed_password)

    # Connect to database
    conn = sqlite3.connect('instance/innstay.db')
    cursor = conn.cursor()

    try:
        # 🔽 Apelează funcția care creează tabela dacă nu există
        create_tables(cursor)

        # Check if admin already exists
        cursor.execute("SELECT * FROM users WHERE username = 'admin'")
        if cursor.fetchone():
            print("Admin user already exists!")
            return

        # Insert admin user
        cursor.execute("""
            INSERT INTO users (username, password, email, role, created_at)
            VALUES (?, ?, ?, ?, ?)
        """, ('admin', hashed_password, 'admin@innstay.com', 'admin', datetime.now()))

        conn.commit()
        print("Admin user created successfully!")

    except sqlite3.Error as e:
        print(f"An error occurred: {e}")
        conn.rollback()

    finally:
        conn.close()
