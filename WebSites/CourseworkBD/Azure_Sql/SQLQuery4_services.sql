USE Kinder
--FUNCTION
--13.	Суми оплат для вказаної дитини, групи, закладу вцілому за певний період
GO 
IF OBJECT_ID (N'dbo.FuncSumOfDateForGarden', N'FN') IS NOT NULL
    DROP FUNCTION dbo.FuncSumOfDateForGarden;
GO
CREATE FUNCTION FuncSumOfDateForGarden(@date_begin DATE, @date_end DATE)
	RETURNS INT AS
		BEGIN
		DECLARE @t INT
		SET @t = (
			SELECT SUM([—умма за весь период]) AS [ќбща¤ сумма садика]
			FROM (SELECT COUNT(Visits_Journal.id_visit)*Sections.cost AS [—умма за весь период]
			FROM (Sections INNER JOIN Visits_Journal ON Sections.id_section = Visits_Journal.id_section)
				INNER JOIN List_of_section ON Sections.id_section = List_of_section.id_section
			WHERE (YEAR(@date_begin) + MONTH(@date_begin) * 0.01 <= 
					YEAR(Visits_Journal.date_visit) + MONTH(Visits_Journal.date_visit) * 0.01 + DAY(Visits_Journal.date_visit) * 0.0001)
				AND (YEAR(@date_end) + MONTH(@date_end) * 0.01 >= 
					YEAR(Visits_Journal.date_visit) + MONTH(Visits_Journal.date_visit) * 0.01 + DAY(Visits_Journal.date_visit) * 0.0001) 
			GROUP BY Sections.cost, Visits_Journal.id_visit) AS X
			)
		RETURN @t
		END
--
 
GO
USE Kinder
SELECT Kinder.dbo.FuncSumOfDateForGarden('2000-10-01', '2015-11-12') AS [общая сумма оплат на заведение]
--///--
USE Kinder
--TRIGGER
--Запрещаем вставлять запись в Teacher_of_section, на текущий месяц и год на секции уже закреплен учитель

IF OBJECT_ID('TRG_DenyInsDupOfSectOnMonthYear') IS NOT NULL
DROP TRIGGER TRG_DenyInsDupOfSectOnMonthYear
GO
CREATE TRIGGER TRG_DenyInsDupOfSectOnMonthYear
ON Teacher_Of_section
AFTER INSERT AS
	BEGIN
		SET NOCOUNT ON;
		----------------------------------------------
	IF (EXISTS(SELECT Teacher_Of_section.month_sect,Teacher_Of_section.year_sect, Teacher_Of_section.id_section 
				FROM Kinder.dbo.Teacher_Of_section
				WHERE (Teacher_Of_section.month_sect = (SELECT month_sect FROM INSERTED)
					AND Teacher_Of_section.year_sect = (SELECT year_sect FROM INSERTED)
					AND Teacher_Of_section.id_section = (SELECT id_section FROM INSERTED)
					)
			))

		BEGIN
			ROLLBACK
			PRINT'Вы не можете добавить преподавателя на данный месяц в данную секцию, так как на эту секцию уже закреплен преподаватель.'
		END
	ELSE
		BEGIN
			PRINT'Запись добавлена.'
		END
	END
GO
USE Kinder

INSERT INTO Teacher_of_section(id_section, id_employee, month_sect, year_sect) VALUES
	(2, 3, 3, 2013)
GO
SELECT * from Teacher_of_section
ORDER BY year_sect, month_sect, id_section
GO


--Создаем резервную копию всех вставок в таблицу Работников
USE Kinder
IF OBJECT_ID('TRG_InsertSyncEmp') IS NOT NULL
DROP TRIGGER TRG_InsertSyncEmp
GO

CREATE TRIGGER TRG_InsertSyncEmp 
ON Kinder.dbo.Employee
AFTER INSERT AS
	BEGIN
		INSERT INTO Kinder.dbo.Employee_BackUp(surname, first_name, last_name, birthday, home_address, telephone, id_med_record)
		SELECT surname, first_name, last_name, birthday, home_address, telephone, id_med_record 
		FROM INSERTED
	END
GO

INSERT INTO Employee (surname, first_name, last_name, birthday, home_address, telephone, id_med_record) VALUES 
('Grinko', 'Alex', 'Rigorioch', '2012-10-22 00:00:00', 'st. Pobedi, 34, 22', 380987415623, null) 


