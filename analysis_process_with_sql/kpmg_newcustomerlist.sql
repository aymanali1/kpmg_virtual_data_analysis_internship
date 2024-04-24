SELECT first_name, 
	last_name, 
	gender, 
	past_3_years_bike_related_purchases, 
	dob, 
	job_title, 
	job_industry_category, 
	wealth_segment, 
	deceased_indicator, 
	owns_car, 
	tenure, 
	address, 
	postcode, 
	state, 
	country, 
	property_valuation, 
	"Rank", 
	"Value"
	FROM kpmgs."NewCustomerList";
	
SELECT COUNT (*) FROM kpmgs."NewCustomerList";
SELECT DISTINCT COUNT (*) FROM kpmgs."NewCustomerList";
SELECT DISTINCT gender FROM kpmgs."NewCustomerList";
SELECT DISTINCT past_3_years_bike_related_purchases FROM kpmgs."NewCustomerList";
SELECT DISTINCT job_title FROM kpmgs."NewCustomerList";
SELECT DISTINCT job_industry_category FROM kpmgs."NewCustomerList";
SELECT DISTINCT wealth_segment FROM kpmgs."NewCustomerList";
SELECT DISTINCT deceased_indicator FROM kpmgs."NewCustomerList";
SELECT DISTINCT owns_car FROM kpmgs."NewCustomerList";
SELECT DISTINCT country FROM kpmgs."NewCustomerList";
SELECT DISTINCT property_valuation FROM kpmgs."NewCustomerList";
SELECT DISTINCT "Rank" FROM kpmgs."NewCustomerList";
SELECT DISTINCT "Value" FROM kpmgs."NewCustomerList";


-- Data Wrangling
--
SELECT * FROM kpmgs."NewCustomerList";

UPDATE kpmgs."NewCustomerList"
	SET "Value" = "Value" :: NUMERIC (10,2);
	
UPDATE kpmgs."NewCustomerList" 
	SET job_industry_category = 'Agriculture'
	WHERE job_industry_category = 'Argiculture';
	
ALTER TABLE kpmgs."NewCustomerList"
ADD COLUMN age INTEGER;

UPDATE kpmgs."NewCustomerList"
	SET age = EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM dob);
	
ALTER TABLE kpmgs."NewCustomerList"
ADD COLUMN age_category TEXT;

UPDATE kpmgs."NewCustomerList"
	SET age_category = CASE
	WHEN age < 20 AND age IS NOT NULL THEN 'Teenagers'
	WHEN age >= 20 AND age <= 34 THEN 'Young adults'
	WHEN age >= 35 AND age <= 54 THEN 'Middle adults'
	WHEN age >= 55 AND age <= 64 THEN 'Mature adults'
	WHEN age > 64 AND age IS NOT NULL THEN 'Seniors'
	END;
	
	
-- Visualization
--

SELECT * FROM kpmgs."NewCustomerList";


	