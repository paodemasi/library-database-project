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
