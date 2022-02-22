----------------------------------
-- Author       : Shawn Long
-- Create Date  : Feb 22, 2022
-- Modify Date  : Feb 22, 2022
-- Description  : CS 166 - Lab 6
-----------------------------------

-- DATABASE SCHEMA
-- suppliers ( sid NUMERIC(9 ,0) PRIMARY KEY,
--     sname CHAR(30), address CHAR(40));

-- parts ( pid NUMERIC(9 ,0) PRIMARY KEY, 
--     pname CHAR(40), color CHAR(15));

-- catalog ( sid NUMERIC(9 ,0) , pid NUMERIC(9,0), 
--     cost NUMERIC(10,2), 
--     PRIMARY KEY(sid ,pid), 
--     FOREIGN KEY( sid ) REFERENCES Suppliers , 
--     FOREIGN KEY( pid ) REFERENCES Parts ) ;

-- Query 1:
-- Find the total number of parts
-- supplied by each supplier.

SELECT S.sid, S.sname, count(C.pid) AS part_count
FROM catalog C, suppliers S
WHERE C.sid = S.sid
GROUP BY S.sid, S.sname
ORDER BY S.sid;

-- Query 2:
-- Find the total number of parts supplied
-- by each suppier who supplies at least
-- 3 parts.

SELECT S.sid, S.sname, count(C.pid)
FROM catalog C, suppliers S
WHERE C.sid = S.sid
GROUP BY S.sid, S.sname
HAVING count(C.pid) >= 3
ORDER BY S.sid;

-- Query 3:
-- For every supplier that supplies only
-- green parts, print the name of the
-- supplier and the total number of parts
-- that he supplies.

SELECT S.sid, S.sname, count(C.pid)
FROM catalog C, suppliers S
WHERE C.sid = S.sid AND S.sid IN 
    (SELECT C2.sid
     FROM catalog C2, parts P2
     WHERE C2.pid = P2.pid AND P2.color = 'Green')
GROUP BY S.sid, S.sname
ORDER BY S.sid;

-- Query 4:
-- For every supplier that supplies green
-- parts and red parts, print the name of
-- the supplier and the price of the most
-- expensive part that he supplies.

SELECT S.sname, MAX(C.cost)
FROM  catalog C, suppliers S
WHERE C.sid = S.sid AND S.sid IN (
    -- Suppliers with Green Parts
    (SELECT DISTINCT C2.sid
    FROM catalog C2, parts P2
    WHERE C2.pid = P2.pid AND P2.color = 'Green')

    INTERSECT

    -- Suppliers with Red Parts
    (SELECT DISTINCT C3.sid
    FROM catalog C3, parts P3
    WHERE C3.pid = P3.pid AND P3.color = 'Red')
)
GROUP BY S.sname;

-- Query 5:
-- Find the name of parts with cost lower than "___"

SELECT DISTINCT P.pname
FROM catalog C, parts P
WHERE C.pid = P.pid AND C.cost <= 10;

-- Query 6:
-- Find the address of the suppliers who supply "___" (pname)
SELECT Distinct S.sname
FROM catalog C, suppliers S, parts P
WHERE C.sid = S.sid AND P.pid = C.pid 
    AND P.pname = 'Fire Hydrant Cap';
    