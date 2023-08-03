-- DAY 07

/*
TASK 00
Выведем идентификаторы людей и общее количество их посещений
в любых пиццериях.
*/

SELECT 
		person_id, 
		count(*) AS count_of_visits
FROM person_visits
GROUP BY person_id
ORDER BY 2 DESC, 1

/*
person_id|count_of_visits|
---------+---------------+
        9|              4|
        4|              3|
        6|              3|
        8|              3|
        2|              2|
        3|              2|
        5|              2|
        7|              2|
        1|              1|
*/

/*
TASK 01 !!!!!
Выведем имена первых 4 клиентов с максимальным количеством посещений
в любых пиццериях.
*/

SELECT  
	p.name AS name, 
	count(*)  AS count_of_visits
FROM person_visits pv
JOIN person p ON p.id = pv.person_id
GROUP BY p.name
ORDER BY 2 DESC, 1
LIMIT 4

/*
name   |count_of_visits|
-------+---------------+
Dmitriy|              4|
Denis  |              3|
Irina  |              3|
Nataly |              3|
 */

/*
TASK 02 !!!!!
Вывести 3 любимых ресторана по посещениям и по заказам в одном списке.
Добавить столбец action_type со значениями «заказ» или «посещение»,
Сортировка:  по столбцу action_type в возрастающем режиме,
			 по столбцу count в нисходящем режиме.
 */

(SELECT
	p.name,
	count(po.id) AS count,
	'order' AS action_type
FROM person_order po 
JOIN menu m ON po.menu_id = m.id 
JOIN pizzeria p ON m.pizzeria_id = p.id
GROUP BY p.name
ORDER BY 2 
DESC LIMIT 3)
UNION 
(SELECT 
	p.name,
	count(*) AS count, 
	'visit' AS action_type
FROM person_visits pv 
JOIN pizzeria p ON pv.pizzeria_id = p.id
GROUP BY p.name
ORDER BY 2 
DESC LIMIT 3)
ORDER BY 3, 2 desc

/*
name      |count|action_type|
----------+-----+-----------+
Dominos   |    6|order      |
Best Pizza|    5|order      |
DinoPizza |    5|order      |
Dominos   |    7|visit      |
DinoPizza |    4|visit      |
Pizza Hut |    4|visit      |
*/

/*
TASK 03 !!! ЭТО ПРОСТО НЕРЕАЛЬНО !!!! РАЗОБРАТЬ 
Напишите оператор SQL, чтобы увидеть, как рестораны группируются по посещениям и заказам 
и соединяются друг с другом по имени ресторана. 
Вы можете использовать внутренние SQL-запросы из упражнения 02
 (рестораны по посещениям и по заказам) без ограничений по количеству строк.
Кроме того, пожалуйста, добавьте следующие правила.
 	- подсчитать сумму заказов и посещений соответствующей пиццерии 
 (учтите, что не все ключи пиццерий представлены в обеих таблицах).
	- сортировать результаты по total_count столбцу по убыванию и по name по возрастанию.
 */

SELECT 
	t1.name,
	coalesce(t1.count, 0) + COALESCE(t2.count, 0) AS total_count
FROM
(SELECT pz.name, count(*) AS count
FROM person_visits pv 
JOIN pizzeria pz ON pz.id = pv.pizzeria_id 
GROUP BY pz.name) AS t1
FULL JOIN 
(SELECT 
	pz.name, 
	count(*) AS count
FROM person_order po
JOIN menu m ON m.id = po.menu_id
JOIN pizzeria pz ON pz.id = m.pizzeria_id 
GROUP BY pz.name) AS t2
ON t1.name = t2.name
ORDER BY 2 DESC, 1 

/*
name      |total_count|
----------+-----------+
Dominos   |         13|
DinoPizza |          9|
Best Pizza|          8|
Pizza Hut |          8|
Papa Johns|          5|
DoDo Pizza|          1|
 */


/*
TASK 04 !!!
Выбрать имя клиента, который посещал пиццерии более 3х раз.
 */

SELECT
	p.name,
	count(*) AS count_of_visits
FROM person_visits pv 
JOIN person p ON p.id = pv.person_id 
GROUP BY p.name
HAVING count(*) > 3

