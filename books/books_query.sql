/*
Необходимо в каждом городе провести выставку книг каждого автора в течение 2020 года. 
Дату проведения выставки выбрать случайным образом. 
*/

SELECT
	c.name_city,
	a.name_author,
	'2020-01-01':: date + floor(random() * 365) :: int AS Год
FROM city c, author a
ORDER BY 1, 3
	
/*
Вывести авторов, общее количество книг которых на складе максимально.
*/

SELECT a.name_author, sum(amount)
FROM book b
JOIN author a ON a.author_id = b.author_id
GROUP BY a.name_author
HAVING sum(amount) = 
 (SELECT max(amount)
 	FROM 
		(SELECT author_id, sum(amount) AS amount
		FROM book
		GROUP BY author_id) AS query_1)


/*
Вывести информацию о книгах, написанных в самых популярных жанрах, в отсортированном в алфавитном порядке по названию книг виде.
Самым популярным считать жанр, общее количество экземпляров книг которого на складе максимально.
*/
	
SELECT  title, a.name_author, g.name_genre, price, amount
FROM  book b
	JOIN  author a ON  a.author_id = b.author_id
	JOIN  genre g ON  g.genre_id = b.genre_id
WHERE  b.genre_id IN  (
	SELECT  genre_id
	FROM  book
	GROUP  BY  genre_id
	HAVING  sum(amount) = (
				SELECT  max(total)
				FROM (
    				SELECT  genre_id, sum(amount) as total
    				FROM  book
    				GROUP  BY  genre_id) q1))
ORDER  BY  1

/*
Нужно разослать книги по книжным магазинам в города из таблицы city. Книги распределяем пропорционально: 
в Москву 50%, в Санкт-Петербург 30%, во Владивосток 20%. 
Вывести город, названия книг, имена авторов и количество книг к отправке. Отсортировать по городу, потом по названию книги. Проверить, что итоговое количество книг к отправке совпадает с тем, что есть на складе.
*/
-- Распределяем книги по городам	
SELECT  name_city, title, name_author,
    CASE 
        WHEN  name_city = 'Владивосток' then floor(b.amount * 0.2)
        WHEN  name_city = 'Москва' then floor(b.amount * 0.5)
        WHEN  name_city = 'Санкт-Петербург' then floor(b.amount * 0.3)
     END  AS  delivery
FROM  city, book b
JOIN  author a ON  a.author_id = b.author_id
ORDER  BY  1, 2;

-- Сверяем количество к отправке с количеством книг на складе
WITH  q AS  (
SELECT  name_city, title, name_author,
    CASE 
        WHEN  name_city = 'Владивосток' then floor(b.amount * 0.2)
        WHEN  name_city = 'Москва' then floor(b.amount * 0.5)
        WHEN  name_city = 'Санкт-Петербург' then floor(b.amount * 0.3)
     END  AS  delivery
FROM  city, book b
JOIN  author a ON  a.author_id = b.author_id
ORDER  BY  1, 2)
SELECT  
	b.title, 
	b.amount AS store_cnt,
	sum(delivery) AS delivery_cnt	
FROM  q
JOIN  book b ON  b.title = q.title
GROUP  BY  b.title, b.amount
ORDER  BY  1;
