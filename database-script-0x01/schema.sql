-- Airbnb Database Schema (3NF Compliant)
-- Created for ALX project

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ======================
-- Table Creation
-- ======================

-- User Roles
CREATE TABLE user_roles (
    role_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    role_name VARCHAR(20) NOT NULL CHECK (role_name IN ('guest', 'host', 'admin')),
    permissions JSONB NOT NULL DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Users
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role_id UUID NOT NULL REFERENCES user_roles(role_id),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Properties
CREATE TABLE properties (
    property_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    host_id UUID NOT NULL REFERENCES users(user_id),
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    address_line1 VARCHAR(100) NOT NULL,
    address_line2 VARCHAR(100),
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) NOT NULL,
    base_price DECIMAL(10,2) NOT NULL CHECK (base_price > 0),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Pricing Periods
CREATE TABLE pricing_periods (
    period_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL REFERENCES properties(property_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    price_per_night DECIMAL(10,2) NOT NULL CHECK (price_per_night > 0),
    CONSTRAINT valid_date_range CHECK (end_date > start_date),
    CONSTRAINT no_date_overlaps EXCLUDE USING gist (
        property_id WITH =,
        daterange(start_date, end_date, '[]') WITH &&
    )
);

-- Bookings
CREATE TABLE bookings (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL REFERENCES properties(property_id),
    user_id UUID NOT NULL REFERENCES users(user_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'confirmed', 'canceled', 'completed')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_booking_dates CHECK (end_date > start_date)
);

-- Payments
CREATE TABLE payments (
    payment_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID NOT NULL REFERENCES bookings(booking_id),
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    payment_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('credit_card', 'paypal', 'bank_transfer')),
    transaction_id VARCHAR(100),
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'completed', 'failed', 'refunded'))
);

-- Reviews
CREATE TABLE reviews (
    review_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL REFERENCES properties(property_id),
    user_id UUID NOT NULL REFERENCES users(user_id),
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Messages
CREATE TABLE messages (
    message_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL REFERENCES users(user_id),
    recipient_id UUID NOT NULL REFERENCES users(user_id),
    message_body TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT sender_recipient_diff CHECK (sender_id <> recipient_id)
);
-- ======================
-- Indexes
-- ======================

-- Users
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role_id);

-- Properties
CREATE INDEX idx_properties_host ON properties(host_id);
CREATE INDEX idx_properties_location ON properties(city, country);

-- Pricing
CREATE INDEX idx_pricing_property ON pricing_periods(property_id);
CREATE INDEX idx_pricing_dates ON pricing_periods(property_id, start_date, end_date);

-- Bookings
CREATE INDEX idx_bookings_user ON bookings(user_id);
CREATE INDEX idx_bookings_property ON bookings(property_id);
CREATE INDEX idx_bookings_dates ON bookings(start_date, end_date);
CREATE INDEX idx_bookings_status ON bookings(status);

-- Payments
CREATE INDEX idx_payments_booking ON payments(booking_id);
CREATE INDEX idx_payments_status ON payments(status);

-- Reviews
CREATE INDEX idx_reviews_property ON reviews(property_id);
CREATE INDEX idx_reviews_user ON reviews(user_id);

-- Messages
CREATE INDEX idx_messages_sender ON messages(sender_id);
CREATE INDEX idx_messages_recipient ON messages(recipient_id);
CREATE INDEX idx_messages_conversation ON messages(GREATEST(sender_id, recipient_id), LEAST(sender_id, recipient_id));