/*
name   |count_of_visits|
-------+---------------+
Dmitriy|              4|
*/


/*
TASK 05
Найти список уникальных имен людей, которые делали заказы в любых пиццериях. 
Сортировка: по имени человека.
 */

SELECT DISTINCT p.name
FROM person_order po
JOIN person p ON p.id = po.person_id 
ORDER BY 1		

/*
name   |
-------+
Andrey |
Anna   |
Denis  |
Dmitriy|
Elvira |
Irina  |
Kate   |
Nataly |
Peter  |
*/


/*
TASK 06
Найти количество заказов, среднюю цену, максимальную и минимальную цены на пиццу, 
проданную соответствующим рестораном-пиццерией. 
Округлите среднюю цену до 2 плавающих чисел.
Сортировка: по названию пиццерии.
 */

SELECT 
	p.name,
	count(po.id) AS count_of_orders,
	round(avg(m.price), 2) AS average_price,
	max(m.price) AS max_price,
	min(m.price) AS min_price
FROM person_order po 
JOIN menu m ON po.menu_id = m.id
JOIN pizzeria p ON m.pizzeria_id = p.id
GROUP BY p.name
ORDER BY 1

/*
name      |count_of_orders|average_price|max_price|min_price|
----------+---------------+-------------+---------+---------+
Best Pizza|              5|       780.00|      850|      700|
DinoPizza |              5|       880.00|     1000|      800|
Dominos   |              6|       933.33|     1100|      800|
Papa Johns|              2|       975.00|     1000|      950|
Pizza Hut |              4|      1125.00|     1200|      900|
 */


/*
TASK 07
Найти общий средний рейтинг (атрибут — global_rating) для всех ресторанов. 
Округлить до 4 плавающих чисел.
 */

SELECT round(avg(rating), 4) AS global_rating
FROM pizzeria
/*
global_rating|
-------------+
       3.9167|
*/

/*
TASK 08
Найти количество заказов по пиццериям и городам.
Сортировка: адрес, название ресторана.
 */

SELECT 
	p.address,
	pz.name, 
	count(*) AS count_of_orders
FROM person_order po
JOIN person p ON p.id = po.person_id
JOIN menu m ON m.id = po.menu_id 
JOIN pizzeria pz ON pz.id = m.pizzeria_id 
GROUP BY p.address, pz.name
ORDER BY 1, 2

/*
address         |name      |count_of_orders|
----------------+----------+---------------+
Kazan           |Best Pizza|              4|
Kazan           |DinoPizza |              4|
Kazan           |Dominos   |              1|
Moscow          |Dominos   |              2|
Moscow          |Pizza Hut |              2|
Novosibirsk     |Dominos   |              1|
Novosibirsk     |Papa Johns|              1|
Saint-Petersburg|Dominos   |              2|
Saint-Petersburg|Papa Johns|              1|
Saint-Petersburg|Pizza Hut |              2|
Samara          |Best Pizza|              1|
Samara          |DinoPizza |              1|
*/



/*
TASK 09
Вывести агрегированную информацию по адресу человека со следующими столбцами:
- address
- formula: max age - min(age) / max(age)
- average: avg(age) по адресу
- comparison: если formula > average -- > True, иначе --> False
Сортировка: адрес.
 */

SELECT 
	address,
	round(max(age) - min(age::numeric) / max(age), 2) AS formula,
	round(avg(age), 2) AS average,
	round(max(age) - min(age::numeric) / max(age), 2) > round(avg(age), 2) AS comparison
FROM person
GROUP BY address
ORDER BY 1

/*
address         |formula|average|comparison|
----------------+-------+-------+----------+
Kazan           |  44.71|  30.33|true      |
Moscow          |  20.24|  18.50|true      |
Novosibirsk     |  29.00|  30.00|false     |
Saint-Petersburg|  23.13|  22.50|true      |
Samara          |  17.00|  18.00|false     |
 */

/*
!!! Примечание: 
1. При делении двух целочисленных чисел остаток от деления отбрасывается.
Если требуется остаток от деления сохранить, то нужно 
привести одно из чисел к числу с дробной частью.
2. Вместо CASE можно использовать просто булево выражение, кот возвращает true/false
 */


















