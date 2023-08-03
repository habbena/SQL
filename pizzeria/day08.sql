-- DAY 08
-- Работа с транзакциями


-- TASK 00
-- Шаги:
-- 1. Открыть 2 окна терминала
-- 2. В окне 1 ввести скрипт:
BEGIN;
UPDATE pizzeria SET rating = 5 WHERE name = 'Pizza Hut';
SELECT * FROM pizzeria;

-- 3. В окне 2 ввести скрипт (проверка на рейтинг пиццерии)
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

-- 4. В окне 1 завершить транзакцию
END;

-- 5. В окне 2 проверить изменение рейтинга
SELECT * FROM pizzeria;


-- TASK 01
-- Шаги:

-- 0. Проверить что нет открытых транзакций
SHOW TRANSACTION ISOLATION LEVEL;
/*
 transaction_isolation 
-----------------------
 read committed
(1 row)
 */

-- 1. В окне 1 ввести скрипт:
BEGIN;

-- 2. В окне 2 ввести скрипт:
BEGIN;

-- 3. В окне 1 ввести скрипт:
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
sql01_datacamp=*# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating 
----+-----------+--------
  1 | Pizza Hut |      5
(1 row)
*/

-- 4. В окне 2 ввести скрипт:
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
sql01_datacamp=*# SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
 id |   name    | rating 
----+-----------+--------
  1 | Pizza Hut |      5
(1 row)
*/
-- 5. В окне 1 ввести скрипт:
UPDATE pizzeria SET rating = 4 WHERE name = 'Pizza Hut';

-- 6. В окне 2 ввести скрипт:
UPDATE pizzeria SET rating = 3.6 WHERE name = 'Pizza Hut';
-- !!!!! ОКНО ЗАВИСЛО, ТРАНЗАКЦИЯ НЕ ПРОВОДИТСЯ

-- 7. В окне 1 ввести скрипт:
COMMIT;
-- Комментарий: автоматически провелась транзакция в окне 2

-- 8. В окне 2 ввести скрипт:
COMMIT;

-- 9. В окне 1 ввести скрипт:
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
id |   name    | rating 
----+-----------+--------
  1 | Pizza Hut |    3.6
(1 row)
 */

-- 8. В окне 2 ввести скрипт:
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
id |   name    | rating 
----+-----------+--------
 1 | Pizza Hut |    3.6
(1 row)
*/
/*
Вывод: во время одновременной работы в БД нескольких пользователей
будет применена та транзакция, которая 
была сделана любым пользователем позже всего. 
Транзакция, которую сделал первый пользователь оказалась анулированной.
*/

/*TASK 02
One of the famous “Lost Update Anomaly” database pattern 
but under REPEATABLE READ isolation level
*/

-- S1
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- SET

-- S2
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;
-- SET

-- S1
BEGIN;

-- S2
BEGIN;

-- S1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
id |   name    | rating 
----+-----------+--------
 1 | Pizza Hut |    3.6
 */

-- S2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
id |   name    | rating 
----+-----------+--------
 1 | Pizza Hut |    3.6
 
 */
-- S1
UPDATE pizzeria SET rating = 4 WHERE name = 'Pizza Hut';
-- UPDATE 1

-- S2
UPDATE pizzeria SET rating = 3.6 WHERE name = 'Pizza Hut';
-- Зависло

-- S1
COMMIT;
-- Во втором окне вышла ошибка: ERROR:  could not serialize access due to concurrent update

-- S2
COMMIT;
-- ROLLBACK


-- S1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
 id |   name    | rating 
----+-----------+--------
  1 | Pizza Hut |      4
 */
-- S2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
 id |   name    | rating 
----+-----------+--------
  1 | Pizza Hut |      4
 */


/*
TASK 03
One of the famous “Non-Repeatable Reads” database pattern but 
under READ COMMITTED isolation level
 */

-- S1
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- S2
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- S1
BEGIN;
-- BEGIN

-- S2
BEGIN;
-- BEGIN

-- S1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

-- S2
UPDATE pizzeria SET rating = 3.6 WHERE name = 'Pizza Hut';
-- UPDATE 1

