USE master
IF EXISTS (SELECT * FROM sys.databases WHERE name='Kinder')
BEGIN 
DROP DATABASE Kinder
END


USE master
CREATE DATABASE Kinder;
GO 
USE Kinder;
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Employee') AND type in (N'U'))
DROP TABLE Employee_BackUp
GO--24**--TRG
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Visits_Journal') AND type in (N'U'))
DROP TABLE Visits_Journal
GO--23
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Teacher_of_section') AND type in (N'U'))
DROP TABLE Teacher_of_section
GO--22
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Appointment') AND type in (N'U'))
DROP TABLE Appointment
GO--21
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Type_of_position') AND type in (N'U'))
DROP TABLE Type_of_position
GO--20
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Department') AND type in (N'U'))
DROP TABLE Department
GO--19
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Employee') AND type in (N'U'))
DROP TABLE Employee
GO--18
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Medical_Journal') AND type in (N'U'))
DROP TABLE Medical_Journal
GO--17
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Type_of_passage') AND type in (N'U'))
DROP TABLE Type_of_passage
GO--16
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List_of_section') AND type in (N'U'))
DROP TABLE List_of_section
GO--15
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Sections') AND type in (N'U'))
DROP TABLE Sections
GO--14
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Medical_card') AND type in (N'U'))
DROP TABLE Medical_card
GO--13
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Height_Weight') AND type in (N'U'))
DROP TABLE Height_Weight
GO--12
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Vaccination') AND type in (N'U'))
DROP TABLE Vaccination
GO--11
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Vaccination_reasons') AND type in (N'U'))
DROP TABLE Vaccination_reasons
GO--11*
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Type_of_vaccination') AND type in (N'U'))
DROP TABLE Type_of_vaccination
GO--10
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Sick_leaves') AND type in (N'U'))
DROP TABLE Sick_leaves
GO--9
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Type_of_sick_leaves') AND type in (N'U'))
DROP TABLE Type_of_sick_leaves
GO--8
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Child') AND type in (N'U'))
DROP TABLE Child
GO--7
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Relatives_type') AND type in (N'U'))
DROP TABLE Relatives_type
GO--6
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'List_of_relatives_type') AND type in (N'U'))
DROP TABLE List_of_relatives_type
GO--5
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Relatives') AND type in (N'U'))
DROP TABLE Relatives
GO--4
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Groups') AND type in (N'U'))
DROP TABLE Groups
GO--3
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Type_groups') AND type in (N'U'))
DROP TABLE Type_groups
GO--2
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Rations') AND type in (N'U'))
DROP TABLE Rations
GO--1

CREATE TABLE Employee_BackUp
(
	id_employee INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	surname VARCHAR(250) NOT NULL,
	first_name VARCHAR(250) NOT NULL,
	last_name VARCHAR(250) NOT NULL,
	birthday DATE NOT NULL,
	home_address VARCHAR(250),
	telephone BIGINT,
	id_med_record INT
)--18


