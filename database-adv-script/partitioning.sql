-- partitioning.sql
-- Description: Range partitioning of bookings table based on start_date

-- Step 1: Create a new partitioned table
CREATE TABLE bookings_partitioned (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    property_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    -- Add other columns as needed
    -- For example: status VARCHAR(20), created_at TIMESTAMP, etc.
) PARTITION BY RANGE (start_date);

-- Step 2: Create partitions for specific date ranges

-- Partition for bookings in 2023
CREATE TABLE bookings_2023 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition for bookings in 2024
CREATE TABLE bookings_2024 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Add more partitions as needed for future years

-- Optional: Create default partition for values outside defined ranges
CREATE TABLE bookings_default PARTITION OF bookings_partitioned DEFAULT;
