package com.example.forage.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "parametre_remise")
public class ParametreRemise {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "seuil_prix", nullable = false, precision = 15, scale = 2)
    private BigDecimal seuilPrix;

    @Column(name = "taux_remise", nullable = false, precision = 5, scale = 2)
    private BigDecimal tauxRemise;

    @Column(nullable = false, length = 10)
    private String operateur;

    @Column(nullable = false)
    private Boolean actif;

    @Column(name = "date_creation", updatable = false)
    private LocalDateTime dateCreation;

    @Column(name = "date_modification")
    private LocalDateTime dateModification;

    public ParametreRemise() {
        this.actif = true;
        this.dateCreation = LocalDateTime.now();
        this.dateModification = LocalDateTime.now();
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public BigDecimal getSeuilPrix() {
        return seuilPrix;
    }

    public void setSeuilPrix(BigDecimal seuilPrix) {
        this.seuilPrix = seuilPrix;
    }

    public BigDecimal getTauxRemise() {
        return tauxRemise;
    }

    public void setTauxRemise(BigDecimal tauxRemise) {
        this.tauxRemise = tauxRemise;
    }

    public String getOperateur() {
        return operateur;
    }

    public void setOperateur(String operateur) {
        this.operateur = operateur;
    }

    public Boolean getActif() {
        return actif;
    }

    public void setActif(Boolean actif) {
        this.actif = actif;
    }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }

    public LocalDateTime getDateModification() {
        return dateModification;
    }

    public void setDateModification(LocalDateTime dateModification) {
        this.dateModification = dateModification;
    }

    @javax.persistence.PreUpdate
    public void preUpdate() {
        this.dateModification = LocalDateTime.now();
    }

 
    public boolean isEligible(BigDecimal prix) {
        if (prix == null || !actif) {
            return false;
        }

        int comparison = prix.compareTo(seuilPrix);
        
        switch (operateur) {
            case ">=":
                return comparison >= 0;
            case ">":
                return comparison > 0;
            case "<=":
                return comparison <= 0;
            case "<":
                return comparison < 0;
            default:
                return false;
        }
    }


    public BigDecimal calculerRemise(BigDecimal prix) {
        if (!isEligible(prix)) {
            return BigDecimal.ZERO;
        }
        
        return prix.multiply(tauxRemise)
                   .divide(BigDecimal.valueOf(100), 2, BigDecimal.ROUND_HALF_UP);
    }


    public BigDecimal calculerPrixApresRemise(BigDecimal prix) {
        BigDecimal remise = calculerRemise(prix);
        return prix.subtract(remise);
    }
}
