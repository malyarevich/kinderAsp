USE Kinder
INSERT INTO Rations (norm, cost) VALUES 
	(5, 15),
	(8, 24),
	(10, 30),
	(15, 35)
GO
INSERT INTO Type_groups (name_of_type, lower_age, higher_age, id_ration ) VALUES 
	('Yasli', 0, 1, 1),
	('Mladshi', 2, 3, 2),
	('Starshi', 4, 5, 3),
	('Podgotovitelni', 6, 7, 4)
GO
INSERT INTO Groups (name_of_group, id_type) VALUES 
	('Yaselnaya gruppa', 1),
	('Mladshaya gruppa', 2),
	('Starshaya gruppa', 3),
	('Podgotovitelnaya gruppa', 4)
GO
INSERT INTO Relatives(surname, first_name, last_name, home_address, telephone, place_of_work, work_position, work_telephone) VALUES
	('Popov', 'Pop', 'Popovich', 'Popovskoe shosse 1', 380984864321, 'Dneprospecstal', 'Rabochiy', 80612241387),
	('Ivanov', 'Ivan', 'Ivanovich', 'Dnevnovskoe shosse 2', 380184864321, 'Zaporojstal', 'Podryadchik', 80612321136),
	('Paulov', 'Paul', 'Paulovich', 'Popovskoe shosse 3', 380987486321, 'Dneprospecstal', 'Rabochiy', 80612241387),
	('Petrov', 'Petr', 'Petrovich', 'Dnevnovskoe shosse 4', 380918486189, 'Alyumineviy zavod', 'Podryadchik', 80612124563),
	('Vasilov', 'Vasil', 'Vasilovich', 'Popovskoe shosse 5', 380189486321, 'Dneprospecstal', 'Rabochiy', 80612241387),
	('Nikolov', 'Nikol', 'Nikolovich', 'Popovskoe shosse 6', 380948654189, 'Zaporojstal', 'Podryadchik', 80612321136),
	('Zinovov', 'Zinov', 'Zinovovich', 'Dnevnovskoe shosse 7', 380918954861, 'Alyumineviy zavod', 'Rabochiy', 80521428457),
	('Igorov', 'Igor', 'Igorovich', 'Igorovskoe shosse 1', 380987486321, 'Dneprospecstal', 'Rabochiy', 80612124563),
	('Oksi', 'Oksana', 'Glebovna', 'Lenina 2, 15', 380980014321, 'Zaporojstal', 'Owner', 80612242287),
	('Olgach', 'Olga', 'Olegovna', 'Lenina 12, 66', 380987600121, 'Dneprospecstal', 'Podryadchik', 80612241387),
	('Rio', 'Margo', 'Alekseyevna',  'Kremlyevskaya 44, 81', 380987654001, 'Alyumineviy zavod', 'Rabochiy', 80612321136),
	('Roy', 'Pavel', 'Igorovich', 'Lenina 212, 104', 380987914601, 'Zaporojstal', 'Direktor', 80612321136),
	('Nikolov', 'Petr', 'Ivanovich', 'Naberejnaya 53, 7', 380981467911, 'Alyumineviy zavod', 'Ohrannik', 80521428457),
	('Ivanov', 'Margo', 'Popovich', 'Kremlyevskaya 44, 2', 380981461001, 'Dneprospecstal', 'Uborshik', 80612241387),
	('Ivanov', 'Oksana', 'Alekseyevna', 'Naberejnaya 174, 81', 380987146794, 'Angolenko', 'Uborshik', 80612124563),
	('Paulov', 'Petr', 'Ivanovich', 'Lenina 32, 81', 380791464001, 'Zaporojstal', 'Rabochiy', 80612321136),
	('Ivanov', 'Margo', 'Zinovovich', 'Kremlyevskaya 53, 7', 380987146798, 'Dneprospecstal', 'Uborshik', 80612241387),
	('Nikolov', 'Zinov', 'Alekseyevna', 'Lenina 53, 17', 380987146101, 'Dneprospecstal', 'Podryadchik', 80521428457),
	('Paulov', 'Petr', 'Zinovovich', 'Naberejnaya 19, 7', 380987651467, 'Zaporojstal', 'Rabochiy', 80612321136),
	('Petrov', 'Margo', 'Ivanovich', 'Lenina 32, 17', 380971464001, 'Dneprospecstal', 'Uborshik', 80521428457)
