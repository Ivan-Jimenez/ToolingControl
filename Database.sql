
if object_id('dbo.Maintenance', 'U') IS NOT NULL 
  drop table dbo.Maintenance; 

create table Maintenance(
	id int identity,
	ToolingID nvarchar(30),
	NP nvarchar(30) unique not null,
	Area nvarchar(40) not null,
	Program nvarchar(40) not null,
	Frequency nvarchar(15) not null,
	Status nvarchar(30) not null,
	TotalNormal int default 0,
	TotalAnnual int default 0,
	LastNormal smallDatetime,
	LastAnnual smallDatetime,
	NextNormal smallDatetime,
	NextAnnual smallDatetime,
	primary key(id)
);

if object_id('dbo.MaintenanceLog', 'U') IS NOT NULL 
  drop table dbo.MaintenanceLog;

create table MaintenanceLog(
	id int identity,
	ToolingID nvarchar(30),
	NP nvarchar(30) not null,
	MaintType nvarchar(30) ,
	Status nvarchar(15),
	FARO bit,
	Validation bit,
	RequestDate smalldatetime,
	PlanningDate smalldatetime,
	ProductionDate smalldatetime,
	QualityDate smalldatetime,
	RequestComment nvarchar(50),
	PlanningComment nvarchar(50),
	ProductionComment nvarchar(50),
	QualityComment nvarchar(50),
	primary key(ID)
);

select * from Maintenance;

update Maintenance
set NextNormal='08/20/2019';

update MaintenanceLog set Status='QUALITY' where id=5;

update maintenance set Frequency='2 WEEKS';

select * from MaintenanceLog;

-- MAINTENANCE DATA 
insert into Maintenance(ToolingID, NP, Area, Program, Frequency, Status, NextNormal, NextAnnual) 
values ('TOOL29350-420-001','F29350-420-001', 'Test Area', 'Test Programa', '2 WEEKS', 'AVAILABLE', '8/23/2019','2019-08-23');

insert into Maintenance(ToolingID, NP, Area, Program, Frequency, Status, NextNormal, NextAnnual) 
values ('', 'F29350-420-002', 'Test Area', 'Test Programa', '1 MONTH', 'AVAILABLE', '08/19/2019','2019-12-17');

insert into Maintenance(ToolingID, NP, Area, Program, Frequency, Status, NextNormal, NextAnnual) 
values ('TOOL29350-420-003', 'F29350-420-003', 'Test Area', 'Test Programa', '2 WEEKS', 'AVAILABLE', '12/23/2019','2019-08-22');

insert into Maintenance(ToolingID, NP, Area, Program, Frequency, Status, NextNormal, NextAnnual) 
values ('TOOL29350-420-004', 'F29350-420-004', 'Test Area', 'Test Programa', '3 WEEKS', 'AVAILABLE', '12/23/2019','2019-08-10');

insert into Maintenance(ToolingID, NP, Area, Program, Frequency, Status, NextNormal, NextAnnual) 
values ('TOOL29350-420-005', 'F29350-420-005', 'Test Area', 'Test Programa', '6 MONTHS', 'AVAILABLE', '12/23/2019','2019-08-10');


SELECT * FROM Maintenance WHERE Status='Available' AND Next  <= GETDATE()+7 order by Next;

update MaintenanceLog set Status='PRODUCTION' WHEre Status='Planning';

select convert(nvarchar,getdate(), 0);

update MaintenanceLog set Status='QUALITY';

if object_id('dbo.Users', 'U') IS NOT NULL 
  drop table dbo.Users;

create table Users(
	id int identity,
	UserID nvarchar(30) unique not null,
	Rol nvarchar(30) not null,
	primary key(UserID)
);

insert into users(userid, rol) values ('ivan.jimenez', 'TOOLING'); 

select * from users where userid='ivan.jimenez';


select time();

select * from tooling;

sp_columns tooling;


create trigger UpdateNextMaint
on db.Maintenance
after update
as 
if (update (Next))
begin
	update Maintenance set MaintType='Anual' where LastAnnual <= 
end;

update Maintenance set nextannual=getDate()+365;

update Maintenance set TotalAnnual = TotalAnnual+1;

select * from maintenance where (NextNormal <= getdate()+7 or NextAnnual <= getdate()+7) and Status='Available';

select * from users;

update users set rol='TOOLING' where userid='ivan.jimenez';

insert into users(Userid, rol) values('ivan.jimenez', 'TOOLING');


drop table CatalogoMantenimiento;

delete users where userid='andres.cortez';


if object_id('dbo.Repair', 'U') IS NOT NULL 
  drop table dbo.Repair;

create table Repair(
	id int identity,
	ToolingID nvarchar(30),
	NP nvarchar(30) unique not null,
	Area nvarchar(50) not null,
	Program nvarchar(50) not null,
	Damage nvarchar(50),
	Status nvarchar(30),
	Requested smalldatetime,
	DamageSearch smalldatetime,
	Repair smalldatetime,
	Bagging smalldatetime,
	RepairValidation smalldatetime,
	Requester nvarchar(50) not null,
	Repairman nvarchar(50) not null,
	primary key(NP)
);

insert into repair(toolingid, np, area, program, damage, Status, Requester, Repairman)
values('tooling-23213213', 'np-tool-13213', 'Area 2', 'Programa der', 'daño tipo 5', 'REQUESTED', 'ivan.jimenez', 'ivan.jimenez');

update repair set status='REQUESTED';

select * from repair;

select * from Maintenance where NP like '%F29%';
