-- SQL_DAY02

/*
TASK 00
write a SQL statement which returns a list of pizzerias names
 with corresponding rating value which have not been visited by persons.
*/

SELECT piz.name AS pizzeria_name, piz.rating
FROM pizzeria piz
LEFT JOIN person_visits pv ON piz.id = pv.pizzeria_id 
WHERE pv.pizzeria_id  IS null
ORDER BY 1

/*
pizzeria_name|rating|
-------------+------+
DoDo Pizza   |   3.2|
*/


/*
TASK 01
Please write a SQL statement which returns the missing days
 from 1st to 10th of January 2022 (including all days) for visits 
  of persons with identifiers 1 or 2 (it means days missed by both).
   Please order by visiting days in ascending mode. 
*/

SELECT gs::date AS missing_date
FROM (
	SELECT visit_date
	FROM person_visits pv 
	WHERE person_id = 1 OR  person_id = 2) pv
RIGHT JOIN (SELECT gs::date
			FROM generate_series('2022-01-01', '2022-01-10', INTERVAL '1 day')gs) gs
ON pv.visit_date = gs
WHERE pv.visit_date IS NULL
ORDER BY 1

-- вариант 2 (понятнее)

SELECT
    missing_date
FROM (
	SELECT missing_date :: date
    FROM
    	GENERATE_SERIES('2022-01-01', '2022-01-10', interval '1 day') AS missing_date
    ) as mis_date
LEFT JOIN person_visits pv ON mis_date.missing_date = pv.visit_date
    AND (pv.person_id = 1 OR pv.person_id = 2)
WHERE
    visit_date IS NULL
ORDER BY
    missing_date;

-- вариант 3

SELECT DISTINCT person_visits.visit_date AS missing_date
FROM (
	SELECT id, visit_date
	FROM person_visits
	WHERE (person_id = 1 OR person_id = 2) AND DATE(visit_date) BETWEEN '2022-01-01' AND '2022-01-10') AS bebs
RIGHT JOIN person_visits ON person_visits.visit_date = bebs.visit_date
WHERE bebs.visit_date IS null
ORDER BY person_visits.visit_date ASC;   
   
   
/*
missing_date|
------------+
  2022-01-03|
  2022-01-04|
  2022-01-05|
  2022-01-06|
  2022-01-07|
  2022-01-08|
  2022-01-09|
  2022-01-10|
 */

/*
TASK 02
Please write a SQL statement that returns a whole list of person names visited (or not visited) 
pizzerias during the period from 1st to 3rd of January 2022 from one side and the whole list of
 pizzeria names which have been visited (or not visited) from the other side. 
 The data sample with needed column names is presented below. 
 Please pay attention to the substitution value ‘-’ for NULL values in person_name and pizzeria_name columns. 
 Please also add ordering for all 3 columns.
 */

SELECT COALESCE(p.name, '-') AS person_name,
 		q.visit_date,
 		COALESCE(p2.name, '-') AS pizzeria_name
FROM person p 
FULL  JOIN (
		SELECT * FROM person_visits
		WHERE visit_date BETWEEN '2022-01-01' AND '2022-01-03') q
	ON p.id = q.person_id 
FULL JOIN pizzeria p2 
	ON p2.id = q.pizzeria_id
ORDER BY 1, 2, 3

/*
person_name|visit_date|pizzeria_name|
-----------+----------+-------------+
-          |          |DinoPizza    |
-          |          |DoDo Pizza   |
Andrey     |2022-01-01|Dominos      |
Andrey     |2022-01-02|Pizza Hut    |
Anna       |2022-01-01|Pizza Hut    |
Denis      |          |-            |
Dmitriy    |          |-            |
Elvira     |          |-            |
Irina      |2022-01-01|Papa Johns   |
Kate       |2022-01-03|Best Pizza   |
Nataly     |          |-            |
Peter      |2022-01-03|Pizza Hut    |
 */

/*
TASK 03 !!!!!!!!!!!!!!!!!!!!! СЛОЖНО! 
Let’s return back to Exercise #01, please rewrite your SQL by using
 the CTE (Common Table Expression) pattern. 
 Please move into the CTE part of your "day generator". 
 The result should be similar like in Exercise #01
 
 Please write a SQL statement which returns the missing days
 from 1st to 10th of January 2022 (including all days) for visits 
  of persons with identifiers 1 or 2 (it means days missed by both).
   Please order by visiting days in ascending mode. 
*/