GO
INSERT INTO List_of_relatives_type(name_of_type) VALUES
	('Papa'),
	('Mama'),
	('Dyadya'),
	('Tyetya'),
	('Deda'),
	('Baba'),
	('Opekun')
GO
INSERT INTO Relatives_type(id_rel_type, id_relatives) VALUES
	(2, 13),
	(1, 15),
	(1, 16),
	(1, 11),
	(1, 1),
	(1, 2),
	(1, 3),
	(1, 4),
	(3, 5),
	(5, 6),
	(1, 2),
	(5, 7),
	(5, 8),
	(4, 9),
	(4, 10),
	(5, 11),
	(6, 8),
	(7, 12),
	(7, 13),
	(2, 14),
	(1, 15),
	(1, 20),
	(1, 17),
	(5, 18),
	(4, 19)
GO
INSERT INTO Child(surname, first_name, last_name, birthday, home_address, id_group, id_type_rel) VALUES
	('Ivanov', 'Vasya', 'Ivanovich', '2012-10-22', 'Lenina 22', 2, 1),
	('Petrov', 'Alex', 'Ivanovich', '2011-06-22',  'Borodinskaya 33', 3, 2),
	('Petrov', 'Oleg', 'Ivanovich', '2009-06-22',  'Patioticheskaya 44', 4, 3),
	('Sidorov', 'Artur', 'Igorovich', '2009-10-22', 'Lenina 55', 4, 4),
	('Petrov', 'Ivan', 'Igorovich', '2010-05-22', 'Kremlevskaya 66', 4, 5),
	('Sidorov', 'Alex', 'Igorovich', '2010-10-22', 'Borodinskaya 72', 4, 6),
	('Sidorov', 'Tomara', 'Artemich', '2010-10-22', 'Kremlevskaya 54', 4, 7),
	('Sidorov', 'Silyar', 'Artemich', '2014-01-22', 'Borodinskaya 19', 1, 8),
	('Sidorov', 'Oleg', 'Artemich', '2013-10-22', 'Lenina 73', 1, 9),
	('Sidorov', 'Grisha', 'Rumakich', '2012-10-22', 'Borodinskaya 54', 3, 10),
	('Firowa', 'Gulchitai', 'Tupovna', '2012-10-22', 'Lenina 53', 3, 11),
	('Alekseyev', 'Jenya', 'Ivanovich', '2011-06-22', 'Borodinskaya 78', 3, 12),
	('Alekseyev', 'Alex', 'Rumakich', '2011-05-22', 'Borodinskaya 94', 3, 13),
	('Petrov', 'Tomara', 'Rumakivna', '2011-06-22', 'Lenina 57', 3, 14),
	('Alekseyev', 'Alex', 'Igorovich', '2012-06-22', 'Borodinskaya 92', 3, 15),
	('Petrov', 'Ivan', 'Alekseevich', '2009-10-22', 'Kremlevskaya 47', 4, 16),
	('Alekseyev', 'Nazar', 'Alekseevich', '2014-01-22', 'Borodinskaya 82', 1, 17),
	('Petrov', 'Tomara', 'Alekseevna', '2011-05-22', 'Kremlevskaya 99', 3, 18),
	('Alekseyev', 'Vasya', 'Petrovich', '2012-06-22', 'Patioticheskaya 45', 2, 19),
	('Romashkin', 'Ivan', 'Alekseevna', '2011-10-22', 'Borodinskaya 15', 3, 20),
	('Kulinich', 'Kolya', 'Nikolaevich', '2012-05-22', 'Kremlevskaya 5', 2, 21),
	('Petrov', 'Jenya', 'Alekseevna', '2010-05-22', 'Lenina 17', 4, 22),
	('Kulinich', 'Vasya', 'Ivanovich', '2012-05-22', 'Borodinskaya 49', 3, 23),
	('Petrov', 'Ivan', 'Artemich', '2013-10-22', 'Lenina 18', 2, 24),
	('Romashkin', 'Alex', 'Nikolaevich', '2012-06-12', 'Borodinskaya 48', 3, 25),
	('Petrov', 'Nazar', 'Ivanovich', '2013-11-22', 'Lenina 8', 2, 20),
	('Roy', 'Nazar', 'Artemich', '2012-12-22', 'Kremlevskaya 72', 3, 21),
	('Roy', 'Filon', 'Alekseevich', '2012-10-22', 'Borodinskaya 48', 3, 22),
	('Petrov', 'Roman', 'Rumakich', '2013-04-22', 'Lenina 19', 2, 23),
	('Kulinich', 'Darin', 'Nikolaevich', '2013-06-22', 'Borodinskaya 184', 2, 25)
