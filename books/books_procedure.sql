DROP FUNCTION IF EXISTS del_fil_book();

CREATE OR REPLACE FUNCTION del_insert_book()
RETURNS void
LANGUAGE plpgsql
AS $$
BEGIN 
	DROP TABLE IF EXISTS book CASCADE;          
	CREATE TABLE book (
        book_id serial PRIMARY KEY,
        title VARCHAR(50),
        author_id INT,
        genre_id int,
        price DECIMAL(8, 2),
        amount INT,
        FOREIGN KEY (author_id) REFERENCES author (author_id) ON DELETE CASCADE,
        FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE SET NULL
    );
	INSERT INTO book (title, author_id, genre_id, price, amount)
	VALUES 
	('Мастер и Маргарита', 1, 1, 670.99, 3),
       ('Белая гвардия', 1, 1, 540.50, 5),
       ('Идиот', 2, 1, 460.00, 10),
       ('Братья Карамазовы', 2, 1, 799.01, 3),
       ('Игрок', 2, 1, 480.50, 10),
       ('Стихотворения и поэмы', 3, 2, 650.00, 15),
       ('Черный человек', 3, 2, 570.20, 6),
       ('Лирика', 4, 2, 518.99, 2);
END
$$


CREATE OR REPLACE FUNCTION del_insert_supply()
RETURNS  void
LANGUAGE plpgsql
AS $$
BEGIN
	DROP TABLE IF EXISTS supply CASCADE;  
	CREATE TABLE IF NOT EXISTS supply(
	supply_id serial PRIMARY KEY,
	title     VARCHAR(50),
	author    VARCHAR(50),
	price     DECIMAL(8, 2),
	amount    INT
	);

	INSERT INTO supply(title, author, price, amount)
	VALUES
	('Доктор Живаго', 'Пастернак Б.Л.', 380.80, 4),
       	('Черный человек', 'Есенин С.А.', 570.20, 6),
       	('Белая гвардия', 'Булгаков М.А.', 540.50, 7),
       	('Идиот', 'Достоевский Ф.М.', 360.80, 3),
       	('Стихотворения и поэмы', 'Лермонтов М.Ю.', 255.90, 4),
       	('Остров сокровищ', 'Стивенсон Р.Л.', 599.99, 5);	
END
$$
