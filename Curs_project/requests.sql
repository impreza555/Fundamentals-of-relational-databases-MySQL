-- Выборки
-- Список оружия guns и разделов weapon_and_ammunition, которым они соответствует и количество на складе.

SELECT g.id, g.`name`, wam.name_of_type, st.quantity_in_stock AS stock FROM guns AS g
LEFT JOIN weapon_and_ammunition AS wam
ON wam.id = g.`type`
LEFT JOIN `storage` AS st
ON st.guns_id = g.id;
 
 -- Отзывы пользователей об оружии.
 
SELECT u.first_name, u.last_name, g.`name`, r.review AS review FROM users AS u
RIGHT JOIN reviews AS r
ON u.id = r.from_user_id
LEFT JOIN guns AS g
ON g.id = r.to_product_id
ORDER BY g.id LIMIT 10;

 -- Выборка данных по конкретной модели оружия
SELECT g.`name`, m.`name`, a.name_of_ammo, g.caliber, r.review AS review FROM guns AS g
LEFT JOIN `ammunition` AS a
ON g.types_of_ammo = a.id
LEFT JOIN `arms_manufacturers` AS m
ON g.manufacturer = m.id
LEFT JOIN `reviews` AS r
ON r.to_product_id = g.id
WHERE g.id IN (1, 5, 15, 10);

-- Самые популярные модели
SELECT g.`name`, m.`name`, o.total AS orders FROM guns AS g
LEFT JOIN orders AS o
ON g.id = o.product_id
LEFT JOIN arms_manufacturers AS m
ON g.manufacturer = m.id
ORDER BY o.total DESC LIMIT 5;
   
-- Представления
-- Оружие по производителям
 
CREATE OR REPLACE VIEW guns_and_manufacturers AS
SELECT g.id, g.`name`, m.`name`AS manufacturer FROM guns AS g
LEFT JOIN `arms_manufacturers`AS m
ON g.manufacturer = m.id;

SELECT * FROM guns_and_manufacturers
ORDER BY manufacturer;

-- Пользователи и заказы

CREATE OR REPLACE VIEW users_and_orders AS
SELECT u.first_name, u.last_name, g.`name`, o.total AS orders FROM users AS u
LEFT JOIN orders AS o
ON u.id = o.user_id
JOIN guns AS g
ON o.product_id = g.id;

SELECT * FROM users_and_orders
LIMIT 5;

-- Хранимые процедуры
-- Назначение поощрительной скидки за большой заказ

DROP PROCEDURE IF EXISTS discount;

DELIMITER //
CREATE PROCEDURE discount (uid INT)
  BEGIN
  DECLARE total INT;
  SET total = uid;
    IF total > 5 THEN
		SELECT u.first_name, u.last_name, (d.discount * 1.9) AS price_discount FROM users AS u
		JOIN discounts AS d
		ON d.user_id = uid
        WHERE u.id = uid;
    ELSE
       SELECT u.first_name, u.last_name, d.discount AS price_discount FROM users AS u
		JOIN discounts AS d
		ON d.user_id = uid
        WHERE u.id = uid;
    END IF;
  END //
DELIMITER ;

CALL discount (38);

-- Назначение скидки в день рождения

DROP PROCEDURE IF EXISTS birth_discount;

DELIMITER //
CREATE PROCEDURE birth_discount (uid INT)
BEGIN
DECLARE b_day VARCHAR(100);
SET b_day = (SELECT date_format(birthday_at, '%m-%d') AS birthday FROM users WHERE id = uid);
	IF b_day = (select date_format(DATE (NOW()), '%m-%d') AS date) THEN
		SELECT u.first_name, u.last_name, (d.discount * 1.5) AS price_discount FROM users AS u
		JOIN discounts AS d
		ON d.user_id = uid
        WHERE u.id = uid;
    ELSE
       SELECT u.first_name, u.last_name, d.discount AS price_discount FROM users AS u
		JOIN discounts AS d
		ON d.user_id = uid
        WHERE u.id = uid;
    END IF;
END //
DELIMITER ;

CALL birth_discount (38);