CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(15) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP DEFAULT CURRENT_TIMESTAMP, --should change this
    is_active BOOLEAN DEFAULT TRUE,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    dob DATE,
    profile_picture_url VARCHAR(255)
);

CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    transaction_datetime DATE NOT NULL,
    merchant VARCHAR(50),
    category VARCHAR(50),
    amount DECIMAL(10, 2) NOT NULL,
    latitude DECIMAL(10, 5) NOT NULL,
    longitude DECIMAL(10, 5) NOT NULL,
    merchant_latitude DECIMAL(10, 5) NOT NULL,
    merchant_longitude DECIMAL(10, 5) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    user_id INT NOT NULL
);

INSERT INTO users (user_id, username, email, phone, last_login, address, city, state, country, postal_code, dob, profile_picture_url) VALUES
(101, 'john_doe', 'john.doe@example.com', '123-456-7890', '2024-10-01 10:30:00', '123 Main St', 'Springfield', 'IL', 'USA', '62701', '1985-04-15', 'http://example.com/images/john_doe.jpg'),
(102, 'jane_smith', 'jane.smith@example.com', '234-567-8901', '2024-10-05 15:45:00', '456 Oak St', 'Greenfield', 'IN', 'USA', '46140', '1990-08-22', 'http://example.com/images/jane_smith.jpg'),
(103, 'alice_johnson', 'alice.johnson@example.com', '345-678-9012', '2024-10-10 09:00:00', '789 Pine St', 'Madison', 'WI', 'USA', '53703', '1995-01-30', 'http://example.com/images/alice_johnson.jpg'),
(104, 'bob_brown', 'bob.brown@example.com', '456-789-0123', '2024-10-12 11:15:00', '321 Maple St', 'Columbus', 'OH', 'USA', '43215', '1988-11-05', 'http://example.com/images/bob_brown.jpg'),
(105, 'charlie_davis', 'charlie.davis@example.com', '567-890-1234', '2024-10-15 08:30:00', '654 Elm St', 'Orlando', 'FL', 'USA', '32801', '1992-12-20', 'http://example.com/images/charlie_davis.jpg'),
(106, 'dave_martinez', 'dave.martinez@example.com', '678-901-2345', '2024-10-20 13:00:00', '987 Cedar St', 'Austin', 'TX', 'USA', '73301', '1982-06-11', 'http://example.com/images/dave_martinez.jpg'),
(107, 'eve_clark', 'eve.clark@example.com', '789-012-3456', '2024-10-22 16:30:00', '321 Birch St', 'Seattle', 'WA', 'USA', '98101', '1993-07-25', 'http://example.com/images/eve_clark.jpg'),
(108, 'frank_wilson', 'frank.wilson@example.com', '890-123-4567', '2024-10-25 14:00:00', '654 Spruce St', 'Phoenix', 'AZ', 'USA', '85001', '1979-03-09', 'http://example.com/images/frank_wilson.jpg'),
(109, 'grace_taylor', 'grace.taylor@example.com', '901-234-5678', '2024-10-27 12:45:00', '987 Fir St', 'San Francisco', 'CA', 'USA', '94101', '1998-02-14', 'http://example.com/images/grace_taylor.jpg'),
(110, 'harry_thomas', 'harry.thomas@example.com', '012-345-6789', '2024-10-30 10:00:00', '135 Willow St', 'Chicago', 'IL', 'USA', '60601', '1984-09-09', 'http://example.com/images/harry_thomas.jpg');


INSERT INTO transactions (transaction_datetime,merchant,category,amount,latitude,longitude,merchant_latitude,merchant_longitude,currency,user_id) VALUES
('2019-01-01 00:00:44','Heller, Gutmann and Zieme','grocery_pos',107.23,48.8878,-118.2105,49.159047,-118.186462,'USD',115),
('2019-01-01 00:00:51','Lind-Buckridge','entertainment',220.11,42.1808,-112.262,43.150704,-112.154481,'USD',115),
('2019-01-01 00:07:27','Kiehn Inc','grocery_pos',96.29,41.6125,-122.5258,41.65752,-122.230347,'USD',120),
('2019-01-01 00:09:03','Beier-Hyatt','shopping_pos',7.77,32.9396,-105.8189,32.863258,-106.520205,'USD',105),
('2019-01-01 00:21:32','Bruen-Yost','misc_pos',6.85,43.0172,-111.0292,43.753735,-111.454923,'USD',109),
('2019-01-01 00:22:06','Kunze Inc','grocery_pos',90.22,20.0827,-155.488,19.560013,-156.045889,'USD',114),
('2019-01-01 00:22:18','Nitzsche, Kessler and Wol','shopping_pos',4.02,42.8062,-100.6215,42.47559,-101.265846,'USD',115);