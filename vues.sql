USE project;

-- a. Créer une vue logique qui affiche le nom, l'email et la maison de chaque étudiant qui suit un cours de potions
DROP VIEW IF EXISTS view_students_potions;


CREATE VIEW view_students_potions AS 
SELECT s.student_name, s.email, h.house_name
FROM students s
JOIN registrations r ON s.id_student = r.id_student
JOIN courses c ON r.id_course = c.id_course
JOIN houses h ON s.id_house = h.id_house
WHERE c.course_name = 'potion';

-- b. Afficher le résultat de la vue.
SELECT * FROM view_students_potions;

-- c. Rajouter 2 étudiants qui suivent un cours de potion.
INSERT INTO students (student_name, email, year, id_house) VALUES 
('Nouvel Etudiant1', 'etudiant1@poudlard.edu', 1, (SELECT id_house FROM houses WHERE house_name = 'Gryffondor')),
('Nouvel Etudiant2', 'etudiant2@poudlard.edu', 1, (SELECT id_house FROM houses WHERE house_name = 'Serpentard'));

INSERT INTO registrations (id_student, id_course) VALUES 
((SELECT id_student FROM students WHERE email = 'etudiant1@poudlard.edu'), 1),
((SELECT id_student FROM students WHERE email = 'etudiant2@poudlard.edu'), 1);


-- d. Afficher (encore) le résultat de la vue.
SELECT * FROM view_students_potions;


-- 3. Modification interdite d'une vue :

-- Créer une vue house_student_count qui regroupe les étudiants par maison et compte le nombre d'étudiants dans chaque maison.
DROP VIEW IF EXISTS house_student_count;


CREATE VIEW house_student_count AS
SELECT h.house_name, COUNT(s.id_student) AS student_count
FROM houses h LEFT JOIN students s ON h.id_house = s.id_house 
GROUP BY h.house_name;

-- Essayer de modifier la colonne contenant le nombre d'étudiants dans une maison. Par exemple, pour la maison Gryffondor, définir le nombre d'étudiants à 10.
UPDATE house_student_count SET student_count = 10 WHERE house_name = 'Gryffondor';
-- crée une erreur