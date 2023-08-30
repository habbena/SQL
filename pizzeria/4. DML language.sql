-- SQL_DAY0

/*
TASK 00
write a SQL statement which returns a list of pizza names, pizza prices,
 pizzerias names and dates of visit for Kate and for prices in range from 800 to 1000 rubles.
  Please sort by pizza, price and pizzeria names.
*/

SELECT  m.pizza_name, 
		m.price, 
		p.name AS pizzeria_name, 
		pv.visit_date
FROM 	menu m
JOIN pizzeria p ON m.pizzeria_id = p.id 
JOIN person_visits pv ON pv.pizzeria_id = p.id
WHERE m.price BETWEEN 800 AND 1000
	AND pv.person_id = (SELECT id
						FROM person p 
						WHERE name = 'Kate')
ORDER BY 1, 2, 3		

/*
pizza_name     |price|pizzeria_name|visit_date|
---------------+-----+-------------+----------+
cheese pizza   |  950|DinoPizza    |2022-01-04|
pepperoni pizza|  800|Best Pizza   |2022-01-03|
pepperoni pizza|  800|DinoPizza    |2022-01-04|
sausage pizza  | 1000|DinoPizza    |2022-01-04|
supreme pizza  |  850|Best Pizza   |2022-01-03|
 */


/*
 TASK 01
 find all menu identifiers which are not ordered by anyone. 
 The result should be sorted by identifiers
 */

SELECT m.id AS menu_id
FROM menu m 
LEFT JOIN person_order po ON po.menu_id = m.id
WHERE po.menu_id IS NULL

-- вариант 2
SELECT m.id AS menu_id
FROM menu m 
EXCEPT 
SELECT menu_id
FROM person_order
ORDER BY 1

/*
menu_id|
-------+
      5|
     10|
     11|
     12|
     15|
*/

/*
 TASK 02
 Please use SQL statement from Exercise #01 and show pizza names
  from pizzeria which are not ordered by anyone, 
  including corresponding prices also. 
  The result should be sorted by pizza name and price. 
*/

SELECT m.pizza_name AS pizza_name, 
		m.price,
		p.name AS pizzeria_name
FROM menu m 
JOIN pizzeria p ON m.pizzeria_id = p.id 
WHERE m.id  IN (
	SELECT m.id AS menu_id
	FROM menu m 
	LEFT JOIN person_order po ON po.menu_id = m.id
	WHERE po.menu_id IS NULL)
ORDER BY 1, 2		


/*
pizza_name   |price|pizzeria_name|
-------------+-----+-------------+
cheese pizza |  700|Papa Johns   |
cheese pizza |  780|DoDo Pizza   |
cheese pizza |  950|DinoPizza    |
sausage pizza|  950|Papa Johns   |
supreme pizza|  850|DoDo Pizza   |
 */  
  
/*
 TASK 03 !!!!!!
 find pizzerias that have been visited more often by women or by men. 
 For any SQL operators with sets save duplicates (UNION ALL, EXCEPT ALL, INTERSECT ALL constructions). 
 Please sort a result by the pizzeria name 
*/

  
SELECT pizzeria.name AS pizzeria_name
FROM person_visits
JOIN person ON person_visits.person_id = person.id
JOIN pizzeria ON person_visits.pizzeria_id = pizzeria.id
GROUP BY pizzeria.name
HAVING COUNT(CASE WHEN person.gender = 'female' THEN 1 END) <> 
			COUNT(CASE WHEN person.gender = 'male' THEN 1 END)  
ORDER BY 1;

/*
pizzeria_name|
-------------+
Best Pizza   |
Dominos      |
Papa Johns   |
 */

/*
 TASK 04
 Please find a union of pizzerias that has orders either from women or  from men.
 Other words, you should find a set of pizzerias names which has orders
 by females only and make "UNION" operation with set of pizzerias names which 
 has orders by males only. 
 Please be aware with word “only” for both genders.
  For any SQL operators with sets don’t save duplicates (UNION, EXCEPT, INTERSECT).  
  Please sort a result by the pizzeria name. The data sample is provided below.
 */

