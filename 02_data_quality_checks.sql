-- Step 2: Raw-data profiling and quality checks
-- Run these BEFORE cleaning anything.

-- 1. Row counts
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'returns', COUNT(*) FROM returns;

-- 2. Missing values
SELECT
  COUNT(*) FILTER (WHERE email IS NULL OR BTRIM(email) = '') AS missing_email,
  COUNT(*) FILTER (WHERE city IS NULL OR BTRIM(city) = '') AS missing_city
FROM customers;

-- 3. Category casing / inconsistent labels
SELECT category, COUNT(*) AS products
FROM products
GROUP BY category
ORDER BY products DESC;

-- 4. Invalid discounts
SELECT *
FROM order_items
WHERE discount_pct < 0 OR discount_pct > 1;

-- 5. Invalid quantities or prices
SELECT *
FROM order_items
WHERE quantity <= 0 OR unit_price < 0;

-- 6. Order status distribution
SELECT order_status, COUNT(*) AS orders
FROM orders
GROUP BY order_status
ORDER BY orders DESC;

-- 7. Foreign-key orphan checks (should return zero rows when constraints are active)
SELECT oi.*
FROM order_items oi
LEFT JOIN products p ON p.product_id = oi.product_id
WHERE p.product_id IS NULL;

-- 8. Date range
SELECT MIN(order_date) AS first_order, MAX(order_date) AS latest_order
FROM orders;
