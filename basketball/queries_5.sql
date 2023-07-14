-- SQL_11 (PROJECT 3.3)

/* TASK 1
 Найти средний, макс, мин рост всех игроков
 и их суммарную зарплату
*/

SELECT 
	round(avg(height), 1) AS avg_height,
	min(height) AS min_height,
	max(height) AS max_height,
	sum(salary) AS total_salary
FROM player

/* Вывод:
 
avg_height|min_height|max_height|total_salary|
----------+----------+----------+------------+
     198.4|       188|       220|     5007000|*/



/* TASK 2
 Найти средний, макс, мин рост всех игроков
  и их суммарную зарплату в разрезе по их позиции
*/

SELECT 
	"position",
	round(avg(height), 2) AS avg_height,
	min(height) AS min_height,
	max(height) AS max_height,
	sum(salary) AS total_salary
FROM player
GROUP BY "position"
ORDER BY "position"

/* Вывод: 
 
position      |avg_height|min_height|max_height|total_salary|
--------------+----------+----------+----------+------------+
защитник      |    191.13|       188|       196|     1082000|
лёгкий форвард|    206.00|       204|       208|      500000|
разыгрывающий |    193.17|       189|       198|     1511000|
форвард       |    204.25|       201|       208|      626000|
центровой     |    208.60|       201|       220|     1288000|
*/


/* TASK 3
 Выберите города, которые встречаются > 1
*/

SELECT city
FROM team
GROUP BY city
HAVING count(city) > 1

/* Вывод:
 
city  |
------+
Москва|
 
 */

/* TASK 4
 Подсчитайте общее количество очков забитых обеими командами
  и сгруппированными в разрезе команды победителя.
*/

SELECT 
	t.name AS name, 
	SUM(g.owner_score + g.guest_score) AS total_points
FROM game g
JOIN team t ON g.winner_team_id = t.id
GROUP BY t.name, g.winner_team_id
ORDER BY total_points;

/* name       |total_points|
-----------+------------+
Зенит      |         162|
ЦСКА       |         301|
Реал Мадрид|         421|
Барселона  |         620|
*/

/* TASK 5
 Подсчитайте количество игроков, 
 сгруппированных по классу роста игрока
 (КЛЕВОЕ ЗАДАНИЕ)
*/

SELECT 
	CASE
		WHEN height < 190 THEN 1
		WHEN height >= 190 AND height < 200 THEN 2
		ELSE 3
	END AS height_class,
	count(height) AS amount_players
FROM player
GROUP BY 
	CASE 
		WHEN height < 190 THEN 1
		WHEN height >= 190 AND height < 200 THEN 2
		ELSE 3
	END
ORDER BY 1

/* Вывод:
 
height_class|amount_players|
------------+--------------+
           1|             4|
           2|            10|
           3|            11|
*/
	