GO
INSERT INTO Medical_card(id_child) VALUES
	(2),
	(3),
	(1),
	(4),
	(5)
GO
INSERT INTO Type_of_sick_leaves(name_of_sick_leave) VALUES
	('ORV'),
	('Travma'),
	('Slojnoe'),
	('Semeynoye')
GO
INSERT INTO Sick_leaves(id_med_card, begin_sick, end_sick, autor, id_type_sick_leave) VALUES
	(2, '2010-10-22 00:00:00', '2010-10-22 00:00:00', 'vrach', 1),
	(3, '2011-03-20 00:00:00', '2011-04-02 00:00:00', 'vrach', 2),
	(2, '2012-10-22 00:00:00', '2012-10-28 00:00:00', 'vrach', 3),
	(1, '2010-08-22 00:00:00', '2010-08-25 00:00:00', 'vrach', 4),
	(5, '2014-10-21 00:00:00', '2014-10-23 00:00:00', 'mama', 2),
	(4, '2015-02-22 00:00:00', '2015-03-22 00:00:00', 'vrach', 3),
	(5, '2010-09-05 00:00:00', '2010-09-21 00:00:00', 'vrach', 1)
GO
INSERT INTO Vaccination_reasons(name_of_reason) VALUES
	('Prichina opozdaniya'),
	('Prichina bolezn'),
	('Prichina otkaz')
GO
INSERT INTO Type_of_vaccination(type_vac, num_vac, term_vac) VALUES
	('ODV', 1, 5),
	('OVI', 1, 6),
	('OMS', 1, 12),
	('OVI', 2, 18),
	('ODV', 2, 24),
	('ODV', 3, 36),
	('OMS', 2, 48),
	('OVI', 3, 60)
GO
INSERT INTO Vaccination(id_med_card, exec_term, id_type_vac, id_reason) VALUES
	(1, 5, 1, null),
	(2, 18, 4, null),
	(3, 19, 4, 1),
	(2, 20, 4, 2),
	(1, 36, 6, null),
	(4, 13, 3, 3),
	(5, 24, 5, null),
	(2, 18, 4, null),
	(1, 12, 3, null)
GO
INSERT INTO Height_Weight(id_med_card, height_of_child, weight_of_child, date_of_check) VALUES
	(1, 140, 35, '2014-10-01'),
	(2, 130, 32, '2015-04-01'),
	(3, 123, 28, '2015-04-01'),
	(2, 134, 36, '2015-10-01'),
	(4, 131, 40, '2015-10-01')
GO
INSERT INTO Sections(cost, name_of_section) VALUES
	(45, 'Tantsi'),
	(15, 'Shaski'),
	(8, 'Pismo'),
	(5, 'Risovanie')
GO
INSERT INTO List_of_section(id_section, id_child, month_sect, year_sect) VALUES
	(1, 5, 4, 2015),
	(2, 6, 4, 2015),
	(4, 7, 5, 2015),
	(2, 8, 3, 2015),
	(1, 4, 2, 2015),
	(3, 3, 10, 2015),
	(2, 2, 2, 2015),
	(1, 1, 3, 2015),
	(3, 2, 4, 2015),
	(2, 8, 9, 2015),
	(1, 1, 10, 2015),
	(1, 2, 10, 2015),
	(1, 3, 10, 2015),
	(1, 4, 10, 2015),
	(2, 1, 10, 2015),
	(2, 2, 10, 2015),
	(2, 3, 10, 2015),
	(2, 4, 10, 2015),
	(3, 1, 10, 2015),
	(3, 2, 10, 2015)
GO
INSERT INTO Type_of_passage(name_of_passage) VALUES
	('Dopuskaetsa'),
	('Ne dopuskaetsa'),
	('Ne vchasno')
GO
INSERT INTO Medical_Journal(date_of_passage, id_passage) VALUES
	('2015-04-01', 1),
	('2015-07-10', 1),
	('2015-10-01', 2),
	('2015-05-01', 1),
	('2015-04-01', 3),
	('2015-09-01', 1),
	('2015-09-11', 1),
	('2015-09-15', 2),
	('2015-09-14', 1),
	('2015-10-15', 1)
