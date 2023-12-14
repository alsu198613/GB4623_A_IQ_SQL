DROP DATABASE IF EXISTS Lesson1;
CREATE DATABASE Lesson1;
USE Lesson1;
DROP TABLE IF EXISTS Students; 
CREATE TABLE Students (id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
						name_student VARCHAR(45) NOT NULL, 
						email VARCHAR(45) NOT NULL,
						phone_number BIGINT UNSIGNED);
DROP TABLE IF EXISTS Teachers;
CREATE TABLE Teachers (id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
						name_teacher VARCHAR(45) NOT NULL, 
						post VARCHAR(45) NOT NULL);
DROP TABLE IF EXISTS Courses;
CREATE TABLE Courses (id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
						name_course VARCHAR(45) NOT NULL,
                        name_teacher VARCHAR(45) NOT NULL,
                        name_student VARCHAR(45) NOT NULL);
INSERT INTO students (name_student, email, phone_number)
VALUES 
('Миша', 'misha@mail.ru', 9876543221),
('Антон', 'anton@mail.ru', 9876543222),
('Маша', 'masha@mail.ru', 9876543223),
('Паша', 'pasha@mail.ru', 9876543224);	

INSERT INTO teachers (name_teacher, post)
VALUES 
('Иванов И.И.', 'Профессор'),
('Петров П.П.', 'Преподаватель'),
('Сидоров С.С.', 'Доцент');

INSERT INTO Courses (name_course, name_teacher, name_student)
VALUES 
('БД', 'Иванов И.И.', 'Миша'),
('PHP', 'Петров П.П.', 'Антон'),
('Аналитика', 'Сидоров С.С.', 'Маша');

SELECT * FROM Students;
SELECT * FROM Teachers;
SELECT * FROM Courses;

SELECT * FROM Students WHERE name_student = 'Антон';
SELECT name_student, email FROM Students;
SELECT * FROM Students WHERE name_student LIKE 'а%';

DROP TABLE IF EXISTS Workers;
CREATE TABLE Workers (id INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
							name_worker VARCHAR(45) NOT NULL,
							dept VARCHAR(45) NOT NULL,
							salary INT NOT NULL);
INSERT INTO workers (id, name_worker, dept, salary)
VALUES 
(100, 'AndreyEx', 'Sales', 5000),
(200, 'Boris', 'IT', 5500),
(300, 'Anna', 'IT', 7000),
(400, 'Anton', 'Marketing', 9500),
(500, 'Dima', 'IT', 6000),
(501, 'Maxs', 'Accounting', 6543);

SELECT * FROM workers;
SELECT name_worker, salary FROM workers WHERE salary > 6000;
SELECT name_worker FROM workers WHERE dept = 'IT';
SELECT name_worker FROM workers WHERE dept != 'IT';