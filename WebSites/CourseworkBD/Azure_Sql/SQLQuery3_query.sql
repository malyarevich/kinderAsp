USE Kinder
--*1 Отримати інформацію про групу дитини за id дитини
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'SelectGroupByChildID')
  DROP PROCEDURE SelectGroupByChildID
GO
CREATE PROC SelectGroupByChildID(@id_child int)
AS
IF @id_child IS NOT null --Gruop
	BEGIN
		SELECT Groups.id_group AS id_group, Groups.name_of_group AS name_of_group, Type_groups.name_of_type AS name_of_type,
			Type_groups.lower_age AS lower_age, Type_groups.higher_age AS higher_age
		FROM (Child INNER JOIN Groups ON Child.id_group = Groups.id_group) 
			INNER JOIN Type_groups ON Groups.id_type = Type_groups.id_type
		WHERE Child.id_child = @id_child
	END
GO
--
EXEC SelectGroupByChildID @id_child = 1;
EXEC SelectGroupByChildID @id_child = 2;
EXEC SelectGroupByChildID @id_child = 3;

--*2 Отримати інформацію про гуртки дитини за id дитини.
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'SelectCircleByChildID')
  DROP PROCEDURE SelectCircleByChildID
GO
CREATE PROC SelectCircleByChildID(@id_child int)
AS
IF @id_child IS NOT null --Gruop
	BEGIN
		SELECT List_of_section.id_section AS id_section, Sections.name_of_section AS name_of_section, Sections.cost AS cost, 
			List_of_section.month_sect AS month_sect, List_of_section.year_sect AS year_sect
		FROM List_of_section INNER JOIN Sections ON List_of_section.id_section = Sections.id_section
		WHERE List_of_section.id_child = @id_child
	END
GO
--
EXEC SelectCircleByChildID @id_child = 1;
EXEC SelectCircleByChildID @id_child = 2;
EXEC SelectCircleByChildID @id_child = 3;


--*3 Одержати відомості про раціон групи за id групи.
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'RationOfGroup')
  DROP PROCEDURE RationOfGroup
GO
CREATE PROC RationOfGroup(@id_group int)
AS
IF @id_group IS NOT null --Gruop
	BEGIN
		SELECT Rations.id_ration AS id_ration, Rations.norm AS norm, Rations.cost AS cost
		FROM (Groups INNER JOIN Type_groups ON Groups.id_type = Type_groups.id_type) 
		INNER JOIN Rations ON Type_groups.id_ration = Rations.id_ration
		WHERE Groups.id_group = @id_group
	END
GO
--
EXEC RationOfGroup @id_group = 1;
EXEC RationOfGroup @id_group = 2;
EXEC RationOfGroup @id_group = 3;

--1. Персональні дані дітей вказанної групи; 
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'PersDataOfSelectGroup')
  DROP PROCEDURE PersDataOfSelectGroup
GO
CREATE PROC PersDataOfSelectGroup(@id_group int)
AS
IF @id_group IS NOT null --Gruop
	BEGIN
		SELECT Child.id_child, (Child.surname + ' ' + Child.first_name + ' ' + Child.last_name) AS [full_name],
		Child.birthday, Child.home_address, Child.id_group, Child.id_type_rel
		FROM Child INNER JOIN Groups ON Child.id_group = Groups.id_group
		WHERE Child.id_group = @id_group
	END
GO
--
EXEC PersDataOfSelectGroup @id_group = 1;-- +3
EXEC PersDataOfSelectGroup @id_group = 2;-- +7
EXEC PersDataOfSelectGroup @id_group = 3;-- +8
--
 
--///--
use Kinder
--2.1 Персональні та контактні дані батьків (родичів) вказанної групи або вказанної дитини;
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'ContactToRelativesOfGroupOrChild')
  DROP PROCEDURE ContactToRelativesOfGroupOrChild

GO
CREATE PROC ContactToRelativesOfGroupOrChild(@id_group int, @id_child int)
AS
IF @id_group IS NOT null --Group
	BEGIN
		SELECT Relatives.id_relatives, (Relatives.surname + ' ' + Relatives.first_name + ' ' + Relatives.last_name) AS [full_name],
			Relatives.home_address, Relatives.telephone, Relatives.place_of_work, Relatives.work_position, Relatives.work_telephone
		FROM ((Relatives_type INNER JOIN Relatives ON Relatives_type.id_relatives = Relatives.id_relatives) 
			INNER JOIN Child ON Child.id_type_rel=Relatives_type.id_type_rel) 
			INNER JOIN Groups ON Groups.id_group=Child.id_group
		WHERE Groups.id_group = @id_group
	END
