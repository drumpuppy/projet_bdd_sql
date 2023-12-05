#creation de database et table pour import du csv#####

DROP DATABASE IF EXISTS project;
CREATE DATABASE project;
USE project;

CREATE TABLE etudiants (
    student_name VARCHAR(255),
    email VARCHAR(255),
    registered_course VARCHAR(255),
    year DECIMAL,
    house VARCHAR(255),
    prefect VARCHAR(255)
);

SELECT * FROM etudiants;

########################################################