--Invalid insert

--Trying to insert a doctor with an already existent id
INSERT INTO Doctor(DocID, FName, LName, CNP, Specialty, DeptID, Score)
VALUES (9801, 'Moris', 'Mikhail', '80723844682479', 'Pneumolog', 12345, 9)

--Trying to insert a patient with an invalid insurance id (non existent foreign key)
INSERT INTO Patient(PatientID, PatientName, DateOfBirth, PhoneNo, Email, InsuranceID)
VALUES (305, 'Michael Wayne', '5-29-98', '0789653736', 'mick@yahoo.com', 99)

--Update

--We discover that the patient with id 106 is allergic to Metformin. Update his medical record, so we can be aware of his allergy.
UPDATE MedicalRecord
SET Allergies = 'Metformin'
WHERE PatientID = 106

--Make the specialty of the nurses with unknown specialty being "general".
UPDATE Nurse
SET Specialty = 'General'
WHERE Specialty IS NULL

--Increase the price of the procedures made in the Christmas holiday by 10%.
UPDATE MedicalProcedure 
SET Cost = Cost*1.10
WHERE ProcDate BETWEEN '2020-12-24' AND '2021-01-02'

--Increase the salary of the doctors having a score greater or equal than 9.
UPDATE Doctor
SET Salary = Salary+500
WHERE Score >= 9

--Doctor Abel Schwarz from the Oncology department has just saved two people. We should increase its score by 1, if it is possible.
UPDATE Doctor
SET Score = Score+1
WHERE FName LIKE '%Abel%' AND LName = 'Schwarz'  AND Score <= 9 AND
		DeptID IN (SELECT DeptID
				  FROM Department 
				  WHERE DeptName = 'Oncology')


--Delete

--Delete the registers of the companies that don't insure any patient.
DELETE FROM InsuranceCompany
WHERE CompanyID NOT IN 
	(SELECT InsuranceID
	FROM Patient)

--We've just build a new pediatric hospital. Delete all the minor patients, as they will be treated there.
DELETE FROM Patient
WHERE DATEDIFF(year, Patient.DateOfBirth, GETDATE()) < 18

--a) 2 queries with the union operation; use UNION [ALL] and OR
--Display all the medical staff (doctors or nurses), with id, name and specialty, with no duplicates.

SELECT DISTINCT 'Doctor' AS Type, DocID AS ID, FName, LName, Specialty
FROM Doctor
UNION
SELECT DISTINCT 'Nurse', NurseID, FName, LName, Specialty
FROM Nurse

--Display all the patients that can donate blood to a person having the blood type A(II) (the patient must have the blood
--type A(II) or 0 - universal donor), showing first the patients with blood type A(II).

SELECT P.PatientID, P.PatientName, MR.BloodType, P.PhoneNo
FROM Patient P, MedicalRecord MR
WHERE P.PatientID = MR.PatientID AND (MR.BloodType LIKE '%A(II)%' OR MR.BloodType LIKE '%0%')
ORDER BY MR.BloodType DESC

--b) 2 queries with the intersection operation;  use INTERSECT and IN
--Display all patients (id, name, illness, date of birth, phone number) treated by doctor with id 9801, which are born before 1980.
SELECT P.PatientID, P.PatientName, P.DateOfBirth, P.PhoneNo, DTP.Illness
FROM Patient P, Doctor_Treats_Patient DTP
WHERE DTP.PatientID = P.PatientID AND P.DateOfBirth < '1980-01-01'
INTERSECT
SELECT P.PatientID, P.PatientName, P.DateOfBirth, P.PhoneNo, DTP.Illness
FROM Patient P, Doctor_Treats_Patient DTP
WHERE DTP.PatientID = P.PatientID AND DTP.DoctorID = 9801

--Display all the nurses that don't have the specialty critical care or general, assigned to the oncology department.
SELECT *
FROM Nurse N
WHERE NOT(N.Specialty = 'General' OR N.Specialty = 'Critical care')
	AND N.NurseID IN
		(SELECT N1.NurseID
		FROM Nurse N1, Department DEP
		WHERE N1.DeptID = (SELECT DEP1.DeptID
						   FROM Department DEP1
						   WHERE DEP1.DeptName = 'Oncology'))

