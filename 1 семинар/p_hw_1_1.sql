/* Создайте таблицу (сущность) с мобильными телефонами mobile_phones. При создании необходимо использовать DDL-команды.
Перечень полей (атрибутов):
id – числовой тип, автоинкремент, первичный ключ;
product_name – строковый тип, обязательный к заполнению;
manufacturer – строковый тип, обязательный к заполнению;
product_count – числовой тип, беззнаковый;
price – числовой тип, беззнаковый.
Используя CRUD-операцию INSERT, наполните сущность mobile_phones данными: */
-- При написании запросов указывайте не только имя таблицы, но и схему.
-- Название вашей схемы - itresume7093817
-- Например, itresume7093817.tablename


-- удаляем таблицу с мобильными телефонами `mobile_phones`, если она существует
DROP TABLE IF EXISTS {schema_name}.mobile_phones;
-- создаём таблицу с мобильными телефонами (mobile_phones)
CREATE TABLE {schema_name}.mobile_phones (
    id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    manufacturer VARCHAR(100) NOT NULL,
    product_count INT,
    price BIGINT
);

-- наполнение данными
INSERT INTO {schema_name}.mobile_phones (product_name, manufacturer, product_count, price)
VALUES
    ('iPhone X', 'Apple', 3, 76000),  
    ('iPhone 8', 'Apple', 2, 51000),  
    ('Galaxy S9', 'Samsung', 2, 56000),  
    ('Galaxy S8', 'Samsung', 1, 41000),
    ('P20 Pro', 'Huawei', 5, 36000);

