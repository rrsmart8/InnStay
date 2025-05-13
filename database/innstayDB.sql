-- USERS
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    role TEXT NOT NULL CHECK (role IN ('user', 'admin', 'db_admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- HOTELS
CREATE TABLE hotels (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    location TEXT NOT NULL,
    description TEXT,
    image TEXT
);

-- HOTEL ADMINS (users assigned to manage hotels)
CREATE TABLE hotel_admins (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hotel_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(hotel_id, user_id)
);

-- ROOMS
CREATE TABLE rooms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hotel_id INTEGER NOT NULL,
    room_no TEXT NOT NULL,
    room_type TEXT NOT NULL,
    price_per_night REAL NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('available', 'booked', 'maintenance')),
    image TEXT,
    facilities TEXT,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);

-- BOOKINGS
CREATE TABLE bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    guests INTEGER NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

-- REVIEWS
CREATE TABLE reviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

-- RECOMMENDATIONS
CREATE TABLE recommendations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    hotel_id INTEGER NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id) ON DELETE CASCADE
);


INSERT INTO users (username, password, email, role)
VALUES ('db_admin_user', 'securepass123', 'admin@example.com', 'db_admin');
INSERT INTO users (username, password, email, role)
VALUES ('hotel_manager', 'hotelpass456', 'manager@hotel.com', 'admin');
INSERT INTO users (username, password, email, role)
VALUES ('john_doe', 'passjohn789', 'john.doe@example.com', 'user');
INSERT INTO users (username, password, email, role)
VALUES ('jane_smith', 'jane987pass', 'jane.smith@example.com', 'user');


