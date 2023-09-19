-- Задание 1
-- Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке. [ORDER BY]

-- основное решение
SELECT DISTINCT firstname
FROM users
ORDER BY firstname;

-- вариант 2
SELECT firstname
FROM users
GROUP BY firstname 
ORDER BY firstname;


-- Задание 2
-- Выведите количество мужчин старше 35 лет [COUNT].
SELECT *
FROM profiles 
WHERE 
     TIMESTAMPDIFF(YEAR, birthday, NOW()) > 35
     AND gender = 'm'


--	Задание 3
-- Сколько заявок в друзья в каждом статусе? (таблица friend_requests) [GROUP BY]
SELECT 
	COUNT(*),
	status
FROM friend_requests 
GROUP BY status
 

--	Задание 4
-- Выведите номер пользователя, который отправил больше всех заявок в друзья (таблица friend_requests) [LIMIT].
SELECT 
	COUNT(*) AS cnt
FROM friend_requests 
GROUP BY initiator_user_id 
ORDER BY cnt DESC
LIMIT 1;

 
-- Задание 5
-- Выведите названия и номера групп, имена которых состоят из 5 символов [LIKE].
SELECT name
FROM communities 
WHERE name LIKE '_____' -- 5 символов подчеркивания заменяют 5 букв
