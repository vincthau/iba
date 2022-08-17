{{ config(materialized='table') }}

SELECT 
	TO_CHAR(datum, 'yyyymmdd')::INT AS date_id,
	datum AS dt,
	TO_CHAR(datum, 'TMDay') AS day_name,
	EXTRACT(ISODOW FROM datum) AS day_of_week,
	EXTRACT(DAY FROM datum) AS day_of_month,
	EXTRACT(MONTH FROM datum) AS month_actual,
	TO_CHAR(datum, 'TMMonth') AS month_name,
	CASE
		WHEN EXTRACT(QUARTER FROM datum) = 1 THEN 'First'
		WHEN EXTRACT(QUARTER FROM datum) = 2 THEN 'Second'
		WHEN EXTRACT(QUARTER FROM datum) = 3 THEN 'Third'
		WHEN EXTRACT(QUARTER FROM datum) = 4 THEN 'Fourth'
		END AS quarter_name,
	EXTRACT(YEAR FROM datum) AS year_actual,
	TO_CHAR(datum, 'mmyyyy') AS mmyyyy,
	TO_CHAR(datum, 'mmddyyyy') AS mmddyyyy
FROM (SELECT '2021-01-01'::DATE + SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES(0, 1000) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1