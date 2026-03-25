package com.example.forage.model;

import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "demande_statut")
public class DemandeStatut {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "demande_id", nullable = false)
    private Demande demande;
    
    @ManyToOne
    @JoinColumn(name = "statut_id", nullable = false)
    private Statut statut;
    
    @Column(name = "date_statut", nullable = false)
    private LocalDateTime dateStatut;
    
    public DemandeStatut() {}
    
    public DemandeStatut(Demande demande, Statut statut, LocalDateTime dateStatut) {
        this.demande = demande;
        this.statut = statut;
        this.dateStatut = dateStatut;
    }
    
    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Demande getDemande() { return demande; }
    public void setDemande(Demande demande) { this.demande = demande; }
    
    public Statut getStatut() { return statut; }
    public void setStatut(Statut statut) { this.statut = statut; }
    
    public LocalDateTime getDateStatut() { return dateStatut; }
    public void setDateStatut(LocalDateTime dateStatut) { this.dateStatut = dateStatut; }
}
