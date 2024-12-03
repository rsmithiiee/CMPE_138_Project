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

--Inventory items that sell the most
WITH SoldInventory AS(
    SELECT inv.id AS inventory_item_id, inv.product_id, inv.sold_at
    FROM `bigquery-public-data.thelook_ecommerce.inventory_items` AS inv
    WHERE inv.sold_at IS NOT NULL
)
SELECT si.inventory_item_id, p.name AS product_name, p.category AS product_category, COUNT(*) AS total_sales
FROM SoldInventory AS si
JOIN `bigquery-public-data.thelook_ecommerce.products` AS p
ON si.product_id = p.id
GROUP BY si.inventory_item_id, p.name, p.category
ORDER BY total_sales DESC
LIMIT 10;

--Top 10 products sold by specified brand optimized
DECLARE var_brand_name STRING;
SET var_brand_name = "Fruit of the Loom";

WITH filtered_products AS (
  SELECT id AS product_id, name
  FROM `bigquery-public-data.thelook_ecommerce.products`
  WHERE brand = var_brand_name
)

SELECT oi.product_id, fp.name AS product_name, SUM(oi.sale_price) AS total_sales_revenue, COUNT(oi.id) AS total_quantity_sold
FROM `bigquery-public-data.thelook_ecommerce.order_items` AS oi
JOIN filtered_products AS fp
ON oi.product_id = fp.product_id
GROUP BY oi.product_id, fp.name
ORDER BY total_quantity_sold DESC, total_sales_revenue DESC
LIMIT 10;

