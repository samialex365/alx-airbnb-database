-- performance.sql
-- Description: Initial complex query to retrieve all bookings with user, property, and payment details

SELECT 
    b.id AS booking_id,
    b.date AS booking_date,
    u.id AS user_id,
    u.name AS user_name,
    u.email AS user_email,
    p.id AS property_id,
    p.name AS property_name,
    p.location AS property_location,
    pay.id AS payment_id,
    pay.amount AS payment_amount,
    pay.status AS payment_status
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.id
JOIN 
    properties p ON b.property_id = p.id
LEFT JOIN 
    payments pay ON pay.booking_id = b.id
ORDER BY 
    b.date DESC;

EXPLAIN ANALYZE
SELECT 
    b.id AS booking_id,
    b.date AS booking_date,
    u.id AS user_id,
    u.name AS user_name,
    u.email AS user_email,
    p.id AS property_id,
    p.name AS property_name,
    p.location AS property_location,
    pay.id AS payment_id,
    pay.amount AS payment_amount,
    pay.status AS payment_status
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.id
JOIN 
    properties p ON b.property_id = p.id
LEFT JOIN 
    payments pay ON pay.booking_id = b.id
ORDER BY 
    b.date DESC;

CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_payments_booking_id ON payments(booking_id);
CREATE INDEX IF NOT EXISTS idx_bookings_date ON bookings(date);


SELECT 
    b.id AS booking_id,
    b.date AS booking_date,
    u.id AS user_id,
    u.name AS user_name,
    p.id AS property_id,
    p.name AS property_name,
    pay.amount AS payment_amount,
    pay.status AS payment_status
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.id
JOIN 
    properties p ON b.property_id = p.id
LEFT JOIN 
    payments pay ON pay.booking_id = b.id
WHERE 
    b.date >= CURRENT_DATE - INTERVAL '6 months'
ORDER BY 
    b.date DESC;

SELECT 
    b.id AS booking_id,
    b.date AS booking_date,
    u.id AS user_id,
    u.name AS user_name,
    u.email AS user_email,
    p.id AS property_id,
    p.name AS property_name,
    p.location AS property_location,
    pay.id AS payment_id,
    pay.amount AS payment_amount,
    pay.status AS payment_status
FROM 
    bookings b
JOIN 
    users u ON b.user_id = u.id
JOIN 
    properties p ON b.property_id = p.id
LEFT JOIN 
    payments pay ON pay.booking_id = b.id
WHERE
    b.date IS NOT NULL
    AND u.id IS NOT NULL
ORDER BY 
    b.date DESC;
