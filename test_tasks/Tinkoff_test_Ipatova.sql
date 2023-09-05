-- Тестовое задание на проверку уровня SQL 
-- Выполнено Ипатовой Е.В.
-- Дата выполнения: 5.09.2023


CREATE  TABLE jobtitles(
  jobtitle_id int PRIMARY key,
  name varchar);
  
INSERT INTO  jobtitles (jobtitle_id, name)
VALUES
(1, 'Разработчик'), (2, 'Системный аналитик'), (3, 'Менеджер проектов'), (4, 'Системный администратор'),(5, 'Руководитель группы'),(6, 'Инженер тестирования'),(7, 'Сотрудник группы поддержки');


CREATE table staff (
  staff_id int  PRIMARY key,
  name varchar,
  salary int,
  email varchar,
  birthday date,
  jobtitle_id int,
  FOREIGN key (jobtitle_id) REFERENCES jobtitles(jobtitle_id));
  
INSERT into staff (staff_id, name, salary, email,birthday, jobtitle_id )
VALUES  
(1, 'Иванов Сергей', 100000, 'test@test.ru','1990-03-03',1),
(2, 'Петров Петр', 60000, 'petr@test.ru','2000-12-01',7),
(3, 'Сидоров Василий', 80000, 'test@test.ru','1999-02-04',6),
(4, 'Максимов Иван',70000, 'ivan.m@test.ru','1997-10-02',4),
(5, 'Полов Иван', 120000, 'popov@test.ru','2001-04-21',5);


/*
 1. Создать запрос, с помощью которого можно найти дубли в поле email из таблицы Sfaff.
 */
	SELECT
        email, COUNT(email)
    FROM
        staff
    GROUP BY
        email
    HAVING
        COUNT(email) > 1;
        
              
/*
2. Напишите запрос, с помощью которого можно определить возраст каждого сотрудника 
  из таблицы Staff на момент запроса.
*/     
SELECT  
	name,
    date_part('year', age(birthday))::int
FROM 
	staff


/*
3. Напишите запрос, с помощью которого можно определить должность 
(Jobtitles.name) со вторым по величине уровнем зарплаты.
 */
	
SELECT j.name
FROM jobtitles j
JOIN staff	s using(jobtitle_id)
WHERE salary <> 
			(SELECT 
				max(salary) 
			FROM staff)
ORDER BY 2 DESC
LIMIT 1
	
	
	
	
	
       
       