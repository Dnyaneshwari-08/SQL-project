/*Table Creation */

-- =======================
-- Department Table
-- ========================
create table Departments_2224 (
DepartmentId int identity primary key,
DepartmentName varchar(100) not null unique,
HeadDoctorId int null
);

INSERT INTO Departments_2224 (DepartmentName, HeadDoctorId) VALUES 
('Cardiology', NULL), ('Neurology', NULL), ('Pediatrics', NULL), ('Orthopedics', NULL), 
('Dermatology', NULL), ('Oncology', NULL), ('Gastroenterology', NULL), ('Psychiatry', NULL), 
('ENT', NULL), ('Ophthalmology', NULL), ('Urology', NULL), ('Gynecology', NULL), 
('Endocrinology', NULL), ('Radiology', NULL), ('Pulmonology', NULL), ('Nephrology', NULL), 
('General Medicine', NULL), ('Emergency', NULL), ('Pathology', NULL), ('Physiotherapy', NULL);



-- =======================
-- Doctors Table
-- ========================
create table Doctors_2224(
DoctorId int identity primary key,
DoctorName varchar(100) not null,
Specialisation varchar(100) not null,
ConsultationFee decimal(10,2) not null check(ConsultationFee >0),
DepartmentId int not null,
IsActive bit default 1,
CONSTRAINT FK_Doctor_Department
      foreign key (DepartmentId) references Departments_2224(DepartmentId)
);

INSERT INTO Doctors_2224 (DoctorName, Specialisation, ConsultationFee, DepartmentId, IsActive) VALUES 
('Dr. Smith', 'Cardiologist', 150.00, 21, 1), ('Dr. Adams', 'Neurologist', 200.00, 22, 1),
('Dr. Brown', 'Pediatrician', 100.00, 23, 1), ('Dr. Clark', 'Surgeon', 180.00, 24, 1),
('Dr. Davis', 'Dermatologist', 120.00, 25, 1), ('Dr. Evans', 'Oncologist', 250.00, 26, 1),
('Dr. Frank', 'Gastroenterologist', 140.00, 27, 1), ('Dr. Ghosh', 'Psychiatrist', 160.00, 28, 1),
('Dr. Hills', 'ENT Specialist', 90.00, 29, 1), ('Dr. Irwin', 'Ophthalmologist', 110.00, 30, 1),
('Dr. Jones', 'Urologist', 170.00, 31, 1), ('Dr. Kelly', 'Gynecologist', 150.00, 32, 1),
('Dr. Lewis', 'Endocrinologist', 130.00, 33, 1), ('Dr. Moore', 'Radiologist', 120.00, 34, 1),
('Dr. Nelson', 'Pulmonologist', 145.00, 35, 1), ('Dr. Owens', 'Nephrologist', 165.00, 36, 1),
('Dr. Perez', 'General Physician', 80.00, 37, 1), ('Dr. Quinn', 'Trauma Surgeon', 220.00, 38, 1),
('Dr. Reed', 'Pathologist', 70.00, 39, 1), ('Dr. Scott', 'Physiotherapist', 60.00, 40, 1);



-- =======================
-- Patients Table
-- ========================
create table Patients_2224(
PatientId int identity primary key,
PatientName varchar(100) not null,
DateOfBirth date not null,
Phone varchar(15),
Address varchar(200)
);
INSERT INTO Patients_2224 (PatientName, DateOfBirth, Phone, Address) VALUES 
('John Doe', '1985-05-12', '555-0101', '123 Maple St'), ('Jane Roe', '1990-07-22', '555-0102', '456 Oak Ave'),
('Alice Sky', '1978-03-15', '555-0103', '789 Pine Rd'), ('Bob Moss', '2000-11-30', '555-0104', '321 Elm Blvd'),
('Charlie Day', '1995-01-10', '555-0105', '654 Cedar Ln'), ('Diana Prince', '1982-08-19', '555-0106', '987 Birch Way'),
('Ethan Hunt', '1975-06-24', '555-0107', '159 Walnut Dr'), ('Fiona Gall', '1992-12-05', '555-0108', '753 Ash Ct'),
('George King', '1960-04-02', '555-0109', '246 Spruce St'), ('Hannah Bell', '2010-09-14', '555-0110', '852 Willow Rd'),
('Ian Wright', '1988-02-28', '555-0111', '369 Cherry Ave'), ('Julia Roberts', '1970-10-31', '555-0112', '951 Poplar St'),
('Kevin Hart', '1984-07-07', '555-0113', '147 Sycamore Dr'), ('Lily Rose', '1999-05-19', '555-0114', '258 Aspen Ln'),
('Mike Wazowski', '2005-03-21', '555-0115', '369 Linden Ct'), ('Nina Simone', '1993-11-11', '555-0116', '741 Hickory Blvd'),
('Oscar Wilde', '1965-01-01', '555-0117', '852 Magnolia Rd'), ('Paul Rudd', '1972-04-06', '555-0118', '963 Beech St'),
('Quinn Fabray', '1996-08-23', '555-0119', '159 Cypress Dr'), ('Riley Reid', '1991-09-09', '555-0120', '357 Juniper Ave');


