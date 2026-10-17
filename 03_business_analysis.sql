-- Retail Revenue Intelligence | Business Analysis
-- Database: retail_sales_db | PostgreSQL 18
-- Revenue and estimated profit calculations use delivered orders only.

-- 1. Monthly delivered revenue
SELECT DATE_TRUNC('month', o.order_date)::date AS sales_month,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY sales_month;

-- 2. Top 10 products by delivered revenue
SELECT p.product_name,
       INITCAP(LOWER(TRIM(p.category))) AS category,
       SUM(oi.quantity) AS units_sold,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_id, p.product_name, INITCAP(LOWER(TRIM(p.category)))
ORDER BY revenue DESC
LIMIT 10;

-- 3. Revenue and estimated profit by category
SELECT INITCAP(LOWER(TRIM(p.category))) AS category,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)), 2) AS revenue,
       ROUND(SUM(oi.quantity * p.unit_cost), 2) AS product_cost,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))
             - SUM(oi.quantity * p.unit_cost), 2) AS estimated_profit,
       ROUND(100.0 * (SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))
             - SUM(oi.quantity * p.unit_cost))
             / NULLIF(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)), 0), 2) AS profit_margin_pct
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'Delivered'
GROUP BY INITCAP(LOWER(TRIM(p.category)))
ORDER BY revenue DESC;

-- 4. Top 10 customers by delivered revenue
SELECT c.customer_id, c.customer_name, c.customer_segment,
       COUNT(DISTINCT o.order_id) AS delivered_orders,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)), 2) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_id, c.customer_name, c.customer_segment
ORDER BY revenue DESC
LIMIT 10;

-- 5. Return rate and total refunds for delivered order items
WITH delivered_items AS (
    SELECT oi.order_item_id
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
),
return_summary AS (
    SELECT COUNT(DISTINCT di.order_item_id) AS delivered_item_count,
           COUNT(DISTINCT r.order_item_id) AS returned_item_count,
           COALESCE(SUM(r.refund_amount), 0) AS total_refunds
    FROM delivered_items di
    LEFT JOIN returns r ON di.order_item_id = r.order_item_id
)
SELECT delivered_item_count, returned_item_count,
       ROUND(100.0 * returned_item_count / NULLIF(delivered_item_count, 0), 2) AS return_rate_pct,
       ROUND(total_refunds, 2) AS total_refunds
FROM return_summary;

-- 6. Advanced category analysis: CTE + window functions
WITH category_performance AS (
    SELECT INITCAP(LOWER(TRIM(p.category))) AS category,
           SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)) AS revenue,
           SUM(oi.quantity * p.unit_cost) AS product_cost
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_status = 'Delivered'
    GROUP BY INITCAP(LOWER(TRIM(p.category)))
),
profit_analysis AS (
    SELECT category, revenue, product_cost,
           revenue - product_cost AS estimated_profit,
           100.0 * (revenue - product_cost) / NULLIF(revenue, 0) AS profit_margin_pct
    FROM category_performance
)
SELECT category, ROUND(revenue, 2) AS revenue,
       ROUND(product_cost, 2) AS product_cost,
       ROUND(estimated_profit, 2) AS estimated_profit,
       ROUND(profit_margin_pct, 2) AS profit_margin_pct,
       DENSE_RANK() OVER (ORDER BY revenue DESC) AS revenue_rank,
       DENSE_RANK() OVER (ORDER BY profit_margin_pct DESC) AS margin_rank
FROM profit_analysis
ORDER BY revenue_rank;

-- Business notes:
-- Home & Kitchen had the highest delivered revenue and estimated profit in this dataset.
-- Fashion had the highest estimated profit margin in this dataset.
-- Estimated profit excludes operating expenses, shipping, taxes, and other accounting adjustments.
-- Review invalid discount percentages and other data-quality anomalies before production reporting.
