-- TASK 00
--  a select statement which returns all person's names and person's ages from the city ‘Kazan’.

SELECT name, age
FROM person
WHERE address  = 'Kazan';
/*
name  |age|
------+---+
Kate  | 33|
Denis | 13|
Elvira| 45|
 */

/* 
TASK 01
Select statement which returns names , 
ages for all women from the city ‘Kazan’. Yep, and please sort result by name.
*/

SELECT name, age
FROM person
WHERE address  = 'Kazan' AND gender = 'female'
ORDER BY 1;

/*
name  |age|
------+---+
Elvira| 45|
Kate  | 33|
 */



/* 
TASK 02
make 2 syntax different select statements which return 
a list of pizzerias (pizzeria name and rating) with rating 
between 3.5 and 5 points (including limit points) 
and ordered by pizzeria rating.

the 1st select statement must contain comparison signs  (<=, >=)
the 2nd select statement must contain BETWEEN keyword
*/

SELECT name, rating
FROM pizzeria
WHERE rating >= 3.5 AND rating <= 5
ORDER BY rating;
/*
name      |rating|
----------+------+
DinoPizza |   4.2|
Dominos   |   4.3|
Pizza Hut |   4.6|
Papa Johns|   4.9|
 */

SELECT name, rating
FROM pizzeria
WHERE rating BETWEEN 3.5 AND 5
ORDER BY rating;
/*
name      |rating|
----------+------+
DinoPizza |   4.2|
Dominos   |   4.3|
Pizza Hut |   4.6|
Papa Johns|   4.9|
 */

/* 
TASK 03
select statement which
returns the person's identifiers (without duplication) 
who visited pizzerias in a period from 6th of January 2022
 to 9th of January 2022 (including all days) or visited pizzeria 
with identifier 2. Also include ordering clause by person identifier
 in descending mode.

*/

SELECT DISTINCT person_id
FROM person_visits pv 
WHERE (visit_date BETWEEN '2022-01-06' AND '2022-01-09')
	OR pizzeria_id = 2
ORDER BY 1 DESC 
/*
person_id|
--------+
       9|
       8|
       7|
       6|
       5|
       4|
       2|
 */

/* 
TASK 04
make a select statement which returns one calculated field with 
name ‘person_information’ in one string like described in the next sample:
Anna (age:16,gender:'female',address:'Moscow')
Finally, please add the ordering clause by calculated 
column in ascending mode.
Please pay attention to quote symbols in your formula!

*/

SELECT  concat(name, ' (age:',age::varchar,',gender:''',gender ,''',address:''', address , ''')')  AS
	"person_information"
FROM person
ORDER BY 1
/*
person_information                                       |
---------------------------------------------------------+
Andrey (age:21,gender:'male',address:'Moscow')           |
Anna (age:16,gender:'female',address:'Moscow')           |
Denis (age:13,gender:'male',address:'Kazan')             |
Dmitriy (age:18,gender:'male',address:'Samara')          |
Elvira (age:45,gender:'female',address:'Kazan')          |
Irina (age:21,gender:'female',address:'Saint-Petersburg')|
Kate (age:33,gender:'female',address:'Kazan')            |
Nataly (age:30,gender:'female',address:'Novosibirsk')    |
Peter (age:24,gender:'male',address:'Saint-Petersburg')  |
*/

/* 
TASK 05 
Please make a select statement which returns person's names
 (based on internal query in SELECT clause) who made orders 
 for the menu with identifiers 13 , 14 and 18 and date of orders
  should be equal 7th of January 2022. 
  Be aware with "Denied Section" before your work.

*/

SELECT p.name
FROM person_order po 
	JOIN person p 
	ON po.person_id = p.id
WHERE po.menu_id IN (13, 14, 18) AND 
	po.order_date = '2022-01-07'
/*
name  |
------+
Denis |
Nataly|
 */
	
SELECT name
FROM person 
WHERE id in (SELECT person_id
				FROM person_order
				WHERE menu_id IN (13, 14, 18) AND 
					order_date = '2022-01-07');
				

/* 
TASK 06
Please use SQL construction from Exercise 05 
and add a new calculated column (use column's name
 ‘check_name’) with a check statement 
 (a pseudo code for this check is presented below) 
in the SELECT clause.
*/
				
SELECT p.name,
	CASE WHEN p.name = 'Denis' THEN 'true'
	ELSE 'false'
	END AS check_name
FROM person_order po 
	JOIN person p 
	ON po.person_id = p.id
WHERE po.menu_id IN (13, 14, 18) AND 
	po.order_date = '2022-01-07'				

/*
name  |check_name|
------+----------+
Denis |true      |
Nataly|false     |
 */
	
/*
 TASK 07
 Let’s apply data intervals for the person table.
Please make a SQL statement which returns a person's identifiers, 
person's names and interval of person’s ages 
(set a name of a new calculated column as ‘interval_info’) 
based on pseudo code below.
please sort a result by ‘interval_info’ column in ascending mode.
 */	

SELECT id, name,
	CASE WHEN age  >= 10 and age <= 20 THEN 'interval #1'
	WHEN age > 20 and age < 24 THEN 'interval #2'
	ELSE 'interval #3'
	END interval_info
FROM person
ORDER BY 3;
/*
 id|name   |interval_info|
--+-------+-------------+
 1|Anna   |interval #1  |
 4|Denis  |interval #1  |
 9|Dmitriy|interval #1  |
 6|Irina  |interval #2  |
 2|Andrey |interval #2  |
 8|Nataly |interval #3  |
 5|Elvira |interval #3  |
 7|Peter  |interval #3  |
 3|Kate   |interval #3  |
 */
	
/*
 TASK 08
 make a SQL statement which returns all columns from the person_order
  table with rows whose identifier is an even (четный) number. 
 The result have to order by returned identifier.	
*/
SELECT *
FROM person_order po 
WHERE id % 2 = 0
ORDER BY 1;	
/*
id|person_id|menu_id|order_date|
--+---------+-------+----------+
 2|        1|      2|2022-01-01|
 4|        2|      9|2022-01-01|
 6|        4|     16|2022-01-07|
 8|        4|     18|2022-01-07|
10|        4|      7|2022-01-08|
12|        5|      7|2022-01-09|
14|        7|      3|2022-01-03|
16|        7|      4|2022-01-05|
18|        8|     14|2022-01-07|
20|        9|      6|2022-01-10|
*/

/*
 TASK 09
 Please make a select statement that returns person names and pizzeria
  names based on the person_visits table with date of visit in a period
   from 07th of January to 09th of January 2022 (including all days) 
   (based on internal query in FROM clause) .
   add a ordering clause by person name in ascending mode
    and by pizzeria name in descending mode
*/

SELECT p.name AS person_name, 
		piz.name AS pizzeria_name
FROM person_visits pv 
	JOIN person p ON pv.person_id = p.id 
	JOIN pizzeria piz ON pv.pizzeria_id = piz.id 
WHERE pv.visit_date BETWEEN '2022-01-07' AND '2022-01-09'
ORDER BY 1, 2 DESC 
/*
person_name|pizzeria_name|
-----------+-------------+
Denis      |DinoPizza    |
Denis      |Best Pizza   |
Dmitriy    |Papa Johns   |
Dmitriy    |Best Pizza   |
Elvira     |Dominos      |
Elvira     |DinoPizza    |
Irina      |Dominos      |
Nataly     |Papa Johns   |
 */






