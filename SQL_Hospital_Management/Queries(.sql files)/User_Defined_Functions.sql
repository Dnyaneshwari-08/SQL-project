/* User Defined Functions */

-- ============================================
-- C1: patient Age Calculator
-- ============================================

go 
create or alter function fn_GetPatientAge
(
	@PatientId int
)
returns int 
as
begin
	declare @DOB date;
	declare @Age int;

	select @DOB = DateOfBirth
	from Patients_2224
	where PatientId = @PatientId;

	if @DOB is null 
		return null;

    set @Age = datediff(year, @DOB,getdate());

	--Adjust if birthday has not occurred yet this year
	if dateadd(year,@Age,@DOB) > getdate()
		set @Age = @Age -1 ;

	return @Age;
end;
go

select PatientId,
	   PatientName,
	   dateOfBirth,
	   dbo.fn_GetpatientAge(PatientId) as CalculatedAge
from Patients_2224;

-- =========================================
-- C2: net Billing Calculator 
-- =========================================

go 
create or alter function fn_CalculateNetBill
(
	@ConsultationCharge decimal(10,2),
	@MedicineCharge decimal(10,2),
	@LabCharge decimal(10,2),
	@InsurancePercent int
)
returns decimal(10,2)
as 
begin
	declare @InsuranceDiscount decimal(10,2);
	declare @GST decimal(10,2);
	declare @FinalAmount decimal(10,2);

	set @InsurancePercent = isnull(@InsurancePercent,0);
    
	--Insurance applies only to medicine + lab
	set @InsuranceDiscount =
		(@MedicineCharge + @labCharge) * @InsurancePercent / 100.0;

	--GST
	set @GST =
		(@MedicineCharge * 0.05) +
		(@MedicineCharge * 0.12);

	set @FinalAmount =
		@ConsultationCharge +
		(@MedicineCharge + @LabCharge - @InsuranceDiscount) +
		@GST;

	return @FinalAmount;
end;
go

select b.BillId,
	   b.AppointmentId,
	   b.FinalAmount as StoredFinalAmount,
	   dbo.fn_CalculateNetBill(
			b.ConsultationFee,
			b.MedicineCost,
			b.LabCost,
			isnull(i.CoveragePercent,0)
	    ) as RecalculatedAmount
from Billing_2224 b
join Appointments_2224 a on b.AppointmentId = a.AppointmentId
left join Insurance i on a.PatientId = i.PatientId;