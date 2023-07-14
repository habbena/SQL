-- PROJECT 2.3

-- TASK 1

SELECT name, position
FROM player
WHERE (height BETWEEN 188 AND 200)
		AND (salary BETWEEN 100000 AND 150000)
ORDER BY "name" DESC;

-- TASK 2

SELECT 
concat('город:', city, '; команда:', name, '; тренер:', coach_name)
FROM team;

-- TASK 3

SELECT name, size
FROM arena
WHERE id IN (10, 30, 50)
ORDER BY size, name;

-- TASK 4

SELECT name, size
FROM arena
WHERE id NOT IN (10, 30, 50)
ORDER BY size, name;

-- TASK 5

SELECT name, "position"
FROM player
WHERE height BETWEEN 188 AND 220
		AND "position" IN ('центровой', 'защитник')
ORDER BY "position" DESC, name DESC;