package com.example.notefinale.model;

import javax.persistence.*;

@Entity
@Table(name = "note")
public class Note {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "candidat_id")
    private Candidat candidat;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "matiere_id")
    private Matiere matiere;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "correcteur_id")
    private Correcteur correcteur;
    
    @Column(nullable = false)
    private Double note;

    public Note() {}

    public Note(Candidat candidat, Matiere matiere, Correcteur correcteur, Double note) {
        this.candidat = candidat;
        this.matiere = matiere;
        this.correcteur = correcteur;
        this.note = note;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Candidat getCandidat() {
        return candidat;
    }

    public void setCandidat(Candidat candidat) {
        this.candidat = candidat;
    }

    public Matiere getMatiere() {
        return matiere;
    }

    public void setMatiere(Matiere matiere) {
        this.matiere = matiere;
    }

    public Correcteur getCorrecteur() {
        return correcteur;
    }

    public void setCorrecteur(Correcteur correcteur) {
        this.correcteur = correcteur;
    }

    public Double getNote() {
        return note;
    }

    public void setNote(Double note) {
        this.note = note;
    }
}
