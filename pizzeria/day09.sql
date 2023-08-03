-- DAY 09

-- Создание и использование функциональных блоков в базах данных.

/*
TASK 00
Аудит входящих записей
Реализуем функцию аудита для входящих изменений INSERT.
*/

-- ШАГ 1. Создаем таблицу person_audit.

CREATE TABLE person_audit(
	created timestamptz NOT NULL DEFAULT now(),
	type_event char(1) DEFAULT 'I' NOT NULL,
	row_id bigint NOT NULL,
	name varchar(100),
	age integer,
	gender varchar(10),
	address varchar(100),
	CONSTRAINT check_type_event 
			CHECK (type_event IN ('I', 'D', 'U'))
);

--DROP TABLE person_audit

-- ШАГ 2. Создаем функцию триггер.

CREATE OR REPLACE FUNCTION fnc_trg_person_insert_audit() 
				  RETURNS TRIGGER AS $trg_person_insert_audit$
	BEGIN 
		IF (TG_OP = 'INSERT') THEN 
			INSERT INTO person_audit SELECT  now(), 'I', NEW.*;
			RETURN NEW;	
		END IF;
		RETURN NULL;	
	END;
$trg_person_insert_audit$ LANGUAGE plpgsql;


-- ШАГ 3. Создаем триггер

CREATE TRIGGER trg_person_insert_audit
	AFTER INSERT ON person
		FOR EACH ROW EXECUTE PROCEDURE fnc_trg_person_insert_audit();


-- ШАГ 4. Проверка работоспособности триггера
	
-- Вставляем новую строку в таблицу person	
INSERT INTO person(id, name, age, gender, address) 
	VALUES (10,'Damir', 22, 'male', 'Irkutsk');

DELETE FROM   person WHERE id = 10


SELECT * FROM person_audit
/*
-- Проверяем содержимое таблицы person_audit

created                      |type_event|row_id|name |age|gender|address|
-----------------------------+----------+------+-----+---+------+-------+
2023-07-14 13:43:11.902 +0300|I         |    10|Damir| 22|male  |Irkutsk|
 */


/*
TASK 01
Реализуем функцию аудита для входящих обновлений UPDATE.
Сохраняем СТАРЫЕ состояния всех значений атрибутов.
 */

CREATE OR REPLACE FUNCTION 	fnc_trg_person_update_audit() 
				  RETURNS TRIGGER AS $trg_person_update_audit$
	BEGIN 
		IF (TG_OP = 'UPDATE') THEN
			INSERT INTO person_audit SELECT now(), 'U', OLD.*;
			RETURN NEW;
		END IF;
		RETURN NULL;
	END;
$trg_person_update_audit$ LANGUAGE plpgsql;

CREATE TRIGGER trg_person_update_audit
	AFTER UPDATE ON person
		FOR EACH ROW EXECUTE PROCEDURE fnc_trg_person_update_audit();
	
	
UPDATE person SET name = 'Bulat' WHERE id = 10;
UPDATE person SET name = 'Damir' WHERE id = 10;	


	
/*
TASK 02
Реализуем функцию аудита для удаления записей (DELETE).
Сохраняем СТАРЫЕ состояния всех значений атрибутов.
 */


CREATE OR REPLACE FUNCTION fnc_trg_person_delete_audit()
			RETURNS TRIGGER AS $trg_person_delete_audit$
	BEGIN 
		IF (TG_OP = 'DELETE') THEN
			INSERT INTO person_audit SELECT now(), 'D', OLD.*;
		END IF;
		RETURN OLD;
	END;
$trg_person_delete_audit$ LANGUAGE plpgsql;
	
CREATE TRIGGER trg_person_delete_audit
	AFTER DELETE ON person
		FOR EACH ROW EXECUTE PROCEDURE fnc_trg_person_delete_audit();
	
DELETE FROM person WHERE id = 10;	
	

/*
TASK 03
Реализуем функцию аудита для для трех команд одновременно: 
INSERT, UPDATE, DELETE.
 */	
	
-- Опустошим таблицу person_audit
TRUNCATE person_audit;

-- Удалим 3 предыдущих триггера и триггерные функции 
DROP TRIGGER trg_person_insert_audit ON person;
DROP TRIGGER trg_person_update_audit ON person;
DROP TRIGGER trg_person_delete_audit ON person;