SELECT * from Employee
SELECT * from Employee_BackUp 
GO

USE Kinder
--INDEX
	--индекс для таблицы Работников по столбцам [ФИО] в первичной группе файлов
GO
--DROP INDEX Employee.INDX_cl_EmpId
DROP INDEX INDX_cl_EmpId
ON Employee
GO
CREATE UNIQUE CLUSTERED INDEX INDX_cl_EmpId
	ON Employee (surname ASC, first_name ASC, last_name ASC)

----------------------------------------------------------------------------------
	-- индекс для таблицы Visits_Journal по столбцам id_child и id_section
USE Kinder
GO
DROP INDEX Visits_Journal.INDX_ncl_VisJournlIdChild
GO
CREATE NONCLUSTERED INDEX INDX_ncl_VisJournlIdChild 
	ON Visits_Journal (id_child ASC, id_section DESC)
GO
-----------------------------------------------------------------------------------
	-- Кластиризированный индекс для таблицы Child по столбцам [ФИО]
USE Kinder
IF OBJECT_ID('INDX_ChildSurname') IS NOT NULL
DROP INDEX INDX_cl_ChildSurname
ON Child
GO
USE Kinder
CREATE CLUSTERED INDEX INDX_cl_ChildSurname 
ON Child (surname ASC, first_name ASC, last_name ASC)
GO
SELECT Child.surname
FROM Child JOIN Groups ON Child.id_group = Groups.id_group
WHERE Child.surname = 'Sidorov'

USE Kinder
--CURSOR
-----------------------------------------------
--курсор для вывода списка детей которые ходят на кружки.

DECLARE	@SFL			VARCHAR(250),
		@amountSections INT,
		@message		VARCHAR(250)
PRINT ' Список детей:'
DECLARE CRS_ChildOnSections CURSOR LOCAL FOR
    SELECT (Child.surname + ' ' + Child.first_name + ' ' + Child.last_name) AS [ФИО], COUNT(List_of_section.id_child) AS [Кол-во секций]
    FROM Child INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child
    GROUP BY Child.surname, Child.first_name, Child.last_name
	ORDER BY [ФИО]ASC, [Кол-во секций] ASC

OPEN CRS_ChildOnSections
FETCH NEXT FROM CRS_ChildOnSections INTO @SFL, @amountSections
WHILE @@FETCH_STATUS=0
BEGIN
    /*SELECT @message = 'Ребенок '+ @SFL +
                    ' Кол-во '+ @amountSections*/
    PRINT ('Ребенок - '+ @SFL + CHAR(13) + SPACE(3) + 'кол-во посещаемых секций '+ CONVERT(VARCHAR(250), @amountSections))

    FETCH NEXT FROM CRS_ChildOnSections 
      INTO @SFL, @amountSections
END
CLOSE CRS_ChildOnSections
DEALLOCATE CRS_ChildOnSections
-------------------------------------

--EXPLICIT
-- TBL_temp
USE Kinder
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TBL_temp') AND type in (N'U'))
DROP TABLE TBL_temp
GO--1
CREATE TABLE TBL_temp
(
	id_tmp INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_child INT NOT NULL,--Child.id_child%TYPE NOT NULL,
	surname VARCHAR(250) NOT NULL,
	first_name VARCHAR(250) NOT NULL,
	last_name VARCHAR(250) NOT NULL
)--tmp-1
GO
--

--1--non-parametric
--Childs that does not attend sections.
USE Kinder
DECLARE @Chld_id INT
DECLARE @Chld_surname VARCHAR(250)
DECLARE @Chld_firstName VARCHAR(250)
DECLARE @Chld_lastName VARCHAR(250)
DECLARE @Chld_birthday DATE
DECLARE @Chld_homeAddress VARCHAR(250)
DECLARE @Chld_idGroup INT
DECLARE @Chld_idTypeRel INT

