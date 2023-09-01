# задача номер 1
SELECT *
FROM university.student
WHERE name = 'Иван Диванов';

-- задача номер 2
SELECT *
FROM university.student
WHERE name LIKE '%Иван';

-- задача 3
SELECT *
FROM university.student
WHERE email LIKE '%mail.ru';

SELECT id, title
FROM course;

SELECT *
FROM student
WHERE name LIKE 'И%';


