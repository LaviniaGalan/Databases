USE HospitalCopy

SELECT * FROM Department

INSERT INTO Department (DeptName, Capacity)
VALUES  ('Oncology', 130),
		('Dermatology', 20),
		('Pulmonology', 40),
		('Neurology', 65),
		('Cardiology', 30)


SELECT * FROM Manager

INSERT INTO Manager(DeptID, Name, PhoneNo)
VALUES (1, 'Steve John', '0734545566'),
	   (2, 'Monica Johnson', '0712342344') ,
	   (3, 'Sharon Goodwin', '0899213456') ,
	   (5, 'Laura Charles', '0978765376') ,
       (4, 'Megan Hunt', '0754327186')




SELECT * FROM Doctor

INSERT INTO Doctor(Name, CNP, DeptID, Score)
VALUES ('Ethan Choi', '70723844682479', 1, 9),
('William Halstead', '78809347651920', 1, 10),
('Natalie Manning', '69834515623949', 2, 9),
('Emilia Palvin', '65687355547859', 2, 7),
 ('Marcel Proust', '79022356442367', 3, 8),
('James Brown', '77063275394754', 3, 10),

('Arthur Rhodes', '76543263798853', 4, 10),

 ('Dominic Tyron', '79152446365442',  5, 10),
 ('Roger Kevin', '73554364829467', 5, 7)


SELECT * FROM Nurse

INSERT INTO Nurse(Name, CNP, DeptID, SuperviserID)
VALUES ('April Murphy', '87636542783764', 1, 2),
('Leon Rowland', '87254472553766', 1, 1),
('Lyiah Buck', '86543253544324', 3, 5),
('Mike Vladinski', '10298387765634', 3, 6)





SELECT * FROM InsuranceCompany

INSERT INTO InsuranceCompany(Email, Funds, CompanyAddress)
VALUES ('asig@gmail.com', 1000000, 'Weymouth Street, London')

INSERT INTO InsuranceCompany(Email, Funds, CompanyAddress)
VALUES ('longlive@gmail.com', 50000, 'Lirei Street, Bucharest')

INSERT INTO InsuranceCompany(Email, Funds, CompanyAddress)
VALUES ('healthcare@yahoo.com', 3500000, 'Abbey Road, London')

INSERT INTO InsuranceCompany(Email, Funds, CompanyAddress)
VALUES ('omniasig@yahoo.com', 3400000, 'Kingsway Street, Los Angeles')

INSERT INTO InsuranceCompany(Email, Funds, CompanyAddress)
VALUES ('bestinsurance@yahoo.com', 9900000, 'Philip Piece, Monaco')

INSERT INTO InsuranceCompany(Email, Funds, CompanyAddress)
VALUES('todelete@gmail.com', 5000000, 'Tokyo, Japan')


SELECT * FROM Patient

INSERT INTO Patient(PatientName, DateOfBirth, PhoneNo, Email, InsuranceID)
VALUES ('Jane Faulk', '8-6-90', '0756565678', 'jane@gmail.com', 1),
('Michael Wayne', '5-29-98', '0789653736', 'mick@yahoo.com', 5),
('Michelle Van Pelt', '1940-06-15', '0231456345', 'michelle@yahoo.com', 5),
('Antonio Murray', '12-14-75', '0765433634', 'itstony@gmail.com', 3),
('Rose Sullivan', '1-16-50', '0765432674', 'rosieee@yahoo.com', 2),
('Elise Martins', '9-6-84', '0724365423', 'ely@gmail.com', 4),
('Lorelei Kenin', '3-14-81', '0764464765', 'yourslori@gmail.com', 5),
('Jack Tukker', '1960-09-15', '0787543261', 'jackie@gmail.com', 2),
('Andrew Morrison', '1974-11-23', '0754433263', 'andyMorris@yahoo.com', 1)

INSERT INTO Patient(PatientID, PatientName, DateOfBirth, PhoneNo, Email, InsuranceID)
VALUES (116, 'Roxanne Morgan', '1982-04-25', '0876542434', 'roxyfoxy@yahoo.com', 2)

INSERT INTO Patient(PatientID, PatientName, DateOfBirth, PhoneNo, Email, InsuranceID)
VALUES (117, 'Alexia Marple', '1965-05-29', '0876535442', 'alexia.marple@gmail.com', 3)

