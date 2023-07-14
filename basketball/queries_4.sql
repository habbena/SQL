
-- PROJECT 3.2 (SQL_10)

/* TASK 1
 * Напишите SQL запрос, который возвращает имена ВСЕХ 
 * (LEFT / RIGHT JOIN) стадионов и соответствующую дату
 *  игры на стадионе. Если стадион не участвовал в играх - 
 * необходимо вывести значение “игра не проводилась”.*/

SELECT 
	a.name AS arena_name, 
	CASE WHEN g.game_date IS NULL THEN 'игра не проводилась'
	ELSE g.game_date :: TEXT
	END AS game_date
FROM 
	game g
	RIGHT JOIN arena a
		ON a.id = g.arena_id
ORDER BY 1, 2;


/* TASK 2 
 2.1 Записать новую строку, где стадион такоей же как у команды ЦСК
 2.2 Сделать запрос в результате которого выйдут города, 
 где больше одной команды */

INSERT INTO team (id, city, name, coach_name, arena_id)
SELECT 60, 'Москва', 'СКА', 'Петр Иванов', arena_id
FROM team
WHERE id = 30;


SELECT t.name AS team_name, t.city
FROM team t
INNER JOIN (
		SELECT city
		FROM team 
		GROUP BY city
		HAVING count(*) > 1) AS team_names
		ON t.city = team_names.city
ORDER BY 1

/* TASK 3
 Напишите SQL запрос, возвращающий наименования стадионов, 
 которые были использованы как арены для проведения игр */

SELECT DISTINCT(a.name)
FROM arena a
RIGHT JOIN game g
	ON a.id = g.arena_id
ORDER BY 1;

SELECT name
FROM arena
WHERE id IN (
	SELECT arena_id
	FROM game)
ORDER BY 1

/* TASK 4
 Напишите SQL запрос возвращающие стадионы, 
 которые были использованы как арены для 
 проведения игр, используя SQL команду EXISTS. 
 */
 
SELECT name
FROM arena a
WHERE EXISTS (
	SELECT arena_id
	FROM game g
	WHERE g.arena_id = a.id)
ORDER BY 1

/* TASK 5
 Напишите SQL запрос с учетом использования CTE
 выражения (Common Table Expression),
 который вернет список городов, играющих команд
 и название домашней арены, вместимость которой
 строго больше, чем 10000 мест. 
 Вынесите в CTE часть SQL запроса по стадионам с 
 фильтрацией по количеству мест строго больше 10000.
 */

WITH filtered_arenas AS (
	SELECT *
	FROM arena
	WHERE SIZE > 10000)
SELECT t.city AS city_name,
		t.name AS team_name,
		f.name AS arena_name
FROM team t
JOIN filtered_arenas f ON f.id = t.arena_id
ORDER BY 1 desc
		


