/* Advacnced Standalone Queries */

-- ============================================
-- D1: Top 3 Doctors per Department by Revenue 
-- ============================================

with DoctorRevenue as 
(
	select 
		dep.DepartmentName,
		d.DoctorId,
		d.DoctorName,
		sum(b.FinalAmount) as TotalRevenue
	from Doctors_2224 d
	join Departments_2224 dep on d.DepartmentId = dep.DepartmentId
	join Appointments_2224 a on d.DoctorId = a.DoctorId
	join Billing_2224 b on a.AppointmentId = b.AppointmentId
	where a.Status = 'Completed'
	group by dep.DepartmentName, d.DoctorId, d.DoctorName
),
RankedDoctors as 
(
	select *,
		rank() over(
			partition by DepartmentName
			order by TotalRevenue desc
		) as DepartmentRank
	from DoctorRevenue
)

select
	DepartmentName,
	DoctorName,
	TotalRevenue,
	DepartmentRank
from RankedDoctors
where Departmentrank <= 3
order by DepartmentName,DepartmentRank;


-- ================================================
-- D2: Running Monthly Revenue Total
-- ================================================

with MonthlyRevenue as 
(
	select 
		year(a.AppointmentDate) as YearValue,
		month(a.AppointmentDate) as MonthValue,
		format(a.AppointmentDate, 'MMM yyyy') as MonthLabel,
		sum(b.FinalAmount) as TotalRevenue
	from Billing_2224 b
	join Appointments_2224 a on b.AppointmentId = a.AppointmentId
	group by 
		year(a.AppointmentDate),
		month(a.AppointmentDate),
		format(a.AppointmentDate,'MMM yyyy')
)

select 
	MonthLabel,
	TotalRevenue,
	sum(TotalRevenue) over (
		order by YearValue,MonthValue
		rows between unbounded preceding and current row 
	) as RunningTotalRevenue
from MonthlyRevenue
order by YearValue,MonthValue;