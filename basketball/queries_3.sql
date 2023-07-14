-- TASK 1

SELECT 
	t.city AS city_name,
	t.name AS team_name,
	a.name AS arena_name
FROM 
	team t
	FULL JOIN arena a ON
	a.id = t.arena_id
WHERE 
	a.size > 10000;


/* TASK 2
Подставить в таблицу game вместо id названия из справочников */

SELECT 
	t1.name AS owner_team,
	t2.name AS guest_team, 
	t3.name AS winner_team, 
	concat (g.owner_score, ':', g.guest_score) AS score,
	a.name AS arena_name	
FROM 
	game g 
	INNER JOIN team t1 ON g.owner_team_id = t1.id
	INNER JOIN team t2 ON g.guest_team_id = t2.id 
	INNER JOIN team t3 ON g.winner_team_id = t3.id
	INNER JOIN arena a ON g.arena_id = a.id
ORDER BY 1, 2
	

/* TASK 3
Создать таблицу, содержащую всех игроков с позицией на площадке “защитник"*/

CREATE TABLE player_defender AS
	SELECT *
	FROM player
	WHERE position = 'защитник';


/* TASK 4
Скорректировать з/п - написать ее до вычета НДФЛ 13%*/

UPDATE player_defender
SET salary = salary * (1 - 0.13);

/* TASK 5
Удалите игроков из таблицы player_defender, 
чья зарплата меньше 
100 000 и вес равный 85 кг.*/

DELETE FROM player_defender
WHERE salary < 100000 AND weight = 85;


