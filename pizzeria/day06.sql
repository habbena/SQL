-- DAY 06

/*
TASK 00
Давайте расширим нашу модель данных, включив в нее новую бизнес-функцию. Каждый человек хочет видеть персональную скидку и каждый бизнес хочет быть ближе к клиентам.
Пожалуйста, подумайте о персональных скидках для людей с одной стороны и ресторанов-пиццерий с другой. Необходимо создать новую реляционную таблицу (укажите имя person_discounts) со следующими правилами.

установите атрибут id как первичный ключ (пожалуйста, посмотрите на столбец id в существующих таблицах и выберите тот же тип данных)
установить внешние ключи атрибутов person_id и pizzeria_id для соответствующих таблиц (типы данных должны быть такими же, как и для столбцов id в соответствующих родительских таблицах)
пожалуйста, установите явные имена для ограничений внешних ключей по шаблону fk_{table_name}_{column_name}, напримерfk_person_discounts_person_id

добавьте атрибут скидки для хранения значения скидки в процентах. Помните, что значение скидки может быть числом с плавающей запятой (просто используйте numericтип данных). Поэтому, пожалуйста, выберите соответствующий тип данных, чтобы покрыть эту возможность.
*/

DROP TABLE person_discounts

CREATE TABLE person_discounts(
	id bigint PRIMARY KEY,
	person_id bigint NOT NULL,
	pizzeria_id bigint NOT NULL,
	discount NUMERIC,
	CONSTRAINT fk_person_discounts_person_id FOREIGN key (person_id)
		REFERENCES person (id),
	CONSTRAINT fk_person_discounts_pizzeria_id FOREIGN KEY (pizzeria_id)
		REFERENCES pizzeria (id)
);


/*
TASK 01
Собственно, мы создали структуру для хранения наших скидок и готовы идти дальше и наполнять нашу person_discountsтаблицу новыми записями.
Итак, есть таблица person_order, в которой хранится история заказов человека. Пожалуйста, напишите оператор DML ( INSERT INTO ... SELECT ...), который вставляет новые записи в person_discountsтаблицу на основе следующих правил.


взять агрегированное состояние по столбцам person_id и pizzeria_id


рассчитать величину персональной скидки по следующему псевдокоду:
if “amount of orders” = 1 then “discount” = 10.5  else if “amount of orders” = 2 then  “discount” = 22 else  “discount” = 30


чтобы сгенерировать первичный ключ для таблицы person_discounts, используйте приведенную ниже конструкцию SQL (эта конструкция взята из области SQL WINDOW FUNCTION).
... ROW_NUMBER( ) OVER ( ) AS id ...

*/
INSERT INTO person_discounts (id,person_id, pizzeria_id, discount)
SELECT 
	ROW_NUMBER () OVER () AS id,
	po.person_id,
	m.pizzeria_id,
	CASE WHEN count(m.pizzeria_id) = 1 THEN 10.5
		 WHEN count(m.pizzeria_id) = 2 THEN 22
		 ELSE 30
	END AS discount
FROM person_order po
JOIN menu m ON m.id = po.menu_id
GROUP BY po.person_id, m.pizzeria_id



/*
TASK 02
Пожалуйста, напишите оператор SQL, который возвращает заказы с фактической ценой и ценой с примененной скидкой для каждого человека в соответствующем ресторане-пиццерии и сортирует по имени человека и названию пиццы. Пожалуйста, взгляните на образец данных ниже.
 */

SET ENABLE_seqscan to OFF;
EXPLAIN ANALYZE 
SELECT  
		p.name AS name, 
		m.pizza_name AS pizza_name, 
		m.price AS price, 
		round(m.price * (100 - pd.discount) / 100, 2) AS discount_price, 
		pz.name AS pizzeria_name
FROM person_order po 
JOIN person p ON p.id = po.person_id 
JOIN menu m ON m.id = po.menu_id 
JOIN pizzeria pz ON pz.id = m.pizzeria_id
LEFT JOIN person_discounts pd ON po.person_id = pd.person_id AND m.pizzeria_id = pd.pizzeria_id
ORDER BY 1, 5

/*
name   |pizza_name     |price|discount_price|pizzeria_name|
-------+---------------+-----+--------------+-------------+
Andrey |cheese pizza   |  800|        624.00|Dominos      |
Andrey |mushroom pizza | 1100|        858.00|Dominos      |
Anna   |pepperoni pizza| 1200|        936.00|Pizza Hut    |
Anna   |cheese pizza   |  900|        702.00|Pizza Hut    |
Denis  |supreme pizza  |  850|        595.00|Best Pizza   |
Denis  |pepperoni pizza|  800|        560.00|Best Pizza   |
Denis  |cheese pizza   |  700|        490.00|Best Pizza   |
Denis  |pepperoni pizza|  800|        624.00|DinoPizza    |
Denis  |sausage pizza  | 1000|        780.00|DinoPizza    |
Denis  |sicilian pizza |  900|        805.50|Dominos      |
Dmitriy|supreme pizza  |  850|        760.75|Best Pizza   |
Dmitriy|pepperoni pizza|  800|        716.00|DinoPizza    |
Elvira |sausage pizza  | 1000|        780.00|DinoPizza    |
Elvira |pepperoni pizza|  800|        624.00|DinoPizza    |
Irina  |sicilian pizza |  900|        805.50|Dominos      |
Irina  |mushroom pizza |  950|        850.25|Papa Johns   |
Kate   |cheese pizza   |  700|        626.50|Best Pizza   |
Nataly |cheese pizza   |  800|        716.00|Dominos      |
Nataly |pepperoni pizza| 1000|        895.00|Papa Johns   |
Peter  |mushroom pizza | 1100|        984.50|Dominos      |
Peter  |sausage pizza  | 1200|        936.00|Pizza Hut    |
Peter  |supreme pizza  | 1200|        936.00|Pizza Hut    |
 */


