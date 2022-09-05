USE HospitalTest
GO
-- delete procedures

CREATE OR ALTER PROCEDURE Delete_From_Table 
@TableName VARCHAR(50)
AS
	--IF @TableName NOT IN (SELECT name
	--					    FROM sys.objects
	--						WHERE type = 'U')
	--BEGIN
	--	PRINT 'Invalid table name!'
	--	RETURN
	--END

	DECLARE @deleteAction NVARCHAR(100)
	SET @deleteAction = 'DELETE FROM ' + @TableName

	EXECUTE sp_executesql @deleteAction
GO