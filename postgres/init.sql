CREATE TABLE the_melvin_bank_db.users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    date_of_birth DATE,
    profile_picture_url VARCHAR(255)
);

CREATE TABLE the_melvin_bank_db.transactions (
    transaction_id INT PRIMARY KEY,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_time DATETIME NOT NULL,
    status ENUM('completed', 'failed', 'pending') NOT NULL,
    transaction_type ENUM('purchase', 'refund', 'withdrawal') NOT NULL,
    payment_method ENUM('credit_card', 'debit_card', 'paypal') NOT NULL,
    currency VARCHAR(3) NOT NULL,
    user_id INT NOT NULL,
    location VARCHAR(255) NOT NULL
);


INSERT INTO the_melvin_bank_db.transactions (user_id, amount, transaction_date, status, transaction_type, payment_method, currency, merchant_id, location) VALUES
(101, 150.00, '2024-10-01 08:45:00', 'completed', 'purchase', 'credit_card', 'USD', 201, 'New York, NY'),
(102, 89.50, '2024-10-01 09:00:00', 'completed', 'purchase', 'debit_card', 'USD', 202, 'Los Angeles, CA'),
(103, 220.75, '2024-10-01 09:15:00', 'failed', 'purchase', 'credit_card', 'USD', 203, 'Chicago, IL'),
(101, 300.00, '2024-10-01 09:30:00', 'completed', 'refund', 'paypal', 'USD', 201, 'New York, NY'),
(104, 75.25, '2024-10-01 10:00:00', 'completed', 'withdrawal', 'credit_card', 'USD', 204, 'San Francisco, CA'),
(105, 500.00, '2024-10-01 10:05:00', 'completed', 'purchase', 'credit_card', 'USD', 205, 'Seattle, WA'),
(102, 125.00, '2024-10-01 10:10:00', 'pending', 'purchase', 'debit_card', 'USD', 202, 'Los Angeles, CA'),
(106, 450.00, '2024-10-01 10:15:00', 'completed', 'purchase', 'credit_card', 'USD', 206, 'Miami, FL'),
(107, 39.99, '2024-10-01 10:20:00', 'completed', 'refund', 'paypal', 'USD', 207, 'Houston, TX'),
(108, 150.00, '2024-10-01 10:30:00', 'failed', 'purchase', 'credit_card', 'USD', 208, 'Philadelphia, PA'),
(109, 300.50, '2024-10-01 10:35:00', 'completed', 'purchase', 'debit_card', 'USD', 209, 'Austin, TX'),
(110, 600.00, '2024-10-01 10:40:00', 'completed', 'purchase', 'credit_card', 'USD', 201, 'New York, NY'),
(111, 10.00, '2024-10-01 10:45:00', 'completed', 'withdrawal', 'paypal', 'USD', 210, 'Denver, CO'),
(112, 900.00, '2024-10-01 10:50:00', 'failed', 'purchase', 'credit_card', 'USD', 211, 'Atlanta, GA'),
(101, 120.00, '2024-10-01 11:00:00', 'completed', 'purchase', 'debit_card', 'USD', 201, 'New York, NY'),
(102, 200.00, '2024-10-01 11:05:00', 'pending', 'purchase', 'credit_card', 'USD', 202, 'Los Angeles, CA'),
(104, 450.00, '2024-10-01 11:10:00', 'completed', 'refund', 'credit_card', 'USD', 204, 'San Francisco, CA'),
(106, 850.00, '2024-10-01 11:15:00', 'completed', 'purchase', 'credit_card', 'USD', 206, 'Miami, FL'),
(103, 123.45, '2024-10-01 11:20:00', 'failed', 'purchase', 'debit_card', 'USD', 203, 'Chicago, IL'),
(110, 99.99, '2024-10-01 11:25:00', 'completed', 'withdrawal', 'paypal', 'USD', 201, 'New York, NY'),
(107, 34.99, '2024-10-01 11:30:00', 'completed', 'purchase', 'credit_card', 'USD', 207, 'Houston, TX'),
(111, 500.50, '2024-10-01 11:35:00', 'pending', 'purchase', 'debit_card', 'USD', 210, 'Denver, CO'),
(108, 320.00, '2024-10-01 11:40:00', 'completed', 'purchase', 'credit_card', 'USD', 208, 'Philadelphia, PA'),
(109, 29.99, '2024-10-01 11:45:00', 'completed', 'purchase', 'debit_card', 'USD', 209, 'Austin, TX'),
(112, 760.00, '2024-10-01 11:50:00', 'failed', 'purchase', 'credit_card', 'USD', 211, 'Atlanta, GA'),
(101, 175.50, '2024-10-01 12:00:00', 'completed', 'purchase', 'paypal', 'USD', 201, 'New York, NY'),
(105, 850.00, '2024-10-01 12:05:00', 'failed', 'purchase', 'credit_card', 'USD', 205, 'Seattle, WA'),
(104, 300.00, '2024-10-01 12:10:00', 'completed', 'purchase', 'debit_card', 'USD', 204, 'San Francisco, CA'),
(102, 60.00, '2024-10-01 12:15:00', 'completed', 'refund', 'paypal', 'USD', 202, 'Los Angeles, CA'),
(106, 430.00, '2024-10-01 12:20:00', 'completed', 'withdrawal', 'credit_card', 'USD', 206, 'Miami, FL');