ELSE
	BEGIN
		SELECT Relatives.id_relatives, (Relatives.surname + ' ' + Relatives.first_name + ' ' + Relatives.last_name) AS [full_name],
			Relatives.home_address, Relatives.telephone, Relatives.place_of_work, Relatives.work_position, Relatives.work_telephone
		FROM (Relatives_type INNER JOIN Relatives ON Relatives_type.id_relatives = Relatives.id_relatives) 
			INNER JOIN Child ON Child.id_type_rel=Relatives_type.id_type_rel
		WHERE Child.id_child = @id_child
	END
GO
--
EXEC ContactToRelativesOfGroupOrChild @id_group = 1, @id_child = null;-- +3
EXEC ContactToRelativesOfGroupOrChild @id_group = 2, @id_child = null;-- +7
EXEC ContactToRelativesOfGroupOrChild @id_group = 3, @id_child = null;-- +8
EXEC ContactToRelativesOfGroupOrChild @id_group = null, @id_child = 1;-- +1
EXEC ContactToRelativesOfGroupOrChild @id_group = null, @id_child = 2;-- +1
EXEC ContactToRelativesOfGroupOrChild @id_group = null, @id_child = 7;-- +1
EXEC ContactToRelativesOfGroupOrChild @id_group = null, @id_child = 8;-- +1
--
GO
--
 
--///--
USE Kinder

--3.1 Склади груп загальні; Склади груп для відвідування певних відів занять; Кількість дітей в кожній групі.
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'GroupMembers')
  DROP PROCEDURE GroupMembers

GO
CREATE PROC GroupMembers(@id_group int, @id_section int)
AS
IF @id_group IS NOT null --Gruop
	BEGIN
		SELECT Groups.id_group AS [Number of Group], Groups.name_of_group AS [Name of Group], 
			(Child.surname + ' ' + Child.first_name + ' ' + Child.last_name) AS [Full Name]
		FROM Groups INNER JOIN Child ON Groups.id_group = Child.id_group
		WHERE (@id_group = Groups.id_group)
		ORDER BY Groups.id_group, [Full Name]
	END
ELSE IF @id_section IS NOT null --Section
	BEGIN
		SELECT Groups.id_group AS [Number of Group], Groups.name_of_group AS [Name of Group], 
			(Child.surname + ' ' + Child.first_name + ' ' + Child.last_name) AS [Full Name],
			Sections.name_of_section AS [Name of section]
		FROM ((Groups INNER JOIN Child ON Groups.id_group = Child.id_group)
			INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
			INNER JOIN Sections ON Sections.id_section = List_of_section.id_section
		WHERE (List_of_section.id_section = @id_section)
		ORDER BY Sections.id_section, Groups.id_group, [Full Name]
	END
ELSE
	BEGIN
		SELECT Groups.id_group, Groups.name_of_group, Count(Child.id_child)
		FROM Groups INNER JOIN Child ON Groups.id_group = Child.id_group
		GROUP BY  Groups.id_group, Groups.name_of_group
	END
GO
--
EXEC GroupMembers @id_group = 1, @id_section = null;-- +3
EXEC GroupMembers @id_group = null, @id_section = 3;-- +1
EXEC GroupMembers @id_group = 3, @id_section = 1;-- +13
EXEC GroupMembers @id_group = null, @id_section = null;-- +4
--
GO
--
 
--///--
USE Kinder
--4	Персональні та контактні дані співробітників дитячого закладу, 
--		що працювали з певною дитиною, групою за весь час навчання, певний проміжок часу
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'PersWithChildOrGroupDate')
  DROP PROCEDURE PersWithChildOrGroupDate

