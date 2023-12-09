
--                                                      ETAPE 2

-- 3. Ajout d'un étudiant et rollback :
START TRANSACTION;
INSERT INTO students (student_name, email, year, id_house)
VALUES ('Lily Rogue', 'lily.rogue@poudlard.edu', 2, 1);
SELECT * FROM students WHERE student_name = 'Lily Rogue';
ROLLBACK;

-- Vérification pour confirmer que l'étudiant n'a pas été ajouté de manière permanente
SELECT * FROM students WHERE student_name = 'Lily Rogue';

########################################################
-- je vais utiliser ce student pour le changement de cours
START TRANSACTION;
INSERT INTO students (student_name, email, year, id_house)
VALUES ('Louise Rogue', 'louise.rogue@poudlard.edu', 1, 3);
SELECT * FROM students WHERE student_name = 'Louise Rogue';
INSERT INTO registrations (id_student, id_course) VALUES (33, 2); 
COMMIT; 


-- 4. Modification multiple et commit :
SET SQL_SAFE_UPDATES = 0;
START TRANSACTION;

-- Changement de la maison d'un étudiant
UPDATE students
SET id_house = 2
WHERE student_name = 'Aiden Ortiz';

-- Mise à jour du cours d'un autre étudiant
UPDATE registrations
SET id_course = (SELECT id_course FROM courses WHERE id_course = 1)
WHERE id_student = (SELECT id_student FROM students WHERE student_name = 'Louise Rogue');

-- Vérifiez la mise à jour de la maison de l'étudiant 'Aiden Ortiz'.
SELECT * FROM students WHERE student_name = 'Aiden Ortiz';

-- Vérifiez la mise à jour du cours de l'étudiant 'Louise Rogue'.
SELECT * FROM registrations WHERE id_student = (SELECT id_student FROM students WHERE student_name = 'Louise Rogue');

-- Validation des modifications
COMMIT;

-- Vérification pour confirmer que les modifications sont permanentes
SELECT * FROM students WHERE student_name IN ('Aiden Ortiz');

SELECT * FROM registrations
WHERE id_student = (SELECT id_student FROM students WHERE student_name = 'Louise Rogue');

########################################################
-- 5. Transaction avec erreur et rollback
START TRANSACTION;

-- Opération 1 : Ajout d'un nouvel étudiant
INSERT INTO students (student_name, email, year, id_house)
VALUES ('Masy Wilys', 'masy.wilys@poudlard.edu', 2, 1);

-- Opération 2 (qui échouera) : Ajout d'un autre étudiant avec le même email
INSERT INTO students (student_name, email, year, id_house)
VALUES ('Owen Wood', 'owen.wood@poudlard.edu', 1, 3);

-- Observation du comportement de la transaction en cas d'erreur
-- une erreur apparait car nous ne pouvons pas dupliquer l'adresse email dans la BDD

-- Annulation de toutes les opérations
ROLLBACK;

SET SQL_SAFE_UPDATES = 1;