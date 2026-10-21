PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;

DROP TABLE IF EXISTS movie_genres;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS genres;
DROP TABLE IF EXISTS occupations;

-- Справочник профессий (устранение транзитивной зависимости)
CREATE TABLE occupations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- Справочник жанров
CREATE TABLE genres (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- Пользователи с проверкой уникальности email, пола и ссылкой на occupation_id
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    gender TEXT NOT NULL CHECK(gender IN ('male', 'female')),
    register_date TEXT NOT NULL,
    occupation_id INTEGER NOT NULL REFERENCES occupations(id)
);

-- Фильмы (без списка жанров в одной строке)
CREATE TABLE movies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    year INTEGER
);

-- Таблица связей многие-ко-многим для фильмов и жанров (1НФ)
CREATE TABLE movie_genres (
    movie_id INTEGER NOT NULL REFERENCES movies(id) ON DELETE CASCADE,
    genre_id INTEGER NOT NULL REFERENCES genres(id) ON DELETE CASCADE,
    PRIMARY KEY (movie_id, genre_id)
);

-- Рейтинги:
-- 1. Удаление пользователя каскадно удаляет его отзывы (ON DELETE CASCADE)
-- 2. Фильм нельзя удалить при наличии отзывов (ON DELETE RESTRICT)
-- 3. Ограничение рейтинга от 0 до 5
CREATE TABLE ratings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    movie_id INTEGER NOT NULL REFERENCES movies(id) ON DELETE RESTRICT,
    rating REAL NOT NULL CHECK(rating >= 0.0 AND rating <= 5.0),
    timestamp INTEGER NOT NULL
);

-- Теги к фильмам
CREATE TABLE tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    movie_id INTEGER NOT NULL REFERENCES movies(id) ON DELETE RESTRICT,
    tag TEXT,
    timestamp INTEGER NOT NULL
);

-- Индексы для оптимизации поиска
CREATE INDEX idx_users_name ON users(name);
CREATE INDEX idx_movies_title ON movies(title);
CREATE INDEX idx_movies_year ON movies(year);

-- ============================================================
-- ЗАПОЛНЕНИЕ ТАБЛИЦЫ occupations
-- ============================================================
INSERT INTO occupations (id, name) VALUES (1, 'administrator');
INSERT INTO occupations (id, name) VALUES (2, 'artist');
INSERT INTO occupations (id, name) VALUES (3, 'doctor');
INSERT INTO occupations (id, name) VALUES (4, 'educator');
INSERT INTO occupations (id, name) VALUES (5, 'engineer');
INSERT INTO occupations (id, name) VALUES (6, 'entertainment');
INSERT INTO occupations (id, name) VALUES (7, 'executive');
INSERT INTO occupations (id, name) VALUES (8, 'healthcare');
INSERT INTO occupations (id, name) VALUES (9, 'homemaker');
INSERT INTO occupations (id, name) VALUES (10, 'lawyer');
INSERT INTO occupations (id, name) VALUES (11, 'librarian');
INSERT INTO occupations (id, name) VALUES (12, 'marketing');
INSERT INTO occupations (id, name) VALUES (13, 'none');
INSERT INTO occupations (id, name) VALUES (