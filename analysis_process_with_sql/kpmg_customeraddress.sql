
-- Data Exploration
--
SELECT customer_id,
	address, 
	postcode,
	state,
	country,
	property_valuation
	FROM kpmgs."CustomerAddress";
	
Select * from kpmgs."CustomerAddress";

-- Data Wrangling
--
UPDATE kpmgs."CustomerAddress" 
	SET address = SUBSTRING (address, 2)
	WHERE address Like ('0%');

/* Deleting unnecessary '0' in the begining of some values in 'address' column */
UPDATE kpmgs."CustomerAddress" 
	SET address = RIGHT(address, LENGTH(address) - 1)  
	WHERE address Like ('0%');

/* Deleting unnecessary white space in 'address' column */
UPDATE kpmgs."CustomerAddress" 
	SET address = ltrim(address);

UPDATE kpmgs."CustomerAddress" 
	SET address = rtrim(address);

/* Unifying the states naming style */
UPDATE kpmgs."CustomerAddress" 
	SET state = 'NSW' 
	WHERE state = 'New South Wales';

UPDATE kpmgs."CustomerAddress" 
	SET state = 'VIC' 
	WHERE state = 'Victoria';

/* Re-Checking */
SELECT DISTINCT state FROM kpmgs."CustomerAddress";
SELECT * FROM kpmgs."CustomerAddress" ORDER BY customer_id LIMIT 100;
SELECT DISTINCT count (customer_id) FROM kpmgs."CustomerAddress";

-- Visualization
--
SELECT count (customer_id) AS customers, state 
	From kpmgs."CustomerAddress"
	GROUP BY state;
