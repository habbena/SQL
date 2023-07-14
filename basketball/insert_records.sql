-- TASK 1

INSERT INTO arena VALUES (10, 'Палау Блауграна', 8250);
INSERT INTO arena VALUES (20, 'Визинк-Центр - Паласио де Депортес', 15500);
INSERT INTO arena VALUES (30, 'УСК ЦСКА им. А.Я. Гомельского', 5000);
INSERT INTO arena VALUES (40, 'Пис энд Френдшип Стадиум', 12000);
INSERT INTO arena VALUES (50, 'СИБУР Арена', 7140);

INSERT INTO team VALUES (10, 'Барселона', 'Барселона', 'Шарунас Ясикявичюс', 10);
INSERT INTO team VALUES (20, 'Мадрид', 'Реал Мадрид', 'Пабло Ласо', 20);
INSERT INTO team VALUES (30, 'Москва', 'ЦСКА', 'Димитрис Итудис', 30);
INSERT INTO team VALUES (40, 'Пирей', 'Олимпиакос', 'Георгиос Барцокас', 40);
INSERT INTO team VALUES (50, 'Санкт-Петербург', 'Зенит', 'Хавьер Паскуаль', 50);

INSERT INTO player VALUES (10, 'Рафа Вильяр', 'защитник', 188, 85, 100000, 10);
INSERT INTO player VALUES (20, 'Кайл Курич', 'защитник', 193, 85, 100000, 10);
INSERT INTO player VALUES (30, 'Ибу Дьянко Баджи', 'центровой', 211, 103, 200000, 10);
INSERT INTO player VALUES (40, 'Ник Калатес', 'разыгрывающий', 198,	97,	150000,	10);
INSERT INTO player VALUES (50, 'Никола Миротич', 'форвард', 208, 107, 175000, 10);
INSERT INTO player VALUES (60, 'Джейси Кэрролл', 'защитник', 188, 82, 175000, 20);
INSERT INTO player VALUES (70, 'Эли Джон Ндиайе', 'центровой', 203,	110, 275000, 20);
INSERT INTO player VALUES (80, 'Уолтер Тавареш', 'центровой', 220, 120, 273000, 20);
INSERT INTO player VALUES (90, 'Томас Давид Эртель', 'разыгрывающий', 189, 88, 173000, 20);
INSERT INTO player VALUES (100, 'Гершон Ябуселе', 'форвард', 203, 118, 99000, 20);
INSERT INTO player VALUES (110, 'Габриэль Иффе Лундберг', 'защитник', 193, 96, 101000, 30);
INSERT INTO player VALUES (120, 'Юрий Умрихин',	'защитник',	190, 75, 251000, 30);
INSERT INTO player VALUES (130,	'Иван Анатольевич Ухов', 'разыгрывающий', 193, 77, 175000, 30);
INSERT INTO player VALUES (140,	'Александр Хоменко', 'разыгрывающий', 192, 85, 375000, 30);
INSERT INTO player VALUES (150,	'Андрей Лопатин', 'лёгкий форвард', 208, 92, 205000, 30);
INSERT INTO player VALUES (160,	'Тайлер Дорси',	'защитник', 193, 83, 205000, 40);
INSERT INTO player VALUES (170,	'Яннулис Ларенцакис', 'защитник',196, 87, 75000, 40);
INSERT INTO player VALUES (180,	'Хассан Мартин', 'центровой', 201, 107, 375000, 40);
INSERT INTO player VALUES (190,	'Михалис Лунцис', 'разыгрывающий', 195, 90, 475000, 40);
INSERT INTO player VALUES (200,	'Георгиос Принтезис', 'форвард', 205, 104, 105000, 40);
INSERT INTO player VALUES (210,	'Билли Джеймс Бэрон', 'защитник', 188, 88, 75000, 50);
INSERT INTO player VALUES (220,	'Артурас Гудайтис',	'центровой', 208, 99, 165000, 50);
INSERT INTO player VALUES (230,	'Денис Захаров', 'разыгрывающий', 192, 88, 163000, 50);
INSERT INTO player VALUES (240,	'Миндаугас Кузминскас',	'лёгкий форвард', 204, 93, 295000, 50);
INSERT INTO player VALUES (250,	'Алекс Пойтресс', 'форвард', 201, 108, 247000, 50);


-- TASK 2

INSERT INTO game VALUES (10, 10, 50, '2021-10-22', 10, 84, 58, 10);
INSERT INTO game VALUES (20, 10, 30, '2021-11-17', 10, 81, 73, 10);
INSERT INTO game VALUES (30, 10, 20, '2021-10-12', 10, 93, 80, 10);
INSERT INTO game VALUES (40, 10, 40, '2021-10-15', 10, 83, 68, 10);
INSERT INTO game VALUES (50, 50, 20, '2022-12-15', 20, 68, 75, 50);
INSERT INTO game VALUES (60, 50, 30, '2022-01-15', 30, 67, 77, 50);
INSERT INTO game VALUES (70, 50, 40, '2022-10-20', 50, 84, 78, 50);
INSERT INTO game VALUES (80, 20, 30, '2021-10-28', 20, 71, 65, 20);
INSERT INTO game VALUES (90, 20, 40, '2022-02-01', 20, 75, 67, 20);
INSERT INTO game VALUES (100, 30, 40, '2022-02-02', 30, 79, 78, 30);

-- TASK 3

SELECT name 
FROM arena
WHERE size > 9000
ORDER BY name;

-- TASK 4

SELECT name
FROM player
WHERE position IN ('защитник', 'форвард')
ORDER BY name DESC;

-- TASK 5
SELECT name 
FROM player
WHERE height > 215 OR weight > 120
ORDER BY name;