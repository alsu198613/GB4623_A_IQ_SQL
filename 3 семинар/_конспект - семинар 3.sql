-- Установим текущую БД
use vk;	

-- Данные пользователя 
SELECT *
FROM users
WHERE id = 1;

SELECT *
FROM profiles
WHERE user_id = 1;


-- LIKE не чувствителен к регистру
SELECT * 
FROM media_types 
WHERE name LIKE 'phoTo';



-- знак «%» заменяет любое количество любых символов
SELECT * 
FROM media_types 
WHERE name LIKE 'p%';

SELECT * 
FROM media_types 
WHERE name LIKE '%photo';

SELECT * 
FROM media_types 
WHERE name LIKE '%o%';

-- знак «_» заменяет 1 любой символ
SELECT * 
FROM media_types 
WHERE name LIKE '_____'; -- названия из 5 символов


-- Выбираем фотографии пользователя
SELECT filename 
FROM media 
WHERE user_id = 1
    AND media_type_id = 1; -- 1 = id фоток в таблице media_types


-- Выбираем видео-новости указанного пользователя
select *
from media
where user_id = 1
	and media_type_id = 3

-- Выбираем видео-новости указанного пользователя
select filename
from media
where user_id = 1
	and (filename like '%.mp4' or filename like '%.avi')
	если убрать скобки перед OR, то получим записи других пользователей 

-- Агрегирующие функции (AVG, MAX, MIN, COUNT, SUM) можно применять к выборкам и без группировки (group by), в этом случае вся выборка будет считаться за 1 группу
-- Подсчитываем количество фотографий пользователя
SELECT COUNT(*) 
FROM media 
WHERE user_id = 1
  AND media_type_id = 1;

-- Количество новостей каждого типа
select 
	count(*)
	, media_type_id
from media
group by media_type_id
 

-- сколько новостей у каждого пользователя?
SELECT COUNT(id) AS news_count, user_id
  FROM media
  GROUP BY user_id;
 

-- вывести самых активных пользователей (больше 1 записи)
select 
	count(*),
	user_id
from media
group by user_id
having count(*) > 1


-- Выбираем друзей пользователя (сначала все заявки, в том числе не подтвержденные) 
SELECT * 
FROM friend_requests 
WHERE 
	initiator_user_id = 1 -- мои заявки
	or target_user_id = 1 -- заявки ко мне
;
 

-- Выбираем только друзей с подтверждённым статусом
SELECT * 
FROM friend_requests 
WHERE (initiator_user_id = 1 or target_user_id = 1)
	and status = 'approved' -- только подтвержденные друзья
;


-- Выбираем новости друзей 
SELECT * 
FROM media 
WHERE user_id IN (1,2,3 union 4,5,6);
	На следующем уроке добавим вычисление user_id динамически (вложенным запросом)


-- Выбираем сообщения от пользователя и к пользователю (мои и ко мне)
SELECT * 	
FROM messages
WHERE from_user_id = 1 -- от меня (я отправитель)
    OR to_user_id = 1 -- ко мне (я получатель)
ORDER BY created_at DESC; -- упорядочим по дате
 

-- диалог между user_id = 1 и user_id = 2
select *
from messages 
where from_user_id = 1 and to_user_id = 2 
    or from_user_id = 2 and to_user_id = 1
order by created_at desc

 

-- Непрочитанные сообщения
-- добавим колонку is_read DEFAULT FALSE
ALTER TABLE messages
ADD COLUMN is_read BIT default false;	

-- получим непрочитанные для меня (будут все) 
SELECT * 
FROM messages
  WHERE to_user_id = 1
    AND is_read = 0
  ORDER BY created_at DESC;

-- количество непрочитанных сообщений
SELECT COUNT(*)
FROM messages 
WHERE to_user_id = 1 AND is_read = 0

-- отметим прочитанными некоторые (определенный диалог)
 -- эмулируем ситуацию, что пользователь прочитал определенный диалог
 update messages
 set is_read = 1
 where and to_user_id = 1
	and from_user_id = 2
;
 

-- Выводим друзей пользователя с преобразованием пола и подсчетом возраста 
-- user_id, gender, age
SELECT user_id, 
    CASE (gender)
         WHEN 'm' THEN 'male'
         WHEN 'f' THEN 'female'
	ELSE 'другой'
    END AS gender, 
    TIMESTAMPDIFF(YEAR, birthday, NOW()) AS age -- функция определяет разницу между датами в выбранных единицах (YEAR)
  FROM profiles
WHERE user_id IN (3, 4, 10)
;
 

-- добавляем поле admin_user_id в таблицу communities
ALTER TABLE vk.communities 
ADD admin_user_id BIGINT UNSIGNED DEFAULT 2 NOT NULL;
 
-- является ли пользователь (user_id) админом группы (community_id)?

set @user_id = 10;
set @community_id := 5;

select @user_id = (
	select admin_user_id
	from communities
	where id = @community_id
	) as 'is admin';


-- выбрать уникальные фамилии
SELECT distinct lastname
from users;


