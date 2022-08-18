testing
------
	docker-compose up --build -d
	docker container ls
	Question 1 response : docker exec -i python_container python get_data_from_db.py public.\"Output1\"
	Question 2 response : docker exec -i python_container python get_data_from_db.py public.\"Output2\"
	Question 3 response : docker exec -i python_container python get_data_from_db.py public.\"Output3\"

Resume
------
	1)Docker image provided by IBA  ,  postgressql db service with a database
	2)Install Docker tool and execute the container to start the db service
	3)Discover the db content (find how to connect), and design a dimensional model
	4)Install DBT and implement the dimensional modeling layer, push the model into the database
	5)Install PowerBI Desktop and generate a report to give a response to the 3 questions
	6)Implement a python code connection to the db than  a sample SELECT cmd,  generate a docker image (containerize)
	7)Test API
	8)Create an helm chart to deploy the API on kubernetes 
	9)Version all the code on github
	10)Create a CI/CD pipeline on GitHub to check the API deployment




Database
--------
	Docker image provided by IBA
	Installation of Docker Desktop (docker compose plugin automatically installed with it)
	Command line:  Move to yaml directory : docker-compose up -d
	Import image then create the container than run it to start the db service
	Connect to pgadmin : http://localhost:8080
	Get credentials : in docker-compose.yaml file
	
Db model analyze
----------------
	We would like to report on the number of installations that the company is doing every month in order to see if the business is growing.
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------
		SELECT 
			 to_char(installation_date, 'YYYYMM') AS yearMonth
			,COUNT(DISTINCT name) AS cnt_install 
		FROM installation 
		GROUP BY to_char(installation_date, 'YYYYMM') 
		ORDER BY to_char(installation_date, 'YYYYMM');
		With Dimensional model
		---------------------
		SELECT 
			 dt.year_actual
			 ,dt.month_actual
			 ,SUM(fact.cnt) AS total
		FROM public."FactInstallations" AS fact
		JOIN public."DimDate"  AS dt
			ON dt.date_dim_id = fact.installation_date
		GROUP BY dt.year_actual,dt.month_actual
		ORDER BY 1,2
	We would also like to see which product category brings us more revenues, and which region of the world is our best market.
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------
		/*which product category brings us more revenues   , PRICE?????*/
		/*Total revenue per product category*/ /*Revenue per month per product category*/
			SELECT 
				 product_category.name           AS product_category
				,SUM(CAST(product.price AS INT)) AS revenue
			FROM installation
			LEFT JOIN product 
				ON product.id = installation.product_id
			LEFT JOIN product_category 
				ON product_category.id = product.category_id
			GROUP BY product_category.name
			ORDER BY 2 DESC;
			/*Revenue per month per product category*/
			SELECT 
				 product_category.name           AS product_category
				,to_char(installation_date, 'YYYYMM') AS yearMonth
				,SUM(CAST(product.price AS INT)) AS revenue
			FROM installation
			LEFT JOIN product 
				ON product.id = installation.product_id
			LEFT JOIN product_category 
				ON product_category.id = product.category_id
			GROUP BY product_category.name,to_char(installation_date, 'YYYYMM')
			ORDER BY 2 , 3 DESC;
			
			With Dimensional model
			---------------------
			SELECT
				 DimDate.year_actual
				,DimDate.month_actual
				,DimProduct.product_category
				,SUM(DimProduct.price) AS revenue
			FROM public."FactInstallations" AS fact
			JOIN public."DimProduct" AS DimProduct
				ON DimProduct.product_id = fact.product_id
			JOIN public."DimDate"  AS DimDate
				ON DimDate.date_dim_id = fact.installation_date
			GROUP BY 	 DimDate.year_actual
				,DimDate.month_actual
				,DimProduct.product_category	

		/*Best Market*/
			WITH 
			installations AS
			(
				SELECT 
					 product_category.name           AS product_category
					,to_char(installation_date, 'YYYYMM') AS yearMonth
					,CAST(product.price AS INT) AS installation_price
					,installation.id AS installation_id
				FROM installation
				LEFT JOIN product 
					ON product.id = installation.product_id
				LEFT JOIN product_category 
					ON product_category.id = product.category_id
			),
			installation_region AS 
			(
				SELECT 
					 country.region
					,installation.id AS installation_id 
				FROM installation
				LEFT JOIN customer 
					ON customer.id = installation.customer_id
				LEFT JOIN country 
					ON country.id = customer.country_id	
			)
			SELECT
				 installation_region.region
				,COUNT(DISTINCT installations.installation_id) AS cnt_installation
				,SUM(installation_price) AS revenue
			FROM installations
			LEFT JOIN installation_region 
				ON installation_region.installation_id = installations.installation_id
			GROUP BY installation_region.region;
			
			
			With Dimensional model
			---------------------		
			SELECT
				 DimDate.year_actual
				,DimDate.month_actual
				,DimCustomer.customer_region
				,SUM(DimProduct.price) AS revenue
			FROM public."FactInstallations" AS fact
			JOIN public."DimProduct" AS DimProduct
				ON DimProduct.product_id = fact.product_id
			JOIN public."DimDate"  AS DimDate
				ON DimDate.date_dim_id = fact.installation_date
			JOIN public."DimCustomer"  AS DimCustomer
				ON DimCustomer.customer_id = fact.customer_id
			GROUP BY 	 DimDate.year_actual
				,DimDate.month_actual
				,DimCustomer.customer_region
				


	
	
	
