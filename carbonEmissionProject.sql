--Q1
-- SELECT COUNT(id) AS number_of_products
--   FROM carbon_emissions;


--Q2
-- SELECT DISTINCT country
--   FROM carbon_emissions
--  ORDER BY country;

--Q3
-- SELECT DISTINCT company
--   FROM carbon_emissions
--  LIMIT 10;


--Q4
-- SELECT country,
-- 	   COUNT(DISTINCT company) AS number_of_companies
--   FROM carbon_emissions
--  GROUP BY country
--  ORDER BY number_of_companies DESC;


--Q5
--  SELECT country, COUNT(product_name) AS number_of_products
--  FROM carbon_emissions
--  GROUP BY country
--  ORDER BY number_of_products DESC;


-- q6
-- SELECT industry_group,
--        COUNT(id) AS number_of_products,
--        ROUND(SUM(carbon_footprint_pcf), 1) AS total_industry_footprint
--   FROM carbon_emissions
--  WHERE year = (SELECT MAX(year) FROM carbon_emissions)
--  GROUP BY industry_group
--  ORDER BY total_industry_footprint DESC;


--q7
-- SELECT product_name, weight_kg, carbon_footprint_pcf AS emissions_kg_co2
--   FROM carbon_emissions
--   WHERE weight_kg = (SELECT MAX(weight_kg) FROM carbon_emissions)


--q8
-- SELECT product_name
--  FROM carbon_emissions
--  GROUP BY product_name
-- HAVING COUNT(product_name) 
--        >=ALL(SELECT COUNT(product_name) FROM carbon_emissions GROUP BY product_name)
--  ORDER BY product_name ASC;

--Q9
-- SELECT DISTINCT year, 
-- 	   SUM(carbon_footprint_pcf) OVER (ORDER BY year RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as cummulative_carbon_footprint
-- FROM carbon_emissions
-- ORDER BY year;


--Q10
-- WITH max_of_country AS 
-- ( 
-- SELECT industry_group, 
-- 	   ROUND(SUM(carbon_footprint_pcf), 1) AS total_industry_footprint, 
-- 	   country
--   FROM carbon_emissions
--  GROUP BY industry_group, country
-- ) 



-- SELECT industry_group, country 
--   FROM max_of_country 
--  WHERE total_industry_footprint IN (SELECT MAX(total_industry_footprint) FROM max_of_country GROUP BY industry_group )
--  GROUP BY industry_group , country 
--  ORDER BY country;


--Q11
-- WITH emis_by_country AS 
-- ( 
-- SELECT industry_group, 
-- 	   ROUND(SUM(carbon_footprint_pcf), 1) AS total_industry_footprint,
-- 	   country,  
--        RANK() OVER (PARTITION BY country ORDER BY ROUND(SUM(carbon_footprint_pcf), 1) DESC) as country_rank
--   FROM carbon_emissions
--  GROUP BY industry_group, country
-- ) 

-- SELECT industry_group,
--        total_industry_footprint,
-- 	   country,
-- 	   country_rank 
--   FROM emis_by_country  
--  WHERE country IN ('USA', 'China', 'India') AND country_rank<=3 
--  ORDER BY country, country_rank;

--Q12
SELECT country, 
       SUM(data15.carbon_footprint_pcf) AS footprint_2015, 
	   SUM(data16.footprint_2016) AS footprint_2016
 FROM carbon_emissions data15 JOIN (SELECT country,
							               SUM(carbon_footprint_pcf) AS footprint_2016 
							          FROM carbon_emissions 
							         WHERE year = 2016 AND country = 'USA' 
							         GROUP BY country) AS data16
 	   USING(country)
 WHERE year = 2016
 GROUP BY country;
