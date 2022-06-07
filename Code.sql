--1--

WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, hop) AS
        (SELECT source_station_name, destination_station_name, 0
        FROM train_info
        WHERE source_station_name = 'KURLA' AND train_no = 97131
    UNION ALL
        SELECT R1.source_station_name, R2.destination_station_name, R1.hop+1
        FROM Reaches_two_hops AS R1, train_info AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND R1.hop <= 1
        )
SELECT DISTINCT destination_station_name
FROM Reaches_two_hops
ORDER BY destination_station_name;


--2--

WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, day_of_arrival, day_of_departure, hop) AS
        (SELECT source_station_name, destination_station_name, day_of_arrival, day_of_departure, 0
        FROM train_info
        WHERE source_station_name = 'KURLA' AND train_no = 97131 AND day_of_arrival = day_of_departure
    UNION ALL
        SELECT R1.source_station_name, R2.destination_station_name, R1.day_of_arrival, R2.day_of_departure, R1.hop+1
        FROM Reaches_two_hops AS R1, train_info AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND R2.day_of_arrival = R2.day_of_departure AND R2.day_of_departure = R1.day_of_arrival AND R1.hop <= 1
        )
SELECT DISTINCT destination_station_name
FROM Reaches_two_hops
ORDER BY destination_station_name;

--3--

WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, day_of_arrival, day_of_departure, total_distance, hop, path) AS
        (SELECT source_station_name, destination_station_name, day_of_arrival, day_of_departure, distance, 0, array[source_station_name, destination_station_name] as path 
        FROM train_info
        WHERE source_station_name = 'DADAR' AND day_of_arrival = day_of_departure
    UNION ALL
        SELECT R1.source_station_name, R2.destination_station_name, R1.day_of_arrival, R2.day_of_departure, R1.total_distance+R2.distance, R1.hop+1,  array_append(path, R2.destination_station_name)
        FROM Reaches_two_hops AS R1, train_info AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND R2.day_of_arrival = R2.day_of_departure AND R2.day_of_departure = R1.day_of_arrival AND R1.hop <= 1 AND NOT R2.destination_station_name = any(path)
        )

SELECT DISTINCT destination_station_name, total_distance as distance, day_of_arrival as day
FROM Reaches_two_hops
WHERE NOT destination_station_name = 'DADAR'
ORDER BY destination_station_name asc, distance asc, day asc;

/*WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, day_of_arrival, day_of_departure, total_distance, hop) AS
        (SELECT source_station_name, destination_station_name, day_of_arrival, day_of_departure, distance, 0 
        FROM train_info
        WHERE source_station_name = 'DADAR' AND day_of_arrival = day_of_departure
    UNION ALL
        SELECT R1.source_station_name, R2.destination_station_name, R1.day_of_arrival, R2.day_of_departure, R1.total_distance+R2.distance, R1.hop+1
        FROM Reaches_two_hops AS R1, train_info AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND R2.day_of_arrival = R2.day_of_departure AND R2.day_of_departure = R1.day_of_arrival AND R1.hop <= 1
        )
SELECT DISTINCT destination_station_name, total_distance as distance, day_of_arrival as day
FROM Reaches_two_hops
WHERE NOT destination_station_name = 'DADAR'
ORDER BY destination_station_name asc, distance asc, day asc;*/


