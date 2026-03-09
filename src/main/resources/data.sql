-- Insertion des opérateurs
INSERT INTO operateur (id, operateur) VALUES (1, '>');
INSERT INTO operateur (id, operateur) VALUES (2, '<');

-- Insertion des résolutions
INSERT INTO resolution (id, nom) VALUES (1, 'plus petite');
INSERT INTO resolution (id, nom) VALUES (2, 'plus grande');
INSERT INTO resolution (id, nom) VALUES (3, 'moyenne');

-- Insertion des candidats
INSERT INTO candidat (id, nom) VALUES (1, 'Rakoto Jean');
INSERT INTO candidat (id, nom) VALUES (2, 'Rabe Marie');
INSERT INTO candidat (id, nom) VALUES (3, 'Randria Paul');
INSERT INTO candidat (id, nom) VALUES (4, 'Rasoa Miry');

-- Insertion des matières
INSERT INTO matiere (id, nom) VALUES (1, 'Mathématiques');
INSERT INTO matiere (id, nom) VALUES (2, 'Physique');
INSERT INTO matiere (id, nom) VALUES (3, 'Informatique');

-- Insertion des correcteurs
INSERT INTO correcteur (id, nom) VALUES (1, 'Prof. Dupont');
INSERT INTO correcteur (id, nom) VALUES (2, 'Prof. Martin');
INSERT INTO correcteur (id, nom) VALUES (3, 'Prof. Bernard');

-- Insertion des paramètres
-- Mathématiques: différence > 3 -> plus grande
INSERT INTO parametre (id, id_matiere, id_operateur, id_resolution, difference) VALUES (1, 1, 1, 2, 3);
-- Physique: différence > 2 -> plus petite
INSERT INTO parametre (id, id_matiere, id_operateur, id_resolution, difference) VALUES (2, 2, 1, 1, 2);
-- Informatique: différence > 4 -> moyenne
INSERT INTO parametre (id, id_matiere, id_operateur, id_resolution, difference) VALUES (3, 3, 1, 3, 4);

-- Insertion des notes pour le candidat 1 (Rakoto Jean) en Mathématiques avec 3 correcteurs
-- Notes: [15.0, 17.0, 16.0] -> différence = 4.0 > 3 -> PLUS GRANDE = 17.0
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (1, 1, 1, 1, 15.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (2, 1, 1, 2, 17.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (3, 1, 1, 3, 16.0);

-- Insertion des notes pour le candidat 1 (Rakoto Jean) en Physique avec 2 correcteurs
-- Notes: [14.0, 14.0] -> identiques -> 14.0
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (4, 1, 2, 1, 14.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (5, 1, 2, 2, 14.0);

-- Insertion des notes pour le candidat 1 (Rakoto Jean) en Informatique avec 2 correcteurs
-- Notes: [16.0, 17.0] -> différence = 1.0 < 4 -> MOYENNE = 16.5
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (6, 1, 3, 1, 16.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (7, 1, 3, 2, 17.0);

-- Insertion des notes pour le candidat 2 (Rabe Marie) en Mathématiques avec 3 correcteurs
-- Notes: [12.0, 18.0, 13.0] -> différence = 11.0 > 3 -> PLUS GRANDE = 18.0
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (8, 2, 1, 1, 12.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (9, 2, 1, 2, 18.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (10, 2, 1, 3, 13.0);

-- Insertion des notes pour le candidat 2 (Rabe Marie) en Physique avec 2 correcteurs
-- Notes: [13.0, 14.0] -> différence = 1.0 < 2 -> PLUS PETITE = 13.0
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (11, 2, 2, 1, 13.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (12, 2, 2, 2, 14.0);

-- Insertion des notes pour le candidat 2 (Rabe Marie) en Informatique avec 2 correcteurs
-- Notes: [15.0, 18.0] -> différence = 3.0 < 4 -> MOYENNE = 16.5
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (13, 2, 3, 1, 15.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (14, 2, 3, 2, 18.0);

-- Insertion des notes pour le candidat 3 (Randria Paul) en Mathématiques avec 3 correcteurs
-- Notes: [14.0, 15.0, 16.0] -> différence = 4.0 > 3 -> PLUS GRANDE = 16.0
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (15, 3, 1, 1, 14.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (16, 3, 1, 2, 15.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (17, 3, 1, 3, 16.0);

-- Insertion des notes pour le candidat 3 (Randria Paul) en Physique avec 2 correcteurs
-- Notes: [15.0, 16.0] -> différence = 1.0 < 2 -> PLUS PETITE = 15.0
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (18, 3, 2, 1, 15.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (19, 3, 2, 2, 16.0);

-- Insertion des notes pour le candidat 3 (Randria Paul) en Informatique avec 3 correcteurs
-- Notes: [16.0, 17.0, 18.0] -> différence = 5.0 > 4 -> MOYENNE = 17.0
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (20, 3, 3, 1, 16.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (21, 3, 3, 2, 17.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (22, 3, 3, 3, 18.0);

-- Insertion des notes pour le candidat 4 (Rasoa Miry) en Mathématiques avec 2 correcteurs
-- Notes: [13.0, 15.0] -> différence = 2.0 < 3 -> MOYENNE = 14.0
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (23, 4, 1, 1, 13.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (24, 4, 1, 2, 15.0);

-- Insertion des notes pour le candidat 4 (Rasoa Miry) en Physique avec 3 correcteurs
-- Notes: [12.0, 13.0, 14.0] -> différence = 4.0 > 2 -> PLUS PETITE = 12.0
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (25, 4, 2, 1, 12.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (26, 4, 2, 2, 13.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (27, 4, 2, 3, 14.0);

-- Insertion des notes pour le candidat 4 (Rasoa Miry) en Informatique avec 2 correcteurs
-- Notes: [17.0, 19.0] -> différence = 2.0 < 4 -> MOYENNE = 18.0
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (28, 4, 3, 1, 17.0);
INSERT INTO note (id, candidat_id, matiere_id, correcteur_id, note) VALUES (29, 4, 3, 2, 19.0);
