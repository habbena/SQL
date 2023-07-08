/*
TASK 00
Please write a SQL statement which returns 
menu’s identifier and pizza names from menu table and 
person’s identifier and person name from person table in one global list
 (with column names as presented on a sample below) 
ordered by object_id and then by object_name columns.
*/

SELECT id AS object_id, pizza_name AS object_name
FROM menu
UNION
SELECT id, name
FROM person
ORDER BY 1, 2
/*
object_id|object_name    |
---------+---------------+
        1|Anna           |
        1|cheese pizza   |
        2|Andrey         |
        2|pepperoni pizza|
        3|Kate           |
        3|sausage pizza  |
        4|Denis          |
        4|supreme pizza  |
        5|Elvira         |
        5|cheese pizza   |
        6|Irina          |
        6|pepperoni pizza|
        7|Peter          |
        7|sausage pizza  |
        8|Nataly         |
        8|cheese pizza   |
        9|Dmitriy        |
        9|mushroom pizza |
       10|cheese pizza   |
       11|supreme pizza  |
       12|cheese pizza   |
       13|mushroom pizza |
       14|pepperoni pizza|
       15|sausage pizza  |
       16|cheese pizza   |
       17|pepperoni pizza|
       18|supreme pizza  |
*/


/*
TASK 01
Please modify a SQL statement from “exercise 00” by removing the object_id
 column. Then change ordering by object_name for part of data 
 from the person table and then from menu table. Please save duplicates!
*/

(SELECT name AS object_name
FROM person
ORDER BY 1)
UNION ALL
(SELECT pizza_name
FROM menu
ORDER BY 1)

/*
object_name    |
---------------+
Andrey         |
Anna           |
Denis          |
Dmitriy        |
Elvira         |
Irina          |
Kate           |
Nataly         |
Peter          |
cheese pizza   |
cheese pizza   |
cheese pizza   |
cheese pizza   |
cheese pizza   |
cheese pizza   |
mushroom pizza |
mushroom pizza |
pepperoni pizza|
pepperoni pizza|
pepperoni pizza|
pepperoni pizza|
sausage pizza  |
sausage pizza  |
sausage pizza  |
supreme pizza  |
supreme pizza  |
supreme pizza  |
 */

/* Вариант 2*/
SELECT t1.object_name
FROM (SELECT pizza_name AS object_name, 'menu' AS LABEL
		FROM menu
		UNION ALL
		SELECT name, 'person' AS LABEL
		FROM person 
		ORDER BY LABEL DESC, object_name) AS t1





/*
TASK 02
Please write a SQL statement which returns unique pizza names from the menu table
 and orders by pizza_name column in descending mode. 
 Please pay attention to the Denied section.
 */

SELECT DISTINCT m.pizza_name
FROM person_order po 
	JOIN menu m ON m.id = po.menu_id
ORDER BY 1 DESC 

/*
pizza_name     |
---------------+
supreme pizza  |
sausage pizza  |
pepperoni pizza|
mushroom pizza |
cheese pizza   |
 */
/* ВАРИАНТ 2* ??? как это работает????*/ 
SELECT pizza_name 
FROM menu 
UNION
SELECT pizza_name 
FROM menu
ORDER by pizza_name desc

/*
TASK 03

Please write a SQL statement which returns common rows for attributes
 order_date, person_id from person_order table from one side and
  visit_date, person_id from person_visits table from the other side
   (please see a sample below). In other words, 
   let’s find identifiers of persons, who visited and ordered some pizza 
   on the same day. Actually, please add ordering by action_date in ascending
    mode and then by person_id in descending mode.
 */

SELECT order_date AS action_date, person_id
FROM person_order 
INTERSECT
SELECT visit_date, person_id
FROM person_visits
ORDER BY 1, 2 DESC 

/*
action_date|person_id|
-----------+---------+
 2022-01-01|        6|
 2022-01-01|        2|
 2022-01-01|        1|
 2022-01-03|        7|
 2022-01-04|        3|
 2022-01-05|        7|
 2022-01-06|        8|
 2022-01-07|        8|
 2022-01-07|        4|
 2022-01-08|        4|
 2022-01-09|        9|
 2022-01-09|        5|
 2022-01-10|        9|
 */


