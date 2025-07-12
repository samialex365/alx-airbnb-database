-- aggregations_and_window_functions.sql
-- Description: Aggregation with COUNT and window functions ROW_NUMBER and RANK

-- 1. Total number of bookings made by each user
SELECT 
    users.id AS user_id,
    users.name,
    COUNT(bookings.id) AS total_bookings
FROM 
    users
LEFT JOIN 
    bookings ON users.id = bookings.user_id
GROUP BY 
    users.id, users.name
ORDER BY 
    total_bookings DESC;


-- 2. Rank properties using RANK() based on total bookings
SELECT 
    property_id,
    properties.name AS property_name,
    COUNT(bookings.id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(bookings.id) DESC) AS booking_rank
FROM 
    properties
LEFT JOIN 
    bookings ON properties.id = bookings.property_id
GROUP BY 
    property_id, properties.name
ORDER BY 
    booking_rank;


-- 3. Rank properties using ROW_NUMBER() based on total bookings
SELECT 
    property_id,
    properties.name AS property_name,
    COUNT(bookings.id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(bookings.id) DESC) AS booking_row_number
FROM 
    properties
LEFT JOIN 
    bookings ON properties.id = bookings.property_id
GROUP BY 
    property_id, properties.name
ORDER BY 
    booking_row_number;
