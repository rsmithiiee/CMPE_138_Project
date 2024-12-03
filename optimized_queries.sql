--Top 10 Best selling products selected by user category
DECLARE select_category STRING;
SET select_category = "Shorts";

WITH filtered_products AS (
  SELECT id, name 
  FROM `bigquery-public-data.thelook_ecommerce.products` 
  WHERE category = select_category
), sales_data AS (
  SELECT oi.product_id, oi.sale_price
  FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
  JOIN filtered_products AS p ON oi.product_id = p.id
)
SELECT 
  sd.product_id, 
  ANY_VALUE(p.name) AS product_name, 
  SUM(sd.sale_price) AS total_sales_revenue, 
  COUNT(sd.product_id) AS total_quantity_sold
FROM sales_data AS sd
JOIN filtered_products AS p ON sd.product_id = p.id
GROUP BY sd.product_id
ORDER BY total_quantity_sold DESC, total_sales_revenue DESC
LIMIT 10;
