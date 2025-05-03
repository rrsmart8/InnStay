import sqlite3
import os

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
