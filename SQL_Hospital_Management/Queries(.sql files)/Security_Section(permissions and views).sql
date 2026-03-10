/* Security Section */

-- ============================================
-- Restricted Patient View for Billing Staff
-- ============================================

go
create or alter view vw_PatientLimitedInfo
as 
select
	p.PatientId,
	p.PatientName,
	i.ProviderName,
	i.Coveragepercent,
	i.YearlyMaxAmount,
	i.UsedAmount
from Patients_2224 p
left join Insurance_2224 i on p.PatientId = i.PatientId;
go

-- ==============================================
-- Create Databse Roles
-- ==============================================

go
create role db_receptionist;
create role db_doctor;
create role db_lab_tech;
create role db_billing;
create role db_admin;
go

-- Role permissions 

--db_receptionist permissions
grant select, insert on Patients_2224 to db_receptionist;
grant select, insert on Appointments_2224 to db_receptionist;

deny select, insert,update,delete on Billing_2224 to db_receptionist;
deny select, insert,update,delete on MedicalRecords_2224 to db_receptionist;
deny select, insert,update,delete on Prescriptions_2224 to db_receptionist;
deny select, insert,update,delete on labOrders_2224 to db_receptionist;

--db_doctor permissions
grant select on Patients_2224 to db_doctor;
grant select on Appointments_2224 to db_doctor;
grant insert, update on MedicalRecords_2224 to db_doctor;
grant insert, update on Prescriptions_2224 to db_doctor;
grant insert, update on labOrders_2224 to db_doctor;

deny select, insert,update,delete on Billing_2224 to db_doctor;

--db_lab_tech permissions
grant select on LabTests_2224 to db_lab_tech;
grant select on labOrders_2224 to db_lab_tech;
grant update (Result,IsAbnormal) on labOrders_2224 to db_lab_tech;

deny select on Patients_2224 to db_lab_tech;
deny select, insert,update,delete on Billing_2224 to db_lab_tech;
 
--db_billing permissions
grant select,insert, update on Billing_2224 to db_billing;
grant select on vw_PatientLimitedInfo to db_billing;

deny select, insert,update,delete on MedicalRecords_2224 to db_lab_tech;
deny select, insert,update,delete on Prescriptions_2224 to db_lab_tech;
deny select, insert,update,delete on labOrders_2224 to db_lab_tech;

--db_admin permissions
grant control on databse::HospitalDB to db_admin;