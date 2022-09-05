
CREATE DATABASE Hospital

USE Hospital

CREATE TABLE Department
(DeptID INT PRIMARY KEY,
DeptName VARCHAR(50),
Capacity INT)

CREATE TABLE Doctor
(DocID INT PRIMARY KEY,
FName VARCHAR(50),
LName VARCHAR(50),
CNP CHAR(14) UNIQUE,
Specialty VARCHAR(50),
DeptID INT,
FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
Score TINYINT)

ALTER TABLE Doctor
ADD Salary INT DEFAULT 3000
WITH VALUES

CREATE TABLE Manager
(ManagerID INT PRIMARY KEY,
DeptID INT UNIQUE FOREIGN KEY REFERENCES Department(DeptID),
ManName VARCHAR(50),
PhoneNo CHAR(10))

CREATE TABLE Room
(DeptID INT,
FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
RoomNumber INT PRIMARY KEY,
RoomFloor TINYINT,
RoomType VARCHAR(50))


CREATE TABLE InsuranceCompany
(CompanyID INT IDENTITY(1,1) PRIMARY KEY,
Email VARCHAR(50),
Funds INT, 
CompanyAddress VARCHAR(50))


CREATE TABLE Patient
(PatientID INT PRIMARY KEY,
PatientName VARCHAR(70),
DateOfBirth DATE,
PhoneNo CHAR(10),
Email VARCHAR(50),
InsuranceID INT FOREIGN KEY REFERENCES InsuranceCompany(CompanyID))


CREATE TABLE Doctor_Treats_Patient
(DoctorID INT FOREIGN KEY REFERENCES Doctor(DocID),
PatientID INT FOREIGN KEY REFERENCES Patient(PatientID),
PRIMARY KEY (DoctorID, PatientID),
Illness VARCHAR(50),
Treatment VARCHAR(100))

ALTER TABLE Doctor_Treats_Patient
ADD MedicationID INT

ALTER TABLE Doctor_Treats_Patient
ADD FOREIGN KEY (MedicationID) REFERENCES Medication(MedicationID)

CREATE TABLE MedicalRecord
(PatientID INT PRIMARY KEY FOREIGN KEY REFERENCES Patient(PatientID),
BloodType VARCHAR(10),
ChronicDiseases VARCHAR(200),
Allergies VARCHAR(200))

ALTER TABLE MedicalRecord
DROP CONSTRAINT FK__MedicalRe__Patie__02FC7413

ALTER TABLE MedicalRecord
ADD CONSTRAINT FK__MedicalRe__Patie__02FC7413
FOREIGN KEY(PatientID) REFERENCES Patient(PatientID)
ON DELETE CASCADE


CREATE TABLE MedicalProcedure
(
DoctorID INT,
PatientID INT,
FOREIGN KEY (DoctorID, PatientID) REFERENCES Doctor_Treats_Patient(DoctorID, PatientID),
RoomNumber INT FOREIGN KEY REFERENCES Room(RoomNumber),
ProcName VARCHAR(100),
Cost INT, 
StartTime TIME,
EndTime TIME,
ProcDate DATE,
PRIMARY KEY (DoctorID, PatientID, ProcDate, StartTime))


CREATE TABLE Nurse
(NurseID INT,
FName VARCHAR(50),
LName VARCHAR(50),
CNP CHAR(14) UNIQUE,
Specialty VARCHAR(50),
DeptID INT FOREIGN KEY REFERENCES Department(DeptID),
BossID INT FOREIGN KEY REFERENCES Doctor(DocID),
PRIMARY KEY(NurseID, DeptID))

USE Hospital

CREATE TABLE Medication
(MedicationID INT PRIMARY KEY,
ActiveSubstance VARCHAR(50))


CREATE TABLE Supplier
(SupplierID INT PRIMARY KEY,
Email VARCHAR(50),
PhoneNo VARCHAR(13),
SupplierAddress VARCHAR(100))

ALTER TABLE Supplier
ADD SupplierName VARCHAR(100)


CREATE TABLE Medication_Supplier
(MedicationID INT FOREIGN KEY REFERENCES Medication(MedicationID),
SupplierID INT FOREIGN KEY REFERENCES Supplier(SupplierID),
MedName VARCHAR(50),
Price INT,
LOT INT,
UseByDate DATE,
InStock INT,
PRIMARY KEY (MedicationID, SupplierID, LOT))

