-- Project 4.2

-- Task 2


INSERT INTO "position" VALUES (1, 'chief');
INSERT INTO "position" VALUES (2, 'waiter');
/*
id|name  |
--+------+
 1|chief |
 2|waiter|
*/

INSERT INTO cafes VALUES 
(100, 'Мой ресторан', 'улица Ново-Светлая, дом 27', 4);

/* 	
id |name        |adress                    |rait
---+------------+--------------------------+----
100|Мой ресторан|улица Ново-Светлая, дом 27|    

 */


INSERT INTO employees VALUES (100, 'Иванов Иван', 100000, 1);
INSERT INTO employees VALUES (200, 'Петров Петр', 60000, 2);


/*	
id |name       |salary|position_id|
---+-----------+------+-----------+
100|Иванов Иван|100000|          1|
200|Петров Петр| 60000|          2| 
 */

INSERT INTO menu VALUES (100, 'Мое меню', 100, 100, '2023-06-20');

/* 
id |name    |cheif_id|cafe_id|date_launch|
---+--------+--------+-------+-----------+
100|Мое меню|     100|    100| 2023-06-20|
 */


INSERT INTO ingredients VALUES (100, 'булочка', 100);
INSERT INTO ingredients VALUES (200, 'котлета', 200);
INSERT INTO ingredients VALUES (300, 'лист зелени', 0);
INSERT INTO ingredients VALUES (400, 'вода', 0);
INSERT INTO ingredients VALUES (500, 'лимон', 10);

/*
id |name       |calories|
---+-----------+--------+
100|булочка    |     100|
200|котлета    |     200|
300|лист зелени|       0|
400|вода       |       0|
500|лимон      |      10|
 */


INSERT INTO recipes VALUES (100, 'Секретный бургер', 100, 70, 100);
INSERT INTO recipes VALUES (200, 'Секретный бургер', 200, 100, 100);
INSERT INTO recipes VALUES (300, 'Секретный бургер', 300, 30, 100);
INSERT INTO recipes VALUES (400, 'Лимонад', 400, 450, 200);
INSERT INTO recipes VALUES (500, 'Лимонад', 500, 50, 200);

/*
id |name            |ingredient_id|ingredient_amount|dish_id|
---+----------------+-------------+-----------------+-------+
100|Секретный бургер|          100|               70|    100|
200|Секретный бургер|          200|              100|    100|
300|Секретный бургер|          300|               30|    100|
400|Лимонад         |          400|              450|    200|
500|Лимонад         |          500|               50|    200|
 */


INSERT INTO dishes VALUES (100, 'гипер-бургер', 0, 2, 200, 100, 100);
INSERT INTO dishes VALUES (200, 'лимонад', 5, 10, 500, 200, 100);

/*
 id |name        |raiting|cooking_time|weight|recipe_id|menu_id|
---+------------+-------+------------+------+---------+-------+
100|гипер-бургер|      0|           2|   200|      100|    100|
200|лимонад     |      5|          10|   500|      200|    100|
 */


INSERT INTO orders VALUES (100, 'ИП_заказ_1', 400, 50, 200);

/*
id |order_num |bill_rub|tips|waiter_id|
---+----------+--------+----+---------+
100|ИП_заказ_1|     400|  50|      200|
 */


INSERT INTO order_dishes VALUES (100, 100, 100, 1);
INSERT INTO order_dishes VALUES (200, 100, 200, 1);

/*
id |order_id|dish_id|quantity|
---+--------+-------+--------+
100|     100|    100|       1|
200|     100|    200|       1|
 */










