CREATE DATABASE IF NOT EXISTS ecommerce_analytics;
USE ecommerce_analytics;
SHOW TABLES;



SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM returns;
SELECT COUNT(*) FROM shipping;

SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;

USE ecommerce_analytics;

SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    ROUND(SUM(o.order_amount), 2) AS total_sales,
    ROUND(SUM(oi.profit), 2) AS total_profit
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;

USE ecommerce_analytics;

SELECT
    p.category,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    ROUND(SUM(oi.profit), 2) AS total_profit,
    ROUND(SUM(oi.profit) / NULLIF(SUM(oi.sales),0) * 100, 2) AS margin_percent
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
AND YEAR(o.order_date) = 2022 
GROUP BY p.category
ORDER BY margin_percent ASC;

SELECT
    c.region,
    c.segment,
    ROUND(SUM(o.order_amount), 2) AS total_revenue,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.order_amount) / NULLIF(COUNT(DISTINCT o.order_id),0), 2) AS avg_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'Completed'
GROUP BY c.region, c.segment
ORDER BY total_revenue DESC;

SELECT
    p.product_name,
    p.category,
    p.subcategory,
    ROUND(SUM(oi.sales), 2) AS total_sales,
    ROUND(SUM(oi.profit), 2) AS total_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY p.product_name, p.category, p.subcategory
ORDER BY total_sales DESC
LIMIT 20;

SELECT
    p.category,
    COUNT(DISTINCT r.order_id) AS return_orders,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(COUNT(DISTINCT r.order_id) / NULLIF(COUNT(DISTINCT o.order_id),0) * 100, 2) AS return_rate_percent
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN returns r ON o.order_id = r.order_id
WHERE o.order_status IN ('Completed','Returned')
GROUP BY p.category
ORDER BY return_rate_percent DESC;

SELECT
    s.is_late,
    COUNT(DISTINCT s.order_id) AS orders_count,
    ROUND(AVG(o.order_amount), 2) AS avg_order_value
FROM shipping s
JOIN orders o ON s.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY s.is_late;
















