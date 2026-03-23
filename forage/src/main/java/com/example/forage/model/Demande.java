package com.example.forage.model;

import java.time.LocalDate;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.springframework.format.annotation.DateTimeFormat;

@Entity
@Table(name = "demande")
public class Demande {
     
    @Id
    
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "client_id", nullable = false)
    private Client client;
    
    @Column(name = "date_demande", nullable = false)
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate dateDemande;
    
    @Column(name = "lieu", nullable = false, length = 150)
    private String lieu;
    
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;
    
    
    
    public Demande() {}
    
    public Demande(Client client, LocalDate dateDemande, String lieu, String description) {
        this.client = client;
        this.dateDemande = dateDemande;
        this.lieu = lieu;
        this.description = description;
    }
    
    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Client getClient() { return client; }
    public void setClient(Client client) { this.client = client; }
    
    public LocalDate getDateDemande() { return dateDemande; }
    public void setDateDemande(LocalDate dateDemande) { this.dateDemande = dateDemande; }
    
    public String getLieu() { return lieu; }
    public void setLieu(String lieu) { this.lieu = lieu; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
}