SELECT DISTINCT p2.name
FROM person_order po
JOIN menu m ON po.menu_id = m.id
JOIN person p ON po.person_id = p.id
JOIN pizzeria p2 ON p2.id = m.pizzeria_id  
WHERE p.gender = 'female'
EXCEPT  
SELECT DISTINCT p2.name
FROM person_order po
JOIN menu m ON po.menu_id = m.id
JOIN person p ON po.person_id = p.id
JOIN pizzeria p2 ON p2.id = m.pizzeria_id  
WHERE p.gender = 'male' 
 
/*
name      |
----------+
Papa Johns|
*/ 
 
/*
 TASK 05
 Please write a SQL statement which returns a list of pizzerias
  which Andrey visited but did not make any orders. 
  Please order by the pizzeria name 
*/ 

SELECT DISTINCT p.name AS pizzeria_name
FROM person_visits pv 
JOIN pizzeria p ON pv.pizzeria_id = p.id 
JOIN person p2 ON pv.person_id = p2.id 
WHERE p2.name = 'Andrey'
EXCEPT 
SELECT DISTINCT p.name
FROM person_order po
JOIN menu m  ON po.menu_id = m.id
JOIN pizzeria p ON m.pizzeria_id = p.id 
JOIN person p2 ON po.person_id = p2.id 
WHERE p2.name = 'Andrey'

/*
pizzeria_name|
-------------+
Pizza Hut    |
 */

/*
 TASK 06 !!!!!!!!
 Please find the same pizza names who have the same price, 
 but from different pizzerias. Make sure that the result is ordered by pizza name.
 */


SELECT DISTINCT m1.pizza_name, 
		p1.name AS pizzeria_name_1, 
		p2.name AS pizzeria_name_2, 
		m1.price
FROM menu m1
JOIN menu m2 ON m1.pizza_name = m2.pizza_name AND m1.price = m2.price
JOIN pizzeria p1 ON m1.pizzeria_id = p1.id
JOIN pizzeria p2 ON m2.pizzeria_id = p2.id
WHERE m1.pizzeria_id > m2.pizzeria_id
ORDER BY 1
/*
pizza_name     |pizzeria_name_1|pizzeria_name_2|price|
---------------+---------------+---------------+-----+
cheese pizza   |Best Pizza     |Papa Johns     |  700|
pepperoni pizza|DinoPizza      |Best Pizza     |  800|
supreme pizza  |Best Pizza     |DoDo Pizza     |  850|
 */

-- Если неизвестно количество пиццерий 
SELECT
  m1.pizza_name,
  ARRAY_AGG(DISTINCT p.name) AS pizzerias,
  m1.price
FROM
  menu m1
JOIN
  menu m2 ON m1.pizza_name = m2.pizza_name AND m1.price = m2.price AND m1.pizzeria_id <> m2.pizzeria_id
JOIN
  pizzeria p ON m2.pizzeria_id = p.id
GROUP BY
  m1.pizza_name, m1.price
HAVING
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT p.name), 1) > 1;

/*
pizza_name     |pizzerias                  |price|
---------------+---------------------------+-----+
cheese pizza   |{"Best Pizza","Papa Johns"}|  700|
pepperoni pizza|{"Best Pizza",DinoPizza}   |  800|
supreme pizza  |{"Best Pizza","DoDo Pizza"}|  850|
 */

/*
TASK 07
Please register a new pizza with name “greek pizza” (use id = 19)
 with price 800 rubles in “Dominos” restaurant (pizzeria_id = 2).
Don’t use direct numbers for identifiers of Primary Key and pizzeria
*/
 
-- Найдем id пиццерии с названием “Dominos”
SELECT m.pizzeria_id 
FROM pizzeria p 
JOIN menu m ON p.id = m.pizzeria_id 
WHERE p.name = 'Dominos'

-- Вставляем нужные данные
INSERT INTO menu (id, pizzeria_id, pizza_name, price)
SELECT (SELECT max(id)+1  FROM menu),
		(SELECT DISTINCT m.pizzeria_id 
		FROM pizzeria p 
		JOIN menu m ON p.id = m.pizzeria_id 
		WHERE p.name = 'Dominos'),
		'greek pizza',
		800
		