/*
TASK 04   	НЕПОНЯТНО ЧТО ХОТЯТ !!!! НЕТ ПРИМЕРА! НАДО ПОДУЧИТЬ 
Please write a SQL statement which returns a difference (minus)
 of person_id column values with saving duplicates between
  person_order table and person_visits table for order_date and
   visit_date are for 7th of January of 2022

*/
SELECT person_id
FROM person_order
WHERE order_date = '2022-01-07'
EXCEPT all
SELECT person_id
FROM person_visits
WHERE visit_date = '2022-01-07'

/*
person_id|
---------+
        4|
        4|
*/

/*
TASK 05
Please write a SQL statement which returns all possible combinations
 between person and pizzeria tables and please 
 set ordering by person identifier and then by pizzeria identifier columns. 
  Please take a look at the result sample below. 
  Please be aware column's names can be different for you.
*/
 
SELECT person.id AS person_id,
		person.name AS person_name, 
		age, gender, address, 
		pizzeria.id AS pizzeria_id, 
		pizzeria.name AS pizzeria_name, rating
FROM person, pizzeria
ORDER BY 1, 6
 
 /*
 person_id|person_name|age|gender|address         |pizzeria_id|pizzeria_name|rating|
---------+-----------+---+------+----------------+-----------+-------------+------+
        1|Anna       | 16|female|Moscow          |          1|Pizza Hut    |   4.6|
        1|Anna       | 16|female|Moscow          |          2|Dominos      |   4.3|
        1|Anna       | 16|female|Moscow          |          3|DoDo Pizza   |   3.2|
  */
 
/*ВАРИАНТ 2*/
 SELECT *
 FROM person p CROSS JOIN pizzeria piz
 ORDER BY p.id, piz.id

/*ВАРИАНТ 3*/
SELECT *
FROM person, pizzeria
ORDER BY person.id, pizzeria.id




 /*
TASK 06
Let's return our mind back to exercise #03 and change our SQL statement
 to return person names instead of person identifiers and change
  ordering by action_date in ascending mode and then
   by person_name in descending mode. 

  */

 
SELECT action_date, p.name AS person_name FROM (
SELECT order_date AS action_date, person_id
FROM person_order 
INTERSECT
SELECT visit_date, person_id
FROM person_visits ) a
JOIN person p ON a.person_id = p.id
ORDER BY 1, 2 desc

/*
action_date|person_name|
-----------+-----------+
 2022-01-01|Irina      |
 2022-01-01|Anna       |
 2022-01-01|Andrey     |
 2022-01-03|Peter      |
 2022-01-04|Kate       |
 2022-01-05|Peter      |
 2022-01-06|Nataly     |
 2022-01-07|Nataly     |
 2022-01-07|Denis      |
 2022-01-08|Denis      |
 2022-01-09|Elvira     |
 2022-01-09|Dmitriy    |
 2022-01-10|Dmitriy    |
 */


/*
TASK  07
Please write a SQL statement which returns
 the date of order from the person_order table and 
 corresponding person name (Andrey (age:21))
  which made an order from the person table. 
  Add a sort by both columns in ascending mode.
 */
 
 SELECT order_date,
 		concat(p.name, ' (age: ', p.age, ')' ) AS person_information
 FROM person_order po
 JOIN person p ON po.person_id = p.id
 ORDER BY 1, 2
 
 /*
order_date|person_information|
----------+------------------+
2022-01-01|Andrey (age: 21)  |
2022-01-01|Andrey (age: 21)  |
2022-01-01|Anna (age: 16)    |
2022-01-01|Anna (age: 16)    |
2022-01-01|Irina (age: 21)   |
2022-01-03|Peter (age: 24)   |
2022-01-04|Kate (age: 33)    |
2022-01-05|Peter (age: 24)   |
2022-01-05|Peter (age: 24)   |
2022-01-06|Nataly (age: 30)  |
2022-01-07|Denis (age: 13)   |
2022-01-07|Denis (age: 13)   |
2022-01-07|Denis (age: 13)   |
2022-01-07|Nataly (age: 30)  |
2022-01-08|Denis (age: 13)   |
2022-01-08|Denis (age: 13)   |
2022-01-09|Dmitriy (age: 18) |
2022-01-09|Elvira (age: 45)  |
2022-01-09|Elvira (age: 45)  |
2022-01-10|Dmitriy (age: 18) |
  */
 
 /*
 TASK  08
 Please rewrite a SQL statement from exercise #07 by using NATURAL JOIN. 
 The result must be the same like for exercise #07.
  */
 
 
