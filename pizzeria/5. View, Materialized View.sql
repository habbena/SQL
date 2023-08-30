-- DAY 04 
-- View, Materialized View: создание, обновление, удаление
-- Вывод всех представлений в схеме, процедура по удалению всех представлений в схеме


/*
TASK 00
создайте 2 представления базы данных (с такими же атрибутами, как исходная таблица)
на основе простой фильтрации по полу людей. 
Установите соответствующие имена для представлений базы данных: 
v_persons_female и v_persons_male.
*/

CREATE VIEW v_persons_female AS
	SELECT *
	FROM person p 
	WHERE gender = 'female';


CREATE VIEW v_persons_male AS
	SELECT *
	FROM person p 
	WHERE gender = 'male';
	
-- Проверка
SELECT * FROM v_persons_female

SELECT * FROM v_persons_male

/*
TASK 01
Пожалуйста, используйте 2 представления базы данных из упражнения №00 
и напишите SQL, чтобы получить имена мужчин и женщин в одном списке. 
Пожалуйста, установите порядок по имени человека.
*/

SELECT name
FROM v_persons_female
UNION 
SELECT name 
FROM v_persons_male
ORDER BY name;

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
TASK 02
Создайте представление базы данных (с именем v_generated_dates), 
которое должно «хранить» сгенерированные даты с 1 по 31 января 2022 года в формате DATE. 
Не забывайте о порядке для столбца generate_date.
*/

CREATE VIEW v_generated_dates AS
	SELECT dates::date AS generated_date
	FROM generate_series(date '2022-01-01', '2022-01-31', '1 day') dates
	ORDER BY 1;

-- Проверка
 SELECT count(*) = 31 AS CHECK,
 min(generated_date) AS chech_1,
 max(generated_date) AS chech_2
 FROM v_generated_dates;


/*
TASK 03
Найдите пропущенные дни для посещений людей в январе 2022 года. 
Используйте v_generated_dates представление для этой задачи
и отсортируйте результат по столбцу missing_date
 */

-- вараинт 1 (EXCEPT)
SELECT generated_date AS missing_date
FROM v_generated_dates
EXCEPT 
SELECT visit_date
FROM person_visits pv 
ORDER BY 1


-- вараинт 2 (right join)
select
b.generate_date as missing_date
from person_visits a
right join v_generated_dates b on a.visit_date = b.generate_date
where a.visit_date is NULL
order by missing_date

/*
missing_date|
------------+
  2022-01-11|
  2022-01-12|
  2022-01-13|
  2022-01-14|
  2022-01-15|
  2022-01-16|
  2022-01-17|
  2022-01-18|
  2022-01-19|
  2022-01-20|
  2022-01-21|
  2022-01-22|
  2022-01-23|
  2022-01-24|
  2022-01-25|
  2022-01-26|
  2022-01-27|
  2022-01-28|
  2022-01-29|
  2022-01-30|
  2022-01-31|
 */


/*
TASK 04
Напишите оператор SQL, удовлетворяющий формуле (R - S)∪(S - R). 
Где R — person_visits таблица с фильтром на 2 января 2022 г., 
S — также person_visits таблица, но с другим фильтром на 6 января 2022 г. 
Пожалуйста, сделайте расчеты с наборами под столбцом, person_id и этот столбец будет 
единственным в результате. 
Отсортируйте результат по person_id столбцу и окончательный SQL-код, пожалуйста, представьте 
в v_symmetric_union view (*) базы данных.

 */
CREATE VIEW v_symmetric_union AS
	(SELECT  person_id
	FROM person_visits
	WHERE visit_date = '2022-01-02'
	EXCEPT 
	SELECT  person_id
	FROM person_visits
	WHERE visit_date = '2022-01-06')
	UNION 
	(SELECT  person_id
	FROM person_visits
	WHERE visit_date = '2022-01-06'
	EXCEPT 
	SELECT  person_id
	FROM person_visits
	WHERE visit_date = '2022-01-02')
	ORDER BY person_id;

-- Проверка
SELECT *
FROM v_symmetric_union

DROP VIEW v_symmetric_union

/*
TASK 05
Создайте представление базы данных v_price_with_discount, 
которое возвращает заказы человека с именами людей, названиями пиццы, 
реальной ценой и расчетным столбцом discount_price (с примененной скидкой 10% и 
удовлетворяет формуле price - price*0.1). 
Результат отсортируйте по имени человека и названию пиццы и 
округлите столбец discount_price до целочисленного типа. 
 */

CREATE VIEW v_price_with_discount AS 
SELECT 
	p.name,
	m.pizza_name,
	m.price,
	round(m.price * 0.9) AS discount_price
FROM person_order po 
JOIN person p ON p.id = po.person_id 
JOIN menu m ON m.id = po.menu_id 
ORDER BY 1, 2;

-- Проверка
SELECT *
FROM v_price_with_discount


