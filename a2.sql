SET search_path TO A2;

--If you define any views for a question (you are encouraged to), you must drop them
--after you have populated the answer table for that question.
--Good Luck!

--Query 1
--Find pname and tname of all champions where players country is same as tournamement country
CREATE VIEW PlayerTournament AS 
SELECT DISTINCT p.pid, t.tid, pname, tname, p.cid 
FROM tournament t, player p, champion c
WHERE p.pid = c.pid AND t.tid = c.tid AND p.cid = t.cid;

INSERT INTO query1
(SELECT pname, cname, tname 
FROM PlayerTournament pt, country c 
WHERE pt.cid = c.cid 
ORDER BY pname);

DROP VIEW IF EXISTS PlayerTournament;

--Query 2
--Find the total capacity of all the courts in each tournament
CREATE VIEW TotalCapacity AS 
SELECT tid, sum(capacity) AS totalCapacity 
FROM court 
GROUP BY tid;

--Find the tournaments with the most capacity, report multiple if more than 1
CREATE VIEW MaxCapacity AS 
SELECT tid, totalCapacity 
FROM TotalCapacity 
WHERE totalCapacity = (SELECT max(totalCapacity) FROM TotalCapacity);

INSERT INTO query2
(SELECT tname, totalCapacity 
FROM tournament t, MaxCapacity 
WHERE t.tid = MaxCapacity.tid 
ORDER BY tname);

DROP VIEW IF EXISTS TotalCapacity, MaxCapacity;

--Query 3
--Find all pairs of players that has played with each other
CREATE VIEW eachother AS
(SELECT winid as p1id, lossid as p2id FROM event) 
UNION 
(SELECT lossid as p1id, winid as p2id FROM event);

--Find all highest ranking each player met (highest rank = lowest rank number)
CREATE VIEW highrankopponent AS 
SELECT p1id, min(globalrank) as highestrank
FROM eachother e, player p 
WHERE e.p2id = p.pid
GROUP BY p1id;

--Find the highest ranking opponent for each player he/she has faced against

INSERT INTO query3
(SELECT p1id, p1.pname AS p1name, p2.pid, p2.pname AS p2name
FROM player p1, player p2, highrankopponent
WHERE p1id = p1.pid AND p2.globalrank = highestrank
ORDER BY p1.pname);

DROP VIEW IF EXISTS eachother, highrankopponent;

--Query 4
--Find the number of distinct tournament a player has been a champion of
CREATE VIEW NumDistinctChampion AS 
SELECT pid, count(distinct tid) AS champions
FROM champion 
GROUP BY pid;

--Count the number of tournaments
CREATE VIEW NumTournaments AS 
SELECT count(tid) AS tournaments
FROM Tournament;

--Check if the distinct number of champions matches with total number of tournaments overall
CREATE VIEW EveryTournament AS
(SELECT pid, champions
FROM NumTournaments t, NumDistinctChampion c
WHERE t.tournaments = c.champions);

INSERT INTO query4
(SELECT p.pid, pname 
FROM EveryTournament e, player p
WHERE p.pid = e.pid
ORDER BY pname);

DROP VIEW NumTournaments, NumDistinctChampion, EveryTournament;

--Query 5
--Find the pid with top ten win averages from 2011 to 2014 inclusively
CREATE VIEW avgwin AS
SELECT pid, avg(wins) as avgwins 
FROM record 
WHERE year >= 2011 AND year <= 2014 
GROUP BY pid;

INSERT INTO query5
(SELECT player.pid, pname, avgwins
FROM player, avgwin
WHERE player.pid = avgwin.pid
ORDER BY avgwins DESC LIMIT 10);

DROP VIEW IF EXISTS avgwin;

--Query 6
--Find the number of wins for each year. Report its pid. 
CREATE VIEW Wins2011 AS
SELECT pid, wins
FROM record
WHERE year = 2011;

CREATE VIEW Wins2012 AS
SELECT pid, wins
FROM record
WHERE year = 2012;