--4--
/*
WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, arrival_int_day, arrival_time, hop) AS
        (SELECT source_station_name, destination_station_name, arrival_int_day, arrival_time, 0 
        FROM train_info_day
        WHERE source_station_name = 'DADAR'
    UNION
        SELECT R1.source_station_name, R2.destination_station_name, R2.arrival_int_day, R2.arrival_time, R1.hop+1
        FROM Reaches_two_hops AS R1, train_info_day AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND R1.arrival_int_day <= R2.departure_int_day AND (CASE WHEN (R1.arrival_int_day = R2.departure_int_day AND R1.arrival_time <= R2.departure_time) THEN 1 ELSE 0 END) = 1 AND R1.hop <= 1
        ),
Day_int(day_word, day_num) AS(
    VALUES
    ('Monday', 1),
    ('Tuesday', 2),
    ('Wednesday', 3),
    ('Thursday', 4),
    ('Friday', 5),
    ('Saturday', 6),
    ('Sunday', 7)
),
train_info_day AS(
    SELECT train_no, train_name, distance, source_station_name, departure_time, day_of_departure, destination_station_name, arrival_time, day_of_arrival, T2.day_num AS departure_int_day, T1.day_num AS arrival_int_day
    FROM train_info, Day_int AS T1, Day_int AS T2
    WHERE T1.day_word = train_info.day_of_arrival AND T2.day_word = train_info.day_of_departure
)

SELECT DISTINCT destination_station_name
FROM Reaches_two_hops
WHERE NOT destination_station_name = 'DADAR'
ORDER BY destination_station_name asc;*/


WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, arrival_int_day, arrival_time, hop, path) AS
        (SELECT source_station_name, destination_station_name, arrival_int_day, arrival_time, 0, array[source_station_name, destination_station_name] as path
        FROM train_info_day
        WHERE source_station_name = 'DADAR'
    UNION ALL
        SELECT R1.source_station_name, R2.destination_station_name, R2.arrival_int_day, R2.arrival_time, R1.hop+1, array_append(path, R2.destination_station_name)
        FROM Reaches_two_hops AS R1, train_info_day AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND R1.arrival_int_day <= R2.departure_int_day AND (CASE WHEN (R1.arrival_int_day = R2.departure_int_day AND R1.arrival_time <= R2.departure_time) THEN 1 ELSE 0 END) = 1 AND R1.hop <= 1 AND NOT R2.destination_station_name = any(path)
        ),
Day_int(day_word, day_num) AS(
    VALUES
    ('Monday', 1),
    ('Tuesday', 2),
    ('Wednesday', 3),
    ('Thursday', 4),
    ('Friday', 5),
    ('Saturday', 6),
    ('Sunday', 7)
),
train_info_day AS(
    SELECT train_no, train_name, distance, source_station_name, departure_time, day_of_departure, destination_station_name, arrival_time, day_of_arrival, T2.day_num AS departure_int_day, T1.day_num AS arrival_int_day
    FROM train_info, Day_int AS T1, Day_int AS T2
    WHERE T1.day_word = train_info.day_of_arrival AND T2.day_word = train_info.day_of_departure
)

SELECT DISTINCT destination_station_name
FROM Reaches_two_hops
WHERE NOT destination_station_name = 'DADAR'
ORDER BY destination_station_name asc;



--5--

WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, hop, path) AS
        (SELECT source_station_name, destination_station_name, 0, array[source_station_name, destination_station_name] as path
        FROM train_info_1
        WHERE source_station_name = 'CST-MUMBAI'
    UNION ALL 
        SELECT R1.source_station_name, R2.destination_station_name, R1.hop+1, array_append(path, R2.destination_station_name)
        FROM Reaches_two_hops AS R1, train_info_1 AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND R1.hop <= 1 AND NOT R2.destination_station_name = 'CST-MUMBAI' AND NOT R2.source_station_name = 'VASHI' AND NOT R2.destination_station_name = any(path)
        )
SELECT COUNT(*)
FROM Reaches_two_hops
WHERE destination_station_name = 'VASHI';


/*WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, hop) AS
        (SELECT source_station_name, destination_station_name, 0
        FROM train_info_1
        WHERE source_station_name = 'CST-MUMBAI'
    UNION ALL
        SELECT R1.source_station_name, R2.destination_station_name, R1.hop+1
        FROM Reaches_two_hops AS R1, train_info_1 AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND R1.hop <= 1 AND NOT R2.destination_station_name = 'CST-MUMBAI' AND NOT R2.source_station_name = 'VASHI' 
        )
SELECT COUNT(*)
FROM Reaches_two_hops
WHERE destination_station_name = 'VASHI';*/

--6--

WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, total_distance, hop, path) AS
        (SELECT source_station_name, destination_station_name, distance, 0, array[source_station_name, destination_station_name] as path
        FROM train_info
    UNION ALL
        SELECT R1.source_station_name, R2.destination_station_name, R1.total_distance+R2.distance, R1.hop+1, array_append(path, R2.destination_station_name)
        FROM Reaches_two_hops AS R1, train_info AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND NOT R1.source_station_name = R2.destination_station_name AND R1.hop <= 5 AND NOT R2.destination_station_name = any(path)
        )
SELECT DISTINCT destination_station_name, source_station_name, MIN(total_distance) as distance
FROM Reaches_two_hops
GROUP BY destination_station_name, source_station_name
ORDER BY destination_station_name asc, source_station_name asc;


--7--

WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, hop, path) AS
        (SELECT source_station_name, destination_station_name, 0, array[source_station_name, destination_station_name] as path
        FROM train_info
    UNION ALL
        SELECT R1.source_station_name, R2.destination_station_name, R1.hop+1, array_append(path, R2.destination_station_name)
        FROM Reaches_two_hops AS R1, train_info AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND NOT R1.source_station_name = R2.destination_station_name AND R1.hop <= 0 AND NOT R2.destination_station_name = any(path)
        )
SELECT DISTINCT source_station_name, destination_station_name
FROM Reaches_two_hops
ORDER BY source_station_name asc, destination_station_name asc;

--8--

WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, day_of_arrival, day_of_departure) AS
        (SELECT source_station_name, destination_station_name, day_of_arrival, day_of_departure
        FROM train_info
        WHERE source_station_name = 'SHIVAJINAGAR' AND day_of_arrival = day_of_departure
    UNION ALL
        SELECT R1.source_station_name, R2.destination_station_name, R1.day_of_arrival, R2.day_of_departure
        FROM Reaches_two_hops AS R1, train_info AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND R2.day_of_arrival = R2.day_of_departure AND R2.day_of_departure = R1.day_of_arrival
        )
SELECT DISTINCT destination_station_name, day_of_arrival AS day
FROM Reaches_two_hops
WHERE destination_station_name <> 'SHIVAJINAGAR'
ORDER BY destination_station_name asc, day asc;

--9--

WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, day_of_arrival, day_of_departure, total_distance, path) AS
        (SELECT source_station_name, destination_station_name, day_of_arrival, day_of_departure, distance, array[source_station_name, destination_station_name] as path
        FROM train_info
        WHERE source_station_name = 'LONAVLA' AND day_of_arrival = day_of_departure
    UNION ALL
        SELECT R1.source_station_name, R2.destination_station_name, R1.day_of_arrival, R2.day_of_departure, R1.total_distance+R2.distance, array_append(path, R2.destination_station_name)
        FROM Reaches_two_hops AS R1, train_info AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND R2.day_of_arrival = R2.day_of_departure AND R2.day_of_departure = R1.day_of_arrival AND NOT R2.destination_station_name = any(path)
        )
SELECT DISTINCT destination_station_name, MIN(total_distance) as distance, day_of_arrival AS day
FROM Reaches_two_hops
GROUP BY destination_station_name, day_of_arrival
ORDER BY distance asc, destination_station_name asc;


--10--

WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, distance, path) AS
        (SELECT source_station_name, destination_station_name, distance, array[source_station_name, destination_station_name] as path
        FROM train_info
    UNION ALL
        SELECT R1.source_station_name, R2.destination_station_name, R1.distance+R2.distance, array_append(path, R2.destination_station_name)
        FROM Reaches_two_hops AS R1, train_info AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND NOT R2.destination_station_name = any(path)
        ),
DP AS(
    SELECT Reaches_two_hops.source_station_name, Reaches_two_hops.distance+train_info.distance AS distance
    FROM train_info, Reaches_two_hops
    WHERE train_info.destination_station_name = Reaches_two_hops.source_station_name AND train_info.source_station_name = Reaches_two_hops.destination_station_name
)
SELECT DISTINCT source_station_name, MAX(distance) AS distance
FROM DP
GROUP BY source_station_name
ORDER BY source_station_name asc;


--11--

