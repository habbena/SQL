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


		