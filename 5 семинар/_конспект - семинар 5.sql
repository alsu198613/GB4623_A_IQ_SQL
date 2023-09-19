-- ----------------------------------------	Оконные функции
-- Количество новостей каждого типа
select distinct
	count(user_id) OVER (partition by media_type_id) as cnt,
	media_type_id 
from media

-- можно создавать несколько окон в рамках одного запроса
select 
	row_number() over (partition by media_type_id) as rn1,
	row_number() over (partition by user_id) as rn2,
	count(*) OVER (partition by media_type_id) as cnt1,
	count(*) OVER (partition by user_id) as cnt2,
	user_id,
	media_type_id 
from media
order by media_type_id

-- вариант синтаксиса окон со словом WINDOW
select 
	count(*) OVER w as cnt1,
	media_type_id,
	user_id 
from media
WINDOW w AS (partition by media_type_id)


-- ----------------------------------------	CTE – табличные выражения
-- Пример из прошлых уроков
-- вывести самых активных пользователей (больше 1 записи)
select 
	count(*),
	user_id
from media
group by user_id
having count(*) > 1

-- Добавим дополнительные колонки с помощью CTE
-- решение с CTE
WITH cte1 AS (
	select 
		count(*),
		user_id
	from media
	group by user_id
	having count(*) > 1
)
SELECT *
FROM cte1 
JOIN users as u on u.id = cte1.user_id
WHERE id = 1;

 

--	Рекурсивные CTE
-- выведет циферки от 0 до 10
WITH RECURSIVE `sequence` (n) AS
(
  SELECT 0
  UNION
  SELECT n + 1 
  FROM `sequence`
  WHERE n + 1 <= 10
)
SELECT n
FROM `sequence`;

 

-- ----------------------------------------	Процедуры [15 минут]
/*Напишем процедуру, которая будет предлагать пользователям новых друзей.
Критерии выбора пользователей:
    # из одного города
    # состоят в одной группе
    # друзья друзей
Из выборки будем показывать 5 человек в случайной комбинации.
*/

drop procedure if exists sp_friendship_offers;

DELIMITER //

create procedure sp_friendship_offers(in for_user_id BIGINT UNSIGNED)
  begin
	-- общий город
	select p2.user_id
	from profiles p1
	join profiles p2 
	    on p1.hometown = p2.hometown
	where p1.user_id = for_user_id 
	    and p2.user_id <> for_user_id -- исключим себя
	
		union 
		
	-- общие группы
	select uc2.user_id
	from users_communities uc1
	join users_communities uc2 
	    on uc1.community_id = uc2.community_id
	where uc1.user_id = for_user_id 
	    and uc2.user_id <> for_user_id -- исключим себя

		union 
		
	-- друзья друзей
	-- получим друзей друзей
	-- объединяем таблицу саму с собой 3 раза
	-- фильтруем «первую» таблицу по for_user_id
	select fr3.target_user_id	
	from friend_requests fr1
		join friend_requests fr2 
		    on (fr1.target_user_id = fr2.initiator_user_id 
		        or fr1.initiator_user_id = fr2.target_user_id)
		join friend_requests fr3 
		    on (fr3.target_user_id = fr2.initiator_user_id 
		        or fr3.initiator_user_id = fr2.target_user_id)
	where (fr1.initiator_user_id = for_user_id or fr1.target_user_id = for_user_id)
	 	and fr2.status = 'approved' -- оставляем только подтвержденную дружбу
	 	and fr3.status = 'approved'
		and fr3.target_user_id <> for_user_id -- исключим себя
	
	order by rand() -- будем брать всегда случайные записи
	limit 5; -- ограничим всю выборку до 5 строк
  END// -- не забываем наш новый разделитель
  
DELIMITER ; -- вернем прежний разделитель

 

--	Вызов продедуры / результаты
--	Каждый раз при вызове процедуры с одним и тем же параметром мы видим разный результат.
CALL sp_friendship_offers(1);
CALL sp_friendship_offers(3);

    

-- ----------------------------------------	Представления [1:20]
--	Офф. Дока: https://dev.mysql.com/doc/refman/8.0/en/create-view.html

-- представление, выбирающее друзей пользователей
CREATE or replace VIEW v_friends AS 
  SELECT *
  FROM users u
    JOIN friend_requests fr ON u.id = fr.target_user_id
  WHERE 
  fr.status = 'approved'
  	UNION
  SELECT *
  FROM users u
    JOIN friend_requests fr ON u.id = fr.initiator_user_id
  WHERE 	
  fr.status = 'approved';

-- получим друзей пользователя из представления 
select *
from view_friends
where id = 1

-- удаление представления
DROP VIEW v_friends;
