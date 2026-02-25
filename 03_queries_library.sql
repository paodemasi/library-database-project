-- ======================================================
-- PROYECTO: library2026
-- ARCHIVO: 03_queries_library.sql
-- DESCRIPCIÓN: Consultas de práctica y análisis de datos.
-- ======================================================

USE library2026;
-- ------------------------------------------------------
-- 0. DICCIONARIO DE DATOS (Guía de estructura)
-- ------------------------------------------------------
-- Ejecuto esta consulta para tener siempre a mano el nombre exacto 
-- de las columnas y sus tipos de datos antes de empezar a consultar.

SELECT 
    table_name AS 'Tabla', 
    column_name AS 'Columna', 
    data_type AS 'Tipo de Dato', 
    is_nullable AS 'Permite Nulos', 
    column_key AS 'Clave'
FROM information_schema.columns
WHERE table_schema = 'library2026'
ORDER BY table_name, ordinal_position;
-- ------------------------------------------------------
-- 1. CONSULTAS DE EXPLORACIÓN GENERAL
-- ------------------------------------------------------

-- Visualización completa de las tablas principales
SELECT * FROM books;
SELECT * FROM readers;
SELECT * FROM readings;

-- Selección de columnas específicas para reportes limpios
SELECT book_name, price, year_pub FROM books;
SELECT surname, name, nationality FROM readers;

-- ------------------------------------------------------
-- 2. FILTRADO DE DATOS (WHERE & OPERADORES)
-- ------------------------------------------------------

-- Filtrado por género específico
SELECT * FROM books 
WHERE genre = 'dystopian';

-- Libros antiguos (clásicos antes de 1950)
SELECT * FROM books 
WHERE year_pub < 1950;

-- Libros extensos (más de 400 páginas)
SELECT * FROM books 
WHERE pages > 400;

-- Libros en un rango de precio específico
SELECT * FROM books 
WHERE price BETWEEN 10 AND 15;

-- ------------------------------------------------------
-- 3. FILTRADO POR FECHAS Y NACIONALIDADES
-- ------------------------------------------------------

-- Lectores nacidos a partir de la década del 90
SELECT * FROM readers 
WHERE birthday > '1990-12-31';

-- Lectores de países específicos (Cono Sur)
SELECT * FROM readers 
WHERE nationality = 'Argentine' OR nationality = 'Chilean';

-- Lecturas realizadas durante el año 2023
SELECT * FROM readings 
WHERE date_finished BETWEEN '2023-01-01' AND '2023-12-31';

-- ------------------------------------------------------
-- 4. ORDENAMIENTO Y VALORES NULOS
-- ------------------------------------------------------

-- Catálogo ordenado por precio (Estrategia comercial)
SELECT * FROM books 
ORDER BY price DESC;

-- Identificación de lecturas en proceso o sin calificar
SELECT * FROM readings 
WHERE rating IS NULL;

-- ------------------------------------------------------
-- 5. RELACIONES ENTRE TABLAS (INNER JOINS)
-- ------------------------------------------------------

-- Listado de libros con sus respectivos autores
SELECT b.book_name, a.full_name
FROM books AS b
INNER JOIN authors AS a ON b.author_id = a.id;

-- Relación de libros con sus géneros
SELECT b.book_name, g.name
FROM books AS b
INNER JOIN genres AS g ON b.genre = g.name;

-- Perfil de lectores con descripción de género
SELECT re.surname, re.name, g.description
FROM readers AS re
INNER JOIN genders AS g ON re.gender_id = g.id;

-- ------------------------------------------------------
-- 6. SEGUIMIENTO DE LECTURAS (JOINS MULTITABLA)
-- ------------------------------------------------------

-- Registro de ISBN leídos por cada lector
SELECT re.surname, re.name, b.ISBN
FROM readings AS r
INNER JOIN readers AS re ON re.id_reader = r.id_reader
INNER JOIN books AS b ON b.ISBN = r.isbn_book;

-- Reporte de calificaciones por lector y libro
SELECT re.surname, re.name, b.book_name, r.rating
FROM readings AS r
INNER JOIN readers AS re ON re.id_reader = r.id_reader
INNER JOIN books AS b ON b.ISBN = r.isbn_book;

--  Cruce total de datos (Lector, Libro, Autor y Género)
SELECT 
    re.surname, 
    re.name, 
    b.book_name, 
    a.full_name, 
    b.genre
