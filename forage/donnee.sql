-- =============================================
-- INSERTION DES DONNÉES DE DÉMONSTRATION
-- =============================================

-- Insertion des clients de démonstration
INSERT INTO client (id, nom, telephone, email) VALUES
(1, 'Client Test 1', '+261 123 456', 'client1@test.com'),
(2, 'Client Test 2', '+261 789 012', 'client2@test.com'),
(3, 'Entreprise ABC', '+261 555 000', 'contact@entreprise-abc.com'),
(4, 'SARL Tech', '+261 333 444', 'info@sarl-tech.fr'),
(5, 'Association XYZ', '+261 777 888', 'contact@association-xyz.org');

-- Insertion des statuts par défaut
INSERT INTO statut (id, nom, libelle) VALUES
(1, 'Créée', 'Demande créée'),
(2, 'Confirmée', 'Demande confirmée'),
(3, 'Annulée', 'Demande annulée'),
(4, 'En cours', 'Demande en cours de traitement'),
(5, 'Terminée', 'Demande terminée');

-- Insertion des types de devis
INSERT INTO type_devis (id, libelle) VALUES
(1, 'Standard'),
(2, 'Premium'),
(3, 'Urgent'),
(4, 'Personnalisé');

-- Insertion des paramètres de remise
INSERT INTO parametre_remise (id, min_quantite, max_quantite, pourcentage_remise) VALUES
(1, 5, 10, 5.00),
(2, 11, 20, 10.00),
(3, 21, 50, 15.00),
(4, 51, 100, 20.00);

-- Insertion des demandes de démonstration
INSERT INTO demande (id, description, lieu, date_demande, client_id) VALUES
(1, 'Demande de test 1 - Réparation ordinateur portable', 'Bureau Central', '2026-04-15', 1),
(2, 'Demande de test 2 - Installation réseau', 'Siège Social', '2026-04-14', 2),
(3, 'Demande de test 3 - Maintenance serveur', 'Data Center', '2026-04-13', 3),
(4, 'Demande de test 4 - Formation logiciel', 'Salle de formation', '2026-04-12', 4),
(5, 'Demande de test 5 - Audit sécurité', 'Bureau Principal', '2026-04-11', 5);

-- Insertion des statuts pour les demandes (historique)
INSERT INTO demande_statut (id, demande_id, statut_id, date_statut, observation) VALUES
-- Demande 1 : Créée → Confirmée
(1, 1, 1, '2026-04-15 09:00:00', 'Demande créée automatiquement'),
(2, 1, 2, '2026-04-15 10:30:00', 'Client a validé la demande par téléphone'),

-- Demande 2 : Créée → En cours → Confirmée
(3, 2, 1, '2026-04-14 08:00:00', 'Demande créée automatiquement'),
(4, 2, 4, '2026-04-14 14:15:00', 'Technicien assigné au projet'),
(5, 2, 2, '2026-04-14 16:45:00', 'Préparation terminée, envoi confirmation'),

-- Demande 3 : Créée → Annulée
(6, 3, 1, '2026-04-13 09:00:00', 'Demande créée automatiquement'),
(7, 3, 3, '2026-04-13 11:20:00', 'Client a annulé pour raisons budgétaires'),

-- Demande 4 : Créée → En cours
(8, 4, 1, '2026-04-12 08:00:00', 'Demande créée automatiquement'),
(9, 4, 4, '2026-04-12 13:30:00', 'Analyse des besoins en cours'),

-- Demande 5 : Créée (pas de changement)
(10, 5, 1, '2026-04-11 09:00:00', 'Demande créée automatiquement');

-- Insertion des devis de démonstration
INSERT INTO devis (id, reference, date_devis, montant_ht, montant_tva, montant_ttc, type_devis_id, demande_id, remise_id) VALUES
(1, 'DEV-2026-001', '2026-04-15', 1200.00, 240.00, 1440.00, 1, 1, NULL),
(2, 'DEV-2026-002', '2026-04-14', 2500.00, 500.00, 3000.00, 2, 2, 2),
(3, 'DEV-2026-003', '2026-04-13', 800.00, 160.00, 960.00, 1, 3, 1),
(4, 'DEV-2026-004', '2026-04-12', 3500.00, 700.00, 4200.00, 3, 4, 3);

-- Insertion des remises de démonstration
INSERT INTO remise (id, pourcentage, montant, devis_id) VALUES
(1, 10.00, 144.00, 1),
(2, 15.00, 450.00, 2),
(3, 5.00, 48.00, 3),
(4, 10.00, 420.00, 4);

-- =============================================
-- FIN DU SCRIPT
-- =============================================

SELECT 'Réinitialisation terminée avec succès !' AS message;
SELECT 'Tables vidées et données de démonstration insérées.' AS details;
