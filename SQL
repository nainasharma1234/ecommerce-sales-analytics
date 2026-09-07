SELECT COUNT(*) FROM olist_customers;

SELECT COUNT(*) FROM olist_orders;

SELECT COUNT(*) FROM olist_order_items;

SELECT COUNT(*) FROM olist_products;


-- =====================================================
-- 2. Verify Relationships
-- =====================================================

-- Customers ↔ Orders

SELECT COUNT(*)
FROM olist_customers c
JOIN olist_orders o
ON c.customer_id = o.customer_id;

-- Orders ↔ Order Items

SELECT COUNT(*)
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id;

-- Order Items ↔ Products

SELECT COUNT(*)
FROM olist_order_items oi
JOIN olist_products p
ON oi.product_id = p.product_id;


-- =====================================================
-- 3. Top 10 Revenue Generating Categories
-- =====================================================

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price), 2) AS revenue
FROM olist_order_items oi
JOIN olist_products p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY revenue DESC
LIMIT 10;


-- =====================================================
-- 4. Top 10 Customers by Revenue
-- =====================================================

SELECT
    c.customer_unique_id,
    ROUND(SUM(oi.price),2) AS revenue
FROM olist_customers c
JOIN olist_orders o
ON c.customer_id = o.customer_id
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_unique_id
ORDER BY revenue DESC
LIMIT 10;


-- =====================================================
-- 5. Monthly Revenue Trend
-- =====================================================

SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp::timestamp) AS month,
    ROUND(SUM(oi.price),2) AS revenue
FROM olist_orders o
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY month
ORDER BY month;


-- =====================================================
-- 6. Top 10 Cities by Revenue
-- =====================================================

SELECT
    c.customer_city,
    ROUND(SUM(oi.price),2) AS revenue
FROM olist_customers c
JOIN olist_orders o
ON c.customer_id = o.customer_id
JOIN olist_order_items oi
ON o.order_id = oi.order_id
GROUP BY c.customer_city
ORDER BY revenue DESC
LIMIT 10;


-- =====================================================
-- 7. Average Order Value (AOV)
-- =====================================================

SELECT
    ROUND(
        SUM(price) / COUNT(DISTINCT order_id),
        2
    ) AS avg_order_value
FROM olist_order_items;


-- =====================================================
-- 8. Repeat Customers
-- =====================================================

SELECT
    c.customer_unique_id,
    COUNT(o.order_id) AS total_orders
FROM olist_customers c
JOIN olist_orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;


-- =====================================================
-- 9. Order Status Analysis
-- =====================================================

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- =====================================================
-- 10. Top 10 Products by Revenue
-- =====================================================
SELECT
    p.product_id,
    ROUND(SUM(oi.price),2) AS revenue
FROM olist_products p
JOIN olist_order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY revenue DESC
LIMIT 10;
