-- TEAM 02
-- TASK 02

WITH q AS (
SELECT 
	b.user_id AS user_id,
	b.currency_id,
	b.updated,
	b.money AS money,
	CASE WHEN b.updated > c.updated THEN 
			(SELECT MAX(updated) FROM currency c WHERE c.updated < b.updated AND 
				c.id = b.currency_id) 
		ELSE (SELECT MIN(updated) FROM currency c WHERE c.updated > b.updated  AND
				c.id = b.currency_id) 
	END AS nearest_date
FROM balance b, 
     (SELECT 
     	MAX(c.updated) as updated 
     FROM currency c
     JOIN balance b
     	ON b.currency_id = c.id) c)
SELECT
	COALESCE (u.name, 'not defined') AS name,
	COALESCE (u.lastname,'not defined') AS lastname,
	c.name AS currency_name,
	q.money * c.rate_to_usd AS currency_in_usd	
FROM q
LEFT JOIN currency c ON c.id = q.currency_id AND 
	q.nearest_date = c.updated
FULL JOIN "user" u ON 	q.user_id = u.id
WHERE c.name IS NOT NULL 
ORDER BY 1 DESC, 2, 3



	
     		
     		
     		
     		
     		
     		
     		
     		
     		