
/* TRIGGERS */
-- ==============================================
-- B1 : Prevent Doctor Double-Booking
-- ==============================================
go
create trigger trg_PreventDoctorDoubleBooking2
on Appointments_2224
after insert
as
begin
    begin try
        if exists (
            select 1
            from Appointments_2224 a
            join inserted i
                on a.DoctorId = i.DoctorId
               and a.AppointmentDate = i.AppointmentDate
               and a.TimeSlot = i.TimeSlot
               and a.AppointmentId <> i.AppointmentId
               and a.Status in ('Schedule','Completed')
        )
        begin
            rollback transaction;

            declare @DoctorId int, @Date date, @Time varchar(20), @ErrorMessage nvarchar(200);

            select
                @DoctorId = DoctorId,
                @Date = AppointmentDate,
                @Time = TimeSlot
            from inserted;

            set @ErrorMessage = 'Doctor ID ' + cast(@DoctorId as varchar(10))
                                + ' already has an appointment on '
                                + convert(varchar(10), @Date, 120)
                                + ' at ' + @Time;

            throw 50010, @ErrorMessage, 1;
        end
    end try
    begin catch
        throw;
    end catch
end;
go

-- This insert query will succeed as there will not be any double booking
insert into Appointments_2224 (PatientId, DoctorId, AppointmentDate, TimeSlot, Status)
values (5, 10, '2026-03-10', '10:00 AM', 'Schedule');

-- This insert query will not succeed as there will be a double booking
insert into Appointments_2224 (PatientId, DoctorId, AppointmentDate, TimeSlot, Status)
values (4,15, '2026-03-10', '10:00 AM', 'Schedule');

select * from Patients_2224;
select * from Doctors_2224;
select * from Appointments_2224;

-- ===================================================
-- B2: Auto Generate Bill on Completion
-- ===================================================

go
create or alter trigger trg_GenerateBillOnCompletion
on Appointments_2224
after update
as
begin
    begin try
        -- Only when status changes to Completed
        if exists (
            select 1
            from inserted i
            join deleted d on i.AppointmentId = d.AppointmentId
            where i.Status = 'Completed'
              and d.Status <> 'Completed'
        )
        begin
            declare 
                @AppointmentId int,
                @PatientId int,
                @ConsultationFee decimal(10,2),
                @MedicineCost decimal(10,2),
                @LabCost decimal(10,2),
                @CoveragePercent int,
                @InsuranceDiscount decimal(10,2),
                @GST decimal(10,2),
                @FinalAmount decimal(10,2);

            select
                @AppointmentId = i.AppointmentId,
                @PatientId = i.PatientId
            from inserted i;

            -- Prevent duplicate bill
            if exists (select 1 from Billing_2224 where AppointmentId = @AppointmentId)
            begin
                throw 50010, 'Bill already exists for this appointment.', 1;
            end

            -- Consultation Fee
            select @ConsultationFee = d.ConsultationFee
            from Appointments_2224 a
            join Doctors_2224 d on a.DoctorId = d.DoctorId
            where a.AppointmentId = @AppointmentId;

            -- Medicine cost
            select @MedicineCost = isnull(sum(m.UnitPrice * p.Quantity),0)
            from Prescriptions_2224 p
            join Medicines_2224 m on p.MedicineId = m.MedicineId
            where p.AppointmentId = @AppointmentId;

            -- Lab Cost
            select @LabCost = isnull(sum(t.Cost),0)
            from LabOrders_2224 lo
            join LabTests t on lo.TestId = t.TestId
            where lo.AppointmentId = @AppointmentId;

            -- Insurance
            select @CoveragePercent = CoveragePercent
            from Insurance_2224
            where PatientId = @PatientId;

            set @CoveragePercent = isnull(@CoveragePercent,0);
            set @InsuranceDiscount = (@MedicineCost + @LabCost) * @CoveragePercent / 100.0;

            -- GST calculation
            set @GST = (@MedicineCost * 0.05) + (@LabCost * 0.12);

            set @FinalAmount = @ConsultationFee 
                             + (@MedicineCost + @LabCost - @InsuranceDiscount) 
                             + @GST;

            insert into Billing_2224(
                AppointmentId,
                ConsultationFee,
                MedicineCost,
                LabCost,
                InsuranceDiscount,
                GSTAmount,
                FinalAmount,
                PaymentStatus
            )
            values(
                @AppointmentId,
                @ConsultationFee,
                @MedicineCost,
                @LabCost,
                @InsuranceDiscount,
                @GST,
                @FinalAmount,
                'Unpaid'
            );
        end
    end try
    begin catch
        throw;
    end catch
end;
go

select *from Appointments_2224; 

update Appointments_2224
set Status = 'Completed'
where AppointmentId = 6; 

select *from Billing_2224;

-- ==================================================
-- B3: Flag Follow-Up on Abonormal Lab Result 
-- ==================================================

go 
create or alter trigger trg_FlagFollowUpOnAbnormalLab
on labOrders_2224
after insert,update
as 
begin 
    
    declare @AppointmentId int;

    select @AppointmentId = AppointmentId
    from inserted 
    where isAbnormal =1;

    if @AppointmentId is not null
    begin 
        if exists (
            select 1
            from MedicalRecords_2224
            where AppointmentId = @AppointmentId
        )
        begin 
            update MedicalRecords_2224
            set RequiresFollowUp =1 
            where AppointmentId = @AppointmentId;
        end
        else
        begin
            print 'Warning : Abnormal lab result detected , but no medical record exists yet.';
        end
    end
end;
go

--checking by inserting the normal result of the test so the RequiresFollowUp status does not change, remains = 0
insert into LabOrders_2224 (AppointmentId, TestId, Result, IsAbnormal)
values (3, 4, 'Normal', 0);

select AppointmentId, RequiresFollowUp
from MedicalRecords_2224
where AppointmentId = 3;

--checking by inserting the abnormal result i.e high for the test so the RequiresFollowUp status changes from 0 to 1
insert into LabOrders_2224 (AppointmentId, TestId, Result, IsAbnormal)
values (4, 8, 'High', 1);

select AppointmentId, RequiresFollowUp
from MedicalRecords_2224
where AppointmentId = 4;
