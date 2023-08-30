-- Traveling Salesman Problem

/*
Traveling Salesman Problem Path Finder in SQL
Задача коммивояжера с возвратом:
Дано 4 города и цены проезда между ними.
Найти все возможные маршруты с учетом возвращения в первый город. 
Первый город задан константной - город 'a'.
Отсортировать по убыванию.
*/

-- Вариант 1
WITH RECURSIVE total_price (tour, first_city_id, last_city_id, total_cost, places_count) AS (
  SELECT
    CAST(name AS text),
    1,
    id,
    0,
    1
  FROM cities c
  WHERE c.name = 'a'
  UNION ALL
  SELECT
    t.tour || ', ' || c.name,
    1,
    c.id,
    t.total_cost + p.price,
    t.places_count + 1
  FROM total_price t
  JOIN price p
    ON t.last_city_id = p.city_from
  JOIN cities c
    ON c.id = p.city_to
  WHERE position(c.name IN t.tour) = 0
)
SELECT total_cost + t1.price AS total_cost, 
		'{' || tour || ', a}' AS tour
FROM total_price t
JOIN (
	SELECT * 
	FROM price
	WHERE city_from = 1) t1 
    ON t.last_city_id = t1.city_to
WHERE places_count = 4 
ORDER BY 1, 2 ;



-- Вариант 2 (не мой) 

WITH RECURSIVE tours AS (
    SELECT 
        point1 AS one_full_tour,
        point1, 
        point2, 
        cost, 
        cost AS summ
    FROM routes
    WHERE point1 = 'a'

    UNION ALL

    SELECT 
        parent.one_full_tour || ',' || child.point1, 
        child.point1, 
        child.point2, 
        child.cost,
        parent.summ + child.cost AS summ

    FROM routes child
    INNER JOIN tours parent 
    ON child.point1 = parent.point2

    WHERE one_full_tour NOT like '%' || child.point1 || '%'


)

SELECT 
    summ AS total_cost, 
    '{' || one_full_tour || ',a}' AS tour
FROM tours

WHERE length(one_full_tour) = 7 
AND point2 = 'a'
AND (summ = (
    SELECT MIN(summ) FROM tours
    WHERE length(one_full_tour) = 7 
    AND point2 = 'a')
OR summ = (
    SELECT MAX(summ) FROM tours
    WHERE length(one_full_tour) = 7 
    AND point2 = 'a'))

ORDER BY summ, tour

	
     		
     		
     		
     		
     		
     		
     		
     		
     		
