USE Hospital
-- modify the type of a column : Modify the column Score from Doctor (which now is TINYINT) such that it will be a float number with
--2 decimals.
GO

CREATE OR ALTER PROCEDURE Set_DoctorScore_Type_Decimal 
AS
	ALTER TABLE Doctor
	ALTER COLUMN Score DECIMAL(4,2)
GO

   --reverse:

CREATE OR ALTER PROCEDURE Set_DoctorScore_Type_Tinyint 
AS
	ALTER TABLE Doctor
	ALTER COLUMN Score TINYINT
GO

-- add/remove a column : Add a level of professional training for Doctors (VARCHAR). (For example: resident, specialist, primary doctor).

CREATE OR ALTER PROCEDURE Add_TrainingLevel_On_Doctor
AS
	ALTER TABLE Doctor
	ADD TrainingLevel VARCHAR(30)
GO

	--reverse:

CREATE OR ALTER PROCEDURE Remove_TrainingLevel_From_Doctor
AS
	ALTER TABLE Doctor
	DROP COLUMN TrainingLevel
GO

-- add/remove a DEFAULT constraint : Add a default capacity of 10 (for Department).

CREATE OR ALTER PROCEDURE Add_DefaultCapacity_On_Department
AS
	ALTER TABLE Department
	ADD CONSTRAINT Default_Dept_Capacity
	DEFAULT 10 FOR Capacity
GO

	--reverse:

CREATE OR ALTER PROCEDURE Remove_DefaultCapacity_From_Department
AS
	ALTER TABLE Department
	DROP Default_Dept_Capacity
GO

-- add/remove a primary key : Remove the primary key formed by Nurse ID in Nurse.

CREATE OR ALTER PROCEDURE Remove_PrimaryKey_From_Nurse
AS
	ALTER TABLE Nurse
	DROP CONSTRAINT PK__Nurse__4384786938E47B2A
GO

	--reverse:
CREATE OR ALTER PROCEDURE Add_PrimaryKey_On_Nurse
AS
	ALTER TABLE Nurse
	ADD CONSTRAINT PK__Nurse__4384786938E47B2A
	PRIMARY KEY(NurseID)
GO


-- add/remove a candidate key : Remove CNP uniqueness constraint from Doctor.

CREATE OR ALTER PROCEDURE Remove_UniqueCNP_From_Doctor
AS
	ALTER TABLE Doctor
	DROP CONSTRAINT UQ__Doctor__C1FF677D9DE72B51
GO
	
	--reverse:

CREATE OR ALTER PROCEDURE Add_UniqueCNP_On_Doctor
AS
	ALTER TABLE Doctor
	ADD CONSTRAINT UQ__Doctor__C1FF677D9DE72B51
	UNIQUE(CNP)
GO

-- add/remove a foreign key : The room number will not be a foriegn key in MedicalProcedure table.

CREATE OR ALTER PROCEDURE Remove_ForeignKey_RoomNumber_In_MedicalProcedure
AS
	ALTER TABLE MedicalProcedure
	DROP CONSTRAINT FK__MedicalPr__RoomN__1F98B2C1
GO

	--reverse:

CREATE OR ALTER PROCEDURE Add_ForeignKey_RoomNumber_In_MedicalProcedure
AS
	ALTER TABLE MedicalProcedure
	ADD CONSTRAINT FK__MedicalPr__RoomN__1F98B2C1
	FOREIGN KEY (RoomNumber) REFERENCES Room(RoomNumber)
GO

-- create/drop table : Remove table Manager.

CREATE OR ALTER PROCEDURE Remove_Table_Manager
AS
	DROP TABLE Manager
GO

	--reverse:

CREATE OR ALTER PROCEDURE Create_Table_Manager
AS
	CREATE TABLE Manager
	(ManagerID INT PRIMARY KEY,
	DeptID INT UNIQUE FOREIGN KEY REFERENCES Department(DeptID),
	ManName VARCHAR(50),
	PhoneNo CHAR(10))
GO

CREATE TABLE DBVersion
(ProcName VARCHAR(70) PRIMARY KEY,
FromVersion INT,
ToVersion INT)

INSERT INTO DBVersion(ProcName, FromVersion, ToVersion)
VALUES
	('Set_DoctorScore_Type_Decimal', 0, 1),
	('Set_DoctorScore_Type_Tinyint', 1, 0),
	('Add_TrainingLevel_On_Doctor', 1, 2),
	('Remove_TrainingLevel_From_Doctor', 2, 1),
	('Add_DefaultCapacity_On_Department', 2, 3),
	('Remove_DefaultCapacity_From_Department', 3, 2),
	('Remove_PrimaryKey_From_Nurse', 3, 4),
	('Add_PrimaryKey_On_Nurse', 4, 3),
	('Remove_UniqueCNP_From_Doctor', 4, 5),
	('Add_UniqueCNP_On_Doctor', 5, 4),
	('Remove_ForeignKey_RoomNumber_In_MedicalProcedure', 5, 6),
	('Add_ForeignKey_RoomNumber_In_MedicalProcedure', 6, 5),
	('Remove_Table_Manager', 6, 7),
	('Create_Table_Manager', 7, 6)

SELECT *
FROM DBVersion
ORDER BY FromVersion


CREATE TABLE CurrentVersion
(VersionNr INT)

INSERT INTO CurrentVersion(VersionNr)
VALUES (0)

SELECT *
FROM CurrentVersion

GO

CREATE OR ALTER PROCEDURE Bring_To_Version (@versionNumber INT)
AS
BEGIN
		DECLARE @currentVersion INT
		DECLARE @procToExec VARCHAR(70)
		DECLARE @currentVersionAux INT

		SET @currentVersion = (SELECT VersionNr
							   FROM CurrentVersion)

		IF (@versionNumber NOT IN (SELECT FromVersion
								   FROM DBVersion))
		BEGIN
			PRINT 'Invalid version number!'
			RETURN
		END
		ELSE IF (@versionNumber = @currentVersion)
		BEGIN
			PRINT 'The provided version is the current one!'
			RETURN
		END

		ELSE IF (@versionNumber > @currentVersion)
			WHILE (@versionNumber > @currentVersion)
			BEGIN
				PRINT 'Current version is ' + CAST(@currentVersion AS VARCHAR)

				SELECT @procToExec =  ProcName, @currentVersionAux = ToVersion
				FROM DBVersion
				WHERE FromVersion = @currentVersion AND FromVersion < ToVersion

				SET @currentVersion = @currentVersionAux

				PRINT 'Executing ' + @procToExec + ' to get to version ' + CAST(@currentVersion AS VARCHAR) + '...'
				EXEC @procToExec
			END	

		ELSE IF (@versionNumber < @currentVersion)
			WHILE (@versionNumber < @currentVersion)
			BEGIN
				PRINT 'Current version is ' + CAST(@currentVersion AS VARCHAR) 

				SELECT @procToExec = ProcName, @currentVersionAux = ToVersion
				FROM DBVersion
				WHERE FromVersion = @currentVersion AND FromVersion > ToVersion

				SET @currentVersion = @currentVersionAux

				PRINT 'Executing ' + @procToExec + ' to get to version ' + CAST(@currentVersion AS VARCHAR) + '...'
				EXEC @procToExec
			END
		

		UPDATE CurrentVersion
		SET VersionNr = @versionNumber

		PRINT 'Current version is ' + CAST(@versionNumber AS VARCHAR) 
END
GO

EXEC Bring_To_Version 5
