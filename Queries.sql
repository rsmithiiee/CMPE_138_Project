--most returned items
SELECT p.id, p.name, p.category, COUNT(*) AS return_count
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS o_i
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON o_i.product_id = p.id
WHERE o_i.returned_at IS NOT NULL
GROUP BY p.id, p.name, p.category
ORDER BY return_count DESC
LIMIT 10

--inventory turnover
SELECT p.id AS product_id, COUNT(DISTINCT i.id) AS total_inventory, COUNT(DISTINCT CASE WHEN i.sold_at IS NOT NULL THEN i.id END) AS items_sold,ROUND(COUNT(DISTINCT CASE WHEN i.sold_at IS NOT NULL THEN i.id END) * 1.0 / NULLIF(COUNT(DISTINCT i.id), 0), 2) AS turnover_rate
FROM `bigquery-public-data.thelook_ecommerce.products` AS p
JOIN `bigquery-public-data.thelook_ecommerce.inventory_items` AS i ON p.id = i.product_id
GROUP BY p.id
ORDER BY total_inventory DESC, turnover_rate DESC;

--Stock Level Monitoring
SELECT ii.product_id, ii.product_name, COUNT(ii.id) AS stock_quantity
FROM `bigquery-public-data.thelook_ecommerce.inventory_items` AS ii
WHERE ii.sold_at IS NULL -- Unsold items indicate current stock
GROUP BY ii.product_id, ii.product_name
HAVING COUNT(ii.id) < 5 -- Threshold for low stock
ORDER BY stock_quantity ASC;


--Top 10 best selling products
SELECT oi.product_id, p.name AS product_name, SUM(oi.sale_price) AS total_sales_revenue, COUNT(oi.id) AS total_quantity_sold
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
ON oi.product_id = p.id
GROUP BY oi.product_id, p.name
ORDER BY total_quantity_sold DESC
LIMIT 10;


--Revenue and sales volume by product category
SELECT p.category AS product_category, SUM(oi.sale_price) AS total_revenue, COUNT(oi.id) AS total_units_sold
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
ON oi.product_id = p.id
GROUP BY p.category
ORDER BY total_revenue DESC
LIMIT 10;

--Customer purchase behaviour based on region
SELECT u.id, u.city, u.state, COUNT(o.order_id) AS total_orders, SUM(oi.sale_price) AS total_spent
FROM `bigquery-public-data.thelook_ecommerce.users` AS u
JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o ON u.id = o.order_id
JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi ON o.order_id = oi.order_id
GROUP BY u.id, u.city, u.state
ORDER BY total_spent DESC;

--Top 10 worst selling products
SELECT p.name, COUNT(oi.id) AS total_orders
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.id=p.id
GROUP BY p.name
ORDER BY total_orders ASC
LIMIT 10;

--FINAL QUERIES

--Show top 10 selling products by user selected category
--Declare variable for category selection
--Can use "Accessories" as another category in demo
DECLARE select_category STRING;
SET select_category = "Shorts";

SELECT oi.product_id, p.name AS product_name, SUM(oi.sale_price) AS total_sales_revenue, COUNT(oi.id) AS total_quantity_sold
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
WHERE p.category = select_category
GROUP BY oi.product_id, p.name
ORDER BY total_quantity_sold DESC, total_sales_revenue DESC
LIMIT 10;

--Revenue and sales volume by product category
SELECT p.category AS product_category, SUM(oi.sale_price) AS total_revenue, COUNT(oi.id) AS total_units_sold
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
ON oi.product_id = p.id
GROUP BY p.category
ORDER BY total_revenue DESC, total_units_sold DESC

--Revenue and sales volume for a specific product
--Declare variable for product_name
--"Nautica Mens Belted Cargo Shorts" for testing
DECLARE var_pname STRING;
SET var_pname = "Rip Curl Men's Constant Walkshort";

SELECT p.id AS product_id, p.name AS product_name, SUM(oi.sale_price) AS total_revenue, COUNT(oi.id) AS total_units_sold
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
WHERE p.name = var_pname
GROUP BY p.id, p.name
ORDER BY total_revenue DESC, total_units_sold DESC

--Traffic sources that bring in the most users
SELECT traffic_source, COUNT (traffic_source) AS num_of_users
FROM `bigquery-public-data.thelook_ecommerce.users`
GROUP BY traffic_source

