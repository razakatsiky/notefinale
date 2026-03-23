package com.example.forage.model;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "client")
public class Client {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "nom", nullable = false, length = 100)
    private String nom;
    
    @Column(name = "contact", length = 100)
    private String contact;
    
    @OneToMany(mappedBy = "client", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Demande> demandes;
    

    public Client() {}
    
    public Client(String nom, String contact) {
        this.nom = nom;
        this.contact = contact;
    }
    
    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    
    public String getContact() { return contact; }
    public void setContact(String contact) { this.contact = contact; }
    
    public List<Demande> getDemandes() { return demandes; }
    public void setDemandes(List<Demande> demandes) { this.demandes = demandes; }
}