/*
TASK 06
Создайте материализованное представление mv_dmitriy_visits_and_eats (с включенными данными) 
на основе оператора SQL, который находит название пиццерии, которую Дмитрий посетил 
8 января 2022 года и мог съесть пиццу менее чем за 800 рублей 
(этот SQL вы можете узнать в День #02, Упражнение #07 ).
*/

CREATE MATERIALIZED VIEW mv_dmitriy_visits_and_eats AS 
SELECT p2.name AS pizzeria_name 	
FROM person_visits pv
JOIN person p ON p.id = pv.person_id
JOIN pizzeria p2 ON p2.id = pv.pizzeria_id 
JOIN menu m ON m.pizzeria_id  = p2.id
WHERE p.name = 'Dmitriy' AND pv.visit_date = '2022-01-08' AND m.price < 800;


-- вариант 2
/*CREATE MATERIALIZED VIEW mv_dmitriy_visits_and_eats AS
WITH pr AS (
		SELECT id as person_id 
		from person 
		WHERE name = 'Dmitriy'),
	pzid AS (
		SELECT pv.pizzeria_id
		FROM person_visits pv
		NATURAL INNER JOIN pr
		WHERE visit_date = '2022-01-08'),
	mn AS (
		SELECT pizzeria_id as id 
		FROM menu 
		NATURAL INNER JOIN pzid 
		WHERE price < 800)
SELECT name AS pizzeria_name 
FROM pizzeria 
NATURAL INNER JOIN mn;
*/

SELECT p2.name AS pizzeria_name 	
FROM person_visits pv
JOIN person p ON p.id = pv.person_id
JOIN pizzeria p2 ON p2.id = pv.pizzeria_id 
JOIN menu m ON m.pizzeria_id  = p2.id
WHERE p.name = 'Dmitriy' AND pv.visit_date = '2022-01-08' AND m.price < 800;

/*
pizzeria_name|
-------------+
Papa Johns   |
 */

-- Проверка

SELECT *
FROM mv_dmitriy_visits_and_eats

/*
TASK 07
Давайте обновим данные в нашем материализованном представлении mv_dmitriy_visits_and_eats
из упражнения №06. Перед этим действием сгенерируйте еще одно посещение Дмитрия, 
которое удовлетворяет предложению SQL материализованного представления, 
за исключением пиццерии, которую мы видим в результате упражнения №06. 
После добавления нового посещения обновите состояние данных для mv_dmitriy_visits_and_eats.
*/

--DELETE FROM person_visits
--WHERE id = 22

-- вариант 1
INSERT INTO person_visits (id, person_id, pizzeria_id, visit_date)
VALUES 
((SELECT max(id) + 1 FROM person_visits),
(SELECT id FROM person WHERE name = 'Dmitriy'),
(SELECT p.id 
FROM pizzeria p
JOIN menu m ON p.id = m.pizzeria_id 
WHERE m.price < 800 AND p.name <> (SELECT * FROM mv_dmitriy_visits_and_eats)
LIMIT 1),
'2022-01-08');

-- вариант 2
insert into person_visits
select
	max(id) + 1 as a1,
	(select id from person where name = 'Dmitriy') as a2,
	(select p.id 
	from pizzeria p 
	join menu m on p.id = m.pizzeria_id and
			 m.price < 800 and 
			 p.name != 'Papa Johns'
	 where p.name = 'DoDo Pizza') as a3,
	'2022-01-09' as a4
from person_visits
;

REFRESH MATERIALIZED VIEW mv_dmitriy_visits_and_eats;

-- Проверка
SELECT *
FROM mv_dmitriy_visits_and_eats


/*
TASK 08
Удалить все представления и материализованные представляения 
*/

-- Выведем список всех view и materialized view
SELECT table_name, 'VIEW' AS table_type
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'VIEW'
UNION ALL
SELECT matviewname AS table_name, 'MATERIALIZED VIEW' AS table_type
FROM pg_matviews
WHERE schemaname = 'public';


-- Создадим процедуру по удалению всех представлений
CREATE OR REPLACE FUNCTION  drop_all_views(schema_name text)
RETURNS void AS $$
DECLARE view_record record;
BEGIN
	FOR view_record IN 
		SELECT table_name, 'VIEW' AS table_type
		FROM information_schema.tables
		WHERE table_schema = 'public'
  			AND table_type = 'VIEW'
	LOOP 
		EXECUTE 'DROP VIEW IF EXISTS ' || schema_name || '.' || view_record.table_name;	
	END LOOP;	
END;
$$ LANGUAGE plpgsql


-- Запустим процедуру по удалению представлений
SELECT drop_all_views('public');

-- Удалим материализованное представление
DROP MATERIALIZED VIEW mv_dmitriy_visits_and_eats;



-- Проверка
SELECT count(*) = 0 AS CHECK
FROM pg_class
WHERE relname IN ('v_generated_dates', 'v_persons_female', 'v_persons_male','v_price_with_discount', 'v_symmetric_union', 'mv_dmitriy_visits_and_eats'  )







