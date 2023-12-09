USE project;

-- 1. Expliquer à quoi sert un index en base de données.

/*
En utilisant CHATGPT :
Un index en base de données est une structure de données qui améliore la vitesse des opérations sur une table,
souvent utilisé pour améliorer la rapidité de récupération des données. 
Les index permettent aux moteurs de base de données de trouver rapidement les lignes correspondantes à une condition de requête. 
Cela est particulièrement utile pour les grandes tables : sans index, le moteur de base de données doit parcourir
l'intégralité de la table (un scan complet) pour trouver les données pertinentes, ce qui peut être très lent.
*/

-- 2. Trouver les requêtes SQL

-- a) compter le nombre d'étudiants qui sont dans la maison "Gryffindor" ;

SELECT COUNT(*) 
FROM students 
JOIN houses ON students.id_house = houses.id_house 
WHERE houses.house_name = 'Gryffondor';

-- b) mesurer le temps de la requête avec la commande SHOW PROFILE

SET profiling = 1;
SELECT COUNT(*) 
FROM students 
JOIN houses ON students.id_house = houses.id_house 
WHERE houses.house_name = 'Gryffondor';
SHOW PROFILES; -- 0.00105025

-- c) ajouter un index sur la colonne "house_id" de la table "students" ;

CREATE INDEX idx_id_house ON students(id_house);

-- d) mesurer à nouveau le temps de la requête après l'ajout de l'index ;

SET profiling = 1;
SELECT COUNT(*) 
FROM students 
JOIN houses ON students.id_house = houses.id_house 
WHERE houses.house_name = 'Gryffondor';
SHOW PROFILES; -- 0.00045850

-- e) mesurer à nouveau le temps de la requête mais sans index.

SET profiling = 1;
SELECT COUNT(*) 
FROM students IGNORE INDEX (idx_id_house)
JOIN houses ON students.id_house = houses.id_house 
WHERE houses.house_name = 'Gryffondor';
SHOW PROFILES; -- 0.00103450


/* 3. Pour les requêtes suivantes, vous devez dire à quoi correspond chaque requête.
Ensuite, vous devez mesurer le temps de la requête, rajouter un index, mesurer encore
une fois le temps de la requête*/

-- Requête a

/*
Cette requête a pour but de compter le nombre d'étudiants par maison et par cours, 
en regroupant les données par nom de maison et nom de cours,
puis en les triant par le nombre d'étudiants en ordre décroissant.
*/

-- mesure sans index
SET profiling = 1;
SELECT houses.house_name, courses.course_name, COUNT(*) AS num_students
FROM students
JOIN houses ON students.id_house = houses.id_house
JOIN registrations ON students.id_student = registrations.id_student
JOIN courses ON registrations.id_course = courses.id_course
GROUP BY houses.house_name, courses.course_name
ORDER BY num_students DESC;
SHOW PROFILES; -- select in 0.00277350


-- mesure avec index
CREATE INDEX idx_house_course ON registrations(id_student, id_course);

SELECT houses.house_name, courses.course_name, COUNT(*) AS num_students
FROM students
JOIN houses ON students.id_house = houses.id_house
JOIN registrations ON students.id_student = registrations.id_student
JOIN courses ON registrations.id_course = courses.id_course
GROUP BY houses.house_name, courses.course_name
ORDER BY num_students DESC;
SHOW PROFILES; -- select in 0.00089225


-- Requête b

/* 
Cette requête sélectionne les noms et les emails des étudiants qui ne sont inscrits dans aucun cours (course_id IS NULL).
*/

-- mesure sans index
SET profiling = 1;
SELECT s.student_name, s.email
FROM students s
LEFT JOIN registrations r ON s.id_student = r.id_student
WHERE r.id_student IS NULL;
SHOW PROFILES; -- 0.00077150

-- mesure avec index

CREATE INDEX idx_registration_student ON registrations(id_student);
SELECT s.student_name, s.email
FROM students s
LEFT JOIN registrations r ON s.id_student = r.id_student
WHERE r.id_student IS NULL;
SHOW PROFILES; -- 0.00053700


-- Requête c

/*
Cette requête compte le nombre d'étudiants 
par maison pour les maisons ayant des étudiants inscrits aux cours 'Potions', 'Sortilèges', ou 'Botanique'.
*/

-- mesure sans index
SET profiling = 1;
SELECT houses.house_name, COUNT(*) AS num_students
FROM students
JOIN houses ON students.id_house = houses.id_house
JOIN registrations ON students.id_student = registrations.id_student
WHERE EXISTS (
    SELECT * FROM courses
    WHERE course_name IN ('Potions', 'Sortilèges', 'Botanique')
    AND id_course = registrations.id_course
)
GROUP BY houses.house_name;
SHOW PROFILES; -- 0.00079925

-- mesure avec index
CREATE INDEX idx_course_name ON courses(course_name);
SELECT houses.house_name, COUNT(*) AS num_students
FROM students
JOIN houses ON students.id_house = houses.id_house
JOIN registrations ON students.id_student = registrations.id_student
WHERE EXISTS (
    SELECT * FROM courses
    WHERE course_name IN ('Potions', 'Sortilèges', 'Botanique')
    AND id_course = registrations.id_course
)
GROUP BY houses.house_name;
SHOW PROFILES; -- 0.00154350



-- Requête d

/*
Cette requête trouve les étudiants qui ont suivi tous les cours disponibles 
pour leur année d'étude, en comparant le nombre de cours distincts suivis 
par chaque étudiant avec le nombre total de cours disponibles pour cette année.
*/

-- mesure sans index
SET profiling = 1;
SELECT s.student_name, s.email
FROM students s
JOIN (
    SELECT id_student, COUNT(DISTINCT id_course) AS num_courses
    FROM registrations
    GROUP BY id_student
) AS sub
ON s.id_student = sub.id_student
JOIN (
    SELECT COUNT(DISTINCT id_course) AS total_courses
    FROM courses
) AS total
ON sub.num_courses = total.total_courses
WHERE sub.num_courses = total.total_courses;
SHOW PROFILES; -- 0.00081500

-- mesure avec les index
CREATE INDEX idx_student_course ON registrations(id_student, id_course);
SELECT s.student_name, s.email
FROM students s
JOIN (
    SELECT id_student, COUNT(DISTINCT id_course) AS num_courses
    FROM registrations
    GROUP BY id_student
) AS sub
ON s.id_student = sub.id_student
JOIN (
    SELECT COUNT(DISTINCT id_course) AS total_courses
    FROM courses
) AS total
ON sub.num_courses = total.total_courses
WHERE sub.num_courses = total.total_courses;
SHOW PROFILES; -- 0.00062675