INSERT INTO hotels (name, location, description, image)
VALUES ('HOTEL LUX GARDEN', 'Azuga, Romania', 'Lux Garden Hotel & Resort invites you to enjoy moments of relaxation in a luxurious setting, surrounded by refinement and elegance, where good taste and harmony are at home. Fresh air, fairy-tale landscapes, and top-level comfort! Perfectly located at the base of the ski slopes and just a few steps away from the gondola’s lower station in Azuga, Lux Garden is the only five-star hotel that offers you an oasis of tranquility, comfort, and dedicated services.', 'azuga1.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Azuga Ski And Bike Resort', 'Azuga, Romania', 'Azuga Ski and Bike Resort is a 4-star hotel located in the heart of the Carpathian Mountains, offering a perfect blend of comfort and adventure. With direct access to ski slopes and mountain biking trails, it’s an ideal destination for outdoor enthusiasts.', 'azuga2.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Casa Azugeana', 'Azuga, Romania', 'Casa Azugeana is a charming guesthouse located in the picturesque town of Azuga. It offers cozy accommodations and a warm atmosphere, making it a perfect retreat for families and couples.', 'azuga3.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Vila La Gabi', 'Azuga, Romania', 'Vila La Gabi is a beautiful villa situated in the scenic Azuga area. It features modern amenities and a lovely garden, providing a peaceful escape for guests.', 'azuga4.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Hotel Margaritar', 'Busteni, Romania', 'Hotel Margaritar is a cozy hotel located in Busteni, offering comfortable rooms and stunning views of the surrounding mountains. It’s a great base for exploring the area.', 'busteni1.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Vila Leonida', 'Busteni, Romania', 'Vila Leonida is a charming villa in Busteni, providing a homely atmosphere and easy access to local attractions. It’s perfect for families and groups.', 'busteni2.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Casa Freya', 'Busteni, Romania', 'Casa Freya is a delightful guesthouse in Busteni, offering comfortable accommodations and a friendly environment. It’s an ideal spot for relaxation and exploration.', 'busteni3.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Hotel Valedor Boutique and Spa', 'Busteni, Romania', 'Hotel Valedor Boutique and Spa is a luxurious hotel in Busteni, featuring elegant rooms and a full-service spa. It’s perfect for those seeking relaxation and pampering.', 'busteni4.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Hotel New Belvedere', 'Poiana Brasov, Romania', 'Hotel New Belvedere is a modern hotel located in Poiana Brasov, offering stylish accommodations and easy access to ski slopes. It’s a great choice for winter sports enthusiasts.', 'poianabrasov1.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Hotel Alpin', 'Poiana Brasov, Romania', 'Hotel Alpin is a luxurious hotel in Poiana Brasov, featuring elegant rooms and top-notch amenities. It’s perfect for a relaxing getaway in the mountains.', 'poianabrasov2.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Ana Hotels Sport Poiana Brasov', 'Poiana Brasov, Romania', 'Ana Hotels Sport Poiana Brasov is a modern hotel offering comfortable accommodations and a range of recreational facilities. It’s ideal for both relaxation and adventure.', 'poianabrasov3.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Hotel Acasa la Dracula', 'Poiana Brasov, Romania', 'Hotel Acasa la Dracula is a unique hotel in Poiana Brasov, themed around the legend of Dracula. It offers a one-of-a-kind experience for guests.', 'poianabrasov4.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('andBeyond Mnemba Island', 'Mnemba Island, Tanzania', 'andBeyond Mnemba Island is a luxurious private island resort in Tanzania. It offers pristine beaches, world-class diving, and exclusive accommodations for an unforgettable tropical getaway.', 'random2.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Six Senses Zighy Bay', 'Musandam, Oman', 'Six Senses Zighy Bay is a stunning resort located in Musandam, Oman. It features luxurious villas with private pools, breathtaking mountain views, and a private beach for a perfect escape.', 'random3.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES('Jumeirah Burj Al Arab', 'Dubai, UAE', 'Jumeirah Burj Al Arab is an iconic luxury hotel in Dubai, known for its distinctive sail-shaped silhouette. It offers opulent accommodations, world-class dining, and unparalleled service, making it a symbol of luxury and extravagance.', 'random4.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Waldorf Astoria Maldives Ithaafushi', 'Maldives', 'Waldorf Astoria Maldives Ithaafushi is a luxurious resort in the Maldives, offering private villas, stunning ocean views, and exceptional dining experiences. It’s the perfect destination for a romantic getaway or a family vacation.', 'random5.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Hotel International', 'Sinaia, Romania', 'Hotel International is a luxurious hotel located in Sinaia, Romania. It offers elegant accommodations, a full-service spa, and stunning views of the Carpathian Mountains.', 'sinaia1.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Hotel Cumpatu', 'Sinaia, Romania', 'Hotel Cumpatu is a charming hotel in Sinaia, providing comfortable rooms and a cozy atmosphere. It’s an ideal base for exploring the beautiful surroundings.', 'sinaia2.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Hotel Tantzia', 'Sinaia, Romania', 'Hotel Tantzia is a delightful hotel in Sinaia, offering modern amenities and a warm ambiance. It’s perfect for families and couples looking for a relaxing getaway.', 'sinaia3.jpg');

INSERT INTO hotels (name, location, description, image)
VALUES ('Vila Camelia', 'Sinaia, Romania', 'Vila Camelia is a beautiful villa in Sinaia, featuring comfortable accommodations and a lovely garden. It’s a great choice for those seeking tranquility and nature.', 'sinaia4.jpg');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (1, '101', 'Deluxe Room', 150.00, 'available', 'azuga1_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (1, '102', 'Superior Room', 200.00, 'available', 'azuga1_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (1, '103', 'Family Room', 250.00, 'available', 'azuga1_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (1, '104', 'Suite', 300.00, 'available', 'azuga1_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (2, '201', 'Standard Room', 120.00, 'available', 'azuga2_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (2, '202', 'Deluxe Room', 180.00, 'available', 'azuga2_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (2, '203', 'Superior Room', 220.00, 'available', 'azuga2_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (2, '204', 'Family Room', 270.00, 'available', 'azuga2_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (3, '301', 'Standard Room', 110.00, 'available', 'azuga3_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (3, '302', 'Deluxe Room', 160.00, 'available', 'azuga3_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (3, '303', 'Superior Room', 210.00, 'available', 'azuga3_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (3, '304', 'Family Room', 260.00, 'available', 'azuga3_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (4, '401', 'Standard Room', 130.00, 'available', 'azuga4_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (4, '402', 'Deluxe Room', 190.00, 'available', 'azuga4_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (4, '403', 'Superior Room', 240.00, 'available', 'azuga4_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (4, '404', 'Family Room', 290.00, 'available', 'azuga4_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (5, '501', 'Standard Room', 140.00, 'available', 'busteni1_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (5, '502', 'Deluxe Room', 200.00, 'available', 'busteni1_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (5, '503', 'Superior Room', 250.00, 'available', 'busteni1_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (5, '504', 'Family Room', 300.00, 'available', 'busteni1_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (6, '601', 'Standard Room', 150.00, 'available', 'busteni2_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (6, '602', 'Deluxe Room', 210.00, 'available', 'busteni2_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (6, '603', 'Superior Room', 260.00, 'available', 'busteni2_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (6, '604', 'Family Room', 310.00, 'available', 'busteni2_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (7, '701', 'Standard Room', 160.00, 'available', 'busteni3_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (7, '702', 'Deluxe Room', 220.00, 'available', 'busteni3_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (7, '703', 'Superior Room', 270.00, 'available', 'busteni3_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (7, '704', 'Family Room', 320.00, 'available', 'busteni3_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (8, '801', 'Standard Room', 170.00, 'available', 'busteni4_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (8, '802', 'Deluxe Room', 230.00, 'available', 'busteni4_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (8, '803', 'Superior Room', 280.00, 'available', 'busteni4_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (8, '804', 'Family Room', 330.00, 'available', 'busteni4_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (9, '901', 'Standard Room', 180.00, 'available', 'poianabrasov1_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (9, '902', 'Deluxe Room', 240.00, 'available', 'poianabrasov1_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (9, '903', 'Superior Room', 290.00, 'available', 'poianabrasov1_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (9, '904', 'Family Room', 340.00, 'available', 'poianabrasov1_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (10, '1001', 'Standard Room', 190.00, 'available', 'poianabrasov2_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (10, '1002', 'Deluxe Room', 250.00, 'available', 'poianabrasov2_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (10, '1003', 'Superior Room', 300.00, 'available', 'poianabrasov2_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (10, '1004', 'Family Room', 350.00, 'available', 'poianabrasov2_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (11, '1101', 'Standard Room', 200.00, 'available', 'poianabrasov3_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (11, '1102', 'Deluxe Room', 260.00, 'available', 'poianabrasov3_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (11, '1103', 'Superior Room', 310.00, 'available', 'poianabrasov3_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (11, '1104', 'Family Room', 360.00, 'available', 'poianabrasov3_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (12, '1201', 'Standard Room', 210.00, 'available', 'poianabrasov4_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (12, '1202', 'Deluxe Room', 270.00, 'available', 'poianabrasov4_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (12, '1203', 'Superior Room', 320.00, 'available', 'poianabrasov4_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (12, '1204', 'Family Room', 370.00, 'available', 'poianabrasov4_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (13, '1301', 'Standard Room', 220.00, 'available', 'random2_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (13, '1302', 'Deluxe Room', 280.00, 'available', 'random2_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (13, '1303', 'Superior Room', 330.00, 'available', 'random2_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (13, '1304', 'Family Room', 380.00, 'available', 'random2_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (14, '1401', 'Standard Room', 230.00, 'available', 'random3_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (14, '1402', 'Deluxe Room', 290.00, 'available', 'random3_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (14, '1403', 'Superior Room', 340.00, 'available', 'random3_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (14, '1404', 'Family Room', 390.00, 'available', 'random3_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (15, '1501', 'Standard Room', 240.00, 'available', 'random4_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (15, '1502', 'Deluxe Room', 300.00, 'available', 'random4_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (15, '1503', 'Superior Room', 350.00, 'available', 'random4_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (15, '1504', 'Family Room', 400.00, 'available', 'random4_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (16, '1601', 'Standard Room', 250.00, 'available', 'random5_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (16, '1602', 'Deluxe Room', 310.00, 'available', 'random5_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');  
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (16, '1603', 'Superior Room', 360.00, 'available', 'random5_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (16, '1604', 'Family Room', 410.00, 'available', 'random5_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (17, '1701', 'Standard Room', 260.00, 'available', 'sinaia1_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (17, '1702', 'Deluxe Room', 320.00, 'available', 'sinaia1_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (17, '1703', 'Superior Room', 370.00, 'available', 'sinaia1_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (17, '1704', 'Family Room', 420.00, 'available', 'sinaia1_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (18, '1801', 'Standard Room', 270.00, 'available', 'sinaia2_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (18, '1802', 'Deluxe Room', 330.00, 'available', 'sinaia2_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (18, '1803', 'Superior Room', 380.00, 'available', 'sinaia2_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (18, '1804', 'Family Room', 430.00, 'available', 'sinaia2_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (19, '1901', 'Standard Room', 280.00, 'available', 'sinaia3_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (19, '1902', 'Deluxe Room', 340.00, 'available', 'sinaia3_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (19, '1903', 'Superior Room', 390.00, 'available', 'sinaia3_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (19, '1904', 'Family Room', 440.00, 'available', 'sinaia3_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (20, '2001', 'Standard Room', 290.00, 'available', 'sinaia4_1.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (20, '2002', 'Deluxe Room', 350.00, 'available', 'sinaia4_2.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (20, '2003', 'Superior Room', 400.00, 'available', 'sinaia4_3.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');
INSERT INTO rooms (hotel_id, room_no, room_type, price_per_night, status, image, facilities)
VALUES (20, '2004', 'Family Room', 450.00, 'available', 'sinaia4_4.jpg', 'Free Wi-Fi, Air Conditioning, Mini Bar, TV, Room Service, Spa, Restaurant, Pool');

INSERT INTO bookings (user_id, room_id, guests, check_in_date, check_out_date, status)
VALUES (1, 1, 2, '2025-06-15', '2025-06-18', 'confirmed');

INSERT INTO bookings (user_id, room_id, guests, check_in_date, check_out_date, status)
VALUES (2, 3, 1, '2025-07-01', '2025-07-05', 'pending');

INSERT INTO bookings (user_id, room_id, guests, check_in_date, check_out_date, status)
VALUES (3, 2, 4, '2025-08-10', '2025-08-15', 'cancelled');

INSERT INTO bookings (user_id, room_id, guests, check_in_date, check_out_date, status)
VALUES (1, 5, 2, '2025-09-01', '2025-09-03', 'confirmed');

INSERT INTO bookings (user_id, room_id, guests, check_in_date, check_out_date, status)
VALUES (2, 4, 3, '2025-07-20', '2025-07-25', 'confirmed');