CREATE VIEW Wins2013 AS
SELECT pid, wins
FROM record
WHERE year = 2013;

CREATE VIEW Wins2014 AS
SELECT pid, wins
FROM record
WHERE year = 2014;

--Check if the wins are strictly increasing. 
CREATE VIEW IncreasingWins AS
SELECT Wins2011.pid FROM Wins2011, Wins2012, Wins2013, Wins2014
WHERE Wins2011.pid = Wins2012.pid AND Wins2012.pid = Wins2013.pid AND Wins2013.pid = Wins2014.pid
AND Wins2011.wins < Wins2012.wins AND Wins2012.wins < Wins2013.wins AND Wins2013.wins < Wins2014.wins;

INSERT INTO query6
(SELECT player.pid, pname
FROM player, IncreasingWins
WHERE player.pid = IncreasingWins.pid
ORDER BY pname);

DROP VIEW IF EXISTS Wins2011, Wins2012, Wins2013, Wins2014, IncreasingWins;

--Query 7
--Find the players who achieved a champion at least twice in a single year
--Note that since (year, tid) is the key, if the year must be the same, tid must be different from each other.
CREATE VIEW AtLeastTwice AS
SELECT pid, year
FROM champion
GROUP BY pid, year
HAVING count(*) >= 2;

INSERT INTO query7
(SELECT pname, year
FROM player p, AtLeastTwice a 
WHERE p.pid = a.pid 
ORDER BY pname DESC, year DESC);

DROP VIEW IF EXISTS AtLeastTwice;

--Query 8
--Find all pairs of players that has played with each other - already removes duplicates
CREATE VIEW eachother AS
(SELECT winid as p1, lossid as p2 FROM event) 
UNION 
(SELECT lossid as p1, winid as p2 FROM event);

--Find all pairs where both players are from the same country
CREATE VIEW samecountry AS
SELECT p1.cid, p1.pname AS p1name, p2.pname AS p2name
FROM player p1, player p2, eachother 
WHERE p1.pid = p1 AND p2.pid = p2 AND p1.cid = p2.cid;

INSERT INTO query8
(SELECT p1name, p2name, cname
FROM samecountry s, country c
WHERE s.cid = c.cid
ORDER BY cname ASC, p1name DESC);

DROP VIEW IF EXISTS samecountry, eachother;

--Query 9
--Count the number of champions a country has won
CREATE VIEW countrychamp AS
SELECT cid, count(p.pid) AS champions 
FROM champion c, player p 
WHERE c.pid = p.pid 
GROUP BY cid;

INSERT INTO query9
(SELECT cname, champions 
FROM countrychamp m, country c
WHERE c.cid = m.cid AND m.champions = (SELECT max(champions) FROM countrychamp)
ORDER BY cname DESC);

DROP VIEW IF EXISTS countrychamp;

--Query 10
--Find all durations of each even from each players both winning and losing sides
CREATE VIEW eventduration AS
(SELECT winid AS pid, duration FROM event) 
UNION ALL 
(SELECT lossid as pid, duration FROM event);

--Find all the players with avg play time of more than 200 minutes
CREATE VIEW averagetime AS
SELECT pid, avg(duration) as avgtime 
FROM eventduration 
GROUP BY pid 
HAVING avg(duration) > 200;

--Find all players who have more wins than losses in 2014
CREATE VIEW winsoverlosses AS
SELECT pid FROM record 
WHERE year = 2014 AND wins > losses;

--Find the set of players who have both more wins over losses and have avg time of over 200
CREATE VIEW intersection AS
(SELECT pid FROM averagetime) 
INTERSECT 
(SELECT pid FROM winsoverlosses);

INSERT INTO query10
(SELECT pname 
FROM player p, intersection i
WHERE p.pid = i.pid
ORDER BY pname DESC);

DROP VIEW IF EXISTS averagetime, winsoverlosses, intersection;

