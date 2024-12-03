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

--Orders by brand
  
--per month
--Initialize variable to specify brand name
DECLARE var_brand_name STRING;
SET var_brand_name = "Fruit of the Loom";

SELECT p.brand, EXTRACT(MONTH FROM o.created_at) AS month, EXTRACT(YEAR FROM o.created_at) AS year, COUNT(*) AS num_of_orders
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o ON oi.order_id = o.order_id
WHERE p.brand = var_brand_name
GROUP BY p.brand, month, year
ORDER BY year, month; 

--Total
--Initialize variable to specify brand name
DECLARE var_brand_name STRING;
SET var_brand_name = "Fruit of the Loom";

SELECT p.brand, COUNT (*) AS num_of_orders
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o ON oi.order_id = o.order_id
WHERE p.brand = var_brand_name
GROUP BY p.brand


--Customers by location for a specific brand for city, state, or country
--Declare variable to store brand name
DECLARE var_brand_name STRING;
SET var_brand_name = "Fruit of the Loom";

--Show customers by city
SELECT u.city, COUNT(DISTINCT u.id) AS number_of_customers
FROM `bigquery-public-data.thelook_ecommerce.users` AS u
JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o ON u.id = o.user_id
JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi ON o.order_id = oi.order_id
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
WHERE p.brand = var_brand_name
GROUP BY u.city
ORDER BY number_of_customers DESC;

--Show customers by state
SELECT u.state, COUNT(DISTINCT u.id) AS number_of_customers
FROM `bigquery-public-data.thelook_ecommerce.users` AS u
JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o ON u.id = o.user_id
JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi ON o.order_id = oi.order_id
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
WHERE p.brand = var_brand_name
GROUP BY u.state
ORDER BY number_of_customers DESC;

--Show customers by country
SELECT u.country, COUNT(DISTINCT u.id) AS number_of_customers
FROM `bigquery-public-data.thelook_ecommerce.users` AS u
JOIN `bigquery-public-data.thelook_ecommerce.orders` AS o ON u.id = o.user_id
JOIN `bigquery-public-data.thelook_ecommerce.order_items` AS oi ON o.order_id = oi.order_id
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
WHERE p.brand = var_brand_name
GROUP BY u.country
ORDER BY number_of_customers DESC;


--Show top 10 best and worst selling products for a specific brand
--Declare variable to store brand name
DECLARE var_brand_name STRING;
SET var_brand_name = "Fruit of the Loom";

--Top 10 best selling products
SELECT oi.product_id, p.name AS product_name, SUM(oi.sale_price) AS total_sales_revenue, COUNT(oi.id) AS total_quantity_sold
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
WHERE p.brand = var_brand_name
GROUP BY oi.product_id, p.name
ORDER BY total_quantity_sold DESC, total_sales_revenue DESC
LIMIT 10;

--Top 10 worst selling products
SELECT oi.product_id, p.name AS product_name, SUM(oi.sale_price) AS total_sales_revenue, COUNT(oi.id) AS total_quantity_sold
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
WHERE p.brand = var_brand_name
GROUP BY oi.product_id, p.name
ORDER BY total_quantity_sold, total_sales_revenue
LIMIT 10;

--Inventory items that are ordered the most
SELECT inv.id AS inventory_item_id, p.name AS product_name, p.category AS product_category, COUNT(*) AS total_sales
FROM `bigquery-public-data.thelook_ecommerce.inventory_items` AS inv
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
ON inv.product_id = p.id
WHERE inv.sold_at IS NOT NULL
GROUP BY inv.id, p.name, p.category
ORDER BY total_sales DESC
LIMIT 10;