-- =======================
-- Insurance Table
-- ========================
create table Insurance_2224(
InsuranceId int identity primary key,
PatientId int unique,
ProviderName varchar(100),
CoveragePercent int check (CoveragePercent between 0 and 100),
YearlyMaxAmount decimal(10,2),
UsedAmount decimal(10,2) default 0,
CONSTRAINT Fk_Insurance_Patient 
         foreign key (PatientId) references Patients_2224(PatientId)
);

INSERT INTO Insurance_2224 (PatientId, ProviderName, CoveragePercent, YearlyMaxAmount, UsedAmount) VALUES 
(1, 'BlueCross', 80, 5000, 100), (2, 'Aetna', 90, 10000, 200), (3, 'Cigna', 70, 4000, 0),
(4, 'UnitedHealth', 100, 15000, 500), (5, 'Humana', 50, 3000, 50), (6, 'Kaiser', 85, 8000, 150),
(7, 'Medicare', 100, 20000, 1000), (8, 'BlueCross', 80, 5000, 0), (9, 'Aetna', 90, 10000, 500),
(10, 'Cigna', 75, 6000, 100), (11, 'UnitedHealth', 80, 7000, 200), (12, 'Humana', 60, 4000, 0),
(13, 'Kaiser', 90, 9000, 300), (14, 'Medicare', 100, 25000, 2000), (15, 'BlueCross', 80, 5000, 100),
(16, 'Aetna', 90, 10000, 0), (17, 'Cigna', 70, 4000, 150), (18, 'UnitedHealth', 85, 12000, 600),
(19, 'Humana', 50, 3000, 0), (20, 'Kaiser', 80, 7000, 100);



-- =======================
-- Appointments Table
-- ========================
create table Appointments_2224 (
 AppointmentId int identity primary key,
 PatientId int not null,
 DoctorId int not null,
 AppointmentDate date not null,
 TimeSlot varchar(20) not null,
 Status varchar(20) not null
        Check (Status in ('Schedule','Completed','Cancelled')),
        CONSTRAINT Fk_Appt_Patient foreign key (PatientId) references Patients_2224 (PatientId),
        CONSTRAINT Fk_Appt_Doctor foreign key (DoctorId) references Doctors_2224 (DoctorId)
);

update Appointments_2224 set AppointmentDate='2025-03-10' where AppointmentId=19;
insert Appointments_2224 values(2, 2, '2024-03-14', '11:00 AM', 'Schedule');