GO
CREATE PROC PersWithChildOrGroupDate(@id_group int, @id_child int, @date_begin date, @date_end date)
AS
IF @id_group IS NOT null --Gruop
	BEGIN
		IF ((@date_begin IS null) OR (@date_end IS null)) --date
			BEGIN
				SELECT DISTINCT (Employee.surname + ' ' + Employee.first_name + ' ' + Employee.last_name) AS [Full Name],
					Employee.birthday, Employee.home_address, Employee.telephone
				FROM ((((Groups INNER JOIN Child ON Groups.id_group = Child.id_group)
					INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
					INNER JOIN Sections ON Sections.id_section = List_of_section.id_section)
					INNER JOIN Teacher_of_section ON Sections.id_section = Teacher_of_section.id_section)
					INNER JOIN Employee ON Employee.id_employee = Teacher_of_section.id_employee
				WHERE ((@id_group = Groups.id_group)
					AND (Teacher_of_section.year_sect + Teacher_of_section.month_sect * 0.01 = List_of_section.year_sect + List_of_section.month_sect * 0.01))
			END
		ELSE
			BEGIN
				SELECT DISTINCT (Employee.surname + ' ' + Employee.first_name + ' ' + Employee.last_name) AS [Full Name],
					Employee.birthday, Employee.home_address, Employee.telephone
				FROM ((((Groups INNER JOIN Child ON Groups.id_group = Child.id_group)
					INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
					INNER JOIN Sections ON Sections.id_section = List_of_section.id_section)
					INNER JOIN Teacher_of_section ON Sections.id_section = Teacher_of_section.id_section)
					INNER JOIN Employee ON Employee.id_employee = Teacher_of_section.id_employee
				WHERE ((@id_group = Groups.id_group) 
					AND (YEAR(@date_begin) + MONTH(@date_begin) * 0.01 < 
						List_of_section.year_sect + List_of_section.month_sect * 0.01)
					AND (YEAR(@date_end) + MONTH(@date_end) * 0.01 > 
						List_of_section.year_sect + List_of_section.month_sect * 0.01)
					AND (Teacher_of_section.year_sect + Teacher_of_section.month_sect * 0.01 = List_of_section.year_sect + List_of_section.month_sect * 0.01))
			END
	END
ELSE
	BEGIN
		IF @id_child IS NOT null --Child
			BEGIN
			IF ((@date_begin IS null) OR (@date_end IS null)) --date
				BEGIN
					SELECT DISTINCT (Employee.surname + ' ' + Employee.first_name + ' ' + Employee.last_name) AS [Full Name],
					Employee.birthday, Employee.home_address, Employee.telephone
					FROM (((Child INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
						INNER JOIN Sections ON Sections.id_section = List_of_section.id_section)
						INNER JOIN Teacher_of_section ON Sections.id_section = Teacher_of_section.id_section)
						INNER JOIN Employee ON Employee.id_employee = Teacher_of_section.id_employee
					WHERE ((@id_child = Child.id_child)
						AND (Teacher_of_section.year_sect + Teacher_of_section.month_sect * 0.01 = List_of_section.year_sect + List_of_section.month_sect * 0.01))
				END
			ELSE
				BEGIN
					SELECT DISTINCT (Employee.surname + ' ' + Employee.first_name + ' ' + Employee.last_name) AS [Full Name],
					Employee.birthday, Employee.home_address, Employee.telephone
					FROM (((Child INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
						INNER JOIN Sections ON Sections.id_section = List_of_section.id_section)
						INNER JOIN Teacher_of_section ON Sections.id_section = Teacher_of_section.id_section)
						INNER JOIN Employee ON Employee.id_employee = Teacher_of_section.id_employee
					WHERE ((@id_child = Child.id_child) 
						AND (YEAR(@date_begin) + MONTH(@date_begin) * 0.01 < 
							List_of_section.year_sect + List_of_section.month_sect * 0.01)
						AND (YEAR(@date_end) + MONTH(@date_end) * 0.01 > 
							List_of_section.year_sect + List_of_section.month_sect * 0.01)
						AND (Teacher_of_section.year_sect + Teacher_of_section.month_sect * 0.01 = List_of_section.year_sect + List_of_section.month_sect * 0.01))
				END
			END
	END
--

GO
EXEC PersWithChildOrGroupDate @id_group = 1, @id_child = null, @date_begin = '1990-01-01', @date_end = '2015-11-12';-- +1
EXEC PersWithChildOrGroupDate @id_group = 2, @id_child = null, @date_begin = '1990-01-01', @date_end = '2015-11-12';
EXEC PersWithChildOrGroupDate @id_group = 3, @id_child = null, @date_begin = '1990-01-01', @date_end = '2015-11-12';-- +1
EXEC PersWithChildOrGroupDate @id_group = null, @id_child = 1, @date_begin = '1990-01-01', @date_end = '2015-11-12';
EXEC PersWithChildOrGroupDate @id_group = null, @id_child = 2, @date_begin = '1990-01-01', @date_end = '2015-11-12';-- +1
EXEC PersWithChildOrGroupDate @id_group = null, @id_child = 7, @date_begin = '1990-01-01', @date_end = '2015-11-12';-- +1
EXEC PersWithChildOrGroupDate @id_group = null, @id_child = 8, @date_begin = null, @date_end = null;-- +2
GO
--
 
--///--
USE Kinder
-- 5.	Відомості про проходження співробітниками медичного огляду 
--		(перелік співробітників, що не пройшли огляд вчасно 
--		або результати огляду не дозволяють їм працювати у дитячому закладі)
SELECT DISTINCT Employee.id_employee, 
	(Employee.surname + ' ' + Employee.first_name + ' ' + Employee.last_name) AS [Full Name],
	Type_of_passage.name_of_passage
FROM (Employee INNER JOIN Medical_Journal ON Employee.id_med_record = Medical_Journal.id_med_record)
	INNER JOIN Type_of_passage ON Type_of_passage.id_passage = Medical_Journal.id_passage
WHERE (Medical_Journal.id_passage = 2 OR Medical_Journal.id_passage = 3)
ORDER BY Type_of_passage.name_of_passage
--
 
--///--
USE Kinder
-- 6.	Медична картка вказанної дитини з для прегляду біометричних даних через певні проміжки часу
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'BiomDataOfChildInDate')
  DROP PROCEDURE BiomDataOfChildInDate

GO
CREATE PROC BiomDataOfChildInDate(@id_child int, @date_begin date, @date_end date)
AS
BEGIN
	SELECT Child.id_child, (Child.surname + ' ' + Child.first_name + ' ' + Child.last_name) AS [Full Name], 
		Height_Weight.date_of_check, Height_Weight.height_of_child, Height_Weight.weight_of_child
	FROM (Child INNER JOIN Medical_card ON Child.id_child = Medical_card.id_child)
		INNER JOIN Height_Weight ON Medical_card.id_med_card = Height_Weight.id_med_card
	WHERE ((Child.id_child = @id_child)
		AND (@date_begin < Height_Weight.date_of_check)
		AND (@date_end > Height_Weight.date_of_check))
END
--

GO
EXEC BiomDataOfChildInDate @id_child = 1, @date_begin = '1990-01-01', @date_end = '2015-11-12';-- +1
EXEC BiomDataOfChildInDate @id_child = 2, @date_begin = '1990-01-01', @date_end = '2015-11-12';-- +1
EXEC BiomDataOfChildInDate @id_child = 3, @date_begin = '2014-09-01', @date_end = '2015-11-12';-- +2
GO
--
 
--///--
USE Kinder
-- 7.	Відомості про щеплення, які були зроблені певній дитині; 
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'VaccinOfChild')
  DROP PROCEDURE VaccinOfChild

GO
CREATE PROC VaccinOfChild(@id_child int)
AS
BEGIN
	SELECT  Child.id_child, (Child.surname + ' ' + Child.first_name + ' ' + Child.last_name) AS [Full Name],
		Type_of_vaccination.type_vac, Type_of_vaccination.num_vac, Type_of_vaccination.term_vac, 
		Vaccination.exec_term
	FROM ((Child INNER JOIN Medical_card ON Child.id_child = Medical_card.id_child)
		INNER JOIN Vaccination ON Medical_card.id_med_card = Vaccination.id_med_card)
		INNER JOIN Type_of_vaccination ON Vaccination.id_type_vac = Type_of_vaccination.id_type_vac
	WHERE Child.id_child = @id_child
	ORDER BY Vaccination.exec_term
END

GO
EXEC VaccinOfChild @id_child = 1;-- +1
EXEC VaccinOfChild @id_child = 2;-- +3
EXEC VaccinOfChild @id_child = 3;-- +3
GO
--
 
--///--
USE Kinder
-- 8.	Списки та загальні кількість дітей, яким мають бути зробленні щеплення у найближчий час;
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'VaccinOfChildInNearTime')
  DROP PROCEDURE VaccinOfChildInNearTime

GO
CREATE PROC VaccinOfChildInNearTime(@date_now date, @month_period int)
AS
BEGIN
	SELECT Child.id_child, (Child.surname + ' ' + Child.first_name + ' ' + Child.last_name) AS [Full Name], 
		((YEAR(@date_now)-YEAR(Child.birthday))*12+(MONTH(@date_now)-MONTH(Child.birthday))) AS [Now month],
	 	NeedVac.term_vac AS [Month Need to vaccinate], NeedVac.type_vac AS [Type of vaccination], 
	 	NeedVac.num_vac [Number of vaccination]
	FROM Child, (
		SELECT Type_of_vaccination.type_vac, Type_of_vaccination.num_vac, Type_of_vaccination.term_vac
		FROM Type_of_vaccination
			
	) AS NeedVac
	WHERE ((YEAR(@date_now)-YEAR(Child.birthday))*12+(MONTH(@date_now)-MONTH(Child.birthday)) >= NeedVac.term_vac - @month_period)
			AND ((YEAR(@date_now)-YEAR(Child.birthday))*12+(MONTH(@date_now)-MONTH(Child.birthday)) <= NeedVac.term_vac)
END

GO
EXEC VaccinOfChildInNearTime @date_now = '2015-11-06', @month_period = 1;-- +2
EXEC VaccinOfChildInNearTime @date_now = '2015-11-06', @month_period = 5;-- +5
EXEC VaccinOfChildInNearTime @date_now = '2015-11-06', @month_period = 10;-- +16
GO
--
 
--///--
USE Kinder
--9.	Список та загальна кількість дітей, яким не були зробленні вчасно щеплення (з вказанням причини). 
SELECT Child.id_child, (Child.surname + ' ' + Child.first_name + ' ' + Child.last_name) AS [Full Name],
	Type_of_vaccination.type_vac, Type_of_vaccination.num_vac, 
	Type_of_vaccination.term_vac, Vaccination.exec_term, Vaccination_reasons.name_of_reason
FROM (((Child INNER JOIN Medical_card ON Child.id_child = Medical_card.id_child)
	INNER JOIN Vaccination ON Medical_card.id_med_card = Vaccination.id_med_card)
	INNER JOIN Type_of_vaccination ON Vaccination.id_type_vac = Type_of_vaccination.id_type_vac)
	INNER JOIN Vaccination_reasons ON Vaccination.id_reason = Vaccination_reasons.id_reason
WHERE Vaccination.exec_term != Type_of_vaccination.term_vac
--
 
--///--
USE Kinder
--10.	Повний переляк занять, які відвідувала вказана дитина в певний проміжок часу
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'SectionOfMembers')
	DROP PROCEDURE SectionOfMembers

