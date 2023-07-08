-- del_insert_book()
-- del_insert_supply()

SELECT  del_insert_book();
SELECT del_insert_supply();

/*
Для книг, которые уже есть на складе (в таблице book) по той же цене, 
что и в поставке (supply), увеличить количество на значение, указанное в поставке, 
а также обнулить количество этих книг в поставке.
Этот запрос должен отобрать строки из таблиц bookи supply такие, что у них совпадают и автор,
 и название книги. 
*/

UPDATE book
SET amount = book.amount + supply.amount
FROM supply
JOIN author ON author.name_author = supply.author
WHERE book.title = supply.title
    AND book.author_id = author.author_id
    AND book.price = supply.price;

UPDATE supply s
SET amount = 0
FROM book b
JOIN author a ON a.author_id = b.author_id
WHERE s.price = b.price AND 
	a.name_author = s.author AND
	b.title = s.title;

SELECT * FROM supply s 
ORDER BY 1


/*
 Для книг, которые уже есть на складе (в таблице book), но по другой цене, чем в поставке (supply),
   необходимо в таблице book увеличить количество на значение, указанное в поставке,  
   и пересчитать цену. А в таблице  supply обнулить количество этих книг.
   Этот запрос должен отобрать строки из таблиц bookи supply такие, что у них совпадают и автор,
 и название книги. Пересчет цены: (b.price * b.amount + s.price * s.amount) / (b.amount + s.amount)
*/
-- Вариант 1
UPDATE book b
SET amount = b.amount + s.amount, 
	price = (b.price * b.amount + s.price * s.amount) / (b.amount + s.amount)
FROM supply s
JOIN author a ON a.name_author = s.author
WHERE
	b.author_id = a.author_id AND
	b.title = s.title AND
	b.price <> s.price;

UPDATE supply s
SET amount = 0
FROM book b
	JOIN author a ON b.author_id = a.author_id
WHERE s.author = a.name_author AND
	s.title = b.title AND 
	b.price <> s.price;


-- Вариант 2
WITH supply_values AS (
  /*Получаем количество и цену книг из supply до обнуления*/
  SELECT
    author.author_id,
    supply.author,
    supply.title,
    supply.amount,
    supply.price
  FROM
    book
    JOIN author USING (author_id)
    JOIN supply ON book.title = supply.title
      AND name_author = supply.author
      AND book.price <> supply.price
),
cte AS (
  /*Обнуляем значение amount в supply из рассчитанной таблицы supply_values*/
  UPDATE
    supply
  SET
    amount = 0
  FROM
    supply_values sv
  WHERE
    supply.author = sv.author
    AND supply.title = sv.title)
UPDATE
  book
SET
  price = (book.price * book.amount + sv.price * sv.amount) / (book.amount + sv.amount),
  amount = book.amount + sv.amount
FROM
  supply_values sv
WHERE
  book.title = sv.title AND
  book.author_id = sv.author_id
RETURNING
  *;


/*
 Включить новых авторов в таблицу author с помощью запроса на добавление.
 Новыми считаются авторы, которые есть в таблице supply, но нет в таблице author.
 */	
INSERT INTO author (name_author)
SELECT s.author
FROM author a
RIGHT JOIN supply s ON s.author = a.name_author
WHERE a.name_author IS NULL;


/*
 Добавить новые книги из таблицы supply 
 в таблицу book. Новые книги - это те, что есть в supply, но нет в book.
 */

INSERT INTO book(title, author_id, genre_id, price, amount)
SELECT s.title, a.author_id, NULL, s.price, s.amount
FROM supply s JOIN author a ON s.author = a.name_author
WHERE amount <> 0;


/*
 Занести для книги «Стихотворения и поэмы» Лермонтова жанр «Поэзия», 
 а для книги «Остров сокровищ» Стивенсона - «Приключения».
 */

UPDATE book
SET genre_id = (
	SELECT genre_id
	FROM genre
	WHERE name_genre = 'Поэзия')
WHERE title = 'Стихотворения и поэмы' AND 
	author_id = (
		SELECT author_id
		FROM author
		WHERE name_author = 'Лермонтов М.Ю.');
	

UPDATE book
SET genre_id = (
	SELECT genre_id
	FROM genre
	WHERE name_genre = 'Приключения')
WHERE title = 'Остров сокровищ' AND 
	author_id = (
		SELECT author_id
		FROM author
		WHERE name_author = 'Стивенсон Р.Л.');

UPDATE book
SET genre_id = 
      (
       SELECT genre_id 
       FROM genre 
       WHERE name_genre = 'Роман'
      )
WHERE book_id = 9;

