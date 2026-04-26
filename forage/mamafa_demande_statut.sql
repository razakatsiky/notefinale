INSERT INTO parametre_remise (seuil_prix, taux_remise, operateur, actif) 
VALUES (1000000.00, 10.00, '>=', 1)
ON DUPLICATE KEY UPDATE seuil_prix = VALUES(seuil_prix), actif = 1;


delete from demande_statut where id=4;