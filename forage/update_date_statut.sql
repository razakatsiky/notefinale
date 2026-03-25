DELETE FROM demande_statut;

ALTER TABLE demande_statut MODIFY COLUMN date_statut DATETIME NOT NULL;