--c)2 queries with the difference operation; use EXCEPT and NOT IN;

--Display all the doctors that do not supervise any nurse, with no duplicates.

SELECT DISTINCT *
FROM Doctor D
WHERE DocID NOT IN 
	(SELECT N.SupervisorID
	FROM Nurse N
	WHERE N.SupervisorID IS NOT NULL)

--Display all the departments (with id and name) that don't have any doctor with a score of 10.
SELECT DEP.DeptID, DEP.DeptName
FROM Department DEP
EXCEPT
SELECT DEP.DeptID, DEP.DeptName
FROM Department DEP
WHERE DEP.DeptID IN 
	(SELECT DOC.DeptID
	FROM Doctor DOC
	WHERE DOC.Score = 10)

--d)d. 4 queries with INNER JOIN, LEFT JOIN, RIGHT JOIN, and FULL JOIN (one query per operator); 
--one query will join at least 3 tables, while another one will join at least two many-to-many relationships

--Display the medical record of all the patients that are currently treated in this hospital, together with their id, name, phone
--number, with no duplicates.
--(display the patients, even if their medical record is not stored),
--order descendingly by the patient id.

SELECT DISTINCT P_IJ_DTP.*, MR.BloodType, MR.ChronicDiseases, MR.Allergies
FROM 
    MedicalRecord MR RIGHT JOIN
	(SELECT P.PatientID, P.PatientName, P.PhoneNo
	FROM Patient P INNER JOIN Doctor_Treats_Patient DTP 
	ON P.PatientID = DTP.PatientID) AS P_IJ_DTP
	ON P_IJ_DTP.PatientID = MR.PatientID
ORDER BY P_IJ_DTP.PatientID DESC

--We need to do an emergency surgery! Display all the surgery rooms together with the procedures scheduled for them.
--(show also the rooms in which no procedure will take place)

SELECT *
FROM  (SELECT *
	   FROM Room 
	   WHERE RoomType = 'Surgery') AS R LEFT JOIN MedicalProcedure MP ON R.RoomNumber = MP.RoomNumber

--Display the medication prescribed by doctor pneumolog Ethan Choi and the data of their suppliers.

SELECT DTP_IJ_M.*, MS.MedName, S.*
FROM (SELECT DTP.PatientID, DTP.Illness, DTP.MedicationID, M.ActiveSubstance
	  FROM Doctor_Treats_Patient DTP INNER JOIN Medication M ON DTP.MedicationID = M.MedicationID
	  WHERE DoctorID IN (SELECT DocID
						 FROM Doctor
		    			 WHERE FName = 'Ethan' AND LName = 'Choi' AND Specialty = 'Pneumolog')) AS DTP_IJ_M 
INNER JOIN Medication_Supplier MS ON DTP_IJ_M.MedicationID = MS.MedicationID
INNER JOIN Supplier S ON S.SupplierID = MS.SupplierID

-- Show the personal data of all the medical staff, such that we can see, for each nurse, his/her supervisor.
-- (display also the nurses that don't have a supervisor and the doctors who don't supervise any nurse)

SELECT N.NurseID, N.FName, N.LName, N.CNP, N.Specialty, D.DocID AS Supervisor_DoctorID, D.FName, D.LName, D.CNP, D.Specialty
FROM Nurse N FULL JOIN Doctor D ON D.DocID = N.SupervisorID


--e)2 queries with the IN operator and a subquery in the WHERE clause; 
--in at least one case, the subquery should include a subquery in its own WHERE clause

--Display the medical procedures made at 2nd floor.

SELECT MP.*
FROM MedicalProcedure MP
WHERE MP.RoomNumber IN (SELECT R.RoomNumber
						FROM Room R
						WHERE R.RoomFloor = 2)

--Display all the patients treated by a doctor assigned to the Oncology department.

SELECT P.*, DTP.DoctorID
FROM Patient P INNER JOIN Doctor_Treats_Patient DTP ON P.PatientID = DTP.PatientID
WHERE DTP.DoctorID IN (SELECT D.DocID
						FROM Doctor D
						WHERE D.DeptID = (SELECT DEP.DeptID
										  FROM Department DEP
					         			  WHERE DEP.DeptName = 'Oncology'))