GO
CREATE PROC SectionOfMembers(@id_child int, @date_begin date, @date_end date)
AS
BEGIN 
	SELECT Sections.id_section, Sections.name_of_section, 
		List_of_section.month_sect, List_of_section.year_sect
	FROM (Child INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
		INNER JOIN Sections ON List_of_section.id_section = Sections.id_section
	WHERE ((Child.id_child = @id_child)
		AND (YEAR(@date_begin) + MONTH(@date_begin) * 0.01 < 
			List_of_section.year_sect + List_of_section.month_sect * 0.01)
		AND (YEAR(@date_end) + MONTH(@date_end) * 0.01 > 
			List_of_section.year_sect + List_of_section.month_sect * 0.01))
	ORDER BY Sections.id_section, List_of_section.year_sect, List_of_section.month_sect
END
GO
--
EXEC SectionOfMembers @id_child = 1, @date_begin = '1990-01-01', @date_end = '2015-11-12';-- +1
EXEC SectionOfMembers @id_child = 2, @date_begin = '1990-01-01', @date_end = '2015-11-12';-- +1
EXEC SectionOfMembers @id_child = 5, @date_begin = '2014-09-01', @date_end = '2015-11-12';-- +2
--
 
--///--
USE Kinder
--11.	Розклад занять групи, дитини, викладача
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'TimetableForGroupChildOrTeacher')
	DROP PROCEDURE TimetableForGroupChildOrTeacher