CREATE TABLE Rations
(
	id_ration INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	norm INT NOT NULL,
	cost INT NOT NULL
)--1
CREATE TABLE Type_groups
(
	id_type INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	name_of_type VARCHAR(250) NOT NULL,
	lower_age INT NOT NULL,
	higher_age INT NOT NULL,
	id_ration INT FOREIGN KEY REFERENCES Rations
)--2
CREATE TABLE Groups
(
	id_group INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	name_of_group VARCHAR(250) NOT NULL,
	id_type INT FOREIGN KEY REFERENCES Type_groups
)--3
CREATE TABLE Relatives
(
	id_relatives INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	surname VARCHAR(250) NOT NULL,
	first_name VARCHAR(250) NOT NULL,
	last_name VARCHAR(250) NOT NULL,
	home_address VARCHAR(250),
	telephone BIGINT,
	place_of_work VARCHAR(250),
	work_position VARCHAR(250),
	work_telephone BIGINT
)--4
CREATE TABLE List_of_relatives_type
(
	id_rel_type INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	name_of_type VARCHAR(250) NOT NULL
)--5
CREATE TABLE Relatives_type
(
	id_type_rel INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_rel_type INT FOREIGN KEY REFERENCES List_of_relatives_type,
	id_relatives INT FOREIGN KEY REFERENCES Relatives
)--6
CREATE TABLE Child
(
	id_child INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	surname VARCHAR(250) NOT NULL,
	first_name VARCHAR(250) NOT NULL,
	last_name VARCHAR(250) NOT NULL,
	birthday DATE NOT NULL,
	home_address VARCHAR(250),
	id_group INT FOREIGN KEY REFERENCES Groups,
	id_type_rel INT FOREIGN KEY REFERENCES Relatives_type
)--7
CREATE TABLE Medical_card
(
	id_med_card INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_child INT FOREIGN KEY REFERENCES Child,
	--id_h_w int FOREIGN KEY REFERENCES Height_Weight,
	--id_vac int FOREIGN KEY REFERENCES Vaccination,
	--id_sick_leave int FOREIGN KEY REFERENCES Sick_leaves
)--8
CREATE TABLE Type_of_sick_leaves
(
	id_type_sick_leave INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	name_of_sick_leave VARCHAR(250) NOT NULL
)--9
CREATE TABLE Sick_leaves
(
	id_sick_leave INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_med_card INT FOREIGN KEY REFERENCES Medical_card,
	begin_sick DATE NOT NULL,
	end_sick DATE NOT NULL,
	autor VARCHAR(250) NOT NULL,
	id_type_sick_leave INT FOREIGN KEY REFERENCES Type_of_sick_leaves
)--10
CREATE TABLE Vaccination_reasons 
(
	id_reason INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	name_of_reason VARCHAR(250) NOT NULL
)--11*(reason)
--reason of dismiss
CREATE TABLE Type_of_vaccination
(
	id_type_vac INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	type_vac VARCHAR(250) NOT NULL,
	num_vac INT NOT NULL,
	term_vac INT NOT NULL
)--11
CREATE TABLE Vaccination
(
	id_vac INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_med_card INT FOREIGN KEY REFERENCES Medical_card,
	exec_term INT NOT NULL,
	id_type_vac INT FOREIGN KEY REFERENCES Type_of_vaccination,
	id_reason INT FOREIGN KEY REFERENCES Vaccination_reasons
)--12
CREATE TABLE Height_Weight
(
	id_h_w INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_med_card INT FOREIGN KEY REFERENCES Medical_card,
	height_of_child INT NOT NULL,
	weight_of_child INT NOT NULL,
	date_of_check DATE NOT NULL
)--13
CREATE TABLE Sections
(
	id_section INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	cost INT NOT NULL,
	name_of_section VARCHAR(250) NOT NULL
)--14
CREATE TABLE List_of_section
(
	id_record_section INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_section INT FOREIGN KEY REFERENCES Sections,
	id_child INT FOREIGN KEY REFERENCES Child,
	month_sect INT NOT NULL,
	year_sect INT NOT NULL
)--15
CREATE TABLE Type_of_passage
(
	id_passage INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	name_of_passage VARCHAR(250) NOT NULL
)--16
CREATE TABLE Medical_Journal
(
	id_med_record INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	date_of_passage DATE NOT NULL,
	id_passage INT FOREIGN KEY REFERENCES Type_of_passage
)--17
CREATE TABLE Employee
(
	id_employee INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	surname VARCHAR(250) NOT NULL,
	first_name VARCHAR(250) NOT NULL,
	last_name VARCHAR(250) NOT NULL,
	birthday DATE NOT NULL,
	home_address VARCHAR(250),
	telephone BIGINT,
	id_med_record INT FOREIGN KEY REFERENCES Medical_Journal
)--18
CREATE TABLE Department
(
	id_dept INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	title_dept VARCHAR(250) NOT NULL,
	attribute_dept VARCHAR(250)
)--19
CREATE TABLE Type_of_position
(
	id_position INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	title_position VARCHAR(250) NOT NULL,
	id_dept INT FOREIGN KEY REFERENCES Department,
	salary REAL NOT NULL
)--20
CREATE TABLE Appointment
(
	id_appointment INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_employee INT FOREIGN KEY REFERENCES Employee,
	id_position INT FOREIGN KEY REFERENCES Type_of_position,
	date_of_employment DATE NOT NULL,
	date_of_dismissal DATE
)--21
CREATE TABLE Teacher_of_section
(
	id_teacher_sect INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_section INT FOREIGN KEY REFERENCES Sections,
	id_employee INT FOREIGN KEY REFERENCES Employee,
	month_sect INT NOT NULL,
	year_sect INT NOT NULL
)--22
CREATE TABLE Visits_Journal
(
	id_visit INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_section INT FOREIGN KEY REFERENCES Sections,
	id_child INT NOT NULL,
	date_visit DATE NOT NULL
)--23
--