DECLARE @CRS_getChilds CURSOR
	SET @CRS_getChilds = CURSOR FOR
		SELECT * FROM Child
	OPEN @CRS_getChilds
	FETCH NEXT FROM @CRS_getChilds INTO @Chld_id, @Chld_surname, @Chld_firstName, @Chld_lastName,
		@Chld_birthday, @Chld_homeAddress, @Chld_idGroup, @Chld_idTypeRel--%ROWTYPE
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS(SELECT id_child 
			FROM List_of_section
			WHERE List_of_section.id_child=@Chld_id)
		BEGIN
			INSERT INTO TBL_temp (id_child, surname, first_name, last_name) 
				VALUES(@Chld_id, @Chld_surname, @Chld_firstName, @Chld_lastName)
		END
		FETCH NEXT FROM @CRS_getChilds INTO @Chld_id, @Chld_surname, @Chld_firstName, @Chld_lastName,
		@Chld_birthday, @Chld_homeAddress, @Chld_idGroup, @Chld_idTypeRel--%ROWTYPE
	END
	CLOSE @CRS_getChilds

	--
GO
SELECT * FROM TBL_temp
GO
TRUNCATE TABLE TBL_temp
GO
DEALLOCATE @CRS_getChilds

--2--parametric.
--SECURITY
--Is This Child that attend sections.
USE Kinder
DECLARE @Chld_id INT
DECLARE @Chld_surname VARCHAR(250)
DECLARE @Chld_firstName VARCHAR(250)
DECLARE @Chld_lastName VARCHAR(250)
DECLARE @Sctn_title VARCHAR(250)

--parametric-without-procedure
DECLARE @Need_idChild INT
SET @Need_idChild = 1

