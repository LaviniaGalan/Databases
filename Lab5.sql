CREATE DATABASE Generic
USE Generic

CREATE TABLE Ta
(aid INT PRIMARY KEY,
a2 INT UNIQUE,
a3 VARCHAR(50))

CREATE TABLE Tb
(bid INT PRIMARY KEY,
b2 INT,
b3 VARCHAR(50))

CREATE TABLE Tc
(cid INT PRIMARY KEY,
aid INT FOREIGN KEY REFERENCES Ta(aid),
bid INT FOREIGN KEY REFERENCES Tb(bid))

GO
CREATE OR ALTER PROCEDURE Populate_Tables @NoOfRows INT
AS
	DELETE FROM Tc
	DELETE FROM Ta
	DELETE FROM Tb

	DECLARE @CurrentRow INT = 1
	DECLARE @MultiplyFactor INT 
	DECLARE @InsertAction VARCHAR(2000)

	
	WHILE @CurrentRow <= @NoOfRows
	BEGIN
		INSERT INTO Ta VALUES (@CurrentRow, @CurrentRow * 10, 'text')
		INSERT INTO Tb VALUES (@CurrentRow, @CurrentRow * 100, 'text')
		INSERT INTO Tc VALUES (@CurrentRow, @CurrentRow, @CurrentRow)
		SET @CurrentRow = @CurrentRow + 1
	END
GO

EXEC Populate_Tables 10000
SELECT * FROM Ta
SELECT * FROM Tb
SELECT * FROM Tc


-- a. Write queries on Ta such that their execution plans contain the following operators:

-- clustered index scan: (we want all the rows, so the clustered index for aid will be scanned)
SELECT *
FROM Ta

-- clustered index seek: (we don't need to go through all the rows, we want just the rows that satisfy the condition for aid, so a seek will be performed on the cluster index for aid)
SELECT *
FROM Ta
WHERE aid = 4

-- nonclustered index scan: (we want for all the rows only the column a2, for which a nonclustered index was created, so that nonclustered index will be scanned) 
SELECT a2
FROM Ta
ORDER BY a2

-- nonclustered index seek: (we want the values for the column a2 for the entries that satisfy a certain condition on a2, so a seek will be performed on the nonclustered index for a2)
SELECT a2
FROM Ta
WHERE a2 < 20

-- key lookup: (we have a certain condition for a2, but we need all the information for that row, not only the a2 value, so a key lookup will be performed)
SELECT *
FROM Ta
WHERE a2 = 20

-- b.  Write a query on table Tb with a WHERE clause of the form WHERE b2 = value and analyze its execution plan. 
-- Create a nonclustered index that can speed up the query. Examine the execution plan again.

DROP INDEX NonCl_Idx_Tb_b2 ON Tb

SELECT b2
FROM Tb
WHERE b2 = 300

CREATE NONCLUSTERED INDEX NonCl_Idx_Tb_b2 ON Tb(b2)

SELECT b2
FROM Tb
WHERE b2 = 300
GO

-- c. Create a view that joins at least 2 tables. 
-- Check whether existing indexes are helpful; if not, reassess existing indexes / examine the cardinality of the tables.

CREATE OR ALTER VIEW View1
AS
	SELECT Tc.bid, Tb.b2
	FROM Tc
	INNER JOIN Tb ON Tb.bid = Tc.bid
	WHERE Tb.b2 = 500
GO

SELECT *
FROM View1

GO












CREATE OR ALTER VIEW View2
AS
	SELECT  Tc.cid, Tc.aid, Ta.aid AS Ta_aid
	FROM Ta INNER JOIN Tc ON Ta.aid = Tc.aid
	WHERE Tc.aid > 100
GO

SELECT *
FROM View2

CREATE NONCLUSTERED INDEX NonCl_Idx_Tc_aid ON Tc(aid)

DROP INDEX NonCl_Idx_Tc_aid ON Tc

