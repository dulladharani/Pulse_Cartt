
-- PulseCart Customer Intelligence Case
-- Station A - SQL Extraction

-- question 1
USE pulsecart;

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT 'products', COUNT(*)
FROM products

UNION ALL

SELECT 'orders', COUNT(*)
FROM orders

UNION ALL

SELECT 'support_tickets', COUNT(*)
FROM support_tickets;

-- question2
-- 2. Churned customers who placed at least one returned order

SELECT DISTINCT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE c.churned = 1
  AND o.returned = 1
ORDER BY c.customer_id;

-- question3
-- 3. Return rate by product category

SELECT
    p.category,
    COUNT(*) AS total_orders,
    SUM(o.returned) AS returned_orders,
    ROUND(
        100.0 * SUM(o.returned) / COUNT(*),
        2
    ) AS return_rate_pct
FROM orders o
INNER JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY return_rate_pct DESC;

-- question4
-- 4. Customers with more than one row for the same email

SELECT
    LOWER(TRIM(email)) AS normalized_email,
    COUNT(*) AS customer_count
FROM customers
WHERE email IS NOT NULL
  AND TRIM(email) <> ''
GROUP BY LOWER(TRIM(email))
HAVING COUNT(*) > 1
ORDER BY customer_count DESC, normalized_email;

-- question 5
-- 5. Orders with a customer_id that does not exist
-- in the customers table

SELECT
    o.order_id,
    o.customer_id,
    o.product_id,
    o.order_date,
    o.quantity,
    o.unit_price,
    o.returned,
    o.status
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL
ORDER BY o.order_id;

-- question 6
-- 6. Top 20 customers by net revenue
-- Cancelled orders excluded
-- Returned order lines subtracted

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    ROUND(
        SUM(
            CASE
                WHEN o.returned = 1
                    THEN -(o.quantity * o.unit_price)
                ELSE (o.quantity * o.unit_price)
            END
        ),
        2
    ) AS net_revenue
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
WHERE LOWER(o.status) <> 'cancelled'
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
ORDER BY net_revenue DESC
LIMIT 20;