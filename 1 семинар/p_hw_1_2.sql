/* Имеется таблица (сущность) с мобильными телефонами mobile_phones.
У сущности имеются следующие поля(атрибуты):
id – идентификатор;
product_name – название;
manufacturer – производитель;
product_count – количество;
price – цена.
Необходимо вывести название, производителя и цену для мобильных телефонов, у которых количество больше чем 2.*/

SELECT product_name, manufacturer, price 
FROM mobile_phones
WHERE product_count > 2;