INSERT INTO the_melvin_bank_db.users (username, email, password_hash, phone, last_login, address, city, state, country, postal_code, date_of_birth, profile_picture_url) VALUES
('john_doe', 'john.doe@example.com', 'hashed_password_1', '123-456-7890', '2024-10-01 10:30:00', '123 Main St', 'Springfield', 'IL', 'USA', '62701', '1985-04-15', 'http://example.com/images/john_doe.jpg'),
('jane_smith', 'jane.smith@example.com', 'hashed_password_2', '234-567-8901', '2024-10-05 15:45:00', '456 Oak St', 'Greenfield', 'IN', 'USA', '46140', '1990-08-22', 'http://example.com/images/jane_smith.jpg'),
('alice_johnson', 'alice.johnson@example.com', 'hashed_password_3', '345-678-9012', '2024-10-10 09:00:00', '789 Pine St', 'Madison', 'WI', 'USA', '53703', '1995-01-30', 'http://example.com/images/alice_johnson.jpg'),
('bob_brown', 'bob.brown@example.com', 'hashed_password_4', '456-789-0123', '2024-10-12 11:15:00', '321 Maple St', 'Columbus', 'OH', 'USA', '43215', '1988-11-05', 'http://example.com/images/bob_brown.jpg'),
('charlie_davis', 'charlie.davis@example.com', 'hashed_password_5', '567-890-1234', '2024-10-15 08:30:00', '654 Elm St', 'Orlando', 'FL', 'USA', '32801', '1992-12-20', 'http://example.com/images/charlie_davis.jpg'),
('dave_martinez', 'dave.martinez@example.com', 'hashed_password_6', '678-901-2345', '2024-10-20 13:00:00', '987 Cedar St', 'Austin', 'TX', 'USA', '73301', '1982-06-11', 'http://example.com/images/dave_martinez.jpg'),
('eve_clark', 'eve.clark@example.com', 'hashed_password_7', '789-012-3456', '2024-10-22 16:30:00', '321 Birch St', 'Seattle', 'WA', 'USA', '98101', '1993-07-25', 'http://example.com/images/eve_clark.jpg'),
('frank_wilson', 'frank.wilson@example.com', 'hashed_password_8', '890-123-4567', '2024-10-25 14:00:00', '654 Spruce St', 'Phoenix', 'AZ', 'USA', '85001', '1979-03-09', 'http://example.com/images/frank_wilson.jpg'),
('grace_taylor', 'grace.taylor@example.com', 'hashed_password_9', '901-234-5678', '2024-10-27 12:45:00', '987 Fir St', 'San Francisco', 'CA', 'USA', '94101', '1998-02-14', 'http://example.com/images/grace_taylor.jpg'),
('harry_thomas', 'harry.thomas@example.com', 'hashed_password_10', '012-345-6789', '2024-10-30 10:00:00', '135 Willow St', 'Chicago', 'IL', 'USA', '60601', '1984-09-09', 'http://example.com/images/harry_thomas.jpg');


--CREATE TABLE fraud_alerts (
--    alert_id SERIAL PRIMARY KEY,
--    transaction_id INTEGER REFERENCES transactions(transaction_id),
--    alert_level VARCHAR(20),
--    alert_message TEXT,
--    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
--);