WITH RECURSIVE Reaches_two_hops(source_station_name,destination_station_name, hop) AS
        (SELECT source_station_name, destination_station_name, 0 
        FROM train_info
    UNION ALL
        SELECT R1.source_station_name, R2.destination_station_name, R1.hop+1
        FROM Reaches_two_hops AS R1, train_info AS R2
        WHERE R1.destination_station_name = R2.source_station_name AND NOT R1.source_station_name = R2.destination_station_name AND R1.hop <= 0
        ),
DP AS(
    SELECT source_station_name, COUNT(*) as total
    FROM Reaches_two_hops
    GROUP BY source_station_name
),
DP1 AS(
    SELECT DISTINCT source_station_name
    FROM train_info
    GROUP BY source_station_name
)
SELECT DP.source_station_name
FROM DP, DP1
WHERE DP.total = (SELECT COUNT(*) FROM DP1)-1
ORDER BY source_station_name asc;


--12--

WITH DP AS(
    SELECT DISTINCT awayteamid
    FROM games, teams
    WHERE games.hometeamid = teams.teamid AND teams.name = 'Arsenal'
),

DP1 AS(
    SELECT DISTINCT games.hometeamid
    FROM games, DP
    WHERE games.awayteamid = DP.awayteamid
),

DP2 AS(
    SELECT DISTINCT teams.name
    FROM DP1, teams
    WHERE DP1.hometeamid = teams.teamid AND NOT teams.name = 'Arsenal'
)

SELECT DISTINCT name AS teamnames
FROM DP2
ORDER BY teamnames asc;





--13--

WITH DP AS(
    SELECT DISTINCT awayteamid
    FROM games, teams
    WHERE games.hometeamid = teams.teamid AND teams.name = 'Arsenal'
),

DP1 AS(
    SELECT DISTINCT games.hometeamid, games.year, games.homegoals
    FROM games, DP
    WHERE games.awayteamid = DP.awayteamid
),

DP2 AS(
    SELECT DISTINCT teams.teamid, teams.name, DP1.year
    FROM DP1, teams
    WHERE DP1.hometeamid = teams.teamid AND NOT teams.name = 'Arsenal'
),

DP3 AS(
    SELECT DISTINCT DP2.name as teamnames, DP2.teamid, DP2.year
    FROM games, DP2
    WHERE DP2.year = (SELECT MIN(year) AS year FROM DP2)
), 

DP4 AS(
    SELECT DP3.teamnames, games.hometeamid, SUM(homegoals) AS goals
    FROM DP3, games
    WHERE games.hometeamid = DP3.teamid
    GROUP BY DP3.teamnames, games.hometeamid
),

DP5 AS(
    SELECT DP3.teamnames, games.awayteamid, SUM(awaygoals) AS goals
    FROM DP3, games
    WHERE games.awayteamid = DP3.teamid
    GROUP BY DP3.teamnames, games.awayteamid
),

DP6 AS(
    SELECT DP5.teamnames, (DP5.goals + DP4.goals) AS goals, DP3.year
    FROM DP4, DP5, DP3
    WHERE DP4.teamnames = DP5.teamnames AND DP4.teamnames = DP3.teamnames
)


SELECT * 
FROM DP6
WHERE goals = (SELECT MAX(goals) AS goals FROM DP6)
ORDER BY teamnames asc;



--14--

WITH DP AS(
    SELECT DISTINCT awayteamid
    FROM games, teams
    WHERE games.hometeamid = teams.teamid AND teams.name = 'Leicester'
),

DP1 AS(
    SELECT DISTINCT games.hometeamid, games.year, games.homegoals
    FROM games, DP
    WHERE games.awayteamid = DP.awayteamid AND year = 2015
),

DP2 AS(
    SELECT DISTINCT teams.teamid, teams.name, DP1.year
    FROM DP1, teams
    WHERE DP1.hometeamid = teams.teamid AND NOT teams.name = 'Leicester'
),

DP3 AS(
    SELECT DP2.name AS teamnames, (games.homegoals - games.awaygoals) as goaldiff
    FROM DP2, games
    WHERE games.hometeamid = DP2.teamid AND games.year = 2015 AND (games.homegoals - games.awaygoals) > 3
)

