-- =============================================
-- SCRIPT DE RÉINITIALISATION COMPLÈTE 
-- =============================================

-- Désactivation des contraintes de clés étrangères
SET FOREIGN_KEY_CHECKS = 0;

-- Vidage des tables dans l'ordre correct (pour éviter les conflits de clés étrangères)

-- 1. Vidage de la table demande_statut (table de jonction)
DELETE FROM demande_statut;

-- 2. Vidage de la table remise (dépend de devis)
DELETE FROM remise;

-- 3. Vidage de la table devis (dépend de demande)
DELETE FROM devis;

-- 4. Vidage de la table demande (dépend de client)
DELETE FROM demande;

-- 5. Vidage de la table type_devis
DELETE FROM type_devis;

-- 6. Vidage de la table statut
DELETE FROM statut;

-- 7. Vidage de la table client
DELETE FROM client;

-- 8. Vidage de la table parametre_remise
DELETE FROM parametre_remise;

-- Réinitialisation des auto-incréments
ALTER TABLE client AUTO_INCREMENT = 1;
ALTER TABLE statut AUTO_INCREMENT = 1;
ALTER TABLE type_devis AUTO_INCREMENT = 1;
ALTER TABLE demande AUTO_INCREMENT = 1;
ALTER TABLE devis AUTO_INCREMENT = 1;
ALTER TABLE remise AUTO_INCREMENT = 1;
ALTER TABLE parametre_remise AUTO_INCREMENT = 1;
ALTER TABLE demande_statut AUTO_INCREMENT = 1;

-- Réactivation des contraintes de clés étrangères
SET FOREIGN_KEY_CHECKS = 1;












