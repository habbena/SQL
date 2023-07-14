-- Project 2.4

-- TASK 1

SELECT name
FROM arena
UNION 
SELECT name
FROM team
ORDER BY name DESC;

-- TASK 2

SELECT name, 'стадион' AS object_name
FROM arena
UNION ALL
SELECT name, 'команда' AS object_name
FROM team
ORDER BY object_name DESC, name;

-- TASK 3

SELECT 
  name, 
  salary 
FROM 
  player 
ORDER BY 
  CASE WHEN salary = 475000 THEN 0 ELSE 1 END, 
  salary
 LIMIT 5;

-- TASK 4

SELECT id FROM player
except 
SELECT id FROM team
ORDER BY id
LIMIT 10;

-- TASK 5

(SELECT id FROM arena
EXCEPT 
SELECT id FROM game)
UNION ALL
(SELECT id FROM game
EXCEPT 
SELECT id FROM arena)
ORDER BY 1;