WITH gs AS(
SELECT gs::date
FROM generate_series('2022-01-01', '2022-01-10', INTERVAL '1 day') AS gs)
SELECT gs::date AS missing_date
FROM (
SELECT visit_date
FROM person_visits pv
WHERE pv.person_id = '1' OR pv.person_id = '2'  ) pv
RIGHT  JOIN gs ON gs = pv.visit_date
	WHERE pv.visit_date IS NULL
/*
missing_date|
------------+
  2022-01-03|
  2022-01-04|
  2022-01-05|
  2022-01-06|
  2022-01-07|
  2022-01-08|
  2022-01-09|
  2022-01-10|
 */	



/*
TASK 04
Find full information about all possible pizzeria names and prices
 to get mushroom or pepperoni pizzas. 
 Please sort the result by pizza name and pizzeria name then. 
  (please use the same column names in your SQL statement).
  */


SELECT q.pizza_name,
	p.name AS pizzeria_name,
	q.price
FROM (
SELECT * FROM menu m 
WHERE m.pizza_name = 'mushroom pizza' OR m.pizza_name = 'pepperoni pizza' ) q
JOIN pizzeria p ON p.id = q.pizzeria_id
ORDER BY 1, 2


-- вариант 2 
select pizza_name, 
		name as pizzeria_name, 
		price
from menu 
inner join pizzeria p on menu.pizzeria_id = p.id
where pizza_name in ('mushroom pizza', 'pepperoni pizza')
order by 1,2


/*
pizza_name     |pizzeria_name|price|
---------------+-------------+-----+
mushroom pizza |Dominos      | 1100|
mushroom pizza |Papa Johns   |  950|
pepperoni pizza|Best Pizza   |  800|
pepperoni pizza|DinoPizza    |  800|
pepperoni pizza|Papa Johns   | 1000|
pepperoni pizza|Pizza Hut    | 1200|
 */

/*
TASK 05
Find names of all female persons older than 25 and 
order the result by name.
 */

SELECT name 
FROM person 
WHERE gender = 'female' AND  age > 25
ORDER BY 1

/*
name  |
------+
Elvira|
Kate  |
Nataly|
*/

/*
TASK 06
Please find all pizza names
 (and corresponding pizzeria names using menu table)
  that Denis or Anna ordered. 
  Sort a result by both columns.
 */

SELECT m.pizza_name, 
		piz.name AS pizzeria_name
FROM menu m	
JOIN 
	(SELECT menu_id
	FROM person_order po 
		JOIN person p ON p.id = po.person_id 
	WHERE p.name = 'Denis' OR p.name = 'Anna') p
ON p.menu_id = m.id
JOIN pizzeria piz ON m.pizzeria_id = piz.id
ORDER BY 1, 2

/*
pizza_name     |pizzeria_name|
---------------+-------------+
cheese pizza   |Best Pizza   |
cheese pizza   |Pizza Hut    |
pepperoni pizza|Best Pizza   |
pepperoni pizza|DinoPizza    |
pepperoni pizza|Pizza Hut    |
sausage pizza  |DinoPizza    |
supreme pizza  |Best Pizza   |
 */

-- Вариант 2
SELECT m.pizza_name AS pizza_name, p.name AS pizzeria_name
FROM person_order po 
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria p ON m.pizzeria_id = p.id
JOIN person p2 ON po.person_id = p2.id 
WHERE p2.name = 'Denis' OR p2.name = 'Anna'
ORDER BY 1, 2


/*
TASK 07
Please find the name of pizzeria Dmitriy visited on January 8, 2022
 and could eat pizza for less than 800 rubles.
*/

SELECT p.name AS pizzeria_name
FROM menu m 
JOIN pizzeria p ON p.id = m.pizzeria_id
JOIN person_visits pv ON pv.pizzeria_id = m.pizzeria_id
JOIN person p2 ON p2.id = pv.person_id 
WHERE p2.name = 'Dmitriy' AND 
	pv.visit_date = '2022-01-08' AND 
	m.price < 800

	
	
-- вариант 2 
	
SELECT
    pizzeria.name AS pizzeria_name
