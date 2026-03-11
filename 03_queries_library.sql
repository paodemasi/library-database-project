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
    ROUND(AVG(r.rating), 2) AS average_rating_author
FROM readings AS r
INNER JOIN books AS b ON r.isbn_book = b.ISBN
INNER JOIN authors AS a ON b.author_id = a.id
GROUP BY a.id
ORDER BY average_rating_author DESC;

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

-- Desafío 4: El Inventario de Calificaciones (Volumen vs Calidad)
-- Escenario: Reporte de catálogo con promedio y cantidad de lecturas vs calificaciones.
SELECT 
    b.book_name AS libro, 
    ROUND(AVG(r.rating), 2) AS promedio_calificacion, 
    COUNT(r.rating) AS cantidad_calificaciones, 
    COUNT(r.isbn_book) AS cantidad_lecturas
FROM books AS b
LEFT JOIN readings AS r ON b.ISBN = r.isbn_book
GROUP BY b.ISBN
ORDER BY promedio_calificacion DESC;

-- Desafío 5: Segmentación por Interés en Género 'Classic'
-- Escenario: Identificar qué lectores han consumido literatura del género 'Classic' y diferenciarlos de los que no leyeron dicho género.
-- Se utiliza CASE WHEN para mostrar en una columna específica si el lector leyó clásico o no con una subconsulta que permite obtener los lectores que si leyeron clásicos. 
SELECT 
    re.name AS lector_nombre, 
    re.surname AS lector_apellido, 
	CASE WHEN re.id_reader IN 
		(SELECT re2.id_reader 
		FROM readers AS re2
		INNER JOIN readings AS r ON re2.id_reader = r.id_reader
		INNER JOIN books AS b ON r.isbn_book = b.ISBN AND b.genre = 'classic') 
	THEN 'si' ELSE 'no' END AS leyo_clasico
FROM readers AS re;

-- Desafío 6: Reporte de "Lectores de Época" (Libros del Siglo XX o anteriores)
-- Lista de lectores y cantidad de libros leidos que se escribieron en siglo xx. Se utiliza COUNT para obtener la cantidad de libros y se agrupa por id_reader para generar un row por lector
SELECT 
    re.name AS nombre_lector, 
    re.surname AS apellido_lector, 
    COUNT(b.ISBN) AS cantidad_libros_sxx
FROM readers AS re
LEFT JOIN readings AS r ON re.id_reader = r.id_reader 
LEFT JOIN books AS b ON r.isbn_book = b.ISBN AND b.year_pub < 2000
GROUP BY re.id_reader;

-- ------------------------------------------------------
-- 11. HAVING AVANZADO Y SUBCONSULTAS
-- ------------------------------------------------------

-- Autores con libros calificados con 4 ó más
SELECT a.full_name, ROUND(AVG(r.rating), 2) AS average_rating_author
FROM readings AS r
INNER JOIN books AS b ON r.isbn_book = b.ISBN
INNER JOIN authors AS a ON b.author_id = a.id
GROUP BY a.id
HAVING average_rating_author > 4
ORDER BY average_rating_author DESC;

-- Géneros de libros que tienen más de un libro
SELECT 
	g.name AS genero_literario, 
    COUNT(b.ISBN) AS cantidad_libros
FROM genres AS g
INNER JOIN books AS b ON g.name = b.genre
GROUP BY genero_literario
HAVING cantidad_libros > 1
ORDER BY cantidad_libros DESC;

-- Lectores que leyeron más de un libro
SELECT 
	re.name AS nombre,
    re.surname AS apellido,
    COUNT(b.ISBN) AS cantidad_libros
FROM readings AS r
INNER JOIN readers AS re ON r.id_reader = re.id_reader
INNER JOIN books AS b ON b.ISBN = r.isbn_book
GROUP BY re.id_reader
HAVING cantidad_libros > 1
ORDER BY cantidad_libros DESC;

-- Nacionalidad de autores que tienen calificaciones de libros mayor a 4
SELECT 
	a.nationality AS nacionalidad,
    (ROUND(AVG(r.rating), 2)) AS promedio_calificado
FROM readings AS r
INNER JOIN books AS b ON r.isbn_book = b.ISBN
INNER JOIN authors AS a ON b.author_id = a.id
GROUP BY nationality
HAVING promedio_calificado > 4
ORDER BY promedio_calificado DESC;

-- Nacionalidad de lectores que tienen promedio de calificacion de libros mayor a 4
SELECT 
	re.nationality AS nacionalidad,
    (ROUND(AVG(r.rating), 2)) AS promedio_calificado
FROM readings AS r
INNER JOIN books AS b ON r.isbn_book = b.ISBN
INNER JOIN readers AS re ON r.id_reader = re.id_reader
GROUP BY nationality
HAVING promedio_calificado > 4
ORDER BY promedio_calificado DESC;

-- Géneros que tienen libros con calificación promedio superior a 4
SELECT 
	g.name AS genero,
    ROUND(AVG(r.rating), 2) AS promedio_genero,
    COUNT(r.id_reading) AS cantidad_lecturas
FROM genres AS g
INNER JOIN books AS b ON g.name = b.genre
INNER JOIN readings AS r ON b.ISBN = r.isbn_book
GROUP BY genero
HAVING promedio_genero > 4
ORDER BY promedio_genero DESC; 

--Autores que tienen más de un libro y el promedio de calificaciones es superior a 3
SELECT 
	a.full_name AS autores,
    COUNT(b.ISBN) AS cantidad_libros_autor,
	ROUND(AVG(r.rating), 2) AS promedio_autor
FROM authors AS a 
INNER JOIN books AS b ON a.id = b.author_id
INNER JOIN readings AS r ON b.ISBN = r.isbn_book
GROUP BY autores
HAVING promedio_autor > 3 AND cantidad_libros_autor > 1
ORDER BY promedio_autor DESC;

-- Libros que cuestan más del precio promedio
SELECT * FROM books
WHERE price >
(SELECT 
	ROUND(AVG(b.price), 2) AS promedio_precios_libros
    FROM books AS b);

-- Lectores que leyeron libros del id_author 1
SELECT 
	re.surname AS apellido,
    re.name AS nombre
FROM readers AS re
INNER JOIN readings AS r ON re.id_reader = r.id_reader 
WHERE r.isbn_book IN (SELECT b.ISBN 
						FROM books AS b
						WHERE b.author_id = 1)
GROUP BY re.id_reader;
