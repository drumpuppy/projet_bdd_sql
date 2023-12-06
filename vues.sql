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

-- Ajouter les étudiants
INSERT INTO students (student_name, email, year) VALUES 
('Etudiant1', 'etudiant1@poudlard.edu', 1),
('Etudiant2', 'etudiant2@poudlard.edu', 1);

-- Récupérer l'ID du cours de potion
SET @course_id_potion = (SELECT id_course FROM courses WHERE course_name = 'potion');

-- Récupérer les ID des étudiants nouvellement ajoutés en supposant que les emails sont uniques
SET @student_id_1 = (SELECT id_student FROM students WHERE email = 'etudiant1@poudlard.edu');
SET @student_id_2 = (SELECT id_student FROM students WHERE email = 'etudiant2@poudlard.edu');

-- Ajouter leurs inscriptions au cours de potion
INSERT INTO registrations (id_student, id_course) VALUES 
(@student_id_1, @course_id_potion),
(@student_id_2, @course_id_potion);


-- d. Afficher (encore) le résultat de la vue.
SELECT * FROM view_students_potions;


-- 3. Modification interdite d'une vue :

-- Créer une vue house_student_count qui regroupe les étudiants par maison et compte le nombre d'étudiants dans chaque maison.
CREATE VIEW house_student_count AS
SELECT houses.house_name, COUNT(registrations.id_student) AS student_count
FROM houses
JOIN students ON houses.id_house = students.id_student
JOIN registrations ON students.id_student = registrations.id_student
GROUP BY houses.house_name;




-- Essayer de modifier la colonne contenant le nombre d'étudiants dans une maison. Par exemple, pour la maison Gryffondor, définir le nombre d'étudiants à 10.
UPDATE house_student_count SET student_count = 10 WHERE house_name = 'Gryffondor';

