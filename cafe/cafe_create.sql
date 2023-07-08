-- Project 4.1

/* Task 1
-- Определение физической модели данных, которая 
описывает работу сети ресторанов быстрого питания */


-- Список кафе
CREATE TABLE cafes(
	id int PRIMARY KEY,
	"name" varchar NOT NULL UNIQUE,
	adress varchar NOT NULL,
	rating int NOT NULL DEFAULT 0
			CHECK (rating BETWEEN 0 AND 5)
);

-- Список должностей
CREATE TABLE "position"(
	id int PRIMARY KEY, 
	name varchar NOT NULL UNIQUE
);

-- Список сотрудников
CREATE TABLE employees(
	id int PRIMARY KEY,
	name varchar NOT NULL,
	salary decimal NOT NULL DEFAULT 60000,
	position_id int NOT NULL,
	CONSTRAINT fk_position 
		FOREIGN KEY (position_id) REFERENCES "position"(id)
);

-- Список меню
CREATE TABLE menu(
	id int PRIMARY KEY,
	"name" varchar NOT NULL,
	cheif_id int NOT NULL,
	cafe_id int NOT NULL,
	date_launch date NOT NULL,
	CONSTRAINT fk_cafe
		FOREIGN KEY (cafe_id) REFERENCES cafes(id),
	CONSTRAINT fk_chief 
		FOREIGN KEY (cheif_id) REFERENCES employees(id)	
);

-- Список ингредиентов
CREATE TABLE ingredients(
	id int PRIMARY KEY,
	name varchar NOT NULL UNIQUE,
	calories int NOT NULL DEFAULT 0
);

-- Список рецептов
-- Единица измерения - грамм / мл, количество сырья на 1 порцию
CREATE TABLE recipes(
	id int PRIMARY KEY,
	name varchar NOT NULL,
	ingredient_id int NOT NULL unique,
	ingredient_amount int NOT NULL DEFAULT 1,
	dish_id int NOT NULL,
	CONSTRAINT fk_ingredient 
		FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);

-- Список блюд
-- Время приготовления в секундах, вес блюда в граммах
CREATE TABLE dishes(
	id int PRIMARY KEY,
	name varchar NOT NULL, 
	rating int NOT NULL DEFAULT 0 CHECK (rating BETWEEN 0 AND 5),
	cooking_time int NOT NULL DEFAULT 60,
	weight int NOT NULL DEFAULT 100,
	recipe_id int NOT NULL,
	menu_id int NOT NULL,
	CONSTRAINT fk_recipe FOREIGN KEY (recipe_id)
		REFERENCES recipes(id),
	CONSTRAINT fk_menu FOREIGN KEY (menu_id)
		REFERENCES menu(id)
);

-- Счета посетителей
CREATE TABLE orders(
	id int PRIMARY KEY,
	order_num varchar NOT NULL,
	bill_rub decimal NOT NULL DEFAULT 0,
	tips decimal NOT NULL DEFAULT 0,
	waiter_id int NOT NULL,
	CONSTRAINT fk_waiter 
		FOREIGN KEY (waiter_id) REFERENCES employees(id)
);

-- Заказы блюд посетителями
CREATE TABLE order_dishes(
	id int PRIMARY KEY,
	order_id int NOT NULL,
	dish_id int NOT NULL,
	quantity int NOT NULL DEFAULT 1,
	CONSTRAINT fk_order 
		FOREIGN KEY (order_id) REFERENCES orders(id),
	CONSTRAINT fk_dish
		FOREIGN KEY (dish_id) REFERENCES dishes(id)
);