--f)2 queries with the EXISTS operator and a subquery in the WHERE clause

--Display the id, email and adress of the insurance company that insures the patient Michael Wayne.

SELECT IC.CompanyID, IC.Email, IC.CompanyAddress
FROM InsuranceCompany IC
WHERE EXISTS (SELECT *
			  FROM Patient P
			  WHERE P.PatientName = 'Michael Wayne' AND P.InsuranceID = IC.CompanyID)

--Display the best paid two doctors from the oncology department.

SELECT TOP 2 D.*
FROM Doctor D
WHERE EXISTS (SELECT *
			  FROM Department DEP
			  WHERE DEP.DeptName = 'Oncology' AND D.DeptID = DEP.DeptID)
ORDER BY Salary DESC

--g)2 queries with a subquery in the FROM clause

--Display all the departments, togheter with their name and number of doctors, sorted descendingly by the number of doctors.
SELECT DEP.DeptID, DEP1.DeptName, DEP.NoDoctors
FROM (SELECT D.DeptID, Count(*) AS NoDoctors
      FROM Doctor D
      GROUP BY DeptID) AS DEP, Department DEP1
WHERE DEP.DeptID = DEP1.DeptID
ORDER BY NoDoctors DESC

--Display the cheapest medication from every supplier, togheter with the price after applying a discount provided by the National 
--Heath System(30%).

SELECT SP.SupplierID, MS.MedicationID, MS.MedName, MS.Price, MS.Price - 0.3*MS.Price AS PriceAfterDiscount, MS.LOT, MS.UseByDate, MS.InStock
FROM (SELECT SupplierID, MIN(Price) AS Min_price
	  FROM Medication_Supplier
	  GROUP BY SupplierID) AS SP, Medication_Supplier MS
WHERE MS.SupplierID = SP.SupplierID AND MS.Price = SP.Min_price

--Display, for each department, the money they should spend on the salaries of the medical staff in December, knowing that:
--A nurse has a salary of 2000 and they receive a Christmas bonus of 450
--A doctor receives his usual salary + a Christmas bonus equal to 30% of his salary
SELECT DeptID, NoOfDoctors, MoneyForDoctors, NoOfNurses, MoneyForNurses
FROM ((SELECT DeptID, Count(*) AS NoOfDoctors, SUM(1.3*Salary) AS MoneyForDoctors
	   FROM Doctor
	   GROUP BY DeptID) AS DEP_NoDOC
	   FULL JOIN
	   (SELECT DeptID AS DeptID2, Count(*) AS NoOfNurses, Count(*) * 2450.0 AS MoneyForNurses
		FROM Nurse
		GROUP BY DeptID) AS DEP_NoNURSE
		ON DEP_NoDOC.DeptID = DEP_NoNURSE.DeptID2)



--h) 4 queries with the GROUP BY clause, 3 of which also contain the HAVING clause; 
-- 2 of the latter will also have a subquery in the HAVING clause; use the aggregation operators: COUNT, SUM, AVG, MIN, MAX;

-- Find the average salary per department and display the doctors who have a salary greater or equal than the average.

SELECT D1.*, AV_SAL_DEP.AvgSal
FROM Doctor D1 INNER JOIN
				(SELECT D.DeptID, AVG(D.Salary) AS AvgSal
				FROM Doctor D
				GROUP BY D.DeptID) AS AV_SAL_DEP
	ON D1.DeptID = AV_SAL_DEP.DeptID AND D1.Salary >= AvgSal

--Display the most expensive medication from each supplier which provides less than 4 medications.

SELECT SupplierID, MedName, Price, LOT, UseByDate, InStock
FROM Medication_Supplier MS INNER JOIN 
					   (SELECT MAX(Price) AS Max_Price
					    FROM Medication_Supplier
						GROUP BY SupplierID
						HAVING Count(*) < 4) AS MS_ID_MAX
						ON MS.Price = MS_ID_MAX.Max_Price

--Display the patients treated by more than one doctor and the total cost of their procedures.

SELECT DTP.PatientID, Count(*) AS NoOfDoctors, SUM(MP.Cost) AS TotalCost
FROM  Doctor_Treats_Patient DTP INNER JOIN MedicalProcedure MP ON DTP.PatientID = MP.PatientID
GROUP BY DTP.PatientID
HAVING 1 < (SELECT DISTINCT Count(*)
			FROM Doctor_Treats_Patient
			WHERE PatientID = DTP.PatientID)

