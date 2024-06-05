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

/* Teenagers = Under 20
	Young adults = 20 - 34
	Middle adults = 35 - 54
	Mature adults = 55 - 64
	Seniors = 64+
	*/
	
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

DELETE FROM kpmgs."modeling"
	WHERE age IS NULL;
	
	
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

CREATE VIEW kpmgs."vw_rfm_score5ntile2" AS
SELECT customer_id,
	NTILE(5) OVER (ORDER BY recency_min DESC) AS rfm_recency,
	NTILE(5) OVER (ORDER BY orders_count ASC) AS rfm_frequency,
	NTILE(5) OVER (ORDER BY total_profit ASC) AS rfm_monetary
	FROM kpmgs."vw_pre_rfm";
	

/* Comparision and checking on the results*/

SELECT * FROM kpmgs."vw_rfm_score5ntile2";

SELECT * FROM kpmgs."vw_rfm_score5ntile2" where rfm_recency= '1'AND rfm_frequency= '1' AND rfm_monetary='1'
	ORDER BY rfm_recency;
	
SELECT * FROM kpmgs."vw_pre_rfm" WHERE customer_id= '1506' ORDER BY recency_min;

SELECT * FROM kpmgs."vw_rfm_score5ntile2"
	WHERE customer_id <= 20
	ORDER BY rfm_recency DESC;
	
SELECT * FROM kpmgs."vw_pre_rfm"
	WHERE customer_id <= 20
	ORDER BY recency_min;
/* Results are successful */
	
-- RFM Score
--

CREATE TABLE kpmgs."rfm_totalscore5ntile2" AS 
SELECT customer_id,
	rfm_recency*100 + rfm_frequency*10 + rfm_monetary AS rfm_score
	FROM kpmgs."vw_rfm_score5ntile2"
	ORDER BY rfm_score DESC;

ALTER TABLE kpmgs."rfm_totalscore5ntile2"
ADD COLUMN group_name TEXT;

UPDATE kpmgs."rfm_totalscore5ntile2"
SET group_name = CASE 

WHEN rfm_score = 555 OR rfm_score = 554 OR rfm_score = 544 OR rfm_score = 545 OR rfm_score = 454 OR rfm_score = 455 OR rfm_score = 445 THEN '01- Champions'
WHEN rfm_score = 543 OR rfm_score = 444 OR rfm_score = 435 OR rfm_score = 355 OR rfm_score = 354 OR rfm_score = 345 OR rfm_score = 344 OR rfm_score = 335 THEN '02- Loyal'
WHEN rfm_score = 553 OR rfm_score = 551 OR rfm_score = 552 OR rfm_score = 541 OR rfm_score = 542 OR rfm_score = 533 OR rfm_score = 532 OR rfm_score = 531 OR rfm_score = 452 OR rfm_score = 451 OR rfm_score = 442 OR rfm_score = 441 OR rfm_score = 431 OR rfm_score = 453 OR rfm_score = 433 OR rfm_score = 432 OR rfm_score = 423 OR rfm_score = 353 OR rfm_score = 352 OR rfm_score = 351 OR rfm_score = 342 OR rfm_score = 341 OR rfm_score = 333 OR rfm_score = 323 THEN '03- Potential Loyalist'
WHEN rfm_score = 512 OR rfm_score = 511 OR rfm_score = 422 OR rfm_score = 421 OR rfm_score = 412 OR rfm_score = 411 OR rfm_score = 311 THEN '04- New Customers'
WHEN rfm_score = 525 OR rfm_score = 524 OR rfm_score = 523 OR rfm_score = 522 OR rfm_score = 521 OR rfm_score = 515 OR rfm_score = 514 OR rfm_score = 513 OR rfm_score = 425 OR rfm_score =424 OR rfm_score = 413 OR rfm_score =414 OR rfm_score =415 OR rfm_score = 315 OR rfm_score = 314 OR rfm_score = 313 THEN '05- Promising'
WHEN rfm_score = 535 OR rfm_score = 534 OR rfm_score = 443 OR rfm_score = 434 OR rfm_score = 343 OR rfm_score = 334 OR rfm_score = 325 OR rfm_score = 324 THEN '06- Need Attention'
WHEN rfm_score = 331 OR rfm_score = 321 OR rfm_score = 312 OR rfm_score = 221 OR rfm_score = 213 OR rfm_score = 231 OR rfm_score = 241 OR rfm_score = 251 THEN '07- About To Sleep'
WHEN rfm_score = 255 OR rfm_score = 254 OR rfm_score = 245 OR rfm_score = 244 OR rfm_score = 253 OR rfm_score = 252 OR rfm_score = 243 OR rfm_score = 242 OR rfm_score = 235 OR rfm_score = 234 OR rfm_score = 225 OR rfm_score = 224 OR rfm_score = 153 OR rfm_score = 152 OR rfm_score = 145 OR rfm_score = 143 OR rfm_score = 142 OR rfm_score = 135 OR rfm_score = 134 OR rfm_score = 133 OR rfm_score = 125 OR rfm_score = 124 THEN '08- At Risk'
WHEN rfm_score = 155 OR rfm_score = 154 OR rfm_score = 144 OR rfm_score = 214 OR rfm_score =215 OR rfm_score =115 OR rfm_score = 114 OR rfm_score = 113 THEN '09- Cannot Lose Them'
WHEN rfm_score = 332 OR rfm_score = 322 OR rfm_score = 233 OR rfm_score = 232 OR rfm_score = 223 OR rfm_score = 222 OR rfm_score = 132 OR rfm_score = 123 OR rfm_score = 122 OR rfm_score = 212 OR rfm_score = 211 THEN '10- Hibernating'
WHEN rfm_score = 111 OR rfm_score = 112 OR rfm_score = 121 OR rfm_score = 131 OR rfm_score =141 OR rfm_score =151 THEN '11- Lost customers'	
END


-- Visualization
--

SELECT * FROM kpmgs."modeling";

SELECT * FROM kpmgs."rfm_totalscore5ntile2" ORDER BY group_name;
