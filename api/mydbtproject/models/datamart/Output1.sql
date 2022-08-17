{{ config(materialized='table') }}

SELECT 
		 dt.year_actual
		 ,dt.month_actual
		 ,SUM(fact.cnt) AS total
	FROM public."FactInstallations" AS fact
	JOIN public."DimDate"  AS dt
		ON dt.date_id = fact.date_id
	GROUP BY dt.year_actual,dt.month_actual
	ORDER BY 1,2