COMMIT;
-- COMMIT

-- S1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
 id |   name    | rating 
----+-----------+--------
  1 | Pizza Hut |    3.6
 */
COMMIT;
-- COMMIT
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
 id |   name    | rating 
----+-----------+--------
  1 | Pizza Hut |    3.6
 */
-- S2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
 id |   name    | rating 
----+-----------+--------
  1 | Pizza Hut |    3.6
 */

/*
TASK 04
one of the famous “Non-Repeatable Reads” database pattern 
but under SERIALIZABLE isolation level
 */

-- S1
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- S2
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- S1
BEGIN;

-- S2
BEGIN;

-- S1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';

-- S2
UPDATE pizzeria SET rating = 3.0 WHERE name = 'Pizza Hut';
COMMIT;

-- S1
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
id |   name    | rating 
----+-----------+--------
 1 | Pizza Hut |    3.6
 */
COMMIT;
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
id |   name    | rating 
----+-----------+--------
 1 | Pizza Hut |    3.0
 */

-- S2
SELECT * FROM pizzeria WHERE name = 'Pizza Hut';
/*
id |   name    | rating 
----+-----------+--------
  1 | Pizza Hut |    3.0
*/


/*
TASK 05
ne of the famous “Phantom Reads” database pattern but under 
READ COMMITTED isolation level
 */

-- S1
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- S2
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- S1
BEGIN;

-- S2
BEGIN;

-- S1
SELECT SUM(rating) FROM pizzeria;
/*
 sum  
------
 21.9
(1 row)
 */

-- S2
UPDATE pizzeria SET rating = 1 WHERE name = 'Pizza Hut';
/*
 sum  
------
 19.9
(1 row)
*/
COMMIT;

-- S1
SELECT SUM(rating) FROM pizzeria;
COMMIT;
SELECT SUM(rating) FROM pizzeria;
/*
 sum  
------
 19.9
(1 row)
*/

-- S2
SELECT SUM(rating) FROM pizzeria;
/*
 sum  
------
 19.9
(1 row)
 */


/*
TASK 06
one of the famous “Phantom Reads” database pattern but under 
REPEATABLE READ isolation level.
 */

-- S1
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- S2
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;

-- S1
BEGIN;

-- S2
BEGIN;

-- S1
SELECT SUM(rating) FROM pizzeria;
/*
 sum  
------
 19.9
(1 row)
 */

-- S2
UPDATE pizzeria SET rating = 5 WHERE name = 'Pizza Hut';
COMMIT;

-- S1
SELECT SUM(rating) FROM pizzeria;
/*
 sum  
------
 19.9
(1 row)
 */
COMMIT;
SELECT SUM(rating) FROM pizzeria;
/*
 sum  
------
 23.9
(1 row)
 */

-- S2
SELECT SUM(rating) FROM pizzeria;
/*
 sum  
------
 23.9
(1 row)
 */

/*
TASK 07
воспроизведем ситуацию взаимоблокировки в нашей базе данных.

 */

-- S1
BEGIN;

-- S2
BEGIN;

-- S1
UPDATE pizzeria SET rating = 2 WHERE name = 'Pizza Hut';

-- S2
UPDATE pizzeria SET rating = 3 WHERE name = 'Dominos';
-- завис

-- S1
UPDATE pizzeria SET rating = 1 WHERE name = 'Dominos';
/* 
 в окне 2 появился текст: UPDATE 1
 первая транзакция по окну 2 выполнилась
 */

-- S2
UPDATE pizzeria SET rating = 5 WHERE name = 'Pizza Hut';
/*
ERROR:  deadlock detected
DETAIL:  Process 65943 waits for ShareLock on transaction 1570; blocked by process 65644.
Process 65644 waits for ShareLock on transaction 1571; blocked by process 65943.
HINT:  See server log for query details.
CONTEXT:  while updating tuple (0,30) in relation "pizzeria"
 */

-- S1
COMMIT;
-- COMMIT

-- S2
COMMIT;
-- ROLLBACK

