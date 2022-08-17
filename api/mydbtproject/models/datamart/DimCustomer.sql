{{ config(materialized='table') }}


SELECT customer.id AS customer_id,
customer.name AS customer_name,
country.name AS customer_country,
country.region AS customer_region
FROM customer 
LEFT JOIN country 
ON country.id = customer.country_id	
ORDER BY 1