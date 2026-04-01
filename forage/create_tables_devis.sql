-- Table type_devis (référence)
CREATE TABLE IF NOT EXISTS type_devis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    libelle VARCHAR(50) NOT NULL
);

-- Table devis
CREATE TABLE IF NOT EXISTS devis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    demande_id INT NOT NULL,
    type_devis_id INT NOT NULL,
    date_devis DATE NOT NULL,
    lieu VARCHAR(200),
    client VARCHAR(200),
    statut_id INT NOT NULL DEFAULT 1,
    
    FOREIGN KEY (demande_id) REFERENCES demande(id) ON DELETE CASCADE,
    FOREIGN KEY (type_devis_id) REFERENCES type_devis(id),
    FOREIGN KEY (statut_id) REFERENCES statut(id)
);

-- Table details_devis (lier à devis)
CREATE TABLE IF NOT EXISTS details_devis (
    id INT AUTO_INCREMENT PRIMARY KEY,
    devis_id INT NOT NULL,
    libelle VARCHAR(150) NOT NULL,
    prix_unitaire DECIMAL(10,2) NOT NULL,
    quantite INT NOT NULL DEFAULT 1,
    
    FOREIGN KEY (devis_id) REFERENCES devis(id) ON DELETE CASCADE
);

-- Insertion des types de devis
INSERT INTO type_devis (libelle) VALUES 
('Forage'),
('Installation'),
('Maintenance'),
('Réparation'),
('Consultation')
ON DUPLICATE KEY UPDATE libelle = libelle;

-- Insertion d'un statut par défaut si nécessaire
INSERT INTO statut (id, nom) VALUES (1, 'Devis créé!')
ON DUPLICATE KEY UPDATE nom = nom;