DECLARE @CRS_isChildAttendSections CURSOR
	SET @CRS_isChildAttendSections = CURSOR FOR
		SELECT DISTINCT Child.id_child, Child.surname, Child.first_name, Child.last_name, Sections.name_of_section
		FROM (Child INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
			INNER JOIN Sections ON List_of_section.id_section = Sections.id_section
		WHERE Child.id_child = @Need_idChild
	OPEN @CRS_isChildAttendSections
	FETCH NEXT FROM @CRS_isChildAttendSections INTO @Chld_id, @Chld_surname, @Chld_firstName, @Chld_lastName, @Sctn_title--%ROWTYPE
	WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT (@Chld_surname + SPACE(1) + @Chld_firstName + SPACE(1) + @Chld_lastName + ' attend - ' + @Sctn_title + '.')  
	FETCH NEXT FROM @CRS_isChildAttendSections INTO @Chld_id, @Chld_surname, @Chld_firstName, @Chld_lastName, @Sctn_title--%ROWTYPE
	END
	CLOSE @CRS_isChildAttendSections

	--
GO
DEALLOCATE @CRS_isChildAttendSections

USE Kinder
--SELECT * FROM sys.fn_builtin_permissions('SERVER') ORDER BY permission_name;
--SELECT * FROM sys.fn_builtin_permissions('Kinder') ORDER BY permission_name;

--
--create role [ViewServerState] 
--add [SomeFakeLogin] to [ViewServerState]
--give rights [VIEW SERVER] for [ViewServerState]
--
-------------------Role Methodist
USE Kinder
GO
CREATE ROLE PositionMethodist AUTHORIZATION dbo--sa
GO
ALTER ROLE PositionMethodist ADD MEMBER userMeth1
GO
ALTER ROLE PositionMethodist ADD MEMBER userMeth2
GO
GRANT EXECUTE ON OBJECT::dbo.PersDataOfSelectGroup
TO PositionMethodist;
GRANT EXECUTE ON OBJECT::dbo.GroupMembers
TO PositionMethodist;
GRANT EXECUTE ON OBJECT::dbo.TimetableForGroupChildOrTeacher
TO PositionMethodist;
GRANT EXECUTE ON OBJECT::dbo.SectionOfMembers
TO PositionMethodist;
GRANT EXECUTE ON OBJECT::dbo.ContactToRelativesOfGroupOrChild
TO PositionMethodist;
GRANT UPDATE ON OBJECT::dbo.Child TO PositionMethodist;
GO
GO
-------------------Role Employee
USE Kinder
GO
CREATE ROLE PositionEmployee AUTHORIZATION dbo--sa
GO
ALTER ROLE PositionMethodist ADD MEMBER userEmp1
GO
ALTER ROLE PositionMethodist ADD MEMBER userEmp2
GO
GRANT EXECUTE ON OBJECT::dbo.PersDataOfSelectGroup
TO PositionEmployee;
GRANT EXECUTE ON OBJECT::dbo.GroupMembers
TO PositionEmployee;
GRANT EXECUTE ON OBJECT::dbo.TimetableForGroupChildOrTeacher
TO PositionEmployee;
GRANT EXECUTE ON OBJECT::dbo.SectionOfMembers
TO PositionEmployee;
GRANT EXECUTE ON OBJECT::dbo.ContactToRelativesOfGroupOrChild
TO PositionEmployee;
GO
-------------------Role Revative
USE Kinder
GO
CREATE ROLE PositionRelative AUTHORIZATION dbo--sa
GO
ALTER ROLE PositionMethodist ADD MEMBER userRel1
GO
ALTER ROLE PositionMethodist ADD MEMBER userRel2
GO
GRANT EXECUTE ON OBJECT::dbo.PersDataOfSelectGroup
TO PositionRelative;
GRANT EXECUTE ON OBJECT::dbo.GroupMembers
TO PositionRelative;
GRANT EXECUTE ON OBJECT::dbo.BiomDataOfChildInDate
TO PositionRelative;
GRANT EXECUTE ON OBJECT::dbo.PersWithChildOrGroupDate
TO PositionRelative;
GRANT EXECUTE ON OBJECT::dbo.VaccinOfChildOfChild
TO PositionRelative;
GRANT EXECUTE ON OBJECT::dbo.VaccinOfChildOfChildInNearTime
TO PositionRelative;
GO 
GO

--GO

Use Kinder
drop role AdminS
GO

Use Kinder
create role AdminS
Go

Use Kinder

GRANT all PRIVILEGES  to AdminS WITH GRANT OPTION
go

grant select, insert, delete, update on [dbo].[Rations] to AdminS
grant select, insert, delete, update on [dbo].[Type_groups] to AdminS
grant select, insert, delete, update on [dbo].[Groups] to AdminS
grant select, insert, delete, update on [dbo].[Relatives] to AdminS
grant select, insert, delete, update on [dbo].[List_of_relatives_type]  to AdminS
grant select, insert, delete, update on [dbo].[Relatives_type] to AdminS
grant select, insert, delete, update on [dbo].[Child] to AdminS
grant select, insert, delete, update on [dbo].[Medical_card] to AdminS
grant select, insert, delete, update on [dbo].[Type_of_sick_leaves] to AdminS
grant select, insert, delete, update on [dbo].[Sick_leaves] to AdminS
grant select, insert, delete, update on [dbo].[Vaccination_reasons] to AdminS
grant select, insert, delete, update on [dbo].[Type_of_vaccination] to AdminS
grant select, insert, delete, update on [dbo].[Vaccination] to AdminS
grant select, insert, delete, update on [dbo].[Height_Weight] to AdminS
grant select, insert, delete, update on [dbo].[Sections] to AdminS
grant select, insert, delete, update on [dbo].[List_of_section] to AdminS
grant select, insert, delete, update on [dbo].[Type_of_passage] to AdminS
grant select, insert, delete, update on [dbo].[Medical_Journal] to AdminS
grant select, insert, delete, update on [dbo].[Employee] to AdminS
grant select, insert, delete, update on [dbo].[Department] to AdminS
grant select, insert, delete, update on [dbo].[Type_of_position] to AdminS
grant select, insert, delete, update on [dbo].[Appointment] to AdminS
grant select, insert, delete, update on [dbo].[Teacher_of_section] to AdminS
grant select, insert, delete, update on [dbo].[Visits_Journal] to AdminS

grant execute on [PersDataOfSelectGroup] to AdminS
grant execute on [ContactToRelativesOfGroupOrChild] to AdminS
grant execute on [GroupMembers] to AdminS
grant execute on [PersWithChildOrGroupDate] to AdminS
grant execute on [BiomDataOfChildInDate] to AdminS
grant execute on [VaccinOfChild] to AdminS
grant execute on [VaccinOfChildInNearTime] to AdminS
grant execute on [SectionOfMembers] to AdminS
grant execute on [TimetableForGroupChildOrTeacher] to AdminS
grant execute on [VisitJournalTableCost] to AdminS
grant execute on [PayChildGroupGardenOfDate] to AdminS
																				exec  sp_droplogin 'admins'
exec  sp_addlogin 'admins','password_123',[Kinder]
GO

exec  sp_dropuser  'AD1'
exec sp_adduser 'admins', 'AD1'

GO
exec  sp_droprolemember 'AdminS','AD1'
exec  sp_addrolemember 'AdminS','AD1'
GO