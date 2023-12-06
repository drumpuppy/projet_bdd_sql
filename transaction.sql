-- 3. Ajout d'un étudiant et rollback :
START TRANSACTION;
INSERT INTO students (student_name, email, year, id_house)
VALUES ('Lily Rogue', 'lily.rogue@poudlard.edu', 2, 1);
SELECT * FROM students WHERE student_name = 'Lily Rogue';
ROLLBACK;

-- Vérification pour confirmer que l'étudiant n'a pas été ajouté de manière permanente
SELECT * FROM students WHERE student_name = 'Lily Rogue';

########################################################
-- 4. Modification multiple et commit :
SET SQL_SAFE_UPDATES = 0;
START TRANSACTION;

-- Changement de la maison d'un étudiant
UPDATE students
SET id_house = 2
WHERE student_name = 'Aiden Ortiz';

-- Mise à jour du cours d'un autre étudiant
UPDATE students
SET registered_course = 'botanique'
WHERE student_name = 'Penelope Price';

-- Vérification des modifications dans la base de données
SELECT * FROM students WHERE student_name IN ('Aiden Ortiz', 'Penelope Price');

-- Validation des modifications
COMMIT;

-- Vérification pour confirmer que les modifications sont permanentes
SELECT * FROM students WHERE student_name IN ('Aiden Ortiz', 'Penelope Price');

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