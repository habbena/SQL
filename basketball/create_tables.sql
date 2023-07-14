-- TASK 1

CREATE TABLE arena(
	id INT PRIMARY KEY,
	name VARCHAR not NULL,
	size INT
);

CREATE TABLE team (
	id INT PRIMARY KEY,
	city VARCHAR,
	name VARCHAR,
	coach_name VARCHAR,
	arena_id INT
);
	
CREATE TABLE player (
	id INT PRIMARY KEY,
	name VARCHAR,
	position VARCHAR,
	height NUMERIC,
	weight NUMERIC,
	salary NUMERIC,
	team_id INT
);

-- TASK 2

ALTER TABLE arena 
	ALTER COLUMN name SET NOT NULL,
	ALTER COLUMN size SET NOT NULL,
	ALTER COLUMN size SET DEFAULT 100;

ALTER TABLE team
	ALTER COLUMN name SET NOT NULL,
	ALTER COLUMN city SET NOT NULL,
	ALTER COLUMN coach_name SET NOT NULL,
	ALTER COLUMN arena_id SET NOT NULL;

ALTER TABLE player
	ALTER COLUMN name SET NOT NULL,
	ALTER COLUMN position SET NOT NULL,
	ALTER COLUMN height SET NOT NULL,
	ALTER COLUMN weight SET NOT NULL,
	ALTER COLUMN salary SET NOT NULL,
	ALTER COLUMN team_id SET NOT NULL,
	ADD CONSTRAINT check_height_positive CHECK (height > 0),
	ADD CONSTRAINT check_weight_positive CHECK (weight > 0),
	ADD CONSTRAINT  check_salary_positive CHECK (salary > 0);
	
-- TASK 3
ALTER TABLE arena 
	ADD UNIQUE (name);

ALTER TABLE team
	ADD CONSTRAINT team_name_ukey UNIQUE (name),
	ADD CONSTRAINT team_coach_ukey UNIQUE (coach_name),
	ADD CONSTRAINT team_arena_fkey FOREIGN KEY (arena_id) 
		REFERENCES arena(id)
		ON UPDATE CASCADE ON DELETE RESTRICT;
	
ALTER TABLE player
	ADD CONSTRAINT player_ukey UNIQUE (name),
	ADD CONSTRAINT player_team_fkey FOREIGN KEY (team_id)
		REFERENCES team(id)
		ON UPDATE CASCADE ON DELETE CASCADE;
		
-- TASK 4

CREATE TABLE game(
	id INT PRIMARY KEY,
	owner_team_id INT,
	guest_team_id INT,
	game_date DATE,
	winner_team_id INT,
	owner_score INT,
	guest_score INT,
	arena_id INT
);

-- TASK 5

ALTER TABLE game 
	ALTER COLUMN owner_team_id SET NOT NULL,   
	ALTER COLUMN guest_team_id SET NOT NULL,
	ALTER COLUMN game_date SET NOT NULL, 
	ALTER COLUMN winner_team_id SET NOT NULL,
	ALTER COLUMN owner_score SET NOT NULL,
	ALTER COLUMN guest_score SET NOT NULL,
	ALTER COLUMN arena_id SET NOT NULL, 
	ALTER COLUMN owner_score SET DEFAULT 0,
	ALTER COLUMN guest_score SET DEFAULT 0,
	ADD CONSTRAINT check_owner_score_positive CHECK (owner_score > 0),
	ADD CONSTRAINT check_guest_score_positive CHECK (guest_score > 0),
	ADD CONSTRAINT owner_guest_ukey UNIQUE (owner_team_id, guest_team_id),
	ADD CONSTRAINT owner_team_fkey FOREIGN KEY (owner_team_id)
			REFERENCES team(id)
			ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT guest_team_fkey FOREIGN KEY (guest_team_id)
			REFERENCES team(id)
			ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT winner_team_fkey FOREIGN KEY (winner_team_id)
			REFERENCES team(id)
			ON UPDATE CASCADE ON DELETE CASCADE,
	ADD CONSTRAINT arena_fkey FOREIGN KEY (arena_id)
			REFERENCES arena(id)
			ON UPDATE CASCADE ON DELETE CASCADE;
	

	
	

