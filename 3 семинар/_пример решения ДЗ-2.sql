------------------ Задача 1.
-- Написать крипт, добавляющий в БД vk, которую создали на занятии, 2-3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей) (CREATE TABLE)

-- добавим таблицу фотоальбомов
DROP TABLE IF EXISTS `photo_albums`;
CREATE TABLE `photo_albums` (
	`id` SERIAL,
	`name` varchar(255),
    `user_id` BIGINT UNSIGNED NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- добавим таблицу фотографий
DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
	id SERIAL,
	`album_id` BIGINT unsigned,
	`media_id` BIGINT unsigned NOT NULL,

	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

-- добавим таблицу городов
DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	id SERIAL,
	`name` varchar(255) NOT NULL,
);

-- добавим поле с идентификатором города
ALTER TABLE profiles ADD COLUMN city_id BIGINT UNSIGNED NOT NULL ;

-- сделаем это поле внешним ключом
ALTER TABLE `profiles` ADD CONSTRAINT fk_profiles_city_id
    FOREIGN KEY (city_id) REFERENCES cities(id)

------------------ Задача 2.
-- Заполнить 2 таблицы БД vk данными (до 10 записей в каждой таблице).
use vk;

-- запросы во все таблицы, вида:
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) VALUES ('1', 'Reuben', 'Nienow', 'arlo50@example.org', '9374071116');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) VALUES ('2', 'Frederik', 'Upton', 'terrence.cartwright@example.org', '9127498182');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) VALUES ('3', 'Unique', 'Windler', 'rupert55@example.org', '9921090703');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) VALUES ('4', 'Norene', 'West', 'rebekah29@example.net', '9592139196');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) VALUES ('5', 'Frederick', 'Effertz', 'von.bridget@example.net', '9909791725');
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) VALUES ('6', 'Victoria', 'Medhurst', 'sstehr@example.net', '9456642385');


-- а лучше использовать пакетную вставку:
INSERT INTO `likes` VALUES 
('1','1','1','1988-10-14 18:47:39'),
('2','2','1','1988-09-04 16:08:30'),
('3','3','1','1994-07-10 22:07:03'),
('4','4','1','1991-05-12 20:32:08'),
('5','5','2','1978-09-10 14:36:01'),
('6','6','2','1992-04-15 01:27:31'),
('7','7','2','2003-02-03 04:56:27'),
('8','8','8','2017-04-24 09:30:19'),
('9','9','9','1974-02-07 20:53:55'),
('10','10','10','1973-05-11 03:21:40'),
('11','11','11','2008-12-17 13:03:56'),
('12','12','12','1995-07-17 21:22:38'),
('13','13','13','1985-09-07 23:34:21'),
('14','14','14','1973-01-27 23:11:53')
; 

-- можно было воспользоваться сервисом генерации данных 
https://filldb.info

------------------ Задача 3.
/*
Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false). При необходимости предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)
*/
-- добавим флаг is_active 
ALTER TABLE vk.profiles 
ADD COLUMN is_active BIT DEFAULT 1;

-- сделать невовершеннолетних неактивными
UPDATE profiles
SET is_active = 0
WHERE (birthday + INTERVAL 18 YEAR) > NOW();

-- проверим не активных
select *
from profiles
where is_active = 0
order by birthday;

-- проверим активных
select *
from profiles
where is_active = 1
order by birthday;

------------------ Задача 4.
/* Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней) */

-- добавим флаг is_deleted 
ALTER TABLE messages 
ADD COLUMN is_deleted BIT DEFAULT 0;

-- отметим пару сообщений неправильной датой
update messages
set created_at = now() + interval 1 year
limit 2;

-- отметим, как удаленные, сообщения "из будущего"
update messages
set is_deleted = 1
where created_at > NOW();

/*
-- физически удалим сообщения "из будущего"
delete from messages
where created_at > NOW()
*/

-- проверим
select *
from messages
order by created_at desc;