FROM readings AS r
INNER JOIN readers AS re ON r.id_reader = re.id_reader
INNER JOIN books AS b ON r.isbn_book = b.ISBN
INNER JOIN authors AS a ON b.author_id = a.id;

-- ------------------------------------------------------
-- 7. FILTRADO AVANZADO Y RANKINGS
-- ------------------------------------------------------

-- Rating 5: Lectores que calificaron con la nota máxima
SELECT re.surname, re.name, b.book_name, r.rating
FROM readings AS r
INNER JOIN readers AS re ON re.id_reader = r.id_reader
INNER JOIN books AS b ON b.ISBN = r.isbn_book
WHERE r.rating = 5;

-- Libros del género 'dystopian' con su autor
SELECT b.book_name, a.full_name
FROM books AS b
INNER JOIN authors AS a ON b.author_id = a.id
WHERE b.genre = 'dystopian';

-- Ranking de libros por extensión (páginas) leídos
SELECT re.surname, re.name, b.pages
FROM readings AS r
INNER JOIN books AS b ON b.ISBN = r.isbn_book
INNER JOIN readers AS re ON r.id_reader = re.id_reader
ORDER BY b.pages DESC;

-- ------------------------------------------------------
-- 8. AGREGACIONES Y MÉTRICAS (GROUP BY)
-- ------------------------------------------------------

-- Los 3 lectores más activos en la temporada de verano (por total de páginas)
SELECT 
    re.surname, 
    re.name, 
    SUM(b.pages) AS totalpages
FROM readings AS r
INNER JOIN books AS b ON r.isbn_book = b.ISBN
INNER JOIN readers AS re ON r.id_reader = re.id_reader
WHERE r.date_finished BETWEEN '2022-12-21' AND '2023-03-21'
GROUP BY re.id_reader
ORDER BY totalpages DESC
LIMIT 3;

-- Promedio de rating por libro (Redondeado a 2 decimales)
SELECT 
    b.book_name, 
    a.full_name, 
    ROUND(AVG(r.rating), 2) AS average_rating_book
FROM readings AS r
INNER JOIN books AS b ON b.ISBN = r.isbn_book
INNER JOIN authors AS a ON b.author_id = a.id
GROUP BY b.ISBN
ORDER BY average_rating_book DESC;

-- Promedio de satisfacción por autor
SELECT 
    a.full_name, 
    ROUND(AVG(r.rating), 2) AS average_rating
FROM readings AS r
INNER JOIN books AS b ON r.isbn_book = b.ISBN
INNER JOIN authors AS a ON b.author_id = a.id
GROUP BY a.id
ORDER BY average_rating DESC;

-- ------------------------------------------------------
-- 9. ACTUALIZACIONES Y BÚSQUEDA DE PATRONES
-- ------------------------------------------------------

-- Búsqueda de palabras clave en títulos o autores
SELECT b.book_name, a.full_name
FROM books AS b
INNER JOIN authors AS a ON a.id = b.author_id
WHERE b.book_name LIKE '%The%' 
   OR b.book_name LIKE '%Amor%' 
   OR b.book_name LIKE '%love%' 
   OR a.full_name LIKE '%Haruki%';

-- Corrección de nombre (Uso de UPDATE con condición específica)
UPDATE authors
SET full_name = 'Eric Arthur Blair'
WHERE id = 6;

-- ------------------------------------------------------
-- 10. AUDITORÍA DE DATOS (LEFT JOINS / VALORES NULL)
-- ------------------------------------------------------

-- Desafío 1: Autores "Fantasma" (Autores sin libros registrados en catálogo)
SELECT a.full_name AS autor_nombre, b.book_name AS libro_titulo
FROM authors AS a
LEFT JOIN books AS b ON a.id = b.author_id
WHERE b.author_id IS NULL;

-- Desafío 2: Géneros Impopulares (Categorías sin libros asociados)
SELECT g.name AS genero_sin_libros 
FROM genres AS g
LEFT JOIN books AS b ON g.name = b.genre
WHERE b.ISBN IS NULL;

-- Desafío 3: Lectores Inactivos (Registrados sin lecturas finalizadas)
SELECT re.name AS lector_nombre, re.surname AS lector_apellido
FROM readers AS re
LEFT JOIN readings AS r ON re.id_reader = r.id_reader
WHERE r.id_reader IS NULL;
