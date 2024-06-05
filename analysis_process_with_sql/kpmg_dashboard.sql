-- Dashboard

SELECT * FROM kpmgs."rfm_totalscore5ntile2" ORDER BY group_name LIMIT 1000;

CREATE TABLE kpmgs."dashboard" As 
SELECT tsn.*,
	m.*

FROM kpmgs."rfm_totalscore5ntile2" AS tsn
INNER JOIN 
