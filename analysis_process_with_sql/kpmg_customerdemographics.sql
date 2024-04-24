-- Exploration
--
SELECT customer_id,
	first_name, 
	last_name, 
	gender, 
	past_3_years_bike_related_purchases, 
	dob, 
	job_title, 
	job_industry_category, 
	wealth_segment, 
	deceased_indicator, 
	owns_car, 
	tenure
	FROM kpmgs."CustomerDemographic";
	
SELECT DISTINCT count(customer_id) 
	FROM kpmgs."CustomerDemographic";

SELECT count(*) As count_all 
	FROM kpmgs."CustomerDemographic";

SELECT DISTINCT count(*) As count_Distincit 
	FROM kpmgs."CustomerDemographic";

SELECT DISTINCT count(tenure) 
	FROM kpmgs."CustomerDemographic";

SELECT DISTINCT job_title 
	FROM kpmgs."CustomerDemographic";

SELECT DISTINCT job_industry_category 
	FROM kpmgs."CustomerDemographic";

SELECT DISTINCT wealth_segment 
	FROM kpmgs."CustomerDemographic";

SELECT DISTINCT owns_car 
	FROM kpmgs."CustomerDemographic";

	
	
-- Data Wrangling
--
DELETE FROM kpmgs."CustomerDemographic"
	WHERE customer_id= 34;
	
SELECT DISTINCT gender 
	FROM kpmgs."CustomerDemographic";
	
UPDATE kpmgs."CustomerDemographic"
	SET gender = 'Male'
	WHERE gender = 'M';
	
UPDATE kpmgs."CustomerDemographic"
	SET gender = 'Female' 
	WHERE gender = 'F';
	
	UPDATE kpmgs."CustomerDemographic"
	SET gender = 'Female' 
	WHERE gender = 'Femal';
	
SELECT DISTINCT gender 
	FROM kpmgs."CustomerDemographic";
	
SELECT DISTINCT deceased_Indicator 
	FROM kpmgs."CustomerDemographic";

DELETE FROM kpmgs."CustomerDemographic"
	WHERE deceased_Indicator = 'Y';
	
UPDATE kpmgs."CustomerDemographic"
	SET job_industry_category = 'Agriculture'
	WHERE job_industry_category = 'Argiculture';
	
UPDATE kpmgs."CustomerDemographic"
	SET job_industry_category = ''
	WHERE job_industry_category = 'n/a';
	
ALTER TABLE kpmgs."CustomerDemographic"
	ADD COLUMN age INTEGER;

UPDATE kpmgs."CustomerDemographic"
	SET age = EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM dob);

DELETE FROM kpmgs."CustomerDemographic"
WHERE age IS NULL;

ALTER TABLE kpmgs."CustomerDemographic"
	ADD COLUMN age_category TEXT;
	
UPDATE kpmgs."CustomerDemographic"
	SET age_category = CASE
	WHEN age < 20 AND age IS NOT NULL THEN 'Teenagers'
	WHEN age >= 20 AND age <= 34 THEN 'Young adults'
	WHEN age >= 35 AND age <= 54 THEN 'Middle adults'
	WHEN age >= 55 AND age <= 64 THEN 'Mature adults'
	WHEN age > 64 AND age IS NOT NULL THEN 'Seniors'
	END;
	
	
-- Visualisation
--
SELECT * FROM kpmgs."CustomerDemographic";

/* Gender segment analysis for customers */

SELECT COUNT (customer_id) AS customer_num, gender
	FROM kpmgs."CustomerDemographic"
	GROUP BY gender
	ORDER BY customer_num;
	
SELECT SUM (past_3_years_bike_related_purchases) AS purchases_num, gender
	FROM kpmgs."CustomerDemographic"
	GROUP BY gender
	ORDER BY purchases_num;


/* Job industry segment analysis for customers */

SELECT COUNT (customer_id) AS customer_num, job_industry_category
	FROM kpmgs."CustomerDemographic"
	WHERE job_industry_category != ''
	GROUP BY job_industry_category 
	ORDER BY customer_num;
	
SELECT SUM (past_3_years_bike_related_purchases) AS purchases_num, job_industry_category
	FROM kpmgs."CustomerDemographic"
	WHERE job_industry_category != ''
	GROUP BY job_industry_category
	ORDER BY purchases_num;


/* Age segment analysis for customers */

SELECT COUNT (customer_id) AS customer_num, age
	FROM kpmgs."CustomerDemographic"
	WHERE age IS NOT NULL
	GROUP BY age
	ORDER BY age;
	
SELECT SUM (past_3_years_bike_related_purchases) AS purchases_num, age
	FROM kpmgs."CustomerDemographic"
	GROUP BY age
	ORDER BY age;
	
/* Wealth segment analysis for customers */

SELECT COUNT (customer_id) AS customer_num, wealth_segment
	FROM kpmgs."CustomerDemographic"
	GROUP BY wealth_segment
	ORDER BY customer_num;
	
SELECT SUM (past_3_years_bike_related_purchases) AS purchases_num, wealth_segment
	FROM kpmgs."CustomerDemographic"
	GROUP BY wealth_segment
	ORDER BY purchases_num;
	
/* Cars owners analysis */

SELECT COUNT (customer_id) AS customer_num, owns_car
	FROM kpmgs."CustomerDemographic"
	GROUP BY owns_car
	ORDER BY customer_num;
	
SELECT SUM (past_3_years_bike_related_purchases) AS purchases_num, owns_car
	FROM kpmgs."CustomerDemographic"
	GROUP BY owns_car
	ORDER BY purchases_num;
	
SELECT * FROM kpmgs."CustomerDemographic";

