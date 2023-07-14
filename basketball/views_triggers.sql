-- SQL_12 (PROJECT 3.4)
/* 
Виртуальные и материализованные представления. 
Триггеры и триггерные функции. 
Программирование в РСУБД
*/

-- TASK 1
-- Создайте виртуальное представление (VIEW) с именем v_arena_more_9000

CREATE VIEW v_arena_more_9000
AS SELECT name
FROM arena
WHERE "size" > 9000
ORDER BY 1

/*
name                              |
----------------------------------+
Визинк-Центр - Паласио де Депортес|
Пис энд Френдшип Стадиум          |
*/


-- TASK 2
/* Создайте виртуальное представление (VIEW) с именем v_arena_team, 
которое возвращает имена стадионов
 и имена команд в одном списке с  отсортированным результатом в убывающем порядке.*/

CREATE VIEW v_arena_team
AS SELECT name
FROM arena
UNION SELECT name
FROM team
ORDER BY name DESC 


SELECT *
FROM v_arena_team
ORDER BY name DESC

/*
name                              |
----------------------------------+
ЦСКА                              |
УСК ЦСКА им. А.Я. Гомельского     |
СКА                               |
СИБУР Арена                       |
Реал Мадрид                       |
Пис энд Френдшип Стадиум          |
Палау Блауграна                   |
Олимпиакос                        |
Зенит                             |
Визинк-Центр - Паласио де Депортес|
Барселона                         |
*/

-- TASK 3
-- Создайте материализованное представление (MATERIALIZED VIEW)


CREATE MATERIALIZED VIEW mv_formula_team
AS SELECT 
concat('город: ' , city, '; команда: ', name, '; тренер: ', coach_name) 
	AS "полная информация"
FROM team
ORDER BY 1

/*
полная информация                                               |
----------------------------------------------------------------+
город: Барселона; команда: Барселона; тренер: Шарунас Ясикявичюс|
город: Мадрид; команда: Реал Мадрид; тренер: Пабло Ласо         |
город: Москва; команда: СКА; тренер: Петр Иванов                |
город: Москва; команда: ЦСКА; тренер: Димитрис Итудис           |
город: Пирей; команда: Олимпиакос; тренер: Георгиос Барцокас    |
город: Санкт-Петербург; команда: Зенит; тренер: Хавьер Паскуаль |
 */

-- TASK 4

CREATE MATERIALIZED VIEW mv_formula_player
AS SELECT 
	round(avg(height), 1)  AS avg_height,
	min(height) AS min_height,
	max(height) AS max_height,
	sum(salary) AS total_salary
FROM player

/*
avg_height|min_height|max_height|total_salary|
----------+----------+----------+------------+
     198.4|       188|       220|     5007000|
*/



-- TASK 5
/* Создать триггер для аудита изменений в таблице player
с использованием команд INSERT / UPDATE / DELETE,
изменения записывать в отдельно созданную таблицу player_audit.*/

CREATE TABLE player_audit (
	modified_date TIMESTAMP NOT NULL,
	modified_type VARCHAR   NOT NULL,
	id            INT  		NOT NULL,
	name          VARCHAR   NOT NULL,
	position      VARCHAR   NOT NULL,
	height        NUMERIC   NOT NULL,
	weight        NUMERIC   NOT NULL,
	salary        NUMERIC   NOT NULL,
	team_id       INT       NOT NULL
);

CREATE OR REPLACE FUNCTION fnc_trg_player_changed() RETURNS TRIGGER AS $trg_player_changed$
	BEGIN 
	IF (TG_OP = 'DELETE') THEN
		INSERT INTO player_audit SELECT now(), 'DELETED', OLD.*;
	ELSEIF (TG_OP = 'UPDATE') THEN
		INSERT INTO player_audit SELECT now(), 'UPDATE', OLD.*;
	ELSEIF (TG_OP = 'INSERT') THEN
		INSERT INTO player_audit SELECT now(), 'INSERT', NEW.*;
	END IF;
	RETURN NULL;
END
$trg_player_changed$ LANGUAGE plpgsql;

CREATE TRIGGER trg_player_changed
AFTER DELETE OR UPDATE OR INSERT ON player
	FOR EACH ROW EXECUTE FUNCTION fnc_trg_player_changed();

-- ПРОВЕРКА РАБОТОСПОСОБНОСТИ ТРИГГЕРА

-- Сделайте добавление нового произвольного игрока
INSERT INTO player VALUES (260, 'Леброн Джеймс', 'форвард', 220, 100, 850000, 50);

-- Обновите любой из атрибутов вновь созданного игрока
UPDATE player SET name = 'Рональдо Мучас' WHERE name  = 'Леброн Джеймс';

-- Удалите вновь созданного пользователя
DELETE FROM "player" WHERE "id" = 260;

/*
modified_date          |modified_type|id |name          |position|height|weight|salary|team_id|
-----------------------+-------------+---+--------------+--------+------+------+------+-------+
2023-06-16 19:44:08.978|INSERT       |260|Леброн Джеймс |форвард |   220|   100|850000|     50|
2023-06-16 19:44:14.212|UPDATE       |260|Леброн Джеймс |форвард |   220|   100|850000|     50|
2023-06-16 19:44:20.370|DELETED      |260|Рональдо Мучас|форвард |   220|   100|850000|     50|
 */

