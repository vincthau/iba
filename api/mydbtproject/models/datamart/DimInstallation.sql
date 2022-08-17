{{ config(materialized='table') }}


SELECT
	id AS installation_id
	,name AS installation_name
	,description AS installation_description
	,to_char(installation_date, 'YYYY') AS installation_year
	,to_char(installation_date, 'MM') AS installation_month
	,installation_date
FROM installation 
ORDER BY id