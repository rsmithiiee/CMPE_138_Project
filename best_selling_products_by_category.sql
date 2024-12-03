--Show top 10 selling products by user selected category
--Declare variable for category selection
DECLARE select_category STRING;
SET select_category = 'Shorts';

SELECT oi.product_id, p.name AS product_name, SUM(oi.sale_price) AS total_sales_revenue, COUNT(oi.id) AS total_quantity_sold
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p ON oi.product_id = p.id
WHERE p.category = select_category
GROUP BY oi.product_id, p.name
ORDER BY total_quantity_sold DESC, total_sales_revenue DESC
LIMIT 10;