-- проверка	
SELECT count(*) = 1 AS CHECK
FROM menu 
WHERE id = 19 AND pizzeria_id = 2 AND
	pizza_name = 'greek pizza' AND
	price = 800

/*
TASK 08
Please register a new pizza with name “sicilian pizza” 
(whose id should be calculated by formula is “maximum id value + 1”)
 with a price of 900 rubles in “Dominos” restaurant
  (please use internal query to get identifier of pizzeria).
  Don’t use direct numbers for identifiers of Primary Key and pizzeria
*/

INSERT INTO menu (id, pizzeria_id, pizza_name, price)
SELECT (SELECT max(id)+1  FROM menu),
		(SELECT id FROM pizzeria WHERE name = 'Dominos'),
		'sicilian pizza', 
		900
		
-- Проверка 
	SELECT count(*) = 1 AS CHECK
	FROM menu 
	WHERE id = 20 AND pizzeria_id = 2 AND
		pizza_name = 'sicilian pizza' AND
		price = 900

						
/*
TASK 9
Please register new visits into Dominos restaurant
 from Denis and Irina on 24th of February 2022.
 Don’t use direct numbers for identifiers of Primary Key and pizzeria
 */

INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
SELECT (SELECT max(id) + 1 FROM person_visits),
		(SELECT id FROM person p WHERE name = 'Denis'), 
		(SELECT id FROM pizzeria  WHERE name = 'Dominos'),
		'2022-02-24'


INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
SELECT (SELECT max(id) + 1 FROM person_visits),
		(SELECT id FROM person p WHERE name = 'Irina'), 
		(SELECT id FROM pizzeria  WHERE name = 'Dominos'),
		'2022-02-24'

-- Проверка 
	SELECT count(*) = 2 AS CHECK
	FROM person_visits 
	WHERE visit_date = '2022-02-24' AND 
			person_id IN (6, 4) AND 
			pizzeria_id = 2
						
/*
 TASK 10
 Please register new orders from Denis and Irina on 24th of February 2022
  for the new menu with “sicilian pizza”.
 */	
			
INSERT INTO person_order (id, person_id, menu_id, order_date)	
SELECT (SELECT max(id) + 1 FROM person_order),
		(SELECT id FROM person p WHERE name = 'Denis'), 
		(SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'),
		'2022-02-24'

INSERT INTO person_order (id, person_id, menu_id, order_date)	
SELECT (SELECT max(id) + 1 FROM person_order),
		(SELECT id FROM person p WHERE name = 'Irina'), 
		(SELECT id FROM menu WHERE pizza_name = 'sicilian pizza'),
		'2022-02-24'	
		
-- проверка 
	SELECT count(*) = 2 AS CHECK
	FROM person_order 
	WHERE order_date = '2022-02-24' AND 
			person_id IN (6, 4) AND 
			menu_id = (SELECT id FROM menu WHERE pizza_name = 'sicilian pizza')
		
		
/*
TASK 11
Please change the price for “greek pizza” on 
-10% from the current value
*/
			
UPDATE menu 
SET price = price * 0.9
WHERE pizza_name = 'greek pizza'

/*
TASK 12
Please register new orders from all persons for “greek pizza” on 25th of February 2022.
Don’t use direct numbers for identifiers of Primary Key, and menu
Don’t use window functions like ROW_NUMBER()
Don’t use atomic INSERT statements
*/

INSERT INTO person_order (id, person_id, menu_id, order_date)
SELECT gs + (SELECT max(id) FROM person_order) AS order_id,
		p.id AS person_id,
		(SELECT id FROM menu WHERE pizza_name = 'greek pizza') AS menu_id,
		'2022-02-25' AS order_date	
FROM person p
JOIN (SELECT gs FROM generate_series(1, (SELECT count(*) FROM person)) gs) gs
ON p.id = gs



/*
TASK 13
Please write 2 SQL (DML) statements that delete all new orders from exercise #12
 based on order date. Then delete “greek pizza” from the menu.
*/

DELETE FROM person_order 
WHERE order_date = '2022-02-25'

DELETE FROM menu 
WHERE pizza_name = 'greek pizza'







 

