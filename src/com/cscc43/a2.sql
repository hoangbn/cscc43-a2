SET search_path TO A2;

--If you define any views for a question (you are encouraged to), you must drop them
--after you have populated the answer table for that question.
--Good Luck!

--Query 1
--Find pname and tname of all champions where players country is same as tournamement country
CREATE VIEW PlayerTournament AS 
SELECT pname, tname, p.cid 
FROM a2.tournament t, a2.player p, a2.champion c
WHERE p.pid = c.pid AND t.tid = c.tid AND p.cid = t.cid;

INSERT INTO query1
(SELECT pname, cname, tname 
FROM PlayerTournament pt, a2.country c 
WHERE pt.cid = c.cid 
ORDER BY pname);

DROP VIEW IF EXISTS PlayerTournament;

--Query 2
--Find the total capacity of all the courts in each tournament
CREATE VIEW TotalCapacity AS 
SELECT tid, sum(capacity) AS totalCapacity 
FROM a2.court 
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
FROM a2.tournament t, MaxCapacity 
WHERE t.tid = MaxCapacity.tid 
ORDER BY tname);

DROP VIEW IF EXISTS TotalCapacity, MaxCapacity;

--Query 3
--INSERT INTO query3

--Query 4
--Find the number of distinct tournament a player has been a champion of
CREATE VIEW NumDistinctChampion AS 
SELECT pid, count(distinct tid) AS champions
FROM a2.champion 
GROUP BY pid;

CREATE VIEW NumTournaments AS 
SELECT count(distinct tid) AS tournaments 
FROM a2.Tournament;

CREATE VIEW EveryTournament AS
(SELECT pid, champions
FROM NumTournaments t, NumDistinctChampion c
WHERE t.tournaments = c.champions);

INSERT INTO a2.query4
(SELECT p.pid, pname 
FROM EveryTournament e, a2.player p
WHERE p.pid = e.pid
ORDER BY pname);

DROP VIEW NumTournaments, NumDistinctChampion, EveryTournament;

--Query 5
--INSERT INTO query5

--Query 6
INSERT INTO query6

--Query 7
INSERT INTO query7

--Query 8
INSERT INTO query8

--Query 9
INSERT INTO query9

--Query 10
INSERT INTO query10

