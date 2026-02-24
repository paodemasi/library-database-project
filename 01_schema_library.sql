-- 1. Intentar borrar si ya existe (para poder re-ejecutar el script sin errores)
DROP DATABASE IF EXISTS library2026;

-- 2. Crear la base de datos
CREATE DATABASE library2026;

-- 3. Empezar a usarla
USE library2026;

-- 4. Creación de tablas 

-- TABLA: genres
-- Catálogo de géneros literarios (ej: Terror, Fantasía).
-- Se usa como tabla de referencia para asegurar que en la tabla 'books'solo se utilicen géneros válidos.
CREATE TABLE genres (
name VARCHAR (20) UNIQUE PRIMARY KEY
);

-- TABLA: authors
-- Contiene los datos biográficos de los escritores.
-- Se usa un ID numérico autoincremental como clave primaria para facilitar las relaciones.
CREATE TABLE authors (
id INT AUTO_INCREMENT PRIMARY KEY,
full_name VARCHAR (50) NOT NULL,
nationality VARCHAR (20),
birthday DATE
);

-- TABLA: genders
-- Diccionario de identidades de género (ej: 'M', 'F', 'NB').
-- Sirve para normalizar la información de los lectores y evitar entradas de texto libre.
CREATE TABLE genders (
id CHAR (2) PRIMARY KEY,
description VARCHAR (30) NOT NULL UNIQUE
);

-- TABLA: books
-- Almacena el catálogo de libros disponibles. 
-- Incluye relaciones (Foreign Keys) hacia 'authors' y 'genres'. 
-- El ISBN se utiliza como clave primaria por ser el estándar de la industria.
CREATE TABLE books(
ISBN VARCHAR (20) PRIMARY KEY,
book_name VARCHAR (50) NOT NULL,
author_id INT NOT NULL,
genre VARCHAR (20) NOT NULL,
pages INT NOT NULL,
year_pub INT NOT NULL,
price DECIMAL (10,2) NOT NULL,
FOREIGN KEY (genre) REFERENCES genres (name),
FOREIGN KEY (author_id) REFERENCES authors (id)
);

-- TABLA: readers
-- Registro de usuarios o socios de la biblioteca.
-- Vincula a cada lector con su identidad de género mediante 'gender_id'.
CREATE TABLE readers(
id_reader INT AUTO_INCREMENT PRIMARY KEY,
surname VARCHAR (50),
name VARCHAR (50),
gender_id CHAR (2),
FOREIGN KEY (gender_id) REFERENCES genders (id),
nationality VARCHAR (20),
birthday DATE
);

-- TABLA: readings
-- Tabla transaccional que registra la actividad de lectura.
-- Conecta lectores con libros y almacena la calificación (rating).
-- El CHECK asegura que la valoración sea siempre del 1 al 5.
CREATE TABLE readings (
id_reading INT AUTO_INCREMENT PRIMARY KEY,
isbn_book VARCHAR (20) NOT NULL,
id_reader INT NOT NULL,
date_finished DATE,
rating INT CHECK (rating BETWEEN 1 AND 5),
FOREIGN KEY (isbn_book) REFERENCES books (ISBN),
FOREIGN KEY (id_reader) REFERENCES readers (id_reader)
);
