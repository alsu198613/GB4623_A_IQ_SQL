DROP DATABASE IF EXISTS vk_dev;
CREATE DATABASE vk_dev;
USE vk_dev;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамиль', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), -- 123456 => vzx;clvgkajrpo9udfxvsldkrn24l5456345t
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'юзеры';

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100)
	
    -- , FOREIGN KEY (photo_id) REFERENCES media(id) -- пока рано, т.к. таблицы media еще нет
);

ALTER TABLE `profiles` ADD CONSTRAINT fk_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)
    ON UPDATE CASCADE -- (значение по умолчанию)
    ON DELETE RESTRICT; -- (значение по умолчанию)

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	-- id SERIAL, -- изменили на составной ключ (initiator_user_id, target_user_id)
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'), # DEFAULT 'requested',
    -- `status` TINYINT(1) UNSIGNED, -- в этом случае в коде хранили бы цифирный enum (0, 1, 2, 3...)
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP, -- можно будет даже не упоминать это поле при обновлении
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id)-- ,
    -- CHECK (initiator_user_id <> target_user_id)
);
-- чтобы пользователь сам себе не отправил запрос в друзья
-- ALTER TABLE friend_requests 
-- ADD CHECK(initiator_user_id <> target_user_id);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities(
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name), -- индексу можно давать свое имя (communities_name_idx)
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL,
    name VARCHAR(255), -- записей мало, поэтому в индексе нет необходимости
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body VARCHAR(255),
    filename VARCHAR(255),
    -- file BLOB,    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes(
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW()

    -- PRIMARY KEY (user_id, media_id) – можно было и так вместо id в качестве PK
  	-- слишком увлекаться индексами тоже опасно, рациональнее их добавлять по мере необходимости (напр., провисают по времени какие-то запросы)  

/* намеренно забыли, чтобы позднее увидеть их отсутствие в ER-диаграмме
    , FOREIGN KEY (user_id) REFERENCES users(id)
    , FOREIGN KEY (media_id) REFERENCES media(id)
*/
);

ALTER TABLE vk_dev.likes 
ADD CONSTRAINT likes_fk 
FOREIGN KEY (media_id) REFERENCES vk_dev.media(id);

ALTER TABLE vk_dev.likes 
ADD CONSTRAINT likes_fk_1 
FOREIGN KEY (user_id) REFERENCES vk_dev.users(id);

ALTER TABLE vk_dev.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);

-- Home work 2
/* 1. Создать БД vk, исполнив скрипт _vk_db_creation.sql (в материалах к уроку)
   2. Написать скрипт, добавляющий в созданную БД vk 2-3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей) (CREATE TABLE) */

DROP TABLE IF EXISTS `goods_categories`;
CREATE TABLE `goods_categories` (
	`category_id` SERIAL PRIMARY KEY, -- Уникальный ID категории
	`category_name` VARCHAR(255) UNIQUE, -- Название категории товаров

	created_at DATETIME DEFAULT NOW(), -- Дата создания
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP -- Дата обновления
    
) COMMENT = 'Таблица категорий товаров';

DROP TABLE IF EXISTS `goods_description`;
CREATE TABLE `goods_description` (
	`goods_id` SERIAL PRIMARY KEY, -- Уникальный ID товара
	`goods_name` VARCHAR(255), -- Название товара
	`goods_photo` VARCHAR(255) DEFAULT NULL, -- Изображение товара
	`goods_description` TEXT, -- Описание товара
	`goods_price` DECIMAL(10,2), -- Стоимость товара
	`goods_category` BIGINT UNSIGNED NOT NULL, -- Категория товара
	`user_posted_id` BIGINT UNSIGNED NOT NULL, -- Пользователь предлагающий товар/услугу
	`created_at` DATETIME DEFAULT NOW(), -- Дата создания
    `updated_at` DATETIME ON UPDATE CURRENT_TIMESTAMP, -- Дата обновления
    
    INDEX goods_category_idx(goods_category),
    INDEX goods_updated_at_idx(updated_at),
    
    FOREIGN KEY fk_goods_category(goods_category) REFERENCES goods_categories(category_id),
    FOREIGN KEY (user_posted_id) REFERENCES users(id)
    
) COMMENT = 'Таблица с описанием товара';


DROP TABLE IF EXISTS `activity_status`;
CREATE TABLE `activity status` (
	`active_user_id` SERIAL PRIMARY KEY NOT NULL,
	`activity status` ENUM('Online', 'Offline'),
	`created_at` DATETIME DEFAULT NOW(), -- Дата создания, для отслеживания времени последней активности
    `updated_at` DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX active_user_id_idx(active_user_id),
    INDEX updated_at_idx(updated_at),
    
    FOREIGN KEY fk_active_user_id(active_user_id) REFERENCES users(id)

) COMMENT = 'Статус активности пользователей';

/* 3. Заполнить 2 таблицы БД vk данными (по 10 записей в каждой таблице) (INSERT)*/