GO
CREATE PROC TimetableForGroupChildOrTeacher(@id_group int, @id_child int, @id_teacher int)
AS
IF @id_group IS NOT null --Gruop
	BEGIN
		SELECT DISTINCT Sections.id_section, Sections.name_of_section, 
			List_of_section.month_sect, List_of_section.year_sect
		FROM ((Groups INNER JOIN Child ON Groups.id_group = Child.id_group)
			INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
			INNER JOIN Sections ON Sections.id_section = List_of_section.id_section
		WHERE (@id_group = Groups.id_group)
		ORDER BY Sections.id_section, List_of_section.year_sect, List_of_section.month_sect
	END
ELSE IF @id_child IS NOT null --Child
	BEGIN
		SELECT DISTINCT Sections.id_section, Sections.name_of_section, 
			List_of_section.month_sect, List_of_section.year_sect
		FROM (Child INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
			INNER JOIN Sections ON Sections.id_section = List_of_section.id_section
		WHERE (@id_child = Child.id_child)		
		ORDER BY Sections.id_section, List_of_section.year_sect, List_of_section.month_sect
	END
ELSE IF @id_teacher IS NOT null --Teacher
	BEGIN
		SELECT DISTINCT Sections.id_section, Sections.name_of_section, 
			List_of_section.month_sect, List_of_section.year_sect
		FROM ((List_of_section INNER JOIN Sections ON Sections.id_section = List_of_section.id_section)
			INNER JOIN Teacher_of_section ON Sections.id_section = Teacher_of_section.id_section)
			INNER JOIN Employee ON Employee.id_employee = Teacher_of_section.id_employee
		WHERE (@id_teacher = Employee.id_employee)
		ORDER BY Sections.id_section, List_of_section.year_sect, List_of_section.month_sect
	END
--
GO
EXEC TimetableForGroupChildOrTeacher @id_group = 1, @id_child = null, @id_teacher = null;-- +1
EXEC TimetableForGroupChildOrTeacher @id_group = null, @id_child = 1, @id_teacher = null;-- +1
EXEC TimetableForGroupChildOrTeacher @id_group = null, @id_child = null, @id_teacher = 4;-- +1
--
 
--///--
USE Kinder
--12.	1 Журнал відвідування
--		2 загальна кількість днів, які підлягають оплаті 
--		  за кожен місяць для кожної дитини.
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'VisitJournalTableCost')
	DROP PROCEDURE VisitJournalTableCost
GO
CREATE PROC VisitJournalTableCost(@for_1_any_input varchar(100))
AS
IF @for_1_any_input IS NOT null -- 1 Журнал відвідування
	BEGIN
		SELECT Visits_Journal.*
		FROM ((Child INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
			INNER JOIN Sections ON List_of_section.id_section = Sections.id_section)
			INNER JOIN Visits_Journal ON Sections.id_section = Visits_Journal.id_section
		WHERE ((YEAR(Visits_Journal.date_visit) = List_of_section.year_sect)
			AND (MONTH(Visits_Journal.date_visit) = List_of_section.month_sect)
			AND (Child.id_child = Visits_Journal.id_child))
		ORDER BY Visits_Journal.id_visit
	END
ELSE -- 2 загальна кількість днів, які...
	BEGIN
		SELECT DISTINCT (Child.surname + ' ' + Child.first_name + ' ' + Child.last_name) AS [Full Name],
			List_of_section.month_sect, List_of_section.year_sect,
			Visits_Journal.id_section, Sections.name_of_section,
			COUNT(Visits_Journal.id_section) AS [кол-во дней]
			--, Sections.cost, 
			--Sections.cost*COUNT(Visits_Journal.id_section)
		FROM ((Child INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
			INNER JOIN Sections ON List_of_section.id_section = Sections.id_section)
			INNER JOIN Visits_Journal ON Sections.id_section = Visits_Journal.id_section
		WHERE ((YEAR(Visits_Journal.date_visit) = List_of_section.year_sect)
			AND (MONTH(Visits_Journal.date_visit) = List_of_section.month_sect)
			AND (Child.id_child = Visits_Journal.id_child))
		GROUP BY Child.surname, Child.first_name, Child.last_name, List_of_section.month_sect, List_of_section.year_sect,
			Visits_Journal.id_section, Sections.name_of_section--, Sections.cost
	END
--
GO
EXEC VisitJournalTableCost @for_1_any_input = 'Any input';-- 
EXEC VisitJournalTableCost @for_1_any_input = null;-- 
GO
--
 
--///--
USE Kinder
--13.	Суми оплат для вказаної дитини, групи, закладу вцілому за певний період
IF EXISTS (SELECT * FROM sys.objects WHERE TYPE = 'P' AND name = 'PayChildGroupGardenOfDate')
	DROP PROCEDURE PayChildGroupGardenOfDate
GO
CREATE PROC PayChildGroupGardenOfDate(@id_child int, @id_group int,
	@date_begin date, @date_end date)
AS
IF @id_group IS NOT null --Gruop
	BEGIN
		SELECT Groups.id_group, Groups.name_of_group, 
			SUM(Sections.cost) AS [Сумма], 
			COUNT(Visits_Journal.id_section) AS [Кол-во]
		FROM ((((Groups INNER JOIN Child ON Groups.id_group = Child.id_group) 
			INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
			INNER JOIN Sections ON List_of_section.id_section = Sections.id_section)
			INNER JOIN Visits_Journal ON Sections.id_section = Visits_Journal.id_section)
		WHERE (Child.id_group = @id_group)
			AND (Visits_Journal.id_child = Child.id_child)
			AND	((YEAR(Visits_Journal.date_visit) = List_of_section.year_sect)
			AND (MONTH(Visits_Journal.date_visit) = List_of_section.month_sect)
			AND (Child.id_child = Visits_Journal.id_child)
			AND (YEAR(@date_begin) + MONTH(@date_begin) * 0.01 <= 
				YEAR(Visits_Journal.date_visit) + MONTH(Visits_Journal.date_visit) * 0.01 + DAY(Visits_Journal.date_visit) * 0.0001)
			AND (YEAR(@date_end) + MONTH(@date_end) * 0.01 >= 
				YEAR(Visits_Journal.date_visit) + MONTH(Visits_Journal.date_visit) * 0.01 + DAY(Visits_Journal.date_visit) * 0.0001) 
			)
		GROUP BY Groups.id_group, Groups.name_of_group
		ORDER BY SUM(Sections.cost),COUNT(Visits_Journal.id_section) DESC
	END
ELSE IF @id_child IS NOT null --Child
	BEGIN
		SELECT  X.id_child, X.[ФИО ребенка] AS [Full Name],
			SUM(X.[Кружок]) AS [Сумма]
		FROM (SELECT Child.id_child, (Child.surname + ' ' + Child.first_name + ' ' + Child.last_name) AS [ФИО ребенка],
			Sections.cost*COUNT(Visits_Journal.id_section) AS [Кружок]
		FROM ((Child INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
			INNER JOIN Sections ON List_of_section.id_section = Sections.id_section)
			INNER JOIN Visits_Journal ON Sections.id_section = Visits_Journal.id_section
		WHERE (Child.id_child = @id_child)
			AND (Visits_Journal.id_section = Sections.id_section)
			AND	((YEAR(Visits_Journal.date_visit) = List_of_section.year_sect)
			AND (MONTH(Visits_Journal.date_visit) = List_of_section.month_sect)
			AND (Child.id_child = Visits_Journal.id_child)
			AND (YEAR(@date_begin) + MONTH(@date_begin) * 0.01 <= 
				YEAR(Visits_Journal.date_visit) + MONTH(Visits_Journal.date_visit) * 0.01 + DAY(Visits_Journal.date_visit) * 0.0001)
			AND (YEAR(@date_end) + MONTH(@date_end) * 0.01 >= 
				YEAR(Visits_Journal.date_visit) + MONTH(Visits_Journal.date_visit) * 0.01 + DAY(Visits_Journal.date_visit) * 0.0001) 
			)
		GROUP BY Child.id_child, Child.surname, Child.first_name, Child.last_name, Sections.id_section, Sections.cost
		) AS X
		GROUP BY X.id_child, X.[ФИО ребенка]
	END
ELSE -- Garden
	BEGIN
		SELECT SUM([Сумма за весь период]) AS [Общая сумма садика]
		FROM (SELECT COUNT(Visits_Journal.id_visit)*Sections.cost AS [Сумма за весь период]
		FROM (Sections INNER JOIN Visits_Journal ON Sections.id_section = Visits_Journal.id_section)
			INNER JOIN List_of_section ON Sections.id_section = List_of_section.id_section
		WHERE (YEAR(@date_begin) + MONTH(@date_begin) * 0.01 <= 
				YEAR(Visits_Journal.date_visit) + MONTH(Visits_Journal.date_visit) * 0.01 + DAY(Visits_Journal.date_visit) * 0.0001)
			AND (YEAR(@date_end) + MONTH(@date_end) * 0.01 >= 
				YEAR(Visits_Journal.date_visit) + MONTH(Visits_Journal.date_visit) * 0.01 + DAY(Visits_Journal.date_visit) * 0.0001) 
		GROUP BY Sections.cost, Visits_Journal.id_visit) AS X;

	END
	/*BEGIN
		SELECT TOP 100 PERCENT *---[Стоимость кружка]*[Сколько раз посещал кружок]
		FROM (
			SELECT TOP 100 PERCENT Sections.cost AS [Стоимость кружка], COUNT(Visits_Journal.id_section) AS [Сколько раз посещал кружок]
			FROM ((Child INNER JOIN List_of_section ON Child.id_child = List_of_section.id_child)
				INNER JOIN Sections ON List_of_section.id_section = Sections.id_section)
				INNER JOIN Visits_Journal ON Sections.id_section = Visits_Journal.id_section
			WHERE ((YEAR(Visits_Journal.date_visit) = List_of_section.year_sect)
				AND (MONTH(Visits_Journal.date_visit) = List_of_section.month_sect)
				AND (Child.id_child = Visits_Journal.id_child)
				AND (YEAR(@date_begin) + MONTH(@date_begin) * 0.01 < 
					List_of_section.year_sect + List_of_section.month_sect * 0.01)
				AND (YEAR(@date_end) + MONTH(@date_end) * 0.01 > 
					List_of_section.year_sect + List_of_section.month_sect * 0.01)
				)
			GROUP BY Sections.cost
			ORDER BY COUNT(Visits_Journal.id_section)
			)
			WHERE 
		ORDER BY [Стоимость кружка] DESC			
	END*/
	--
GO
EXEC PayChildGroupGardenOfDate @id_child = 2, @id_group = null, @date_begin = '1990-01-01', @date_end = '2015-11-12';-- 
EXEC PayChildGroupGardenOfDate @id_child = null, @id_group = 3, @date_begin = '1990-01-01', @date_end = '2015-11-12';-- 
EXEC PayChildGroupGardenOfDate @id_child = null, @id_group = null, @date_begin = '2000-10-01', @date_end = '2015-11-12';-- 
GO
--
 
--///--BIG PROBLEM
USE Kinder
--14.	Суми оплат працівникам, які ведуть платні заняття, за кожен місяць
SELECT X.id_emp, X.[ФИО работника], X.month_sect, X.year_sect, SUM(X.cost_of_visits) AS [К оплате]
FROM (SELECT Employee.id_employee AS id_emp, 
	(Employee.surname + ' ' + Employee.first_name + ' ' + Employee.last_name) AS [ФИО работника], Teacher_of_section.month_sect AS month_sect, 
		Teacher_of_section.year_sect AS year_sect, Sections.cost*COUNT(Visits_Journal.id_visit) AS cost_of_visits
	FROM ((Employee INNER JOIN Teacher_of_section ON Employee.id_employee = Teacher_of_section.id_employee)
		INNER JOIN Sections ON Teacher_of_section.id_section = Sections.id_section)
		INNER JOIN Visits_Journal ON Sections.id_section = Visits_Journal.id_section
	WHERE (Teacher_of_section.year_sect = YEAR(Visits_Journal.date_visit)
		AND Teacher_of_section.month_sect = MONTH(Visits_Journal.date_visit)
		AND Visits_Journal.id_section = Teacher_of_section.id_section)
	GROUP BY Employee.id_employee, Employee.surname, Employee.first_name, Employee.last_name,
		Teacher_of_section.month_sect, Teacher_of_section.year_sect,  Sections.cost) AS X
GROUP BY X.id_emp, X.[ФИО работника], X.month_sect, X.year_sect
ORDER BY X.year_sect, X.month_sect
--
 
--///--
