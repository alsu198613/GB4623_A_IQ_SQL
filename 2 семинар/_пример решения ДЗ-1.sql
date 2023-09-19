/*1.	Создайте таблицу с мобильными телефонами, используя графический интерфейс. Необходимые поля таблицы: product_name (название товара), manufacturer (производитель), product_count (количество), price (цена). Заполните БД произвольными данными.
*/ 
CREATE TABLE `shop2`.`sellphones` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_name` VARCHAR(45) NULL,
  `manufacturer` VARCHAR(45) NULL,
  `product_count` INT NULL,
  `price` DOUBLE NULL,
  PRIMARY KEY (`id`));

INSERT INTO `sellphones` 
VALUES 
(1,'iPhone X','Apple',3,75000),
(2,'iPhone 8 Pro','Apple',2,50000),
(3,'Galaxy s9','Samsung',5,46000),
(4,'Galaxy s10','Samsung',4,64000);


-- 2. 	Напишите SELECT-запрос, который выводит название товара, производителя и цену для товаров, количество которых превышает 2
SELECT 
	product_name, manufacturer, price, product_count
FROM shop2.selllphones
WHERE product_count > 2;

-- 3.  Выведите SELECT-запросом весь ассортимент товаров марки “Samsung”
SELECT *
FROM shop2.selllphones
WHERE manufacturer = 'Samsung';

/*4.*  	С помощью SELECT-запроса с оператором LIKE найти:
	4.1.* Товары, в которых есть упоминание "Iphone"
	4.2.* Товары, в которых есть упоминание "Samsung"
	4.3.*  Товары, в названии которых есть ЦИФРЫ
	4.4.*  Товары, в названии которых есть ЦИФРА "8"  
*/
SELECT 	*
FROM shop2.selllphones
WHERE product_name LIKE '%iPhone%';

SELECT 	*
FROM shop2.selllphones
WHERE manufacturer = 'Samsung';

SELECT 	*
FROM selllphones
WHERE product_name REGEXP '[0-9]';

SELECT 	*
FROM selllphones
WHERE product_name REGEXP '[8]';

SELECT 	*
FROM selllphones
WHERE product_name LIKE '%8%';

