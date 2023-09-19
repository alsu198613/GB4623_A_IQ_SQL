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


/*Задача 4
 общее количество лайков, которые получили пользователи младше 18 лет. */

select count(*) 
from likes l
join media m on l.media_id = m.id
join profiles p on p.user_id = m.user_id
where  YEAR(CURDATE()) - YEAR(birthday) < 18;


/* Задача 5
Определить: кто больше поставил лайков (всего) - мужчины или женщины.*/

SELECT  gender, COUNT(*)
from likes
join profiles on likes.user_id = profiles.user_id 
group by gender;

