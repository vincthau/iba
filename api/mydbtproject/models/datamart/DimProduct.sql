{{ config(materialized='table') }}


SELECT product.id AS product_id
,product.reference
,product.name AS product_name
,CAST(product.price AS int) AS price
,product_category.name AS product_category
FROM product
LEFT JOIN product_category 
ON product_category.id = product.category_id
ORDER BY 1