INSERT INTO users (firstname, lastname, email,	password_hash,	phone) VALUES 
('Elfrieda','Torphy','dylan89@example.com','353722', 325698564422),
('Issac','Hansen','rico75@example.net','127gjghgghgk', 79856325696),
('Dejuan','Kuhic','karianne57@example.org','714ghk5235', 7916397856),
('Vicente','Schroeder','talia.mohr@example.org','1jkk566fghhj', 89637412563),
('Lauretta','Ebert','franecki.aidan@example.com','665734', 85236985523),
('Duane','Daugherty','antonietta53@example.com','010203050505', 7852967411),
('Mckenzie','Kihn','weber.alexandrine@example.net','058522555', 7459685522),
('Trudie','Boyer','gklocko@example.net','125787878kkjkjk', 89167418596),
('Kareem','Lind','deondre64@example.com','1khjhjhjhhgghhghj', 8974859632),
('Krista','O\'Conner','stanton.adonis@example.org','262832', 8529637411);

select * from users u ;

INSERT INTO `profiles` VALUES
('1','F','1989-09-29', NULL, default, 'Moscow'),
('2','M','1999-04-25', NULL, default, 'Samara'),
('3','M','1982-03-26', NULL, default, 'Orel'),
('4','M','2006-02-18', NULL, default, 'Tver'),
('5','F','2014-04-26', NULL, default, 'Vologda'),
('6','F','1987-09-16', NULL, default, 'London'),
('7','M','1989-01-27', NULL, default, 'Paris'),
('8','M','1970-03-08', NULL, default, 'New York'),
('9','M','1999-12-15', NULL, default, 'Washington'),
('10','F','1993-09-24', NULL, default, 'Vladivistok');
SELECT * FROM profiles p ;

-- 4.* Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных 
-- (поле is_active = true). При необходимости предварительно добавить такое поле в 
-- таблицу profiles со значением по умолчанию = false (или 0) (ALTER TABLE + UPDATE)

ALTER TABLE profiles
-- DROP COLUMN is_active;
ADD is_active BOOl DEFAULT true;

UPDATE profiles
SET
	is_active = false
WHERE (YEAR(CURRENT_DATE) - YEAR(birthday)) < 18;

SELECT birthday FROM profiles
WHERE (YEAR(CURRENT_DATE) - YEAR(birthday)) < 18;



-- 5.* Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней) (DELETE)

INSERT INTO `messages` VALUES 
('1','1','1','Expedita consequatur et in sit est. Distinctio quibusdam voluptatem qui porro. Dolore aperiam molestias ut corrupti corrupti sint aut. Et voluptates quam dicta dolor aut natus et.','2000-03-16 18:04:11'),
('2','2','2','Et vero nisi architecto asperiores hic voluptate. Enim perspiciatis vero officiis sequi quidem eius. Numquam aliquam sunt molestiae dolor enim. Ipsam aliquam quis officia aut non ut est.','2012-02-20 20:33:06'),
('3','3','3','Nesciunt ipsa atque animi sed. Et aspernatur qui dolor itaque voluptatem. A eos aspernatur perspiciatis nemo earum sit.','1992-11-24 21:08:34'),
('4','4','4','Perspiciatis architecto neque expedita fugiat et et sunt minima. Voluptatem aliquid reprehenderit quis aut est.','2006-03-04 05:48:09'),
('5','5','5','Error quo praesentium eaque consequatur ut. Numquam praesentium quibusdam dolore vel eum nemo reiciendis. Iure ut ab alias voluptatem dolor consequatur porro qui. Commodi nobis nobis voluptates ea ipsa ut expedita.','2012-02-11 02:32:34'),
('6','6','6','Quia natus tenetur tempore ipsa. Alias rerum accusantium a odio optio incidunt. Rerum adipisci alias facere in repellat sit nihil. Ut et ipsum at ipsum nihil.','1980-02-02 04:50:13'),
('7','7','7','Adipisci ut sed ut qui dolor doloribus. Nemo impedit amet officia ut tempora laboriosam. Id corrupti cupiditate voluptatem aperiam accusantium. Ea in aut qui porro voluptatem.','2018-10-12 22:08:55'),
('8','8','8','Id eos corrupti cupiditate quia veritatis quae corrupti. Sint ea ducimus minima laborum sit aliquid ad. Consequatur rerum dolore dolores omnis eius quaerat. Quasi tempora vel laboriosam explicabo.','1971-02-07 18:49:15'),
('9','9','9','Iusto voluptas et voluptas. Quaerat nihil sit repellat vel nihil. Ea sit aut nulla.','1974-03-16 03:28:43'),
('10','10','10','Distinctio fugit debitis et corrupti est soluta. Non sequi ratione consequuntur qui. Voluptatum veniam aspernatur expedita nihil accusamus suscipit nemo. Aut fugiat animi eveniet voluptatibus odio quaerat. Cupiditate nostrum tenetur est est eum autem quae.','1989-07-20 19:01:51')
;

SELECT * FROM messages;

DELETE FROM messages
WHERE created_at < CURRENT_TIMESTAMP();