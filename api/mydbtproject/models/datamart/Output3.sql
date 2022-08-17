{{ config(materialized='table') }}

SELECT
			 DimDate.year_actual
			,DimDate.month_actual
			,DimCustomer.customer_region
			,SUM(DimProduct.price) AS revenue
		FROM public."FactInstallations" AS fact
		JOIN public."DimProduct" AS DimProduct
			ON DimProduct.product_id = fact.product_id
		JOIN public."DimDate"  AS DimDate
			ON DimDate.date_id = fact.date_id
		JOIN public."DimCustomer"  AS DimCustomer
			ON DimCustomer.customer_id = fact.customer_id
		GROUP BY 	 DimDate.year_actual
			,DimDate.month_actual
			,DimCustomer.customer_region