GO
INSERT INTO Employee(surname, first_name, last_name, birthday, home_address, telephone, id_med_record) VALUES
	('Uchilka', 'Zoya', 'Andreevna', '1975-10-15', null, 380954568711, 1),
	('Uchilka', 'Tamara', 'Vasilevna', '1976-10-15', null, 380954645681, 2),
	('Uchilka', 'Olga', 'Olegovna', '1987-10-15', null, 380954647711, 3),
	('Uchilko', 'Vadim', 'Anatolievich', '1945-10-15', null, 380956835711, 4),
	('Medikolka', 'Inna', 'Sergeevna', '1988-10-15', null, 380954568711, 5),
	('Medikolka', 'Helan', 'Sergeevich', '1988-10-15', null, 380954165681, 6),
	('Medikolka', 'Elan', 'Vladimirovich', '1988-10-15', null, 380954635711, 7),
	('Medikolka', 'Helena', 'Ivanovna', '1988-10-15', null, 380954756811, 8),
	('Medikolka', 'Elena', 'Sidorovna', '1988-10-15', null, 380954635568, 9),
	('Medikolka', 'Fedora', 'Petrovna', '1988-10-15', null, 380955685568, 10)
GO
INSERT INTO Department(title_dept, attribute_dept) VALUES
	('Administraciya', null),
	('Buhgalteriya', null),
	('Vihovatel', null),
	('Nannya', null),
	('Kuhar', null)
GO
INSERT INTO Type_of_position(title_position, id_dept, salary) VALUES
	('Administratorsha', 1, 5000),
	('Buhgaltersha', 2, 3000),
	('Vihovatelka', 3, 2000),
	('Nanechka', 4, 1500),
	('Kuharka', 5, 1800)
GO
INSERT INTO Appointment(id_employee, id_position, date_of_employment, date_of_dismissal) VALUES
	(10, 1, '1999-10-15', null),
	(9, 2, '2004-09-15', null),
	(8, 3, '2002-08-15', null),
	(7, 3, '2005-04-15', null),
	(6, 3, '2001-07-15', null),
	(5, 4, '2006-01-15', null),
	(4, 4, '2007-09-15', null),
	(3, 5, '2002-02-15', null),
	(2, 5, '2003-05-15', null),
	(1, 5, '2004-07-15', null)
GO
INSERT INTO Teacher_of_section(id_section, id_employee, month_sect, year_sect) VALUES
	(2, 3, 3, 2013),
	(2, 4, 4, 2014),
	(2, 5, 5, 2014),
	(2, 3, 6, 2014),
	(4, 4, 9, 2014),
	(2, 4, 10, 2014),
	(2, 4, 11, 2014),
	(4, 5, 12, 2014),
	(2, 3, 1, 2015),
	(2, 4, 2, 2015),
	(2, 5, 3, 2015),
	(2, 3, 4, 2015),
	(2, 4, 5, 2015),
	(4, 4, 5, 2015),
	(2, 4, 6, 2015),
	(2, 4, 9, 2015),
	(2, 4, 10, 2015),
	(3, 4, 10, 2015),
	(4, 5, 9, 2015),
	(3, 2, 10, 2015),
	(4, 3, 10, 2015)
GO
INSERT INTO Visits_Journal(id_section, id_child, date_visit) VALUES
	(1, 1, '2015-07-11'),
	(1, 1, '2015-08-12'),
	(2, 1, '2015-09-13'),
	(3, 1, '2015-09-14'),
	(3, 1, '2015-09-15'),
	(2, 1, '2015-09-16'),
	(1, 1, '2015-09-17'),
	(2, 1, '2015-09-18'),
	(2, 1, '2015-09-19'),	
	(1, 1, '2015-09-12'),
	(2, 1, '2015-09-13'),
	(1, 2, '2015-09-12'),
	(2, 2, '2015-10-13'),
	(3, 2, '2015-10-14'),
	(3, 3, '2015-10-15'),
	(2, 3, '2015-10-16'),
	(1, 2, '2015-10-17'),
	(2, 4, '2015-10-18'),
	(4, 3, '2015-10-18'),
	(3, 7, '2015-10-18'),
	(4, 11, '2015-09-18'),
	(4, 11, '2015-10-18'),
	(2, 5, '2015-09-15')
GO
USE Kinder
SELECT *
FROM Child