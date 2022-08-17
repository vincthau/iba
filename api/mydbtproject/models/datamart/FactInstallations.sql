{{ config(materialized='table') }}

SELECT 
	 TO_CHAR(installation_date, 'yyyymmdd')::INT AS date_id
	 ,installation.id AS installation_id
	 ,product.id AS product_id 
	 ,customer.id AS customer_id
	 ,1 AS cnt
	 ,CAST(product.price AS INT) AS price
FROM installation 
LEFT JOIN product 
	ON product.id = installation.product_id
LEFT JOIN customer 
	ON customer.id = installation.customer_id
	ORDER BY 1,2