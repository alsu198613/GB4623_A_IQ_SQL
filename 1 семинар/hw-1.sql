-- Урок 1. Установка СУБД, подключение к БД, просмотр и создание таблиц

/*Задача 1
Создайте таблицу с мобильными телефонами, используя графический интерфейс. 
Необходимые поля таблицы: product_name (название товара), manufacturer (производитель), 
product_count (количество), price (цена). Заполните БД произвольными данными.*/

CREATE SCHEMA `home_work`;

CREATE TABLE `home_work`.`smartphones` (
  `id` INT NOT NULL,
  `product_name` VARCHAR(45) NULL,
  `manufacturer` VARCHAR(45) NULL,
  `product_count` INT NULL,
  `price` INT NULL,
  PRIMARY KEY (`id`));
  
INSERT INTO `home_work`.`smartphones` (`id`, `product_name`, `manufacturer`, `product_count`, `price`) VALUES ('1', 'Samsung A30', 'Samsung', '15', '13000');
INSERT INTO `home_work`.`smartphones` (`id`, `product_name`, `manufacturer`, `product_count`, `price`) VALUES ('2', 'Huawei E40', 'Huawei', '10', '6000');
INSERT INTO `home_work`.`smartphones` (`id`, `product_name`, `manufacturer`, `product_count`, `price`) VALUES ('3', 'IPhone 10 ', 'Apple', '5', '50000');

/*Задача 2
Напишите SELECT-запрос, который выводит название товара, производителя и цену для товаров,
количество которых превышает 2*/

SELECT * 
FROM home_work.smartphones
WHERE product_count > 2
;

/*Задача 3
Выведите SELECT-запросом весь ассортимент товаров марки “Samsung”*/

SELECT * 
FROM home_work.smartphones
WHERE manufacturer LIKE '%Samsung'
;

/*Задача 4.* С помощью SELECT-запроса с оператором LIKE / REGEXP найти: 
4.1.* Товары, в которых есть упоминание "Iphone" */

SELECT *
FROM home_work.smartphones
WHERE product_name LIKE '%Iphone%'
;

-- 4.2.* Товары, в которых есть упоминание "Samsung"
SELECT *
FROM home_work.smartphones
WHERE product_name LIKE '%Samsung%'
;

-- 4.3.* Товары, в названии которых есть ЦИФРЫ

SELECT *
FROM home_work.smartphones
WHERE product_name REGEXP '[0-9]'
;

-- 4.4.* Товары, в названии которых есть ЦИФРА "8" 
SELECT *
FROM home_work.smartphones
WHERE product_name LIKE '%8%'
;