DROP DATABASE IF EXISTS vk;	-- удалить БД с проверкой
CREATE DATABASE vk; 		-- создать БД
USE vk; 					-- выбрать БД


DROP TABLE IF EXISTS users; -- тоже DDL команда
CREATE TABLE users (		-- создать таблицу
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id2 SERIAL, # BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
    firstname VARCHAR(50),
   lastname VARCHAR(100) COMMENT 'фамиль...', -- COMMENT на случай, если имя неочевидное (фича MySQL)
    email VARCHAR(120) UNIQUE,
    password_hash varchar(255),
    phone bigint unsigned unique, -- 79 201 234 567 
	
	INDEX idx_users_username(firstname, lastname) -- для быстрого поиска людей по ФИО
) COMMENT 'юзеры';


DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	user_id BIGINT UNSIGNED NOT NULL PRIMARY KEY,
	gender CHAR(1),
	hometown VARCHAR(100),
	#birthday DATETIME,
	created_at DATETIME DEFAULT NOW()
);

-- Добавим отдельным запросом внешний ключ (ссылку на таблицу users)
ALTER TABLE `profiles` ADD CONSTRAINT fk_profiles_user_id
    FOREIGN KEY (user_id) REFERENCES users(id)


-- Меняем структуру таблицы
ALTER TABLE profiles ADD COLUMN birthday DATETIME;
ALTER TABLE profiles MODIFY COLUMN birthday DATE;
ALTER TABLE profiles RENAME COLUMN birthday TO date_of_birth;
ALTER TABLE profiles DROP COLUMN date_of_birth;
ALTER TABLE profiles ADD COLUMN birthday DATE;


-- создадим таблицу сообщений
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
    id SERIAL, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    -- body2 VARCHAR(255),
    body TEXT,
    created_at DATETIME DEFAULT NOW(), -- можно будет даже не упоминать это поле при вставке

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);


-- INSERT
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) 
VALUES (1, 'Reuben', 'Nienow', 'arlo50@example.org', '9374071116');
	
-- INSERT Без указания поля id
INSERT INTO `users` (`firstname`, `lastname`, `email`, `phone`) 
VALUES ('Reuben', 'Nienow', 'arlo50@example.org', '9374071116');

-- вставка нескольких строк одной командой (пакетная вставка) - быстро
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) 
VALUES 
('98', 'Lori', 'Koch', 'damaris34@example.net', '9192291407'),
('99', 'Sam', 'Kuphal', 'telly.miller@example.net', '9917826312'),
('100', 'Pearl', 'Prohaska', 'xeichmann@example.net', '9136605713');

-- вставка нескольких строк - медленно
INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) 
VALUES ('95', 'Ozella', 'Hauck', 'idickens@example.com', '9773438197');

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) 
VALUES ('96', 'Emmet', 'Hammes', 'qcremin@example.org', '9694110645');

INSERT INTO `users` (`id`, `firstname`, `lastname`, `email`, `phone`) 
VALUES ('97', 'Eleonore', 'Ward', 'antonietta.swift@example.com', '9397815776');


-- явное указание значений полей при вставке
INSERT INTO `users` 
SET
	`firstname` = 'Kristina', 
	`lastname` = 'Jast', 
	`email` = 'jennifer27@example.com', 
	`phone` = '9133161481'
;


-- SELECT

select * 
from users;

-- лучше явно указывать имена полей
select id, firstname, lastname, email, password_hash, phone 
from users;

-- выбрать уникальные значения (DISTINCT)
SELECT distinct lastname
from users;


-- UPDATE

-- подтвердить запрос в друзья
UPDATE friend_requests
SET 
	status = 'approved', 
	confirmed_at = now()
WHERE initiator_user_id = 1 and target_user_id = 3
-- and status = 'requested'
;

-- отклонить запрос в друзья
UPDATE friend_requests
SET 
	status = 'declined',
	confirmed_at = now()
WHERE
	initiator_user_id = 1 and target_user_id = 3
-- 	and status = 'requested'
;


-- DELETE

-- удаляем сообщения
delete from messages
where from_user_id = 1 and to_user_id = 2;


-- TRUNCATE
-- пересоздадим таблицу сообщений
TRUNCATE TABLE messages;

-- очистим таблицу сообщений
DELETE FROM messages;
