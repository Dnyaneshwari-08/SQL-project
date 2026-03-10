
/* Procedures */
-- ========================================================
--  A1: Monthly Department Report 
-- ========================================================
go
create or alter procedure sp_MonthlyDepartmentReport
	@Month int,
	@Year int
as 
begin 

	begin try
		if @Month not between 1 and 12 
			throw 50001, 'Invalid month value.',1;

		select 
			d.DepartmentName,
			count(a.AppointmentId) as TotalAppointments,
			count(distinct a.PatientId) as UniquePatients,
			isnull (sum(doc.ConsultationFee),0) as ConsultationRevenue
		from Departments_2224 d
		left join Doctors_2224 doc on d.DepartmentId = doc.DepartmentId
		left join Appointments_2224 a
			on doc.DoctorId = a.DoctorId
			and month(a.AppointmentDate)= @Month
			and year(a.AppointmentDate) = @Year
			and a.Status = 'Completed'
		group by d.DepartmentName
		order by d.DepartmentName;
	end try
	begin catch
		throw;
	end catch
end
go

exec sp_MonthlyDepartmentReport 03,2024 ;
select *from Appointments_2224;

-- ========================================================
--  A2: Patient Billing Statement
-- ========================================================
go 
create or alter procedure sp_PatientBillingStatement
	@PatientID int
as 
begin
	
	begin try
		if not exists (select 1 from Patients where PatientId = @PatientID)
			throw 50002, 'Patient ID does not exist.', 1;

		select 
			a.AppointmentDate,
			d.DoctorName,
			b.ConsultationFee,
			b.MedicineCost,
			b.LabCost,
			b.InsuranceDiscount,
			b.GSTAmount,
			b.FinalAmount
		from Appointments_2224 a
		join Doctors_2224 d on a.DoctorId = d.DoctorId
		join Billing_2224 b on a.AppointmentId = b.AppointmentId
		where a.PatientId = @PatientID
		and a.Status = 'Completed'

		union all

		select 
			null,
			'GRAND TOTAL',
			sum(b.ConsultationFee),
			sum(b.MedicineCost),
			sum(b.LabCost),
			sum(b.InsuranceDiscount),
			sum(b.GSTAmount),
			sum(b.FinalAMount)
		from Appointments_2224 a
		join Billing_2224 b on a.AppointmentId = b.AppointmentId
		where a.PatientId = @PatientID
		and a.Status ='Completed';
	end try
	begin catch
		throw;
	end catch
end;
go

exec sp_PatientBillingStatement 2; 
select *from Patients_2224;

-- ====================================================
-- A3: Doctor Performance Report(Medium)
-- ====================================================
go
create or alter procedure sp_DoctorPerformanceReport
	@MinAppointments int
as 
begin

	begin try
		select
			d.DoctorName,
			count(a.AppointmentId) as TotalAppointments,
			sum(case when a.Status = 'Completed' then 1 else 0 end) as CompletedAppointemnts,
			cast(
				100.0 * sum(case when a.Status = 'Completed' then 1 else 0 end)
				/ nullif(count(a.AppointmentId),0)
				as decimal(5,2)
			) as CompletionRatePercent,
			isnull(sum(b.FinalAmount),0) as TotalRevenue,
			count(distinct mr.Dignosis) as UniqueDiagnoses
		from Doctors_2224 d
		left join Appointments_2224 a on d.DoctorId = a.DoctorId
		left join Billing_2224 b on a.AppointmentId = b.AppointmentId
		left join MedicalRecords_2224 mr on a.AppointmentId = mr.AppointmentId
		where d.IsActive =1 
		group by d.DoctorName
		having count(a.AppointmentId) >=@MinAppointments
		order by TotalRevenue desc;
	end try
	begin catch
		throw;
	end catch
end;
go

exec sp_DoctorPerformanceReport 2;

-- ====================================================
-- A4: Medicines Never Prescribed 
-- ====================================================
go 
create or alter procedure sp_MedicinesNeverPrescribed
as 
begin
	
	begin try
	select MedicineId,MedicineName
	from Medicines_2224
	where MedicineId not in (
		select distinct MedicineId from Prescriptions_2224
	);
end try 
begin catch
	throw;
end catch
end;
go

exec sp_MedicinesNeverPrescribed;

-- ==========================================================
-- A5: Monthly REvenue vs Target
-- ==========================================================

go
create or alter procedure sp_MonthlyRevenueVsTarget
as 
begin
	
	declare @Target decimal(10,2) = 500000;

	begin try
		select
			format(a.AppointmentDate, 'MMM yyyy') as [Month],
			sum(b.FinalAmount) as TotalRevenue,
			case
				when sum(b.FinalAmount) >= @Target then 'Yes'
				else 'No'
			end as TargetMet,
			sum(b.FinalAMount) - @Target as SurplusOrDeficit
		from Billing_2224 b
		join Appointments_2224 a on b.AppointmentId = a.AppointmentId
		group by format(a.AppointmentDate, 'MMM yyyy'),
				 year(a.AppointmentDate),
				 month(a.AppointmentDate)
		order by year(a.AppointmentDate),month(a.AppointmentDate);

		select
			count(case when MonthlyRevenue >= @Target then 1 end) as MonthsMetTarget,
			count(case when MonthlyRevenue < @Target then 1 end) as MonthsMissedTarget
		from (
			select sum(b.FinalAmount) as MonthlyRevenue
			from Billing_2224 b
			join Appointments_2224 a on b.AppointmentId = a.AppointmentId
			group by year(a.AppointmentDate),month(a.AppointmentDate)
		) x;
   end try
   begin catch
		throw;
   end catch
end;
go

exec sp_MonthlyRevenueVsTarget;

