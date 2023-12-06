-- Supprimer la table 'students_' si elle existe (à utiliser avec prudence)
DROP TABLE IF EXISTS students_2;

-- Création de la table students_
CREATE TABLE students_2(
    id_students INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(255),
    email VARCHAR(255),
    year DECIMAL(10,0)
);

-- Insertion des données dans la table students_
INSERT INTO students_2(student_name, email, year) SELECT DISTINCT student_name, email, year FROM etudiants;

-- Création de la table house
CREATE TABLE house(
    id_house INT AUTO_INCREMENT PRIMARY KEY,
    house_name VARCHAR(255),
    id_students INT,
    FOREIGN KEY (id_students) REFERENCES students_2(id_students)
);

-- Insertion des données dans la table house
INSERT INTO house(house_name, id_students)
SELECT DISTINCT house, id_students FROM etudiants
INNER JOIN students_2 ON etudiants.student_name = students_2.student_name;

-- Création de la table prefects
CREATE TABLE prefects(
    id_prefect INT AUTO_INCREMENT PRIMARY KEY,
    prefect_name VARCHAR(255),
    id_house INT,
    FOREIGN KEY (id_house) REFERENCES house(id_house)
);

-- Insertion des données dans la table prefects
INSERT INTO prefects(prefect_name, id_house)
SELECT DISTINCT prefect, id_house FROM etudiants
INNER JOIN house ON etudiants.house = house.house_name;

-- Création de la table registered_courses
CREATE TABLE registered_courses(
    id_course INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(255),
    id_students INT,
    FOREIGN KEY (id_students) REFERENCES students_2(id_students)
);

-- Insertion des données dans la table registered_courses
INSERT INTO registered_courses(course_name, id_students)
SELECT DISTINCT registered_course, id_students FROM etudiants
INNER JOIN students_2 ON etudiants.student_name = students_2.student_name;

DROP TABLE etudiants;