SELECT po.order_date, 
		concat(p.name, ' (age: ', p.age, ')' ) AS person_information
FROM person_order po 
NATURAL JOIN 
(SELECT id AS person_id, name, age
FROM person) p
ORDER BY 1, 2
 
/*
order_date|person_information|
----------+------------------+
2022-01-01|Andrey (age: 21)  |
2022-01-01|Andrey (age: 21)  |
2022-01-01|Anna (age: 16)    |
2022-01-01|Anna (age: 16)    |
2022-01-01|Irina (age: 21)   |
2022-01-03|Peter (age: 24)   |
2022-01-04|Kate (age: 33)    |
2022-01-05|Peter (age: 24)   |
2022-01-05|Peter (age: 24)   |
2022-01-06|Nataly (age: 30)  |
2022-01-07|Denis (age: 13)   |
2022-01-07|Denis (age: 13)   |
2022-01-07|Denis (age: 13)   |
2022-01-07|Nataly (age: 30)  |
2022-01-08|Denis (age: 13)   |
2022-01-08|Denis (age: 13)   |
2022-01-09|Dmitriy (age: 18) |
2022-01-09|Elvira (age: 45)  |
2022-01-09|Elvira (age: 45)  |
2022-01-10|Dmitriy (age: 18) |
  */


 /*
 TASK  09 !!!! НЕ ПОЛУЧАЕТСЯ NOT  EXISTS !!!!! ИЗУЧИТЬ!!!
 Please write 2 SQL statements which return
  a list of pizzerias names which have not been visited by persons by using
   IN for 1st one and EXISTS for the 2nd one.
  */

SELECT name
FROM pizzeria
WHERE id NOT IN (
	SELECT pizzeria_id
	FROM person_visits)


/*
name      |
----------+
DoDo Pizza|
 */

SELECT name
FROM pizzeria p
WHERE  NOT  EXISTS 
(SELECT p.id
FROM person_visits pv
WHERE  pv.pizzeria_id = p.id)

/*
name      |
----------+
DoDo Pizza|
*/


/*
 TASK  10
 Please write a SQL statement which returns a list of the person names
  which made an order for pizza in the corresponding pizzeria.
The sample result (with named columns) is provided below and yes ...
 please make ordering by 3 columns (person_name, pizza_name, pizzeria_name)
  in ascending mode.
*/

SELECT p.name AS person_name,
		m.pizza_name AS pizza_name, 
		p2.name AS pizzeria_name
FROM person_order po 
JOIN person p ON po.person_id = p.id
JOIN menu m ON m.id = po.menu_id
JOIN pizzeria p2 ON m.pizzeria_id = p2.id
ORDER BY 1, 2, 3

/*
person_name|pizza_name     |pizzeria_name|
-----------+---------------+-------------+
Andrey     |cheese pizza   |Dominos      |
Andrey     |mushroom pizza |Dominos      |
Anna       |cheese pizza   |Pizza Hut    |
Anna       |pepperoni pizza|Pizza Hut    |
Denis      |cheese pizza   |Best Pizza   |
Denis      |pepperoni pizza|Best Pizza   |
Denis      |pepperoni pizza|DinoPizza    |
Denis      |sausage pizza  |DinoPizza    |
Denis      |supreme pizza  |Best Pizza   |
Dmitriy    |pepperoni pizza|DinoPizza    |
Dmitriy    |supreme pizza  |Best Pizza   |
Elvira     |pepperoni pizza|DinoPizza    |
Elvira     |sausage pizza  |DinoPizza    |
Irina      |mushroom pizza |Papa Johns   |
Kate       |cheese pizza   |Best Pizza   |
Nataly     |cheese pizza   |Dominos      |
Nataly     |pepperoni pizza|Papa Johns   |
Peter      |mushroom pizza |Dominos      |
Peter      |sausage pizza  |Pizza Hut    |
Peter      |supreme pizza  |Pizza Hut    |
 */
