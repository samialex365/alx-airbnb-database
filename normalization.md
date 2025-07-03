# Database Normalization to 3NF

## Normalized Schema

### Tables
1. User
   - user_id (PK, UUID)
   - first_name, last_name, email (UNIQUE), password_hash
   - role_id (FK → UserRole)  <!-- Normalized from ENUM -->

2. UserRole  <!-- New table -->
   - role_id (PK), role_name, permissions

3. Property
   - property_id (PK)
   - Split location into:
     - address_line1, city, state, postal_code, country

4. Pricing  <!-- New table -->
   - pricing_id (PK)
   - property_id (FK), start_date, end_date, price_per_night

5. Booking
   - Removed total_price (derivable from Pricing)
   - Kept essential FKs: property_id, user_id

## Normalization Steps

1. 1NF Compliance:
   - All attributes atomic (e.g., split address)

2. 2NF Compliance:
   - Removed partial dependencies:
     - Moved role to separate table
     - Eliminated calculated fields

3. 3NF Compliance:
   - Removed transitive dependencies:
     - Role permissions now in UserRole
     - Pricing separated from Property

## 3NF Verification
- No non-PK attribute depends on another non-PK attribute
- All tables represent single entities
- Sample dependency chain:
