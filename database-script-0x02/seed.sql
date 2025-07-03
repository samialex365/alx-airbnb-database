-- Sample Data for Airbnb Database
-- ALX Project Submission

-- Clear existing data (optional)
TRUNCATE TABLE messages, reviews, payments, bookings, pricing_periods, properties, users, user_roles RESTART IDENTITY CASCADE;

-- 1. User Roles
INSERT INTO user_roles (role_name, permissions) VALUES
('guest', '{"view_listings": true, "make_bookings": true}'),
('host', '{"create_listings": true, "manage_bookings": true}'),
('admin', '{"manage_users": true, "manage_all_content": true}');

-- 2. Users (password = 'Test1234' hashed)
INSERT INTO users (first_name, last_name, email, password_hash, phone_number, role_id) VALUES
('John', 'Doe', 'john@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MH/r7s3B6G1B6L7BQyp2LpFRY.6YdK2', '+1234567890', (SELECT role_id FROM user_roles WHERE role_name = 'host')),
('Jane', 'Smith', 'jane@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MH/r7s3B6G1B6L7BQyp2LpFRY.6YdK2', '+1987654321', (SELECT role_id FROM user_roles WHERE role_name = 'guest')),
('Admin', 'User', 'admin@example.com', '$2a$10$N9qo8uLOickgx2ZMRZoMy.MH/r7s3B6G1B6L7BQyp2LpFRY.6YdK2', '+1122334455', (SELECT role_id FROM user_roles WHERE role_name = 'admin'));

-- 3. Properties
INSERT INTO properties (host_id, name, description, address_line1, city, state, postal_code, country, base_price) VALUES
((SELECT user_id FROM users WHERE email = 'john@example.com'), 
 'Cozy Downtown Apartment', 
 'Modern 1-bedroom apartment in city center', 
 '123 Main St', 'New York', 'NY', '10001', 'USA', 120.00),
((SELECT user_id FROM users WHERE email = 'john@example.com'), 
 'Beachfront Villa', 
 'Luxury 3-bedroom villa with ocean view', 
 '456 Beach Rd', 'Miami', 'FL', '33139', 'USA', 350.00);

-- 4. Pricing Periods
INSERT INTO pricing_periods (property_id, start_date, end_date, price_per_night) VALUES
((SELECT property_id FROM properties WHERE name = 'Cozy Downtown Apartment'),
 '2023-12-20', '2024-01-05', 180.00), -- Holiday pricing
((SELECT property_id FROM properties WHERE name = 'Beachfront Villa'),
 '2024-06-01', '2024-08-31', 500.00); -- Summer pricing

-- 5. Bookings
INSERT INTO bookings (property_id, user_id, start_date, end_date, status) VALUES
((SELECT property_id FROM properties WHERE name = 'Cozy Downtown Apartment'),
 (SELECT user_id FROM users WHERE email = 'jane@example.com'),
 '2023-12-28', '2024-01-02', 'confirmed'),
((SELECT property_id FROM properties WHERE name = 'Beachfront Villa'),
 (SELECT user_id FROM users WHERE email = 'jane@example.com'),
 '2024-07-15', '2024-07-22', 'pending');

-- 6. Payments
INSERT INTO payments (booking_id, amount, payment_method, status) VALUES
((SELECT booking_id FROM bookings WHERE start_date = '2023-12-28'),
 900.00, 'credit_card', 'completed'),
((SELECT booking_id FROM bookings WHERE start_date = '2024-07-15'),
 3500.00, 'paypal', 'pending');

-- 7. Reviews
INSERT INTO reviews (property_id, user_id, rating, comment) VALUES
((SELECT property_id FROM properties WHERE name = 'Cozy Downtown Apartment'),
 (SELECT user_id FROM users WHERE email = 'jane@example.com'),
 5, 'Perfect location and very clean!');

-- 8. Messages
INSERT INTO messages (sender_id, recipient_id, message_body) VALUES
((SELECT user_id FROM users WHERE email = 'jane@example.com'),
 (SELECT user_id FROM users WHERE email = 'john@example.com'),
 'Is the apartment available for late check-out?'),
((SELECT user_id FROM users WHERE email = 'john@example.com'),
 (SELECT user_id FROM users WHERE email = 'jane@example.com'),
 'Yes, we can arrange a 1pm check-out.');
