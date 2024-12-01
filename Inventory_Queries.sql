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
