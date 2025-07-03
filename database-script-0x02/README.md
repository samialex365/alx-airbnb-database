# Database Seeding Documentation

## Sample Data Overview

### Tables Populated
1. user_roles: 3 roles (guest, host, admin)
2. users: 3 sample users
3. properties: 2 listings
4. pricing_periods: Seasonal pricing examples
5. bookings: 2 reservations
6. payments: Corresponding transactions
7. reviews: 1 guest review
8. messages: Sample conversation

## Usage Instructions

### 1. Run the Seed Script
```bash
psql -d alx_airbnb -f database-script-0x02/seed.sql