--Display the departments together with the number of nurses assigned to them,
--which have a number of doctors greater than the minimum number of doctors/department.

SELECT *
FROM
(SELECT DEP.DeptID, Count(*) AS NoOfNurses
FROM Department DEP INNER JOIN Nurse N ON DEP.DeptID = N.DeptID
GROUP BY DEP.DeptID
HAVING DEP.DeptID IN (SELECT DOC_PER_DEP1.DeptID
					  FROM
					  (SELECT MIN(NoOfDoctors) AS MinDoc
					   FROM (SELECT DeptID, Count(*) AS NoOfDoctors
						     FROM Doctor 				        
							 GROUP BY DeptID) AS DOC_PER_DEP) AS MIN_DOC_PER_DEP
					  INNER JOIN
				      (SELECT D.DeptID, Count(*) AS NoOfDoctors
					   FROM Doctor D					        
					   GROUP BY D.DeptID) AS DOC_PER_DEP1
					  ON DOC_PER_DEP1.NoOfDoctors > MIN_DOC_PER_DEP.MinDoc)) AS DEP_NURSES
INNER JOIN
Department DEP1
ON DEP_NURSES.DeptID = DEP1.DeptID



--i) 4 queries using ANY and ALL to introduce a subquery in the WHERE clause (2 queries per operator); 
--rewrite 2 of them with aggregation operators, and the other 2 with IN / [NOT] IN.


--Display all the insurance companies that are not from London and have lower funds than some company in London. Show also
--the funds that they can allocate monthly for covering the costs of the procedures (the funds in the table are per year),
--with 2 decimals.

SELECT *, CONVERT(DECIMAL(10, 2), CAST(Funds AS float)/CAST(12 AS float)) AS 'MonthlyFunds'
FROM InsuranceCompany
WHERE CompanyAddress NOT LIKE ('%London%') AND Funds < ANY (SELECT Funds
															FROM InsuranceCompany
															WHERE CompanyAddress LIKE ('%London'))
--equivalent to
SELECT *, CONVERT(DECIMAL(10, 2), CAST(Funds AS float)/CAST(12 AS float)) AS 'MonthlyFunds'
FROM InsuranceCompany
WHERE CompanyAddress NOT LIKE ('%London%') AND Funds < (SELECT MAX(Funds)
														FROM InsuranceCompany
														WHERE CompanyAddress LIKE ('%London'))

--Display all the managers of the departments (also with the department name) having at least one nurse with the specialty 'General'.
SELECT M.*, D.DeptName
FROM Manager M INNER JOIN Department D ON M.DeptID = D.DeptID
WHERE M.DeptID = ANY (SELECT DeptID
				      FROM Nurse
					  WHERE Specialty = 'General')
--equivalent to
SELECT M.*, D.DeptName
FROM Manager M INNER JOIN Department D ON M.DeptID = D.DeptID
WHERE M.DeptID IN (SELECT DeptID
				   FROM Nurse
				   WHERE Specialty = 'General')

--Show the patient which are not currently treated in the hospital.

SELECT P.*
FROM Patient P
WHERE P.PatientID <> ALL(SELECT DTP.PatientID
						 FROM Doctor_Treats_Patient DTP)

-- equivalent to

SELECT P.*
FROM Patient P
WHERE P.PatientID NOT IN (SELECT DTP.PatientID
						 FROM Doctor_Treats_Patient DTP)

--Display the first 50% of the doctors having a lower score than all the doctors from Pulmonology.

SELECT TOP 50 PERCENT *
FROM Doctor D
WHERE D.Score < ALL(SELECT Score
					FROM Doctor
					WHERE DeptID =  (SELECT DeptID
									 FROM Department
									 WHERE DeptName = 'Pulmonology'))

--equivalent to
SELECT TOP 50 PERCENT  *
FROM Doctor D
WHERE D.Score <    (SELECT MIN(Score)
					FROM Doctor
					WHERE DeptID =  (SELECT DeptID
									 FROM Department
									 WHERE DeptName = 'Pulmonology'))