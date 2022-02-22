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
    (SELECT sid
     FROM catalog C, parts P
     WHERE C.pid = P.pid AND P.color = 'Green')
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
    (SELECT DISTINCT C.sid
    FROM catalog C, parts P
    WHERE C.pid = P.pid AND P.color = 'Green')

    INTERSECT

    -- Suppliers with Red Parts
    (SELECT C.sid
    FROM catalog C, parts P
    WHERE C.pid = P.pid AND P.color = 'Red')
)
GROUP BY S.sname;