SELECT * 
FROM DP3
ORDER BY goaldiff asc, teamnames asc;

--15--

WITH DP AS(
    SELECT DISTINCT awayteamid
    FROM games, teams
    WHERE games.hometeamid = teams.teamid AND teams.name = 'Valencia'
),

DP1 AS(
    SELECT DISTINCT games.hometeamid
    FROM games, DP
    WHERE games.awayteamid = DP.awayteamid
),

DP2 AS(
    SELECT DISTINCT teams.teamid
    FROM DP1, teams
    WHERE DP1.hometeamid = teams.teamid AND NOT teams.name = 'Valencia'
),


DP3 AS(
    SELECT appearances.playerid, appearances.goals
    FROM games, DP2, appearances
    WHERE DP2.teamid = games.hometeamid  AND appearances.gameid = games.gameid AND games.leagueid = appearances.leagueid
),

DP4 AS(
    SELECT playerid, SUM(goals) AS score
    FROM DP3
    GROUP BY playerid
)


SELECT name as playernames, score
FROM DP4, players
WHERE players.playerid = DP4.playerid AND score = (SELECT MAX(score) AS score FROM DP4)
ORDER BY playernames asc;

--16--


WITH DP AS(
    SELECT DISTINCT awayteamid
    FROM games, teams
    WHERE games.hometeamid = teams.teamid AND teams.name = 'Everton'
),

DP1 AS(
    SELECT DISTINCT games.hometeamid
    FROM games, DP
    WHERE games.awayteamid = DP.awayteamid
),

DP2 AS(
    SELECT DISTINCT teams.teamid
    FROM DP1, teams
    WHERE DP1.hometeamid = teams.teamid AND NOT teams.name = 'Everton'
),


DP3 AS(
    SELECT appearances.playerid, appearances.assists
    FROM games, DP2, appearances
    WHERE DP2.teamid = games.hometeamid AND appearances.gameid = games.gameid AND games.leagueid = appearances.leagueid
),

DP4 AS(
    SELECT playerid, SUM(assists) AS assistscount
    FROM DP3
    GROUP BY playerid
)


SELECT name as playernames, assistscount
FROM DP4, players
WHERE players.playerid = DP4.playerid AND assistscount = (SELECT MAX(assistscount) AS assistscount FROM DP4)
ORDER BY playernames asc;

--17--



WITH DP AS(
    SELECT DISTINCT awayteamid
    FROM games, teams
    WHERE games.hometeamid = teams.teamid AND teams.name = 'AC Milan'
),

DP1 AS(
    SELECT DISTINCT games.hometeamid, games.year
    FROM games, DP
    WHERE games.awayteamid = DP.awayteamid
),

DP2 AS(
    SELECT DISTINCT teams.teamid
    FROM DP1, teams
    WHERE DP1.hometeamid = teams.teamid AND NOT teams.name = 'AC Milan' AND DP1.year = 2016
),


DP3 AS(
    SELECT appearances.playerid, appearances.shots
    FROM games, DP2, appearances
    WHERE DP2.teamid = games.awayteamid AND appearances.gameid = games.gameid AND games.leagueid = appearances.leagueid AND games.year = 2016
),

DP4 AS(
    SELECT playerid, SUM(shots) AS shotscount
    FROM DP3
    GROUP BY playerid
)


SELECT name as playernames, shotscount
FROM DP4, players
WHERE players.playerid = DP4.playerid AND shotscount = (SELECT MAX(shotscount) AS shotscount FROM DP4)
ORDER BY playernames asc;

--18--

/*
WITH DP AS(
    SELECT DISTINCT awayteamid
    FROM games, teams
    WHERE games.hometeamid = teams.teamid AND teams.name = 'AC Milan'
),

DP1 AS(
    SELECT DISTINCT games.hometeamid
    FROM games, DP
    WHERE games.awayteamid = DP.awayteamid
),

DP2 AS(
    SELECT DISTINCT teams.teamid, teams.name
    FROM DP1, teams
    WHERE DP1.hometeamid = teams.teamid AND NOT teams.name = 'AC Milan'
),
DP3 AS(
    SELECT DISTINCT DP2.name, games.year
    FROM games, DP2
    WHERE DP2.teamid = games.hometeamid AND games.year = 2020 AND awaygoals = 0
)
SELECT *
FROM DP3
ORDER BY name asc
LIMIT 5;
*/



