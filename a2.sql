SET search_path TO A2;

--If you define any views for a question (you are encouraged to), you must drop them
--after you have populated the answer table for that question.
--Good Luck!

--Query 1
--Find pname and tname of all champions where players country is same as tournamement country
CREATE VIEW PlayerTournament AS 
SELECT pname, tname, p.cid 
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

--Fidn the tournaments with the most capacity, report multiple if more than 1
CREATE VIEW MaxCapacity AS 
SELECT tid, totalCapacity 
FROM TotalCapacity t1 
WHERE NOT EXISTS 
	(SELECT * FROM TotalCapacity t2 
	WHERE t1.tid <> t2.tid AND t1.totalCapacity < t2.totalCapacity);

INSERT INTO query2
(SELECT tname, totalCapacity 
FROM tournament t, MaxCapacity 
WHERE t.tid = MaxCapacity.tid 
ORDER BY tname);

DROP VIEW IF EXISTS TotalCapacity, MaxCapacity;

--Query 3
--INSERT INTO query3

--Query 4
--Find the number of distinct tournament a player has been a champion of
CREATE VIEW NumDistinctChampion AS 
SELECT pid, count(distinct tid) AS champions
FROM champion 
GROUP BY pid;

CREATE VIEW NumTournaments AS 
SELECT count(distinct tid) AS tournaments 
FROM Tournament;

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
GROUP BY pid 
HAVING count(distinct pid) <= 10 
ORDER BY avgwins DESC LIMIT 10;

INSERT INTO query5
(SELECT player.pid, pname, avgwins
FROM player, avgwin
WHERE player.pid = avgwin.pid
ORDER BY avgwins DESC LIMIT 10);

DROP VIEW IF EXISTS avgwins;

--Query 6
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

CREATE VIEW IncreasingWins AS
SELECT Wins2011.pid FROM Wins2011, Wins2012, Wins2013, Wins2014 
WHERE Wins2011.wins < Wins2012.wins AND Wins2012.wins < Wins2013.wins AND Wins2013.wins < Wins2014.wins 
AND Wins2011.pid = Wins2012.pid AND Wins2012.pid = Wins2013.pid AND Wins2013.pid = Wins2014.pid;

INSERT INTO query6
(SELECT pname, player.pid
FROM player, IncreasingWins
WHERE player.pid = IncreasingWins.pid
ORDER BY pname);

DROP VIEW IF EXISTS Wins2011, Wins2012, Wins2013, Wins2014, IncreasingWins;

--Query 7
INSERT INTO query7

--Query 8
INSERT INTO query8

--Query 9
INSERT INTO query9

--Query 10
INSERT INTO query10

