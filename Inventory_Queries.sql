--1. most returned items
SELECT p.id, p.name, p.category, COUNT(*) AS return_count
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS o_i
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON o_i.product_id = p.id
WHERE o_i.returned_at IS NOT NULL
GROUP BY p.id, p.name, p.category
ORDER BY return_count DESC
LIMIT 10

--2. inventory turnover
SELECT p.category, COUNT(DISTINCT i.id) AS total_inventory, COUNT(DISTINCT CASE WHEN i.sold_at IS NOT NULL THEN i.id END) AS items_sold,
ROUND(COUNT(DISTINCT CASE WHEN i.sold_at IS NOT NULL THEN i.id END) * 1.0 / NULLIF(COUNT(DISTINCT i.id), 0), 2) AS turnover_rate
FROM `bigquery-public-data.thelook_ecommerce.products` AS p
JOIN `bigquery-public-data.thelook_ecommerce.inventory_items` AS inv ON p.id = inv.product_id
GROUP BY p.category
ORDER BY turnover_rate DESC

--3. Stock Level Monitoring
SELECT ii.product_id, ii.product_name, COUNT(ii.id) AS stock_quantity
FROM `bigquery-public-data.thelook_ecommerce.inventory_items` AS ii
WHERE ii.sold_at IS NULL -- Unsold items indicate current stock
GROUP BY ii.product_id, ii.product_name
HAVING COUNT(ii.id) < 5 -- Threshold for low stock
ORDER BY stock_quantity ASC;


--4. Top 10 best selling products
SELECT oi.product_id, p.name AS product_name, SUM(oi.sale_price) AS total_sales_revenue, COUNT(oi.id) AS total_quantity_sold
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
ON oi.product_id = p.id
GROUP BY oi.product_id, p.name
ORDER BY total_quantity_sold DESC
LIMIT 10;


--5. Revenue and sales volume by product category
SELECT p.category AS product_category, SUM(oi.sale_price) AS total_revenue, COUNT(oi.id) AS total_units_sold
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
ON oi.product_id = p.id
GROUP BY p.category
ORDER BY total_revenue DESC
LIMIT 10;




