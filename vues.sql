USE project;

-- a. Créer une vue logique qui affiche le nom, l'email et la maison de chaque étudiant qui suit un cours de potions
CREATE VIEW potion_students_view AS SELECT student_name, email, house FROM etudiants WHERE registered_course = 'potion';

-- b. Afficher le résultat de la vue.
SELECT * FROM potion_students_view;

-- c. Rajouter 2 étudiants qui suivent un cours de potion.

-- TODO


INSERT INTO etudiants (student_name, email, registered_course, year, house, prefect)
VALUES ('Marie', 'marie@poudlard.edu', 'potion', 3.0, 'Gryffondor', 'Godrick'),
       ('Loic', 'loic@poudlard.edu', 'potion', 1.0, 'Serdaigle', 'Help');

-- d. Afficher (encore) le résultat de la vue.
SELECT * FROM potion_students_view;
-- vérifie que marie et loic sont insérés
SELECT * FROM potion_students_view WHERE student_name = "Marie" OR student_name = "Loic";


-- 3. Modification interdite d'une vue :

-- Créer une vue house_student_count qui regroupe les étudiants par maison et compte le nombre d'étudiants dans chaque maison.
CREATE VIEW house_student_count AS SELECT house AS house_name, COUNT(*) AS student_count FROM etudiants GROUP BY house;

-- Essayer de modifier la colonne contenant le nombre d'étudiants dans une maison. Par exemple, pour la maison Gryffondor, définir le nombre d'étudiants à 10.

UPDATE house_student_count SET student_count = 10 WHERE house_name = 'Gryffondor';
