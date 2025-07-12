-- database_index.sql
-- Description: Create indexes to improve query performance and measure with EXPLAIN ANALYZE


-- ======== CREATE INDEX COMMANDS ========

-- Index on bookings.user_id for faster joins and lookups
CREATE INDEX IF NOT EXISTS idx_bookings_user_id ON bookings(user_id);

-- Index on bookings.property_id for joins with properties
CREATE INDEX IF NOT EXISTS idx_bookings_property_id ON bookings(property_id);

-- Index on bookings.date to speed up ORDER BY queries involving booking date
CREATE INDEX IF NOT EXISTS idx_bookings_date ON bookings(date);

-- Index on reviews.property_id for join with properties and filtering
CREATE INDEX IF NOT EXISTS idx_reviews_property_id ON reviews(property_id);

-- Optional: Index on reviews.rating to speed up average rating calculations
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);



-- ======== MEASURE QUERY PERFORMANCE BEFORE INDEXES ========
-- Run this BEFORE creating the indexes

EXPLAIN ANALYZE
SELECT users.id, users.name, COUNT(bookings.id) AS total_bookings
FROM users
LEFT JOIN bookings ON users.id = bookings.user_id
GROUP BY users.id, users.name
ORDER BY total_bookings DESC;



-- ======== MEASURE QUERY PERFORMANCE AFTER INDEXES ========
-- Run this AFTER creating the indexes

EXPLAIN ANALYZE
SELECT users.id, users.name, COUNT(bookings.id) AS total_bookings
FROM users
LEFT JOIN bookings ON users.id = bookings.user_id
GROUP BY users.id, users.name
ORDER BY total_bookings DESC;