INSERT INTO Patient(PatientID, PatientName, DateOfBirth, PhoneNo, Email, InsuranceID)
VALUES (118, 'Mariah James', '2004-02-14', '0787543726', 'heydearmariah@yahoo.com', 4)



SELECT * FROM MedicalRecord

INSERT INTO MedicalRecord(PatientID, BloodType, ChronicDiseases, Allergies)
VALUES (1, 'AB(IV) Rh+', 'Asthma', NULL)

INSERT INTO MedicalRecord(PatientID, BloodType, ChronicDiseases, Allergies)
VALUES (2, '0 Rh-', NULL, 'Paracetamol')

INSERT INTO MedicalRecord(PatientID, BloodType, ChronicDiseases, Allergies)
VALUES (3, 'B(III) Rh+', 'Alzheimer', 'Tobradex, Simvastatin')

INSERT INTO MedicalRecord(PatientID, BloodType, ChronicDiseases, Allergies)
VALUES (4, 'A(II) Rh+', NULL, NULL)

INSERT INTO MedicalRecord(PatientID, BloodType, ChronicDiseases, Allergies)
VALUES (5, 'B(III) Rh-', 'Leukimia', 'Amoxacillin')

INSERT INTO MedicalRecord(PatientID, BloodType, ChronicDiseases, Allergies)
VALUES (6, '0 Rh+', 'Chronic heart failure', NULL)

INSERT INTO MedicalRecord(PatientID, BloodType, ChronicDiseases, Allergies)
VALUES (7, 'AB(IV) Rh-', 'Osteosarcoma', 'Amlodipine')

INSERT INTO MedicalRecord(PatientID, BloodType, ChronicDiseases, Allergies)
VALUES (8, 'B(III) Rh+', 'Liver Cancer', NULL)

INSERT INTO MedicalRecord(PatientID, BloodType, ChronicDiseases, Allergies)
VALUES (9, 'A(II) Rh+', 'Lung Cancer', 'Adderall')

--INSERT INTO MedicalRecord(PatientID, BloodType, ChronicDiseases, Allergies)
--VALUES (116, 'A(II) Rh-', NULL, NULL)

--DELETE FROM MedicalRecord
--WHERE PatientID = 116

INSERT INTO MedicalRecord(PatientID, BloodType, ChronicDiseases, Allergies)
VALUES (117, 'AB(IV) Rh+', 'Arthritis', 'Levothyroxine')

INSERT INTO MedicalRecord(PatientID, BloodType, ChronicDiseases, Allergies)
VALUES (118, '0 Rh+', 'Kidney failure', NULL)



SELECT * FROM Doctor_Treats_Patient

SELECT * FROM Doctor D
INNER JOIN Department DE ON (D.DeptID = DE.DeptID)

INSERT INTO Doctor_Treats_Patient(DoctorID, PatientID, Illness, Treatment, MedicationID)
VALUES (3, 1, 'Acne', NULL, 8)

INSERT INTO Doctor_Treats_Patient(DoctorID, PatientID, Illness, Treatment, MedicationID)
VALUES (9801, 102, 'TBC', NULL, 6)

INSERT INTO Doctor_Treats_Patient(DoctorID, PatientID, Illness, Treatment, MedicationID)
VALUES (9802, 101, 'Asthma', NULL, 10)

INSERT INTO Doctor_Treats_Patient(DoctorID, PatientID, Illness, Treatment, MedicationID)
VALUES (8403, 109, 'Angina Pectoris', NULL, 9)

INSERT INTO Doctor_Treats_Patient(DoctorID, PatientID, Illness, Treatment, MedicationID)
VALUES (6701, 1, 'Leukemia', 'Radiotherapy, Morphin', NULL)

INSERT INTO Doctor_Treats_Patient(DoctorID, PatientID, Illness, Treatment, MedicationID)
VALUES (2605, 105, 'Alzheimer', 'Vitamin-based diet', 1)

INSERT INTO Doctor_Treats_Patient(DoctorID, PatientID, Illness, Treatment, MedicationID)
VALUES (6703, 2, 'Osteosarcoma', 'Chemotherapy', NULL)

