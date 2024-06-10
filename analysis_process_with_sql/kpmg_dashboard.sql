-- Dashboard

SELECT * FROM kpmgs."rfm_totalscore5ntile2" ORDER BY group_name LIMIT 1000;

CREATE TABLE kpmgs."oldcustomer1k_cltvid" As 
SELECT DISTINCT tsn.*,
	mo.gender,
	mo.age_category,
	mo.job_industry_category, 
	mo.wealth_segment, 
	mo.owns_car,
	mo.address,
	mo.postcode,
	mo.state,
	mo.past_3_years_bike_related_purchases
FROM kpmgs."rfm_totalscore5ntile2" AS tsn
INNER JOIN kpmgs."modeling" AS mo
ON tsn.customer_id = mo.customer_id;

DROP TABLE kpmgs."oldcustomer1k_cltvl";
DROP TABLE kpmgs."oldcustomer1k_cltvi";
DROP TABLE kpmgs."oldcustomer1k_cltv";


SELECT * FROM kpmgs."oldcustomer1k_cltvid"
	ORDER BY group_name LIMIT 1000;

SELECT * FROM kpmgs."NewCustomerList";

SELECT * FROM kpmgs."NewCustomerList"
	WHERE age_category = 'Middle adults' 
	 And job_industry_category IN ('Financial Services', 'Manufacturing', 'Health') 
	 And "state" = 'NSW'  And wealth_segment = 'Mass Customer';


SELECT * FROM kpmgs."NewCustomerList"
	WHERE age_category = 'Middle adults' 
	 Or job_industry_category IN ('Financial Services', 'Manufacturing') 
	 Or "state" = 'NSW'  Or wealth_segment = 'Mass Customer';

