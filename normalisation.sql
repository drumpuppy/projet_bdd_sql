-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS registrations, prefects, students, courses, houses;


-- Création de la table 'students'
CREATE TABLE houses (
    id_house INT PRIMARY KEY AUTO_INCREMENT,
    house_name VARCHAR(255) UNIQUE
);

CREATE TABLE courses (
    id_course INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(255) UNIQUE
);

CREATE TABLE students (
    id_student INT PRIMARY KEY AUTO_INCREMENT,
    student_name VARCHAR(255),
    email VARCHAR(255) UNIQUE,
    year DECIMAL,
    id_house INT,
    FOREIGN KEY (id_house) REFERENCES houses(id_house)
);

CREATE TABLE registrations (
    id_student INT,
    id_course INT,
    PRIMARY KEY (id_student, id_course),
    FOREIGN KEY (id_student) REFERENCES students(id_student),
    FOREIGN KEY (id_course) REFERENCES courses(id_course)
);

CREATE TABLE prefects (
    id_prefect INT PRIMARY KEY AUTO_INCREMENT,
    prefect_name VARCHAR(255),
    id_house INT,
    FOREIGN KEY (id_house) REFERENCES houses(id_house)
);

-- Insertion des données dans les tables 'courses' et 'houses'
INSERT INTO houses (house_name) SELECT DISTINCT house FROM etudiants;
INSERT INTO courses (course_name) SELECT DISTINCT registered_course FROM etudiants;

-- Insertion des étudiants
INSERT INTO students (student_name, email, year, id_house)
SELECT DISTINCT e.student_name, e.email, e.year, h.id_house
FROM etudiants e
JOIN houses h ON e.house = h.house_name
ON DUPLICATE KEY UPDATE id_student = id_student;



-- Insérer les préfets après que 'houses' ait été peuplée
INSERT INTO prefects (prefect_name, id_house)
SELECT 
    DISTINCT e.prefect, h.id_house
FROM etudiants e
JOIN houses h ON e.house = h.house_name;

-- Insérer les inscriptions après que 'students' et 'courses' aient été peuplés
INSERT IGNORE INTO registrations (id_student, id_course)
SELECT s.id_student, c.id_course
FROM etudiants e
JOIN students s ON e.student_name = s.student_name AND e.email = s.email
JOIN courses c ON e.registered_course = c.course_name;

-- Supprimer la table 'etudiants' si tout est correct
-- DROP TABLE etudiants;