INSERT INTO Appointments_2224 (PatientId, DoctorId, AppointmentDate, TimeSlot, Status) VALUES 
(1, 2, '2024-03-01', '09:00 AM', 'Completed'), (2, 3, '2024-03-01', '10:00 AM', 'Completed'),
(3, 4, '2024-03-02', '11:00 AM', 'Completed'), (4, 5, '2024-03-02', '01:00 PM', 'Completed'),
(5, 6, '2024-03-03', '09:30 AM', 'Schedule'), (6, 7, '2024-03-03', '10:30 AM', 'Completed'),
(7, 8, '2024-03-04', '02:00 PM', 'Cancelled'), (8, 9, '2024-03-04', '03:00 PM', 'Completed'),
(9, 10, '2024-03-05', '08:00 AM', 'Completed'), (10, 11, '2024-03-05', '09:00 AM', 'Completed'),
(11, 12, '2024-03-06', '10:00 AM', 'Completed'), (12, 13, '2024-03-06', '11:30 AM', 'Completed'),
(13, 14, '2024-03-07', '12:00 PM', 'Completed'), (14, 15, '2024-03-07', '01:30 PM', 'Completed'),
(15, 16, '2024-03-08', '02:00 PM', 'Completed'), (16, 17, '2024-03-08', '03:30 PM', 'Completed'),
(17, 18, '2024-03-09', '09:00 AM', 'Completed'), (18, 19, '2024-03-09', '10:00 AM', 'Completed'),
(19, 20, '2024-03-10', '11:00 AM', 'Completed'), (20, 21, '2024-03-10', '12:00 PM', 'Completed');


 

 -- =======================
-- Medical Records Table
-- ========================
create table MedicalRecords_2224 (
RecordId int identity primary key,
AppointmentId int unique,
Dignosis varchar(200),
TratmentPlan varchar(200),
RequiresFollowUp bit default 0,
CONSTRAINT Fk_Record_Appointment foreign key (AppointmentId) references Appointments_2224 (AppointmentId)
);

INSERT INTO MedicalRecords_2224 (AppointmentId, Dignosis, TratmentPlan, RequiresFollowUp) VALUES 
(2, 'Hypertension', 'Low salt diet', 1), (3, 'Migraine', 'Rest and hydration', 0),
(4, 'Common Cold', 'Paracetamol', 0), (5, 'Fractured Arm', 'Cast for 6 weeks', 1),
(6, 'Skin Rash', 'Topical Cream', 0), (7, 'Anxiety', 'Therapy', 1),
(8, 'Sinusitis', 'Antibiotics', 0), (9, 'Myopia', 'New glasses', 1),
(10, 'UTI', 'Antibiotics', 0), (11, 'Pregnancy Checkup', 'Prenatal vitamins', 1),
(12, 'Type 2 Diabetes', 'Insulin management', 1), (13, 'Routine X-Ray', 'No issues', 0),
(14, 'Asthma', 'Inhaler use', 1), (15, 'Kidney Stone', 'Increased fluids', 1),
(16, 'Flu', 'Rest and fluids', 0), (17, 'Ligament Tear', 'Surgery prep', 1),
(18, 'Anemia', 'Iron supplements', 0), (19, 'Back Pain', 'Physiotherapy', 1),
(20, 'Pending', 'Observation', 0), (21, 'Checkup', 'Continue current meds', 0);



-- =======================
-- Medicines Table
-- ========================
create table Medicines_2224(
MedicineId int primary key,
MedicineName varchar(100) unique not null,
UnitPrice decimal(10,2) not null check(UnitPrice >0)
);


INSERT INTO Medicines_2224 (MedicineId, MedicineName, UnitPrice) VALUES 
(1, 'Paracetamol', 5.50), (2, 'Amoxicillin', 12.00), (3, 'Ibuprofen', 8.25),
(4, 'Metformin', 15.00), (5, 'Atorvastatin', 22.50), (6, 'Lisinopril', 11.00),
(7, 'Albuterol', 35.00), (8, 'Omeprazole', 14.75), (9, 'Levothyroxine', 18.00),
(10, 'Amlodipine', 9.50), (11, 'Gabapentin', 25.00), (12, 'Sertraline', 30.00),
(13, 'Losartan', 13.00), (14, 'Azithromycin', 20.00), (15, 'Prednisone', 7.00),
(16, 'Fluticasone', 40.00), (17, 'Hydrochlorothiazide', 6.50), (18, 'Warfarin', 28.00),
(19, 'Montelukast', 19.00), (20, 'Pantoprazole', 16.00);



-- =======================
-- Prescriptions Table
-- ========================
create table Prescriptions_2224(
PrescriptionId int identity primary key,
RecordId int not null,
MedicineId int not null,
Dosage varchar(50),
DurationDays int,
Quantity int check(QUantity>0),
CONSTRAINT Fk_Prescription_Record foreign key (RecordId) references MedicalRecords_2224 (RecordId),
CONSTRAINT Fk_Prescription_Medicine foreign key (MedicineId) references Medicines_2224 (MedicineId)
);

