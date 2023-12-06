
--                                                      ETAPE 0 

-- a. Afficher l’ensemble des tables en SQL
SHOW TABLES;

-- b. Afficher les colonnes de la table "project"
SHOW COLUMNS FROM etudiants;

-- c. Le nombre d'étudiants dans la base de données
SELECT COUNT(*) as nombre_étudiant FROM etudiants;

-- d. Les différents cours dans la base de données
SELECT DISTINCT registered_course FROM etudiants;

-- e. Les différentes maisons dans la base de données
SELECT DISTINCT house FROM etudiants;

-- f. Les différents préfets dans la base de données
SELECT DISTINCT prefect FROM etudiants; 

-- g. Quel est le préfet pour chaque maison ?
SELECT house, prefect FROM etudiants GROUP BY house, prefect;

-- h. Pour compter le nombre d'étudiants par année
SELECT year, COUNT(*) as nombre_etudiants FROM etudiants GROUP BY year;

-- i. Pour afficher les noms et les emails des étudiants qui suivent le cours "potion"
SELECT student_name, email FROM etudiants WHERE registered_course = "potion";

-- j. Pour trouver le nombre d'étudiants de chaque maison qui suivent le cours "potion"
SELECT house,COUNT(*) as nombre_etudiant FROM etudiants WHERE registered_course = "potion" GROUP BY house;

-- k. Afficher les maisons des étudiants et le nombre d'étudiants dans chaque maison
SELECT house, COUNT(*) AS number_of_students FROM etudiants GROUP BY house;

-- l. Afficher les maisons des étudiants et le nombre d'étudiants dans chaque maison, triés par ordre décroissant
SELECT house, COUNT(*) AS number_of_students FROM etudiants GROUP BY house ORDER BY number_of_students DESC;

-- m. Afficher le nombre d'étudiants inscrits à chaque cours, triés par ordre décroissant
SELECT registered_course, COUNT(*) as nombre_étudiants_inscrits FROM etudiants GROUP BY registered_course ORDER BY nombre_étudiants_inscrits DESC;

-- n. Afficher les préfets de chaque maison, triés par ordre alphabétique des maisons
SELECT house, prefect FROM etudiants GROUP BY house, prefect ORDER BY house ASC; 