DROP FUNCTION fnc_trg_person_insert_audit();
DROP FUNCTION fnc_trg_person_update_audit();
DROP FUNCTION fnc_trg_person_delete_audit();
	
--  Создадим новый триггер

CREATE OR REPLACE FUNCTION fnc_trg_person_audit() RETURNS TRIGGER AS $trg_person_audit$
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			INSERT INTO person_audit SELECT now(), 'I', NEW.*;
		ELSEIF (TG_OP = 'UPDATE') THEN
			INSERT INTO person_audit SELECT now(), 'U', OLD.*;
		ELSEIF (TG_OP = 'DELETE') THEN 
			INSERT INTO person_audit SELECT now(), 'D', OLD.*;
		END IF;
		RETURN NULL;
	END;
$trg_person_audit$ LANGUAGE plpgsql;

CREATE TRIGGER trg_person_audit
	AFTER INSERT OR UPDATE OR DELETE ON person
		FOR EACH ROW EXECUTE FUNCTION fnc_trg_person_audit();
	
INSERT INTO person(id, name, age, gender, address)  
	VALUES (10,'Damir', 22, 'male', 'Irkutsk');
UPDATE person SET name = 'Bulat' WHERE id = 10;
UPDATE person SET name = 'Damir' WHERE id = 10;
DELETE FROM person WHERE id = 10;

/*
created                      |type_event|row_id|name |age|gender|address|
-----------------------------+----------+------+-----+---+------+-------+
2023-07-14 15:39:31.289 +0300|I         |    10|Damir| 22|male  |Irkutsk|
2023-07-14 15:39:33.618 +0300|U         |    10|Damir| 22|male  |Irkutsk|
2023-07-14 15:39:35.271 +0300|U         |    10|Bulat| 22|male  |Irkutsk|
2023-07-14 15:39:37.296 +0300|D         |    10|Damir| 22|male  |Irkutsk|
 */


/*
TASK 04
Создадим 2 функции: 
- отбор клиентов женского пола
- отбор клиентов мужского пола
 */	

-- fnc_persons_female ()

CREATE FUNCTION fnc_persons_female()
RETURNS TABLE (id bigint,
			   name varchar,
			   age int,
			   gender varchar,
			   address varchar) 
AS 
$$
    SELECT * 
    FROM person
   	WHERE gender = 'female';
$$ 
LANGUAGE  SQL;

SELECT * FROM fnc_persons_female();

-- fnc_persons_male()

CREATE FUNCTION fnc_persons_male()
RETURNS TABLE (id bigint,
			   name varchar,
			   age int,
			   gender varchar,
			   address varchar) 
AS 
$$
    SELECT * 
    FROM person
   	WHERE gender = 'male';
$$ 
LANGUAGE  SQL;

SELECT * FROM fnc_persons_male();

DROP FUNCTION fnc_persons_female ()
DROP FUNCTION fnc_persons_male ();

/*
TASK 05
Создадим одну функцию с аргументом gender.
 */	

CREATE FUNCTION fnc_persons(pgender VARCHAR(10) DEFAULT 'female')
RETURNS TABLE (id bigint, name VARCHAR(50), age int, gender VARCHAR(10), address varchar)
AS
$$
    SELECT *
    FROM person
    WHERE gender = pgender
$$
LANGUAGE SQL;

SELECT *
FROM fnc_persons(pgender := 'male');

SELECT *
FROM fnc_persons();

DROP FUNCTION fnc_persons(VARCHAR(10));


/*
TASK 6
создайте функцию pl/pgsql   fnc_person_visits_and_eats_on_date
 на основе оператора SQL, которая находит названия пиццерий, 
 которые человек ( IN параметр pperson со значением по умолчанию "Дмитрий") 
 посещал и в которых он мог купить пиццу меньше, чем заданная сумма в рублях 
 (параметр INpprice с значение по умолчанию — 500) на конкретную дату 
 ( IN параметр pdate со значением по умолчанию — 8 января 2022 г.).
 */

CREATE OR REPLACE FUNCTION fnc_person_visits_and_eats_on_date(
    IN pperson VARCHAR DEFAULT 'Dmitriy',
    IN pprice DECIMAL DEFAULT 500,
    IN pdate DATE DEFAULT '2022-01-08')