FROM
    pizzeria
    JOIN person_visits ON person_visits.pizzeria_id = pizzeria.id
    AND person_visits.visit_date = '2022-01-08'
    JOIN person ON person_visits.person_id = person.id
    AND person.name = 'Dmitriy'
    JOIN menu ON menu.pizzeria_id = pizzeria.id
    AND menu.price < 800;

/*
pizzeria_name|
-------------+
Papa Johns   |
*/

	
	
	
	
/*
TASK 08
Please find the names of all males from Moscow or Samara cities
 who orders either pepperoni or mushroom pizzas (or both) . 
 Please order the result by person name in descending mode.
 */	
	
SELECT p.name
FROM person_order po 
JOIN menu m ON po.menu_id = m.id 
JOIN person p ON p.id = po.person_id 
WHERE address IN  ('Moscow', 'Samara') AND
	gender = 'male' AND 
	m.pizza_name IN ('pepperoni pizza', 'mushroom pizza')
ORDER BY 1 DESC 	
/*
name   |
-------+
Dmitriy|
Andrey |
 */	

/*
TASK 09 !!!!!!!!!!!!!!!!!!!!!!! BOTH!!!
Please find the names of all females who ordered both
 pepperoni and cheese pizzas (at any time and in any pizzerias). 
 Make sure that the result is ordered by person name.
 */

SELECT DISTINCT p.name
FROM 
	  (SELECT person_id 
	   FROM person_order
			JOIN menu m ON menu_id = m.id 
		WHERE m.pizza_name  = 'pepperoni pizza') q1
JOIN (SELECT person_id 
	  FROM (
	  	SELECT po.person_id 
		FROM person_order po 
			JOIN menu m ON po.menu_id = m.id 
		WHERE m.pizza_name  = 'cheese pizza') q) q2
ON q1.person_id = q2.person_id
JOIN person p ON q1.person_id= p.id
WHERE p.gender = 'female'


-- вариант 2
SELECT p.name
  FROM person p
         JOIN(SELECT po.person_id
                FROM person_order po
                       JOIN menu m
                       ON po.menu_id = m.id
               WHERE m.pizza_name IN ('pepperoni pizza', 'cheese pizza')
               GROUP BY po.person_id
              HAVING COUNT(DISTINCT m.pizza_name) = 2) AS p2
    -- группируем по id и смотрим чтобы количество заказанных пицц у каждого id было 2
         ON p2.person_id = p.id
 WHERE p.gender = 'female'
 ORDER BY 1

-- вариант 3

SELECT DISTINCT name
FROM person
WHERE id IN (
	SELECT person_id
	FROM person_order
	LEFT JOIN menu ON menu.id = person_order.menu_id
	WHERE menu.pizza_name = 'pepperoni pizza') AND id IN (
	SELECT person_id
	FROM person_order
	LEFT JOIN menu ON menu.id = person_order.menu_id
	WHERE menu.pizza_name = 'cheese pizza') AND gender = 'female'
ORDER BY name ASC

/*
name  |
------+
Anna  |
Nataly|
 */


/*
TASK 10 !!!!!!!!!!!!! self-join
Please find the names of persons who live on the same address. 
Make sure that the result is ordered by 1st person, 2nd person's name
 and common address. 
Please make sure your column names are corresponding column names below.
 */

SELECT p1.name AS person_name1,
		p2.name AS person_name2, 
		p1.address AS common_address
FROM person p1
JOIN person p2 
	ON p1.address = p2.address AND p1.name < p2.name
ORDER BY
    1, 2, 3;
   
-- вариант 2   
WITH human AS (
        SELECT name, id, address
        FROM person)
SELECT
    h1.name AS person_name1,
    h2.name AS person_name2,
    h1.address AS common_address
FROM human AS h1, human AS h2
WHERE
    h1.address = h2.address
    AND h1.id != h2.id
    AND h1.id > h2.id
ORDER BY 1, 2, 3;

-- Вариант 3 !!!
SELECT DISTINCT person.name AS person_name1, bebs.name AS person_name2, person.address AS common_address
FROM person
JOIN (SELECT * FROM person) AS bebs ON bebs.address = person.address
WHERE person.id > bebs.id
ORDER BY 1, 2, 3


/*
name1 |name2 |city            |
------+------+----------------+
Andrey|Anna  |Moscow          |
Denis |Elvira|Kazan           |
Denis |Kate  |Kazan           |
Elvira|Kate  |Kazan           |
Irina |Peter |Saint-Petersburg|
 */
	
	
	
	
	
	




	