alter table Prescriptions_2224
add AppointmentId int
    constraint FK_Prescription_Appointment
    references Appointments_2224(AppointmentId);
update p
set p.AppointmentId = a.AppointmentId
from Prescriptions_2224 p
join Appointments_2224 a
    on p.RecordId = a.AppointmentId; 


INSERT INTO Prescriptions_2224 (RecordId, MedicineId, Dosage, DurationDays, Quantity) VALUES 
(2, 6, '10mg Daily', 30, 30), (3, 3, '400mg As needed', 5, 10),
(4, 1, '500mg TDS', 3, 9), (5, 10, '5mg Daily', 30, 30),
(6, 12, '50mg Nightly', 30, 30), (7, 2, '250mg TDS', 7, 21),
(8, 8, '20mg Daily', 14, 14), (9, 2, '500mg BD', 5, 10),
(10, 9, '50mcg Daily', 30, 30), (11, 4, '500mg BD', 30, 60),
(12, 5, '10mg Nightly', 30, 30), (13, 7, '2 Puffs PRN', 30, 1),
(14, 14, '500mg Daily', 3, 3), (15, 15, '10mg Daily', 5, 5),
(16, 1, '500mg BD', 2, 4), (17, 20, '40mg Daily', 10, 10),
(18, 13, '25mg Daily', 30, 30), (19, 18, '2mg Daily', 30, 30),
(20, 11, '300mg Nightly', 14, 14), (21, 3, '200mg TDS', 10, 30);




-- =======================
-- Lab Tests Table
-- ========================
create table LabTests_2224(
TestId int identity primary key,
TestName varchar(100)unique not null,
Cost decimal(10,2) not null check(Cost>0)
);

INSERT INTO LabTests_2224 (TestName, Cost) VALUES 
('CBC', 25.00), ('Lipid Profile', 50.00), ('HbA1c', 40.00), ('Thyroid Panel', 60.00),
('Urinalysis', 15.00), ('Chest X-Ray', 100.00), ('MRI Brain', 500.00), ('ECG', 45.00),
('Liver Function Test', 55.00), ('Kidney Function Test', 55.00), ('Blood Sugar', 10.00), ('Vitamin D', 70.00),
('COVID-19 PCR', 80.00), ('Ultrasound', 120.00), ('CT Scan', 300.00), ('Biopsy', 200.00),
('Electrolytes', 35.00), ('Pap Smear', 90.00), ('Stool Test', 20.00), ('Allergy Test', 150.00);



-- =======================
-- Lab Orders Table
-- ========================
create table labOrders_2224(
LabOrderId int identity primary key,
AppointmentId int not null,
TestId int not null,
Result varchar(200),
IsAbnormal bit default 0,
CONSTRAINT Fk_LabOrders_Appointment foreign key (AppointmentId) references Appointments_2224 (AppointmentId),
CONSTRAINT Fk_LabOrders_Test foreign key (TestId) references LabTests_2224 (TestId),
);

INSERT INTO labOrders_2224 (AppointmentId, TestId, Result, IsAbnormal) VALUES 
(2, 1, 'Normal', 0), (3, 8, 'Sinus Rhythm', 0), (4, 7, 'Clear', 0), (5, 1, 'High WBC', 1),
(6, 6, 'Fracture visible', 1), (7, 1, 'Normal', 0), (8, 4, 'Slight TSH elevation', 1),
(9, 1, 'Normal', 0), (10, 1, 'Normal', 0), (11, 5, 'Bacteria Present', 1),
(12, 11, 'Normal', 0), (13, 3, '7.5%', 1), (14, 14, 'Normal', 0), (15, 1, 'Normal', 0),
(16, 10, 'Elevated Creatinine', 1), (17, 13, 'Negative', 0), (18, 15, 'Tear noted', 1),
(19, 1, 'Low Hemoglobin', 1), (20, 1, 'Normal', 0), (21, 1, 'Normal', 0);




