-- subqueries.sql
-- Description: SQL queries using correlated and non-correlated subqueries

-- NON-CORRELATED SUBQUERY: AVG_RATING_GT_4
SELECT 
    id, name, location
FROM 
    properties
WHERE 
    id IN (
        SELECT 
            property_id
        FROM 
            reviews
        GROUP BY 
            property_id
        HAVING 
            AVG(rating) > 4.0
    )
ORDER BY 
    name ASC;


-- CORRELATED SUBQUERY: USERS_WITH_MORE_THAN_3_BOOKINGS
SELECT 
    id, name, email
FROM 
    users u
WHERE 
    (
        SELECT 
            COUNT(*) 
        FROM 
            bookings b
        WHERE 
            b.user_id = u.id
    ) > 3
ORDER BY 
    name ASC;
