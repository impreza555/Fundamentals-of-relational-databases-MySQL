DROP DATABASE IF EXISTS guns;
CREATE DATABASE guns;

USE guns;

DROP TABLE IF EXISTS weapon_and_ammunition;
CREATE TABLE weapon_and_ammunition (
id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
name_of_type VARCHAR(100) NOT NULL,
`description` TEXT
) COMMENT = 'Типы стрелкового оружия и боеприпасов';

DROP TABLE IF EXISTS photo;
CREATE TABLE photo (
id SERIAL PRIMARY KEY,
filename VARCHAR(255),
file_directory VARCHAR(255),
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Фото продукции';

DROP TABLE IF EXISTS arms_manufacturers;
CREATE TABLE arms_manufacturers (
id SERIAL PRIMARY KEY,
`name` VARCHAR(500) NOT NULL,
year_of_foundation SMALLINT UNSIGNED,
country VARCHAR(250),
`description` TEXT,
INDEX name_idx (`name`),
INDEX country_idx (country)
) COMMENT = 'Производители оружия';

DROP TABLE IF EXISTS ammunition;
CREATE TABLE ammunition (
id SERIAL PRIMARY KEY,
name_of_ammo VARCHAR(100) NOT NULL,
type_ammo VARCHAR(100) NOT NULL,
cartridge_length INT UNSIGNED,
bullet_mass INT UNSIGNED,
bullet_muzzle_velocity INT UNSIGNED,
`description` TEXT,
photo_id BIGINT UNSIGNED NOT NULL,
INDEX name_of_ammo_idx (name_of_ammo),
FOREIGN KEY (photo_id) REFERENCES photo(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Типы боеприпасов и основные характеристики';
  
DROP TABLE IF EXISTS guns;
CREATE TABLE guns (
id SERIAL PRIMARY KEY,
`type`INT UNSIGNED NOT NULL,
`name` VARCHAR(500) NOT NULL,
manufacturer BIGINT UNSIGNED,
years_of_production VARCHAR(100),
dimensions JSON, -- Здесь будут габаритные размеры '{'Длина': 'Значение', 'Ширина': 'Значение', 'Высота': 'Значение'}
weight INT UNSIGNED,
types_of_ammo BIGINT UNSIGNED,
caliber INT UNSIGNED,
work_principles VARCHAR(500),
sighting_range INT UNSIGNED,
type_of_ammunition VARCHAR(500),
`description` TEXT,
photo_id BIGINT UNSIGNED NOT NULL,
INDEX name_idx (`name`),  
FOREIGN KEY (`type`) REFERENCES weapon_and_ammunition(id) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (manufacturer) REFERENCES arms_manufacturers(id) ON UPDATE CASCADE ON DELETE SET NULL,
FOREIGN KEY (types_of_ammo) REFERENCES ammunition(id) ON UPDATE CASCADE ON DELETE SET NULL,
FOREIGN KEY (photo_id) REFERENCES photo(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Оружие и основные характеристики';

DROP TABLE IF EXISTS `storage`;
CREATE TABLE `storage` (
id SERIAL PRIMARY KEY,
product_type INT UNSIGNED,
guns_id BIGINT UNSIGNED,
ammunition_id BIGINT UNSIGNED,
quantity_in_stock INT UNSIGNED,
price INT UNSIGNED,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY (product_type) REFERENCES weapon_and_ammunition(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (guns_id) REFERENCES guns(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (ammunition_id) REFERENCES ammunition(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Склад магазина';

DROP TABLE IF EXISTS users;
CREATE TABLE users (
id SERIAL PRIMARY KEY,
first_name VARCHAR(255),
last_name VARCHAR(255),
birthday_at DATE,
license_number INT UNSIGNED NOT NULL,
phone BIGINT UNSIGNED,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
INDEX user_idx (first_name, last_name)
) COMMENT = 'Покупатели';

DROP TABLE IF EXISTS orders;
CREATE TABLE orders (
id SERIAL PRIMARY KEY,
user_id BIGINT UNSIGNED,
product_id BIGINT UNSIGNED,
total INT UNSIGNED DEFAULT 1,
created_at DATETIME DEFAULT NOW(),
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (product_id) REFERENCES `storage`(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Заказы';

DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
id SERIAL PRIMARY KEY,
from_user_id BIGINT UNSIGNED NOT NULL,
to_product_id BIGINT UNSIGNED NOT NULL,
review TEXT,
created_at DATETIME DEFAULT NOW(),
FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION,
FOREIGN KEY (to_product_id) REFERENCES guns(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Отзывы, обзоры товаров';

DROP TABLE IF EXISTS discounts;
CREATE TABLE discounts (
id SERIAL PRIMARY KEY,
user_id BIGINT UNSIGNED,
product_id BIGINT UNSIGNED,
discount FLOAT,
started_at DATETIME,
finished_at DATETIME,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (product_id) REFERENCES `storage`(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Скидки';