RETURNS TABLE (pizzeria_name VARCHAR)
AS
$$
BEGIN
    RETURN QUERY
    SELECT pz.name AS pizzeria_name
    FROM pizzeria pz
    WHERE pz.name IN (
        SELECT DISTINCT pz.name
		FROM person_visits pv
		JOIN person p ON p.id = pv.person_id
		JOIN pizzeria pz ON pz.id = pv.pizzeria_id 
		JOIN menu m ON m.pizzeria_id = pz.id
		WHERE p.name = pperson AND
	  		  pv.visit_date = pdate AND 
	  		  m.price <= pprice
    );
END;
$$
LANGUAGE plpgsql;

select *
from fnc_person_visits_and_eats_on_date(pprice := 800);

select *
from fnc_person_visits_and_eats_on_date(pperson := 'Anna',pprice := 1300,pdate := '2022-01-01');


DROP FUNCTION fnc_person_visits_and_eats_on_date(VARCHAR, DECIMAL, DATE);




SELECT DISTINCT pz.name
FROM person_visits pv
JOIN person p ON p.id = pv.person_id
JOIN pizzeria pz ON pz.id = pv.pizzeria_id 
JOIN menu m ON m.pizzeria_id = pz.id
WHERE p.name = 'Anna' AND
	  pv.visit_date = '2022-01-01' AND 
	  m.price <= 1300
	  
 
SELECT DISTINCT pz.name
FROM person_visits pv
JOIN person p ON p.id = pv.person_id
JOIN pizzeria pz ON pz.id = pv.pizzeria_id 
JOIN menu m ON m.pizzeria_id = pz.id
WHERE p.name = 'Dmitriy' AND
	  pv.visit_date = '2022-01-08' AND 
	  m.price <= 800
 

	  
/*
TASK 7
напишите функцию SQL или pl/pgsql func_minimum(это зависит от вас), 
у которой входной параметр представляет 
собой массив чисел, и функция должна возвращать минимальное значение.
 */
 
CREATE FUNCTION  func_minimum (VARIADIC arr NUMERIC[])
	RETURNS NUMERIC 
AS 
$$
	SELECT min($1[i]) FROM generate_subscripts ($1, 1) g(i);
$$
LANGUAGE SQL;
	  
SELECT func_minimum(VARIADIC arr => ARRAY[10.0, -1.0, 5.0, 4.4]);	  
	  
	  
	  
/*
TASK 8
напишите функцию SQL или pl/pgsql fnc_fibonacci(это зависит от вас), 
которая имеет входной параметр pstop с типом integer 
(по умолчанию 10), а выход функции представляет собой таблицу
 со всеми числами Фибоначчи меньше, чем pstop.
 */	  

-- язык SQL
CREATE OR REPLACE FUNCTION fnc_fibonacci(pstop INTEGER DEFAULT 10)
RETURNS TABLE (fibonacci_number INTEGER)
AS
$$
WITH recursive fib_seq(fib_prev, fib_curr) AS (
  SELECT 0, 1
  UNION ALL
  SELECT fib_curr, fib_prev + fib_curr
  FROM fib_seq
  WHERE fib_curr < pstop
)
SELECT fib_prev AS fibonacci_number
FROM fib_seq;
$$
LANGUAGE SQL;
	  

-- язык plpgsql
CREATE OR REPLACE FUNCTION fnc_fibonacci(pstop INTEGER DEFAULT 10)
RETURNS TABLE (fibonacci_number INTEGER)
AS
$$
DECLARE
    fib_prev INTEGER := 0;
    fib_curr INTEGER := 1;
BEGIN
    IF pstop >= fib_prev THEN
        RETURN QUERY SELECT fib_prev;
    END IF;

    WHILE fib_curr < pstop LOOP
        RETURN QUERY SELECT fib_curr;
        fib_curr := fib_prev + fib_curr;
        fib_prev := fib_curr - fib_prev;
    END LOOP;

    RETURN;
END;
$$
LANGUAGE plpgsql;

	  
select * from fnc_fibonacci(20);
select * from fnc_fibonacci();
	  
DROP FUNCTION fnc_fibonacci(INTEGER);	  
	  
	  
	  
	  
	  
	  
	  
 
 

