DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;

USE shop;

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  `name` VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  `name` VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

-- Проверял себя, по заданию 2.
/*
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  `name` VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(500),
  updated_at VARCHAR(500)
) COMMENT = 'Покупатели';
*/

INSERT INTO users (`name`, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  `name` VARCHAR(255) COMMENT 'Название',
  `description` TEXT COMMENT 'Описание',
  price DECIMAL (11,2) COMMENT 'Цена',
  catalog_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_catalog_id (catalog_id)
) COMMENT = 'Товарные позиции';

INSERT INTO products
  (`name`, `description`, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2);

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products (
  id SERIAL PRIMARY KEY,
  order_id INT UNSIGNED,
  product_id INT UNSIGNED,
  total INT UNSIGNED DEFAULT 1 COMMENT 'Количество заказанных товарных позиций',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Состав заказа';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  product_id INT UNSIGNED,
  discount FLOAT UNSIGNED COMMENT 'Величина скидки от 0.0 до 1.0',
  started_at DATETIME,
  finished_at DATETIME,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id),
  KEY index_of_product_id(product_id)
) COMMENT = 'Скидки';

DROP TABLE IF EXISTS storehouses;
CREATE TABLE storehouses (
  id SERIAL PRIMARY KEY,
  `name` VARCHAR(255) COMMENT 'Название',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Склады';

INSERT INTO storehouses
  (`name`)
VALUES
  ('Intel Core i3-8100'),
  ('Intel Core i5-7400'),
  ('AMD FX-8320E'),
  ('AMD FX-8320'),
  ('ASUS ROG MAXIMUS X HERO'),
  ('Gigabyte H310M S2H'),
  ('MSI B250M GAMING PRO');

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  `value` INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (storehouse_id) REFERENCES storehouses(id) ON UPDATE CASCADE ON DELETE CASCADE,
  FOREIGN KEY (product_id) REFERENCES products(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Запасы на складе';

INSERT INTO storehouses_products
  (product_id, storehouse_id, `value`)
VALUES
  (1, 1, 5),
  (2, 2, 6),
  (3, 3, 1),
  (4, 4, 3),
  (5, 5, 0),
  (6, 6, 2),
  (7, 7, 0);

-- Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»

-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

UPDATE users SET
	created_at = now(),
    updated_at = now();
    
/*  2. Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR
и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME,
сохранив введённые ранее значения.
*/

ALTER TABLE users 
	MODIFY created_at DATETIME,
    MODIFY updated_at DATETIME;

/*  3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0,
если товар закончился и выше нуля, если на складе имеются запасы.
Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
Однако нулевые запасы должны выводиться в конце, после всех записей.
*/

SELECT storehouse_id, product_id, `value` FROM storehouses_products ORDER BY CASE WHEN `value` = 0 THEN 1 ELSE 0 END, `value`;

/*  4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
Месяцы заданы в виде списка английских названий (may, august).
*/

SELECT `name`, birthday_at,
CASE
	WHEN date_format(birthday_at, '%m') = 5 THEN 'may'
	WHEN date_format(birthday_at, '%m') = 8 THEN 'august'
END AS mounth
FROM users WHERE date_format(birthday_at, '%m') = 5 OR date_format(birthday_at, '%m') = 8;

/*  5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM
catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN.
*/

-- Вариант 1
SELECT * FROM catalogs WHERE id IN (5, 1, 2)
ORDER BY CASE
	WHEN id = 5 THEN 0
    WHEN id = 1 THEN 1
    WHEN id = 2 THEN 2
END;

-- Вариант 2
SELECT * FROM catalogs WHERE id IN (5, 1, 2)
ORDER BY
	field(id, 5, 1, 2);
    

-- Практическое задание теме «Агрегация данных»

-- 1. Подсчитайте средний возраст пользователей в таблице users.

SELECT  floor(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))) AS 'Средний возраст' FROM users;

/*  2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
Следует учесть, что необходимы дни недели текущего года, а не года рождения.
*/

SELECT
	dayname(concat(YEAR(now()), '-', substring(birthday_at, 6, 10))) AS 'Дни недели с днями рождения в этом году',
	count(dayname(concat(YEAR(now()), '-', substring(birthday_at, 6, 10)))) AS 'Количество дней рождения'
FROM users GROUP BY dayname(concat(YEAR(now()), '-', substring(birthday_at, 6, 10)));

-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.

SELECT exp(sum(ln(price))) AS 'Произведение' FROM products;
