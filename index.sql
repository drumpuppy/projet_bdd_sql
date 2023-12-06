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


SELECT COUNT(*) as nombre_etudiants FROM etudiants WHERE house = 'Gryffondor';


-- b) mesurer le temps de la requête avec la commande SHOW PROFILE
SET profiling = 1;
SELECT COUNT(*) FROM etudiants WHERE house = 'Gryffondor';
SHOW PROFILE;

-- c) ajouter un index sur la colonne "house_id" de la table "students" ;
CREATE INDEX idx_house_id ON etudiants (house_id);

-- d) mesurer à nouveau le temps de la requête après l'ajout de l'index ;
SELECT COUNT(*) FROM etudiants WHERE house = 'Gryffindor';
SHOW PROFILE;

-- e) mesurer à nouveau le temps de la requête mais sans index.
SELECT COUNT(*) FROM etudiants IGNORE INDEX (idx_house_id) WHERE house = 'Gryffindor';

SET profiling = 1;
SELECT COUNT(*) FROM etudiants IGNORE INDEX (idx_house_id) WHERE house = 'Gryffindor';
SHOW PROFILE;

/* 3. Pour les requêtes suivantes, vous devez dire à quoi correspond chaque requête.
Ensuite, vous devez mesurer le temps de la requête, rajouter un index, mesurer encore
une fois le temps de la requête*/


-- Requête a

SELECT houses.house_name, courses.course_name, COUNT(*) AS num_students
FROM students
JOIN houses ON students.house_id = houses.house_id
JOIN courses ON students.course_id = courses.course_id
GROUP BY houses.house_name, courses.course_name
ORDER BY num_students DESC;

-- Requête b

SELECT student_name, email FROM students WHERE course_id IS NULL;

-- Requête c
SELECT houses.house_name, COUNT(*) AS num_students FROM students
JOIN houses ON students.house_id = houses.house_id
WHERE EXISTS (
SELECT * FROM courses WHERE course_name IN ('Potions', 'Sortilèges', 'Botanique')
AND course_id = students.course_id
)
 GROUP BY houses.house_name;


-- Requête d
SELECT s.student_name, s.email FROM students s
JOIN (
SELECT student_id, year_id, COUNT(DISTINCT course_id) AS
num_courses
FROM students
GROUP BY student_id, year_id
) AS sub
ON s.student_id = sub.student_id AND s.year_id = sub.year_id
JOIN (
SELECT year_id, COUNT(DISTINCT course_id) AS num_courses
FROM students
GROUP BY year_id
) AS total
ON s.year_id = total.year_id AND sub.num_courses =
total.num_courses
WHERE sub.num_courses = total.num_courses;





