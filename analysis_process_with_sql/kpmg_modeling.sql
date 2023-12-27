-- Exploring && preparation
--
/* Joining the historical data tables and exploring data to decide which form of data will be used */

CREATE TABLE kpmgs."modeling" AS
SELECT tra.* ,
	cd.first_name, 
	cd.last_name, 
	cd.gender, 
	cd.past_3_years_bike_related_purchases, 
	cd.dob, 
	cd.job_title, 
	cd.job_industry_category, 
	cd.wealth_segment, 
	cd.deceased_indicator, 
	cd.owns_car, 
	cd.tenure,
	ca.address, 
	ca.postcode,
	ca.state,
	ca.country,
	ca.property_valuation
	FROM kpmgs."Transactions" AS tra
	INNER JOIN kpmgs."CustomerDemographic" AS cd
	ON tra.customer_id = cd.customer_id
	INNER JOIN kpmgs."CustomerAddress" AS ca
	ON tra.customer_id = ca.customer_id;
	
	
ALTER TABLE kpmgs."modeling"
	ADD COLUMN age INTEGER;
UPDATE kpmgs."modeling"
	SET age = EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM dob);
	
SELECT DISTINCT age FROM kpmgs."modeling";
SELECT DISTINCT dob FROM kpmgs."modeling";
SELECT * FROM kpmgs."modeling" WHERE dob IS NULL;


ALTER TABLE kpmgs."modeling"
	ADD COLUMN age_category TEXT;

UPDATE kpmgs."modeling"
	SET age_category = CASE
	WHEN age < 20 AND age IS NOT NULL THEN 'Teenagers'
	WHEN age >= 20 AND age <= 34 THEN 'Young adults'
	WHEN age >= 35 AND age <= 54 THEN 'Middle adults'
	WHEN age >= 55 AND age <= 64 THEN 'Mature adults'
	WHEN age > 64 AND age IS NOT NULL THEN 'Seniors'
	END;

	
SELECT * FROM kpmgs."modeling";

SELECT COUNT(*) FROM kpmgs."modeling";

CREATE VIEW kpmgs."VW_model" AS
SELECT tra.* ,
	cd.first_name, 
	cd.last_name, 
	cd.gender, 
	cd.past_3_years_bike_related_purchases, 
	cd.dob, 
	cd.job_title, 
	cd.job_industry_category, 
	cd.wealth_segment, 
	cd.deceased_indicator, 
	cd.owns_car, 
	cd.tenure,
	ca.address, 
	ca.postcode,
	ca.state,
	ca.country,
	ca.property_valuation
	FROM kpmgs."Transactions" AS tra
	LEFT JOIN kpmgs."CustomerDemographic" AS cd
	ON tra.customer_id = cd.customer_id
	LEFT JOIN kpmgs."CustomerAddress" AS ca
	ON tra.customer_id = ca.customer_id;
	
SELECT * FROM kpmgs."VW_model";
	
SELECT COUNT (*) FROM kpmgs."VW_model";

SELECT COUNT (*) - (SELECT COUNT (*) FROM kpmgs."modeling")
	FROM kpmgs."VW_model";

SELECT COUNT (order_status) 
	FROM kpmgs."modeling"
	WHERE order_status LIKE 'Cancelled';

SELECT COUNT (order_status) 
	FROM kpmgs."modeling"
	WHERE order_status LIKE 'Approved';
	
SELECT transaction_date
	FROM kpmgs."modeling"
	ORDER BY transaction_date;
	
SELECT transaction_date
	FROM kpmgs."modeling"
	ORDER BY transaction_date DESC;
	
SELECT COUNT (online_order) FROM kpmgs."modeling"
	WHERE online_order = '1';

SELECT COUNT (online_order) FROM kpmgs."modeling"
	WHERE online_order = '0';
	
SELECT COUNT (online_order) FROM kpmgs."modeling"
	WHERE online_order IS NULL;
	

-- Modeling
--
/* The inner join table was selected for modeling as the result would has a significant sample and clean data*/

SELECT * FROM kpmgs."modeling"
	ORDER BY transaction_id;
	
ALTER TABLE kpmgs."modeling"
	ADD COLUMN recency INTEGER;
	
UPDATE kpmgs."modeling"
	SET recency = ('2017-12-30' - transaction_date);

/* Checking the result of adding the recency column */
SELECT transaction_date, recency FROM kpmgs."modeling"
	ORDER BY transaction_date;


-- RFM Analysis
--

/* preparing for doing the RFM Analysis*/
CREATE VIEW kpmgs."vw_pre_rfm" AS
SELECT customer_id,
	MIN (recency) AS recency_min,
	COUNT (transaction_id) AS orders_count,
	ROUND (SUM (profit), 2) AS total_profit
	FROM kpmgs."modeling"
	GROUP BY customer_id
	ORDER BY recency_min;
	
	
SELECT * FROM kpmgs."vw_pre_rfm" ORDER BY recency_min;

/* Calculating the RFM scores*/
CREATE VIEW	kpmgs."vw_rfm_score" AS
SELECT customer_id,
	NTILE(4) OVER (ORDER BY recency_min DESC) AS rfm_recency,
	NTILE(4) OVER (ORDER BY orders_count) AS rfm_frequency,
	NTILE(4) OVER (ORDER BY total_profit) AS rfm_monetary
	FROM kpmgs."vw_pre_rfm";
	
SELECT DISTINCT * FROM kpmgs."vw_rfm_score"
	ORDER BY rfm_recency;

/* Comparision and checking on the results*/
SELECT * FROM kpmgs."vw_rfm_score"
	WHERE customer_id <= 20
	ORDER BY rfm_recency DESC;
	
SELECT * FROM kpmgs."vw_pre_rfm"
	WHERE customer_id <= 20
	ORDER BY recency_min;
/* Results are successful */
	
-- RFM Score
--
SELECT customer_id,
	rfm_recency*100 + rfm_frequency*10 + rfm_monetary AS rfm_score
	FROM kpmgs."vw_rfm_score"
	ORDER BY rfm_score DESC;
	

-- Visualization
--
SELECT * FROM kpmgs."modeling" WHERE age IS NOT NULL;


