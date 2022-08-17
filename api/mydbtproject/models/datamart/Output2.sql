{{ config(materialized='table') }}

SELECT
		 DimDate.year_actual
		,DimDate.month_actual
		,DimProduct.product_category
		,SUM(DimProduct.price) AS revenue
	FROM public."FactInstallations" AS fact
	JOIN public."DimProduct" AS DimProduct
		ON DimProduct.product_id = fact.product_id
	JOIN public."DimDate"  AS DimDate
		ON DimDate.date_id = fact.date_id
	GROUP BY 	 DimDate.year_actual
		,DimDate.month_actual
		,DimProduct.product_category