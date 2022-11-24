/*  Написать cкрипт, добавляющий в БД vk, которую создали на 3 вебинаре,
3-4 новые таблицы (с перечнем полей, указанием индексов и внешних ключей).
(по желанию: организовать все связи 1-1, 1-М, М-М)
*/

USE vk;

-- Таблица игры.
DROP TABLE IF EXISTS games;
CREATE TABLE games (
	id SERIAL PRIMARY KEY,
    name_of_the_game VARCHAR(500), -- Название игры
    game_achievements VARCHAR(250), -- Названия игровых ачивок (достижений), у каждой игры свои.
    INDEX games_name_idx(name_of_the_game)
);

-- Таблица игровых сессий.
DROP TABLE IF EXISTS game_session;
CREATE TABLE game_session (
	game_session_id SERIAL PRIMARY KEY,
	game_id BIGINT UNSIGNED NOT NULL,
    game_score BIGINT UNSIGNED, -- Набранные в игре очки.
    achieved_achievements VARCHAR(250), -- Полученные в игре ачивки (достижения).
    achieved_at DATETIME DEFAULT NOW(), -- Дата получения достижения.
	FOREIGN KEY (game_session_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (game_id) REFERENCES games(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Стена пользователя.
-- Стену можно, по идее, добавить в таблицу профиля.
DROP TABLE IF EXISTS wall;
CREATE TABLE wall (
	wall_id SERIAL PRIMARY KEY,
    comments_allowed bit default 0,
    pinned_messages BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (wall_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Сообщения на стене.
DROP TABLE IF EXISTS wall_messages;
CREATE TABLE wall_messages (
	message_id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL, -- Кто пишет на стене, может писать как сам владелец стены, так и любой пользователь.
	body TEXT,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Отмечается дата изменения сообщения.
    FOREIGN KEY (from_user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE NO ACTION, -- При удалении пользователя, написавшего сообщение, само сообщение не удаляется.
	FOREIGN KEY (message_id) REFERENCES wall(wall_id) ON UPDATE CASCADE ON DELETE CASCADE
);