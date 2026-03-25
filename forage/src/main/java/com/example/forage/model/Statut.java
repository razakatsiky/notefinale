package com.example.forage.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "statut")
public class Statut {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "nom", nullable = false, length = 50)
    private String nom;
    
    // Champ pour compatibilité avec la colonne libelle si elle existe encore
    @Column(name = "libelle", nullable = true, length = 100)
    private String libelle;
    
    public Statut() {}
    
    public Statut(String nom) {
        this.nom = nom;
        this.libelle = nom; // Initialiser libelle avec la même valeur
    }
    
    public Statut(String nom, String libelle) {
        this.nom = nom;
        this.libelle = libelle;
    }
    
    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    
    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }
}
