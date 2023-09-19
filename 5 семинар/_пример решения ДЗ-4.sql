/* Задача 1. Подсчитать количество групп, в которые вступил каждый пользователь. */
select 
	CONCAT(firstname, ' ', lastname) AS owner,
	count(*)
from users u
join users_communities uc on u.id = uc.user_id
group by u.id
order by count(*) desc


/* Задача 2. Подсчитать количество пользователей в каждом сообществе.*/
select
	count(*),
	communities.name
from users_communities 
join communities on users_communities.community_id = communities.id
group by communities.id


/* Задача 3.
Пусть задан некоторый пользователь. 
Из всех пользователей соц. сети найдите человека, который больше всех общался с выбранным пользователем.
(решение с объединением таблиц) */
use vk;

select 
	from_user_id
	, concat(u.firstname, ' ', u.lastname) as name
	, count(*) as 'messages count'
from messages m
join users u on u.id = m.from_user_id
where to_user_id = 1
group by from_user_id
order by count(*) desc
limit 1;

-- (решение с вложенными запросами) 
select 
	from_user_id 
	, concat(
		(select firstname from users where id = m.from_user_id), ' ', 
		(select lastname from users where id = m.from_user_id)
	) as name
	, count(*) cnt
from messages m
where to_user_id = 1
group by from_user_id
order by cnt desc
limit 1;

-- ---------------------------------------------------------------
/*Задача 4
 общее количество лайков, которые получили пользователи младше 18 лет.
 (решение с вложенными запросами) */
select count(*) -- количество лайков
from likes
where media_id in ( -- все медиа записи таких пользователей
	select id 
	from media 
	where user_id in ( -- все пользователи младше 18 лет
		select 
			user_id
		-- 	, birthday
		from profiles as p
		where  YEAR(CURDATE()) - YEAR(birthday) < 18
	)
);
 
-- (решение с объединением таблиц)
select count(*) -- количество лайков
from likes l
join media m on l.media_id = m.id
join profiles p on p.user_id = m.user_id
where  YEAR(CURDATE()) - YEAR(birthday) < 18;

-- ---------------------------------------------------------------
/* Задача 5
Определить: кто больше поставил лайков (всего) - мужчины или женщины.
(решение с вложенными запросами) */
select 
	gender
	, count(*)
from (
	select 
		user_id as user,
		(
			select gender 
			from vk.profiles
			where user_id = user
		) as gender
	from likes
) as dummy
group by gender;

-- решение с объединением таблиц
SELECT  gender, COUNT(*)
from likes
join profiles on likes.user_id = profiles.user_id 
group by gender;

/***********************************************************
 * Определить кто больше поставил лайков (всего): мужчины или женщины.
 * Альтернативное решение.
 *************************************************************/ 
SELECT gender FROM (
	SELECT gender, COUNT((SELECT COUNT(*) FROM likes as L where L.user_id = P.user_id)) as gender_likes_count FROM profiles as P
	WHERE gender = 'm'
	GROUP BY gender
	UNION ALL
	SELECT gender, COUNT((SELECT COUNT(*) FROM likes as L where L.user_id = P.user_id)) FROM profiles as P
	WHERE gender = 'f'
	GROUP BY gender
) AS T
GROUP BY gender
ORDER BY MAX(gender_likes_count) DESC
LIMIT 1;