INSERT INTO Doctor_Treats_Patient(DoctorID, PatientID, Illness, Treatment, MedicationID)
VALUES (9801, 115, 'Sinusitis', NULL, 5)

INSERT INTO Doctor_Treats_Patient(DoctorID, PatientID, Illness, Treatment, MedicationID)
VALUES (2605, 116, 'Cephalgia', NULL, 3)


SELECT * FROM Room

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (75600, 305, 3, 'Examination')

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (75600, 302, 3, 'Basic Procedures')

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (75600, 300, 3, 'Surgery')

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (19000, 201, 2, 'Surgery')

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (19000, 204, 2, 'Surgery')

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (19000, 207, 2, 'Examination')

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (45200, 105, 1, 'Surgery')

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (59300, 102, 1, 'Examination')

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (59300, 103, 1, 'Surgery')

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (12345, 010, 0, 'Admission')

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (12345, 012, 0, 'Admission')

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (12345, 013, 0, 'Radiotherapy')

INSERT INTO Room(DeptID, RoomNumber, RoomFloor, RoomType)
VALUES (12345, 015, 0, 'Chemotherapy')


SELECT * FROM MedicalProcedure

INSERT INTO MedicalProcedure(DoctorID, PatientID, RoomNumber, ProcName, Cost, StartTime, EndTime, ProcDate)
VALUES (3405, 101, 302, 'Dermapen', 700, '08:30', '9:30', '2020-10-10')

INSERT INTO MedicalProcedure(DoctorID, PatientID, RoomNumber, ProcName, Cost, StartTime, EndTime, ProcDate)
VALUES (9801, 115, 201, 'Pneumonectomy', 30000, '10:00', '14:00', '2020-10-13')

INSERT INTO MedicalProcedure(DoctorID, PatientID, RoomNumber, ProcName, Cost, StartTime, EndTime, ProcDate)
VALUES (8403, 109, 105, 'Coronary angioplasty', 15000, '09:00', '12:00', '2020-10-09')

INSERT INTO MedicalProcedure(DoctorID, PatientID, RoomNumber, ProcName, Cost, StartTime, EndTime, ProcDate)
VALUES (6701, 107, 010, 'Morphin Injection', 100, '14:00', '14:10', '2020-10-13')

INSERT INTO MedicalProcedure(DoctorID, PatientID, RoomNumber, ProcName, Cost, StartTime, EndTime, ProcDate)
VALUES (9801, 102, 204, 'WLL', 5000, '19:00', '20:20', '2020-12-25')




SELECT * FROM Medication

INSERT INTO Medication(ActiveSubstance)
VALUES ('Vitamin B'),
('Vitamin C'),
('Ibuprofen'),
('Benzoyl Peroxide'),
('Amoxacilin'),
('Azithromycin'),
( 'Beclometasone'),
('Isotretinoin'),
('Acetylsalicylic acid'),
('Salbutamol')


SELECT * FROM Supplier

INSERT INTO Supplier(Email, PhoneNo, SupplierName)
VALUES ('bayern_pharmaceuticals@yahoo.com', '0231455667', 'Bayern')

INSERT INTO Supplier(Email, PhoneNo, SupplierName)
VALUES ('popular_pharma@gmail.com', '0231544577', 'Popular Pharma')

INSERT INTO Supplier(Email, PhoneNo, SupplierName)
VALUES ('balkan_pharma@gmail.com', '0231147269',  'Balkan Pharmaceuticals')


SELECT * FROM Medication_Supplier

INSERT INTO Medication_Supplier(MedicationID, SupplierID, MedName, LOT, UseByDate)
VALUES (3, 1, 'Nurofen', 204213, '2021-11-20'),
(3, 1, 'Ibalgin-Rapid', 446335, '2021-08-13'),
(1, 2, 'B-Complex',  456256, '2022-05-30'),
(2, 2, 'C-Complex',  234524, '2022-04-21'),
(4, 1, 'Epiduo', 765434, '2021-02-15'),
(5, 2, 'Amoxacilin ATB',  345534, '2023-01-01'),
(6, 3, 'Azitrox Terapia', 554374, '2021-07-21'),
(10, 1, 'Ventolin',  245546, '2022-01-15'),
(8, 2, 'RoAccutane',  234567, '2021-03-30'),
(9, 3, 'Aspenter',  145325, '2023-05-12')