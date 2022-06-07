
CREATE TABLE IF NOT EXISTS public.teams
(
    teamid integer NOT NULL,
    name character varying COLLATE pg_catalog."default",
    CONSTRAINT teams_pkey PRIMARY KEY (teamid)
);

CREATE TABLE IF NOT EXISTS public.players
(
    playerid integer NOT NULL,
    name character varying COLLATE pg_catalog."default",
    CONSTRAINT players_pkey PRIMARY KEY (playerid)
);

CREATE TABLE IF NOT EXISTS public.leagues
(
    leagueid integer NOT NULL,
    name character varying COLLATE pg_catalog."default",
    CONSTRAINT leagues_pkey PRIMARY KEY (leagueid)
);

CREATE TABLE IF NOT EXISTS public.games
(
    gameid integer NOT NULL,
    leagueid integer,
    year integer,
    hometeamid integer,
    awayteamid integer,
    homegoals integer,
    awaygoals integer,
    CONSTRAINT games_pkey PRIMARY KEY (gameid),
    CONSTRAINT games_leagueid_fkey FOREIGN KEY (leagueid)
        REFERENCES public.leagues (leagueid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS public.appearances
(
    gameid integer,
    playerid integer,
    goals integer,
    owngoals integer,
    shots integer,
    assists integer,
    keypasses integer,
    leagueid integer,
    CONSTRAINT appearances_gameid_fkey FOREIGN KEY (gameid)
        REFERENCES public.games (gameid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT appearances_leagueid_fkey FOREIGN KEY (leagueid)
        REFERENCES public.leagues (leagueid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT appearances_playerid_fkey FOREIGN KEY (playerid)
        REFERENCES public.players (playerid) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE IF NOT EXISTS public.train_info (
	train_no integer,
    train_name text,
    source_station_name text,
    destination_station_name text,
    departure_time time,
    arrival_time time,
    day_of_departure text,
    day_of_arrival text,
    distance bigint NOT NULL
);

copy teams from 'C:/Users/vbikk/Desktop/Study_material/6th semester/COL362(DBMS)/Assignments/Assignment2/Checking/teams.csv' delimiter ',' csv header encoding 'win1250';

copy leagues from 'C:/Users/vbikk/Desktop/Study_material/6th semester/COL362(DBMS)/Assignments/Assignment2/Checking/leagues.csv' delimiter ',' csv header encoding 'win1250';

copy players from 'C:/Users/vbikk/Desktop/Study_material/6th semester/COL362(DBMS)/Assignments/Assignment2/Checking/players.csv' delimiter ',' csv header encoding 'win1250';

copy games from 'C:/Users/vbikk/Desktop/Study_material/6th semester/COL362(DBMS)/Assignments/Assignment2/Checking/games.csv' delimiter ',' csv header encoding 'win1250';

copy appearances from 'C:/Users/vbikk/Desktop/Study_material/6th semester/COL362(DBMS)/Assignments/Assignment2/Checking/appearances.csv' delimiter ',' csv header encoding 'win1250';

copy train_info from 'C:/Users/vbikk/Desktop/Study_material/6th semester/COL362(DBMS)/Assignments/Assignment2/Checking/train_info .csv' delimiter ',' csv header encoding 'win1250';