WITH DP AS(
    SELECT DISTINCT awayteamid
    FROM games, teams
    WHERE games.hometeamid = teams.teamid AND teams.name = 'AC Milan'
),

DP1 AS(
    SELECT DISTINCT games.hometeamid
    FROM games, DP
    WHERE games.awayteamid = DP.awayteamid
),

DP2 AS(
    SELECT DISTINCT teams.teamid, teams.name
    FROM DP1, teams
    WHERE DP1.hometeamid = teams.teamid AND NOT teams.name = 'AC Milan'
),

DP3 AS(
    SELECT DP2.teamid, DP2.name, games.year, games.awaygoals
    FROM games, DP2
    WHERE DP2.teamid = games.hometeamid AND games.year = 2020
),

DP4 AS(
    SELECT teamid, name, year, SUM(awaygoals) AS total_awaygoals
    FROM DP3
    GROUP BY  teamid, name, year
)



SELECT name AS teamnames, year
FROM DP4
WHERE total_awaygoals = 0
ORDER BY teamnames asc
LIMIT 5;


--19--


WITH DP AS(
    SELECT gameid, leagueid, hometeamid, awayteamid, SUM(homegoals) as score
    FROM games
    WHERE games.year = 2019
    GROUP BY gameid, leagueid, hometeamid, awayteamid
),

DP1 AS(
    SELECT *
    FROM DP
    WHERE score = (SELECT MAX(score) FROM DP)
),

--20--

WITH RECURSIVE Max_path_length(hometeamid, awayteamid, distance, path) AS
        (SELECT hometeamid, awayteamid, 1, array[hometeamid, awayteamid] as path
        FROM games, teams
        WHERE hometeamid = teams.teamid AND teams.name = 'Manchester United'
    UNION
        SELECT R1.hometeamid, R2.awayteamid, R1.distance+1, array_append(path, R2.awayteamid)
        FROM Max_path_length AS R1, games AS R2, teams
        WHERE R1.awayteamid = R2.hometeamid AND NOT R2.awayteamid = any(path) 
        )
SELECT DISTINCT MAX(distance) as count
FROM Max_path_length, teams
WHERE awayteamid = teams.teamid AND teams.name = 'Manchester City';




--21--


WITH RECURSIVE Max_path_length(hometeamid, awayteamid, distance, path) AS
        (SELECT hometeamid, awayteamid, 1, array[hometeamid, awayteamid] as path
        FROM games, teams
        WHERE hometeamid = teams.teamid AND teams.name = 'Manchester United'
    UNION
        SELECT R1.hometeamid, R2.awayteamid, R1.distance+1, array_append(path, R2.awayteamid)
        FROM Max_path_length AS R1, games AS R2, teams
        WHERE R1.awayteamid = R2.hometeamid AND NOT R2.awayteamid = any(path)
        )


SELECT count(*) as count
FROM Max_path_length, teams
WHERE awayteamid = teams.teamid AND teams.name = 'Manchester City';



-- WITH RECURSIVE Max_path_length(hometeamid, awayteamid, distance) AS
--         (SELECT hometeamid, awayteamid, 1
--         FROM games, teams
--         WHERE hometeamid = teams.teamid AND teams.name = 'Manchester United'
--     UNION ALL
--         SELECT R1.hometeamid, R2.awayteamid, R1.distance+1
--         FROM Max_path_length AS R1, games AS R2, teams
--         WHERE R1.awayteamid = R2.hometeamid /*AND R2.awayteamid NOT IN (SELECT hometeamid FROM R1)*/ /*AND R1.distance <= 1*/
--         )
-- SELECT DISTINCT count(*) as count
-- FROM Max_path_length, teams
-- WHERE awayteamid = teams.teamid AND teams.name = 'Manchester City';

--22--


