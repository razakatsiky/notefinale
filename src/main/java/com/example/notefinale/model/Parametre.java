package com.example.notefinale.model;

import javax.persistence.*;

@Entity
@Table(name = "parametre")
public class Parametre {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "id_matiere", nullable = false)
    private Matiere matiere;
    
    @ManyToOne
    @JoinColumn(name = "id_operateur", nullable = false)
    private Operateur operateur;
    
    @ManyToOne
    @JoinColumn(name = "id_resolution", nullable = false)
    private Resolution resolution;
    
    @Column(nullable = false)
    private Integer difference;

    public Parametre() {}

    public Parametre(Matiere matiere, Operateur operateur, Resolution resolution, Integer difference) {
        this.matiere = matiere;
        this.operateur = operateur;
        this.resolution = resolution;
        this.difference = difference;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Matiere getMatiere() {
        return matiere;
    }

    public void setMatiere(Matiere matiere) {
        this.matiere = matiere;
    }

    public Operateur getOperateur() {
        return operateur;
    }

    public void setOperateur(Operateur operateur) {
        this.operateur = operateur;
    }

    public Resolution getResolution() {
        return resolution;
    }

    public void setResolution(Resolution resolution) {
        this.resolution = resolution;
    }

    public Integer getDifference() {
        return difference;
    }

    public void setDifference(Integer difference) {
        this.difference = difference;
    }
}
