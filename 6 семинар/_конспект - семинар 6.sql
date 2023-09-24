-- Функции
/*
Напишем функцию, которая будет считать коэффициент направленности дружбы.
Формула: Кол-во приглашений в друзья к пользователю / (разделим на)  Кол-во заявок в друзья от пользователя.

Из результата (которым будет некоторое вещественное число) можно будет делать некоторые выводы:
1.	Чем больше значение, тем популярность пользователя выше.
2.	Если значение меньше единицы - пользователь инициатор связей (и наоборот).

•	Решим задачу в процедурном стиле 
•	Наша функция будет только читать данные => READS SQL DATA

Направленность дружбы
Кол-во приглашений в друзья к пользователю
/
Кол-во приглашений в друзья от пользователя

Чем больше - популярность выше
Если значение меньше единицы - пользователь инициатор связей.
*/

USE vk;

DROP FUNCTION IF EXISTS func_friendship_direction;

DELIMITER // -- выставим разделитель
CREATE FUNCTION func_friendship_direction(check_user_id BIGINT UNSIGNED)
RETURNS FLOAT READS SQL DATA
  BEGIN
-- объявим переменные
    DECLARE requests_to_user INT;
    DECLARE requests_from_user INT;
    DECLARE `_result` FLOAT;
    
-- получим запросы к пользователю
    SET requests_to_user = (
    	  SELECT COUNT(*) 
    	  FROM friend_requests
    	  WHERE target_user_id = check_user_id);

/*	set requests_from_user = (
		select count(*)
		from vk.friend_requests 
		where initiator_user_id = check_user_id
	);*/
    
-- получим запросы от пользователя
    SELECT COUNT(*)
    INTO requests_from_user 
    FROM friend_requests
    WHERE initiator_user_id = check_user_id;
	
	if requests_from_user > 0 then 
		set `_result` = requests_to_user / requests_from_user;
	else 
		set `_result` = 99999;
	end if;

-- разделим первое на второе и вернем результат
    RETURN `_result`;
  END// -- не забываем наш новый разделитель
DELIMITER ; -- вернем прежний разделитель


-- Вызов функции / результаты
SELECT func_friendship_direction(1);
 

-- Округлим результат с помощью функции TRUNCATE
SELECT ROUND(vk.friendship_direction(11), 2) as user_popularity;
-- Посчитаем результат для другого пользоваетля (id = 11)
SELECT ROUND(friendship_direction(11), 2);
 

-- Транзакции
-- Транзакция по добавлению нового пользователя      
START TRANSACTION;
	INSERT INTO users (firstname, lastname, email, phone)
  	VALUES ('New', 'User', 'new@mail.com', 454545456);

	# SELECT @last_user_id := (SELECT MAX(id) FROM users); -- опасный способ
  	set @last_user_id = LAST_INSERT_ID(); -- лучше так
	
  	INSERT INTO profiles (user_id, gender, birthday, hometown)
  	VALUES (@last_user_id, 'M', '1999-10-10', 'Moscow');  
COMMIT;
# ROLLBACK;
 

-- проверить
SELECT * FROM users ORDER BY id DESC;	
SELECT * FROM profiles ORDER BY user_id DESC;	


-- обработка ошибки в транзакции
DROP PROCEDURE IF EXISTS `sp_add_user`;

DELIMITER $$

CREATE PROCEDURE `sp_add_user`(firstname varchar(100), lastname varchar(100), 
	email varchar(100), phone varchar(12), hometown varchar(50), photo_id INT, 
	OUT tran_result varchar(200))
BEGIN
    DECLARE `_rollback` BOOL DEFAULT 0;
   	DECLARE code varchar(100);
   	DECLARE error_string varchar(100);
   	DECLARE last_user_id int;

   DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
   begin
    	SET `_rollback` = 1;
	GET stacked DIAGNOSTICS CONDITION 1
          code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
    	set tran_result := concat('Error occured. Code: ', code, '. Text: ', error_string);
    end;
		        
    START TRANSACTION;
		INSERT INTO users (firstname, lastname, email, phone)
		  VALUES (firstname, lastname, email, phone);
	
		INSERT INTO profiles (user_id, hometown, photo_id)
		  VALUES (last_insert_id(), hometown, photo_id); 
	
	    IF `_rollback` THEN
	       ROLLBACK;
	    ELSE
		set tran_result := 'ok';
	       COMMIT;
	    END IF;
END$$

DELIMITER ;
-- вызываем процедуру
call sp_add_user('New', 'User', 'new87@mail.com', 454545456, 'Moscow', 1, @tran_result);

-- смотрим результат
select @tran_result;




-- Триггеры
 
-- триггер для проверки возраста пользователя перед обновлением
drop TRIGGER if exists check_user_age_before_update;

DELIMITER //

CREATE TRIGGER check_user_age_before_update BEFORE UPDATE ON profiles
FOR EACH ROW
begin
    IF NEW.birthday >= CURRENT_DATE() THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Обновление отменено. Дата рождения должна быть в прошлом.';
    END IF;
END//

DELIMITER ;

-- триггер для корректировки возраста пользователя при вставке новых строк

DROP TRIGGER IF EXISTS check_user_age_before_insert;

DELIMITER //

CREATE TRIGGER check_user_age_before_insert 
BEFORE INSERT ON profiles
FOR EACH ROW
begin
    IF NEW.birthday > CURRENT_DATE() THEN
        SET NEW.birthday = CURRENT_DATE();
    END IF;
END//

DELIMITER ;

-- Циклы 
-- REPEAT-UNTIL
-- Цикл с постуслоием

DROP PROCEDURE IF EXISTS repeat_loop_example;

DELIMITER //

CREATE PROCEDURE repeat_loop_example(start_point INT)
BEGIN
  DECLARE x INT;
  DECLARE str VARCHAR(255);
  SET x = start_point;
  SET str = '';

  REPEAT
    SET str = CONCAT(str,x,',');
    SET x = x - 1;
    UNTIL x <= 0
  END REPEAT;

  SELECT str;
END//

DELIMITER ; 

-- вызов процедуры с циклом
CALL repeat_loop_example(10); 

 

-- WHILE-DO
-- Цикл с предусловием

DROP PROCEDURE IF EXISTS while_loop_example;

DELIMITER //

CREATE PROCEDURE while_loop_example(start_point INT)
BEGIN
  DECLARE x INT;
  DECLARE str VARCHAR(255);
  SET x = start_point;
  SET str = '';

  WHILE x > 0 DO
    SET str = CONCAT(str,x,',');
    SET x = x - 1;
  END WHILE;
 
  SELECT str;
END//

DELIMITER ;


-- вызов процедуры с циклом
CALL while_loop_example(10);

