-- 1.	Создайте представление с произвольным SELECT-запросом из прошлых уроков [CREATE VIEW]
-- Количество друзей у каждого пользователя
SELECT 
	COUNT(*) AS cnt,
	u.id
FROM users AS u
JOIN friend_requests AS fr ON (
	u.id = fr.target_user_id OR u.id = fr.initiator_user_id 
)
WHERE fr.status = 'approved'
GROUP BY u.id
ORDER BY cnt DESC;


CREATE OR REPLACE VIEW friends_amount AS 
SELECT 
	COUNT(*) AS cnt,
	u.id
FROM users AS u
JOIN friend_requests AS fr ON (
	u.id = fr.target_user_id OR u.id = fr.initiator_user_id 
)
WHERE fr.status = 'approved'
GROUP BY u.id
ORDER BY cnt DESC;


-- 2.	Выведите данные, используя написанное представление [SELECT]
SELECT * FROM friends_amount;


-- 3.	Удалите представление [DROP VIEW]
DROP VIEW friends_amount;



-- 4.	* Сколько новостей (записей в таблице media) у каждого пользователя? Вывести поля: news_count (количество новостей), user_id (номер пользователя), user_email (email пользователя). Попробовать решить с помощью CTE или с помощью обычного JOIN.
-- Решение с помощью JOIN
SELECT 
	COUNT(*),
	user_id,
	email
FROM media as m
JOIN users as u on u.id = m.user_id 
GROUP BY user_id;


-- Решение с CTE
WITH cte AS (
	SELECT 
		COUNT(*) as cnt,
		user_id 
	FROM media 
	GROUP BY user_id
)
SELECT 
	cnt,
	user_id,
	email
FROM cte
JOIN users as u on u.id = cte.user_id;
