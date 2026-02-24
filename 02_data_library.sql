USE library2026;

-- GÉNEROS 
INSERT INTO genres (name) VALUES 
('fantasy'), ('science fiction'), ('dystopian'), ('romance'), ('mystery'), 
('thriller'), ('horror'), ('historical'), ('adventure'), ('young adult'), 
('contemporary'), ('literary fiction'), ('magical realism'), ('urban fantasy'), 
('paranormal'), ('crime'), ('nonfiction'), ('biography'), ('memoir'), 
('self-help'), ('philosophy'), ('psychology'), ('poetry'), ('classic'), 
('graphic novel'), ('children');

-- AUTORES 
INSERT INTO authors (full_name, nationality, birthday) VALUES 
('Gabriel García Márquez', 'Colombian', '1927-03-06'),
('Jorge Luis Borges', 'Argentine', '1899-08-24'),
('Isabel Allende', 'Chilean', '1942-08-02'),
('Julio Cortázar', 'Argentine', '1914-08-26'),
('Jane Austen', 'British', '1775-12-16'),
('George Orwell', 'British', '1903-06-25'),
('Haruki Murakami', 'Japanese', '1949-01-12'),
('Margaret Atwood', 'Canadian', '1939-11-18'),
('Fyodor Dostoevsky', 'Russian', '1821-11-11'),
('Ernest Hemingway', 'American', '1899-07-21'),
('Virginia Woolf', 'British', '1882-01-25'); -- <-- Autora sin libros (para el JOIN)

-- GÉNEROS DE IDENTIDAD
INSERT INTO genders (id, description) VALUES
('M', 'male'), ('F', 'female'), ('NB', 'non binary'), ('X', 'prefer not to say');

-- LIBROS 
INSERT INTO books (ISBN, book_name, author_id, genre, pages, year_pub, price) VALUES
('9780307474728', 'One Hundred Years of Solitude', 1, 'magical realism', 417, 1967, 15.99),
('9780307950925', 'Love in the Time of Cholera', 1, 'romance', 348, 1985, 14.50),
('9788432225074', 'Ficciones', 2, 'literary fiction', 224, 1944, 12.00),
('9788432225081', 'El Aleph', 2, 'literary fiction', 272, 1949, 13.20),
('9780553213102', 'Pride and Prejudice', 5, 'classic', 279, 1813, 9.99),
('9780451524935', '1984', 6, 'dystopian', 328, 1949, 11.50),
('9780385490818', 'Kafka on the Shore', 7, 'fantasy', 505, 2002, 16.80),
('9780385721676', 'Norwegian Wood', 7, 'romance', 296, 1987, 14.00),
('9780385497466', 'The Handmaid''s Tale', 8, 'dystopian', 311, 1985, 13.90),
('9780140449136', 'Crime and Punishment', 9, 'classic', 671, 1866, 18.50),
('9780684803357', 'The Old Man and the Sea', 10, 'classic', 127, 1952, 10.50),
('9780060883287', 'The House of the Spirits', 3, 'magical realism', 433, 1982, 15.20),
('9788432225098', 'Rayuela', 4, 'literary fiction', 736, 1963, 19.00),
('9780141187761', 'Animal Farm', 6, 'dystopian', 112, 1945, 8.99),
('9780307744661', 'Blindness', 8, 'literary fiction', 352, 1995, 14.75),
('9780451525482', 'The Shining', 10, 'horror', 447, 1977, 12.99); -- <-- Libro sin lecturas

-- LECTORES 
INSERT INTO readers (surname, name, gender_id, nationality, birthday) VALUES
('Gomez', 'Lucia', 'F', 'Argentine', '1990-05-12'),
('Perez', 'Martin', 'M', 'Argentine', '1985-11-03'),
('Lopez', 'Carla', 'F', 'Uruguayan', '1994-07-21'),
('Rodriguez', 'Santiago', 'M', 'Chilean', '1988-02-14'),
('Fernandez', 'Ana', 'F', 'Spanish', '1992-09-09'),
('Silva', 'Joao', 'M', 'Brazilian', '1980-01-30'),
('Martinez', 'Rocio', 'F', 'Argentine', '1998-12-05'),
('Diaz', 'Pablo', 'M', 'Mexican', '1983-06-17'),
('Ruiz', 'Valentina', 'F', 'Colombian', '2000-03-22'),
('Morales', 'Diego', 'M', 'Peruvian', '1991-08-10'),
('Castro', 'Elena', 'F', 'Chilean', '1987-04-18'),
('Herrera', 'Tomas', 'M', 'Argentine', '1995-10-27'),
('Navarro', 'Sofia', 'F', 'Spanish', '1989-01-08'),
('Ramos', 'Alex', 'NB', 'American', '1993-06-01'),
('Vega', 'Camila', 'X', 'Argentine', '1996-11-19'),
('Cooper', 'Georgie', 'M', 'American', '1994-12-01'); -- <-- Lector sin lecturas

-- LECTURAS (Solo usamos los IDs del 1 al 15)
INSERT INTO readings (isbn_book, id_reader, date_finished, rating) VALUES
('9780307474728', 1, '2023-01-15', 5),
('9780307950925', 1, '2023-03-10', 4),
('9788432225074', 2, '2022-11-02', 5),
('9780553213102', 3, '2023-02-20', 4),
('9780451524935', 4, '2023-04-01', 5),
('9780385490818', 5, '2022-12-12', 3),
('9780385721676', 6, '2023-01-28', 4),
('9780385497466', 7, '2023-05-06', 5),
('9780140449136', 8, '2022-10-18', 4),
('9780684803357', 9, '2023-03-03', 5),
('9780060883287', 10, '2023-02-14', 4),
('9788432225098', 11, '2023-04-22', 5),
('9780141187761', 12, '2023-01-05', 4),
('9780307744661', 13, '2023-03-30', 3),
('9780307474728', 14, NULL, NULL),
('9780451524935', 15, NULL, NULL);
