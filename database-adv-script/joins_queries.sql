SELECT 
    bookings.id AS booking_id,
    bookings.date,
    users.id AS user_id,
    users.name,
    users.email
FROM 
    bookings
INNER JOIN 
    users ON bookings.user_id = users.id;

SELECT 
    properties.id AS property_id,
    properties.name AS property_name,
    properties.location,
    reviews.id AS review_id,
    reviews.rating,
    reviews.comment
FROM 
    properties
LEFT JOIN 
    reviews ON properties.id = reviews.property_id;



SELECT 
    users.id AS user_id,
    users.name,
    bookings.id AS booking_id,
    bookings.date,
    bookings.property_id
FROM 
    users
FULL OUTER JOIN 
    bookings ON users.id = bookings.user_id;

SELECT 
    bookings.id AS booking_id,
    bookings.date,
    users.id AS user_id,
    users.name,
    users.email
FROM 
    bookings
INNER JOIN 
    users ON bookings.user_id = users.id
ORDER BY 
    bookings.date DESC;  -- Most recent bookings first


-- 2. LEFT JOIN: Get all properties and their reviews (including properties with no reviews)
SELECT 
    properties.id AS property_id,
    properties.name AS property_name,
    properties.location,
    reviews.id AS review_id,
    reviews.rating,
    reviews.comment
FROM 
    properties
LEFT JOIN 
    reviews ON properties.id = reviews.property_id
ORDER BY 
    properties.name ASC;  -- Alphabetical order of property name


-- 3. FULL OUTER JOIN: Get all users and all bookings
-- Note: Some SQL engines (like MySQL) do not support FULL OUTER JOIN directly

-- If your SQL engine supports FULL OUTER JOIN:
SELECT 
    users.id AS user_id,
    users.name,
    bookings.id AS booking_id,
    bookings.date,
    bookings.property_id
FROM 
    users
FULL OUTER JOIN 
    bookings ON users.id = bookings.user_id
ORDER BY 
    users.name ASC NULLS LAST,  -- Order by user name, keep NULLs (no user) last
    bookings.date DESC;         -- Then sort by booking date (most recent first)


-- If you're using MySQL (alternative using UNION):
-- Simulate FULL OUTER JOIN
SELECT 
    users.id AS user_id,
    users.name,
    bookings.id AS booking_id,
    bookings.date,
    bookings.property_id
FROM 
    users
LEFT JOIN 
    bookings ON users.id = bookings.user_id

UNION

SELECT 
    users.id AS user_id,
    users.name,
    bookings.id AS booking_id,
    bookings.date,
    bookings.property_id
FROM 
    bookings
LEFT JOIN 
    users ON bookings.user_id = users.id
WHERE 
    users.id IS NULL
ORDER BY 
    user_id, bookings.date DESC;