-- =======================
-- Billing Table
-- ========================
create table Billing_2224(
BillId int identity primary key,
AppointmentId int not null,
ConsultationFee decimal(10,2),
MedicineCost decimal(10,2),
LabCost decimal(10,2),
InsuranceDiscount decimal(10,2),
GSTAmount decimal(10,2),
FinalAmount decimal(10,2),
PaymentStatus varchar(20) check(PaymentStatus in ('Paid','Unpaid')),
CONSTRAINT Fk_Billing_Appointment foreign key (AppointmentId) references Appointments_2224 (AppointmentId),
);


INSERT INTO Billing_2224 (AppointmentId, ConsultationFee, MedicineCost, LabCost, InsuranceDiscount, GSTAmount, FinalAmount, PaymentStatus) VALUES 
(2, 150, 50, 70, 40, 18, 248, 'Paid'), (3, 200, 20, 500, 60, 50, 710, 'Paid'),
(4, 100, 15, 25, 0, 10, 150, 'Paid'), (5, 180, 40, 100, 80, 20, 260, 'Paid'),
(6, 250, 30, 25, 50, 25, 280, 'Paid'), (7, 160, 45, 60, 30, 15, 250, 'Unpaid'),
(8, 90, 25, 25, 10, 8, 138, 'Paid'), (9, 110, 15, 25, 20, 10, 140, 'Paid'),
(10, 170, 35, 15, 40, 12, 192, 'Paid'), (11, 150, 40, 10, 50, 10, 160, 'Paid'),
(12, 130, 60, 40, 100, 15, 145, 'Paid'), (13, 120, 10, 120, 50, 15, 215, 'Unpaid'),
(14, 145, 35, 25, 40, 15, 180, 'Paid'), (15, 165, 20, 55, 30, 15, 225, 'Paid'),
(16, 80, 10, 80, 0, 10, 180, 'Paid'), (17, 220, 50, 300, 100, 40, 510, 'Paid'),
(18, 70, 30, 25, 0, 8, 133, 'Paid'), (19, 60, 25, 25, 20, 5, 95, 'Unpaid'),
(20, 120, 0, 0, 0, 10, 130, 'Unpaid'), (21, 250, 0, 0, 0, 0, 0, 'Unpaid');



-- ==========================================
-- setting headdoctor ID
-- ==========================================
UPDATE Departments_2224 SET HeadDoctorId = 2 WHERE DepartmentId = 21;
UPDATE Departments_2224 SET HeadDoctorId = 3 WHERE DepartmentId = 22;
UPDATE Departments_2224 SET HeadDoctorId = 4 WHERE DepartmentId = 23;
UPDATE Departments_2224 SET HeadDoctorId = 5 WHERE DepartmentId = 24;
UPDATE Departments_2224 SET HeadDoctorId = 6 WHERE DepartmentId = 25;
UPDATE Departments_2224 SET HeadDoctorId = 7 WHERE DepartmentId = 26;
UPDATE Departments_2224 SET HeadDoctorId = 8 WHERE DepartmentId = 27;
UPDATE Departments_2224 SET HeadDoctorId = 9 WHERE DepartmentId = 28;
UPDATE Departments_2224 SET HeadDoctorId = 10 WHERE DepartmentId = 29;
UPDATE Departments_2224 SET HeadDoctorId = 11 WHERE DepartmentId = 30;
UPDATE Departments_2224 SET HeadDoctorId = 12 WHERE DepartmentId = 31;
UPDATE Departments_2224 SET HeadDoctorId = 13 WHERE DepartmentId = 32;
UPDATE Departments_2224 SET HeadDoctorId = 14 WHERE DepartmentId = 33;
UPDATE Departments_2224 SET HeadDoctorId = 15 WHERE DepartmentId = 34;
UPDATE Departments_2224 SET HeadDoctorId = 16 WHERE DepartmentId = 35;
UPDATE Departments_2224 SET HeadDoctorId = 17 WHERE DepartmentId = 36;
UPDATE Departments_2224 SET HeadDoctorId = 18 WHERE DepartmentId = 37;
UPDATE Departments_2224 SET HeadDoctorId = 19 WHERE DepartmentId = 38;
UPDATE Departments_2224 SET HeadDoctorId = 20 WHERE DepartmentId = 39;
UPDATE Departments_2224 SET HeadDoctorId = 21 WHERE DepartmentId = 40;

select *from Doctors_2224;
select *from Departments_2224;