/*
Planning Time: 0.806 ms   
Execution Time: 1.297 ms  
 */

/*
TASK 03
На самом деле нам нужно улучшить согласованность данных с одной стороны 
и настроить производительность с другой. 
Создайте многостолбцовый уникальный индекс (с именем idx_person_discounts_unique), 
который предотвращает дублирование парных значений идентификаторов человека и пиццерии.
*/

CREATE UNIQUE INDEX idx_person_discounts_unique ON person_discounts(person_id, pizzeria_id )

EXPLAIN ANALYZE 
SELECT *
FROM person_discounts
WHERE person_id = 1

/*
QUERY PLAN                                                                                                                                   |
---------------------------------------------------------------------------------------------------------------------------------------------+
Index Scan using idx_person_discounts_unique on person_discounts  (cost=0.14..8.15 rows=1 width=56) (actual time=0.021..0.022 rows=1 loops=1)|
  Index Cond: (person_id = 1)                                                                                                                |
Planning Time: 0.651 ms                                                                                                                      |
Execution Time: 0.044 ms                                                                                                                     |
 */


/*
TASK 04
Добавьте следующие правила ограничения для существующих столбцов таблицы person_discounts.

Столбец person_id не должен быть NULL (используйте имя ограничения ch_nn_person_id)
Столбец pizzeria_id не должен быть NULL (используйте имя ограничения ch_nn_pizzeria_id)
столбец скидки не должен быть NULL (используйте имя ограничения ch_nn_discount)
столбец скидки должен быть 0 процентов по умолчанию
столбец скидки должен находиться в диапазоне значений от 0 до 100 (используйте имя ограничения ch_range_discount)
 */


ALTER TABLE person_discounts
			ADD CONSTRAINT ch_nn_person_id CHECK  (person_id IS  NOT NULL),
			ADD CONSTRAINT ch_nn_pizzeria_id CHECK (pizzeria_id  IS NOT NULL),
			ADD CONSTRAINT ch_nn_discount CHECK (discount  IS NOT NULL),
			ADD CONSTRAINT ch_range_discount CHECK (discount BETWEEN 0 AND 100)
						
ALTER TABLE person_discounts
	ALTER COLUMN discount SET  DEFAULT 0

-- Если что-то пошло не так
ALTER TABLE person_discounts
DROP CONSTRAINT IF EXISTS ch_nn_pizzeria_id,
DROP CONSTRAINT IF EXISTS ch_nn_discount,
DROP CONSTRAINT IF EXISTS ch_range_discount

-- Проверка 1
SELECT count(*) = 4 AS CHECK
FROM pg_constraint 
WHERE pg_constraint.conname IN ('ch_nn_person_id',
								'ch_nn_pizzeria_id',
								'ch_nn_discount',
								'ch_range_discount')
	
--	Проверка 2							
SELECT columns.column_default::integer = 0 AS CHECK
FROM information_schema.COLUMNS
WHERE column_name = 'discount' AND table_name = 'person_discounts'


/*
TASK 05
Чтобы соответствовать политикам управления данными, 
необходимо добавить комментарии к таблице и столбцам таблицы. 
Применим эту политику к person_discounts таблице. 
Пожалуйста, добавьте комментарии на английском или русском языке 
(на ваше усмотрение), объясняющие, какова бизнес-цель таблицы 
и всех включенных в нее атрибутов.
 */

COMMENT ON TABLE person_discounts IS 'Размер скидок для клиентов';
COMMENT ON COLUMN person_discounts.id IS 'Уникальный ключ';
COMMENT ON COLUMN person_discounts.person_id IS 'Уникальный номер клиента';
COMMENT ON COLUMN person_discounts.pizzeria_id IS 'Уникальный номер пиццерии';
COMMENT ON COLUMN person_discounts.discount IS 'Размер скидки в %';

-- Проверка 
SELECT count(*) = 5 AS CHECK
FROM pg_description
WHERE objoid = 'person_discounts'::regclass


/*
 TASK 06
 Давайте создадим последовательность базы данных (Database Sequence) с именем seq_person_discounts (начиная с 1 значения)
 и установим значение по умолчанию для атрибута id таблицы
 person_discounts так, чтобы оно автоматически принимало значение  из seq_person_discounts.
 Имейте в виду, что ваш следующий порядковый номер равен 1, в этом случае установите фактическое значение 
 для последовательности базы данных на основе формулы «количество строк в таблице person_discounts» + 1. 
 В противном случае вы получите ошибки об ограничении нарушения первичного ключа.
 */

CREATE SEQUENCE seq_person_discounts START 1;

ALTER TABLE person_discounts
	ALTER COLUMN id SET DEFAULT nextval('seq_person_discounts');

--Устанавливаем текущее значение последовательности
-- Вариант 1
SELECT SETVAL('seq_person_discounts', 
		(SELECT MAX(id) FROM person_discounts));
	
-- Вариант 2
SELECT SETVAL('seq_person_discounts', 
		(SELECT count(*) + 1 FROM person_discounts));
	
-- Проверка
INSERT INTO person_discounts (person_id, pizzeria_id, discount)
VALUES (2, 6, 22);

SELECT *
FROM person_discounts pd 

--DELETE FROM person_discounts
--WHERE id =  18








