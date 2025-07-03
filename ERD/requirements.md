## Entity-Relationship Diagram
![ERD Diagram](./images/erd.png)

## Entities and Attributes

### User
- user_id: UUID (Primary Key)
- first_name: VARCHAR (NOT NULL)
- last_name: VARCHAR (NOT NULL)
- email: VARCHAR (UNIQUE, NOT NULL)
- role: ENUM('guest', 'host', 'admin') (NOT NULL)

### Property
- property_id: UUID (Primary Key)
- host_id: UUID (Foreign Key → User)
- name: VARCHAR (NOT NULL)
- price_per_night: DECIMAL (NOT NULL)

### Booking
- booking_id: UUID (Primary Key)
- property_id: UUID (Foreign Key → Property)
- user_id: UUID (Foreign Key → User)
- status: ENUM('pending', 'confirmed', 'canceled')

### Payment
- payment_id: UUID (Primary Key)
- booking_id: UUID (Foreign Key → Booking)
- amount: DECIMAL (NOT NULL)

### Review
- review_id: UUID (Primary Key)
- property_id: UUID (Foreign Key → Property)
- rating: INTEGER (1-5) (NOT NULL)

## Relationships
- User → Property: One-to-Many (Host owns properties)
- Property → Booking: One-to-Many (Property has bookings)
- User → Booking: One-to-Many (User makes bookings)
- Booking → Payment: One-to-One (Booking has payment)
- Property → Review: One-to-Many (Property receives reviews
