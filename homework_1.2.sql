/*  2. Создайте базу данных example, разместите в ней таблицу users,
состоящую из двух столбцов, числового id и строкового name.
*/

CREATE DATABASE example DEFAULT CHARSET utf8;
USE example;
CREATE TABLE users(
	id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL COMMENT 'Имя пользователя'
);
INSERT INTO users (name)
VALUES ('Vasja'), ('Petja'), ('Zina'), ('Klava');