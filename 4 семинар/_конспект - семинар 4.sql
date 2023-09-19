select 
	firstname,
	lastname ,
	(select hometown from profiles where user_id = users.id) as 'city',
	(select filename from media where id = (
		select photo_id from profiles where user_id = users.id
	)) as 'main_photo'
from users 
where id = 1


-- Выбираем фотографии пользователя
SELECT filename 
FROM media 
WHERE user_id = 1
    AND media_type_id = 1; 

SELECT filename 
FROM media 
WHERE user_id = (select id from users where email = 'arlo50@example.org')
    AND media_type_id = 1; 


-- Количество новостей каждого типа
select 
	count(*)
	, media_type_id
	, (select name from media_types where id = media_type_id) as type
from media
group by media_type_id;


-- CROSS JOIN
select *
from users, messages ;

select count(*)
from users, messages ;

select *
from users, messages 
where users.id = messages.from_user_id ;


-- CROSS JOIN
select *
from users, messages 
where users.id = messages.from_user_id ;


-- INNER JOIN
SELECT *
FROM users
INNER JOIN messages ON users.id = messages.from_user_id ;


-- LEFT JOIN
SELECT *
FROM users
LEFT JOIN messages ON users.id = messages.from_user_id
ORDER BY messages.id


-- LEFT JOIN
SELECT users.*
FROM users
LEFT OUTER JOIN messages ON users.id = messages.from_user_id
WHERE messages.id IS NULL
ORDER BY messages.id
# LIMIT 16


-- LEFT JOIN
SELECT users.*, messages.*
FROM users LEFT JOIN messages ON users.id = messages.from_user_id
ORDER BY messages.id


-- RIGHT JOIN
SELECT users.*, messages.*
FROM messages RIGHT JOIN users ON users.id = messages.from_user_id
ORDER BY messages.id


-- FULL JOIN
SELECT users.*, messages.*
FROM users 
LEFT JOIN messages ON users.id = messages.from_user_id
union
SELECT users.*, messages.*
FROM users 
RIGHT JOIN messages ON users.id = messages.from_user_id

-- INNER JOIN			100 
-- LEFT OUTER JOIN		116
-- RIGHT OUTER JOIN 	102
-- FULL [OUTER] JOIN	118 = 100 + 16 + 2


-- Выборка данных по пользователю (со вложенными запросами)
SELECT 
	firstname, 
	lastname, 
	(SELECT birthday FROM profiles WHERE user_id = users.id) AS birthday,
	(SELECT hometown FROM profiles WHERE user_id = users.id) AS city,
	(SELECT filename FROM media WHERE id = 
	    (SELECT photo_id FROM profiles WHERE user_id = users.id)
	) AS main_photo
FROM users 
WHERE id = 1;

-- Выборка данных по пользователю (JOIN)
SELECT 
	firstname, 
	lastname, 
	birthday,
	p.hometown AS city,
	m.filename AS main_photo
FROM users AS u
JOIN profiles AS p ON p.user_id = u.id
JOIN media as m ON m.id = p.photo_id 
WHERE u.id = 1;


-- Сообщения к пользователю
select 
	u.email as 'receiver email',
	u2.email as 'sender email',
	m.*
from messages as m
join users as u on u.id = m.to_user_id
join users as u2 on u2.id = m.from_user_id 
where to_user_id = 1


-- Количество друзей у каждого пользователя
select 
	count(*) as cnt,
	u.id
from users as u
join friend_requests as fr on (
	u.id = fr.target_user_id or u.id = fr.initiator_user_id 
)
where fr.status = 'approved'
group by u.id
order by cnt desc


-- Выборка новостей друзей пользователя (users.id = 1)
select *
from media as m
join friend_requests as fr on (
	m.user_id = fr.initiator_user_id and fr.target_user_id = 1
		or 
	m.user_id = fr.target_user_id and fr.initiator_user_id = 1
)
where fr.status = 'approved'
order by created_at desc

