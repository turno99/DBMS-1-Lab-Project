-- create player table
CREATE TABLE player(
	player_id SERIAL,
	name varchar(50) NOT NULL,
	date_of_birth DATE NOT NULL,
		CONSTRAINT player_pKey PRIMARY KEY(id)
);

-- create coach table
CREATE TABLE coach(
	coach_id SERIAL,
	name varchar(50) NOT NULL,
	country varchar(50) NOT NULL,
	date_of_birth DATE NOT NULL,
		CONSTRAINT coach_pKey PRIMARY KEY(id)
);

-- create stadium table
CREATE TABLE stadium(
	name varchar(50),
	city varchar(50) NOT NULL,
	country varchar(50) NOT NULL,
	capacity INT
		CONSTRAINT stadium_capacity_constraint CHECK (capacity > 0),
		CONSTRAINT stadium_pKey PRIMARY KEY(name)
);

-- create team table
CREATE TABLE team(
	team_id SERIAL,
	full_name varchar(70) NOT NULL UNIQUE,
	budget NUMERIC(15, 2)
		CONSTRAINT team_budget_constraint CHECK (budget >= 0),
		CONSTRAINT team_pKey PRIMARY KEY (id)
);

-- create plays table
CREATE TABLE plays(
	player_id SERIAL NOT NULL,
	team_id SERIAL NOT NULL,
	wage NUMERIC(10, 2)
		CONSTRAINT plays_wage_constraint CHECK (wage >= 0),
		CONSTRAINT plays_pKey PRIMARY KEY(player_id),
		CONSTRAINT plays_playerID_fKey FOREIGN KEY(player_id) REFERENCES player(id)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
		CONSTRAINT plays_teamID_fKey FOREIGN KEY(team_id) REFERENCES team(id)
			ON DELETE SET NULL
			ON UPDATE CASCADE
);

-- create coaches table
CREATE TABLE coaches(
	coach_id SERIAL NOT NULL,
	team_id SERIAL NOT NULL,
	wage NUMERIC(10, 2)
		CONSTRAINT coaches_wage_constraint CHECK (wage >= 0),
		CONSTRAINT coaches_pKey PRIMARY KEY (coach_id),
		CONSTRAINT coaches_coachID_fKey FOREIGN KEY(coach_id) REFERENCES coach(id)
			ON DELETE CASCADE
			ON UPDATE CASCADE,
		CONSTRAINT coaches_teamID_fKey FOREIGN KEY(team_id) REFERENCES team(id)
			ON DELETE SET NULL
			ON UPDATE CASCADE
);

-- create matches table
CREATE TABLE matches(
	match_id SERIAL,
	home_team_id SERIAL NOT NULL,
	away_team_id SERIAL NOT NULL,
	date_of_match DATE,
	venue varchar(50),
	home_team_runs INT
		CONSTRAINT matches_home_team_goal_constraint CHECK (home_team_runs >= 0),
	away_team_runs INT
		CONSTRAINT matches_away_team_goal_constraint CHECK (away_team_runs >= 0),
	winner INT NOT NULL
		CONSTRAINT matches_winner_constraint CHECK ((winner>=0) and (winner<=2)), -- 1 if home team wins, 2 if away team wins, 0 if draw
		CONSTRAINT matches_pKey PRIMARY KEY(match_id),
		CONSTRAINT matches_homeID_fKey FOREIGN KEY(home_team_id) REFERENCES team(id)
			ON DELETE No Action
			ON UPDATE CASCADE,
		CONSTRAINT matches_awayID_fKey FOREIGN KEY(away_team_id) REFERENCES team(id)
			ON DELETE No Action
			ON UPDATE CASCADE,
		CONSTRAINT matches_venue_fKey FOREIGN KEY(venue) REFERENCES stadium(name)
			ON DELETE No Action
			ON UPDATE CASCADE
);
-- create batting table
CREATE TABLE batting(
	match_id SERIAL,
	player_id SERIAL,
	runs_scored INT,
	balls_played INT,
	boundaries_hit INT
		CONSTRAINT batting_runs_scored_constraint check (runs_scored >= 0),
		CONSTRAINT batting_balls_played_constraint check (balls_played >= 0),
	CONSTRAINT batting_pKey PRIMARY KEY (match_id, player_id),
	CONSTRAINT batting_matchID_fKey FOREIGN KEY(match_id) REFERENCES matches(match_id)
		ON DELETE No Action
		ON UPDATE CASCADE,
	CONSTRAINT batting_playerID_fKey FOREIGN KEY(player_id) REFERENCES player(id)
		ON DELETE No Action
		ON UPDATE CASCADE
);
--create bowling table
CREATE TABLE bowling(
	match_id SERIAL,
	player_id SERIAL,
	wickets_taken INT,
	balls_bowled INT,
    runs_conceded INT
		CONSTRAINT bowling_wickets_taken_constraint check (wickets_taken >= 0 and wickets_taken <= balls_bowled),
		CONSTRAINT bowling_balls_bowled_constraint check (balls_bowled >= 0),
		CONSTRAINT bowling_runs_conceded_constraint check (runs_conceded >= 0),
	CONSTRAINT bowling_pKey PRIMARY KEY (match_id, player_id),
	CONSTRAINT bowling_matchID_fKey FOREIGN KEY(match_id) REFERENCES matches(match_id)
		ON DELETE No Action
		ON UPDATE CASCADE,
	CONSTRAINT bowling_playerID_fKey FOREIGN KEY(player_id) REFERENCES player(id)
		ON DELETE No Action
		ON UPDATE CASCADE
);