DBT
----
	Install VS Code , than DBT plugin
	https://www.getdbt.com/
	https://towardsdatascience.com/anatomy-of-a-dbt-project-50e810abc695
	Data Build Tool
	dbt run --full-refresh  on project directory to push the code to the database
	DBT models created in /models/datamart directory
PowerBI 
-------
	Install PBI Desktop, then create 3 tables
	report in /PowerBI
Python API
------------
	Install python plugin on vs code
	Develop the python code  , test with 127.0.0.1 host OK
	Install plugin docker on vs code
	in vscode create an image 
		include library psycopg2-binary in the requirements.txt   (psycopg2-binary==2.9.3)  (The psycopg2-binary package is meant for beginners to start playing with Python and PostgreSQL without the need to meet the build requirements.)
		RUN docker-compose up --build		
		
	TEST the API : Test connection service "postgres : OK
Docker
------
	Containers platform, Image creation, containerization and execution of the container
	docker-compose up --build -d
Kubernetes
-----------
	Containers orchestrator.
	Application Deployment, automatisation, scheduling, Cluster of machines to handle the load
HELM
----
	Helm is a Kubernetes deployment tool for automating creation, packaging, configuration, and deployment of applications and services to Kubernetes clusters. 
	Helm helps to deploy containers on kubernetes cluster
	Install vscode extension vscode-helm
	Download https://github.com/helm/helm/releases then install helm
	
	Move into the folder which contains the Dockerfile  (/API) 
	Then Run cmd : E:\tmp\helm-v3.9.3-windows-amd64\windows-amd64\helm.exe create MonPackage
	
CI/CD pipeline
--------------
	https://github.blog/2022-02-02-build-ci-cd-pipeline-github-actions-four-steps/
	On GitHub,
	Repository-->Actions-->Workflows-->Docker Image
	Update the config file just before the build command (change directory to the DockerFile directory (/api))

Push to GitHub
--------------
	Install github cli
	Command line->
	Move to your local directory then
	git init -b main
	git config --global user.email "vincent.thauvoye@gmail.com"
    git config --global user.name "Vinc Thau"
	
	git add . && git commit -m "my commit"
	Create repository on github then
	git remote add origin [GitHub repo URL] (https://github.com/vincthau/iba.git)

	git push origin main
	


