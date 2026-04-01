package com.example.forage.model;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "devis")
public class Devis {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "demande_id", nullable = false)
    private Demande demande;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "type_devis_id", nullable = false)
    private TypeDevis typeDevis;
    
    @Column(name = "date_devis", nullable = false)
    private Date dateDevis;
    
    @Column(length = 200)
    private String lieu;
    
    @Column(length = 200)
    private String client;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "statut_id", nullable = false)
    private Statut statut;
        
    @OneToMany(mappedBy = "devis", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<DetailsDevis> detailsDevis;
    
    
    public Devis() {}
    
    public Devis(Demande demande, TypeDevis typeDevis, Date dateDevis, 
                 String lieu, String client, Statut statut) {
        this.demande = demande;
        this.typeDevis = typeDevis;
        this.dateDevis = dateDevis;
        this.lieu = lieu;
        this.client = client;
        this.statut = statut;
    }
    
    public BigDecimal getMontantTotalCalcule() {
        if (detailsDevis != null) {
            return detailsDevis.stream()
                .map(detail -> detail.getPrixUnitaire().multiply(BigDecimal.valueOf(detail.getQuantite())))
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        }
        return BigDecimal.ZERO;
    }
    
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Demande getDemande() { return demande; }
    public void setDemande(Demande demande) { this.demande = demande; }
    
    public TypeDevis getTypeDevis() { return typeDevis; }
    public void setTypeDevis(TypeDevis typeDevis) { this.typeDevis = typeDevis; }
    
    public Date getDateDevis() { return dateDevis; }
    public void setDateDevis(Date dateDevis) { this.dateDevis = dateDevis; }
    
    public String getLieu() { return lieu; }
    public void setLieu(String lieu) { this.lieu = lieu; }
    
    public String getClient() { return client; }
    public void setClient(String client) { this.client = client; }
    
    public Statut getStatut() { return statut; }
    public void setStatut(Statut statut) { this.statut = statut; }
        
    public List<DetailsDevis> getDetailsDevis() { return detailsDevis; }
    public void setDetailsDevis(List<DetailsDevis> detailsDevis) { this.detailsDevis = detailsDevis; }
    
    public void addDetail(DetailsDevis detail) {
        detailsDevis.add(detail);
        detail.setDevis(this);
    }
    
    public void removeDetail(DetailsDevis detail) {
        detailsDevis.remove(detail);
        detail.setDevis(null);
    }
    
}
