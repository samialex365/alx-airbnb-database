# Database Performance Monitoring and Optimization Report

Repository: alx-airbnb-database  
Directory: database-adv-script    
Date: *(Add date here)*

---

## Objective

Continuously monitor and refine database performance by analyzing query execution plans and making schema adjustments to optimize frequently used queries.

---

## Step 1: Monitoring Query Performance

Used EXPLAIN ANALYZE to inspect execution plans of key queries. Examples include:

```sql
EXPLAIN ANALYZE
SELECT users.id, users.name, COUNT(bookings.id) AS total_bookings
FROM users
LEFT JOIN bookings ON users.id = bookings.user_id
GROUP BY users.id, users.name
ORDER BY total_bookings DESC;
