
-- Exploration
--
SELECT transaction_id, 
	product_id, 
	customer_id, 
	transaction_date, 
	online_order, 
	order_status, 
	brand, 
	product_line, 
	product_class, 
	product_size, 
	list_price, 
	standard_cost, 
	product_first_sold_date
	FROM kpmgs."Transactions";

SELECT DISTINCT * FROM kpmgs."Transactions";
SELECT COUNT (*) FROM kpmgs."Transactions";
SELECT DISTINCT COUNT (*) FROM kpmgs."Transactions";

SELECT DISTINCT order_status FROM kpmgs."Transactions";

SELECT  COUNT (order_status) FROM kpmgs."Transactions" 
	WHERE order_status = 'Cancelled' ;

SELECT DISTINCT brand FROM kpmgs."Transactions";
SELECT DISTINCT product_line FROM kpmgs."Transactions";
SELECT DISTINCT product_class FROM kpmgs."Transactions";
SELECT DISTINCT product_size FROM kpmgs."Transactions";

SELECT COUNT (online_order) FROM kpmgs."Transactions"
	WHERE online_order = '1';

SELECT COUNT (online_order) FROM kpmgs."Transactions"
	WHERE online_order = '0';
	
SELECT COUNT (online_order) FROM kpmgs."Transactions"
	WHERE online_order IS NULL;
	
-- Data Wrangling
--
UPDATE kpmgs."Transactions"
	SET list_price = list_price::numeric(10, 2);

UPDATE kpmgs."Transactions"
	SET standard_cost = standard_cost::numeric(10, 2);

DELETE FROM kpmgs."Transactions"
	WHERE order_status = 'Cancelled';


ALTER TABLE kpmgs."Transactions"
	ADD COLUMN profit NUMERIC (10,2);

UPDATE kpmgs."Transactions"
	SET profit = list_price - standard_cost;


-- Visualization
--
SELECT * FROM kpmgs."Transactions" ORDER BY transaction_id;

SELECT SUM (profit) AS total_profit, brand
	FROM kpmgs."Transactions"
	GROUP BY brand
	ORDER BY total_profit;

SELECT SUM (profit) AS total_profit, product_line
	FROM kpmgs."Transactions"
	GROUP BY product_line
	ORDER BY total_profit;

SELECT SUM (profit) AS total_profit, product_class
	FROM kpmgs."Transactions"
	GROUP BY product_class
	ORDER BY product_class;

SELECT SUM (profit) AS total_profit, product_size
	FROM kpmgs."Transactions"
	GROUP BY product_size
	ORDER BY product_size;
	
-- Visualization
--

SELECT * FROM kpmgs."Transactions";

