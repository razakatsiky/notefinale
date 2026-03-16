package com.example.notefinale.service;

import com.example.notefinale.model.*;
import com.example.notefinale.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import java.util.List;
import java.util.Optional;
import java.util.ArrayList;
import java.util.stream.Collectors;

@Service
public class NoteService {

    private static final Logger logger = LoggerFactory.getLogger(NoteService.class);

    @Autowired
    private NoteRepository noteRepository;
    
    @Autowired
    private ParametreRepository parametreRepository;
    
    @Autowired
    private CandidatRepository candidatRepository;
    
    @Autowired
    private MatiereRepository matiereRepository;
    
    @Autowired
    private CorrecteurRepository correcteurRepository;
    
    @PersistenceContext
    private EntityManager entityManager;

    public Double calculerNoteFinale(Long candidatId, Long matiereId) {
        logger.info("Calcul note finale pour candidat {} et matiere {}", candidatId, matiereId);
        
        List<Note> notes = noteRepository.findByCandidatAndMatiere(candidatId, matiereId);
        
        if (notes.isEmpty()) {
            logger.warn("Aucune note trouvée");
            return 0.0;
        }
        
        List<Double> valeursNotes = notes.stream()
                .map(Note::getNote)
                .collect(Collectors.toList());
        
        logger.info("Notes trouvées: {}", valeursNotes);
        
        if (valeursNotes.size() == 1) {
            logger.info("Une seule note trouvée: {}", valeursNotes.get(0));
            return valeursNotes.get(0);
        }
        
        if (toutesNotesIdentiques(valeursNotes)) {
            logger.info("Toutes les notes sont identiques: {}", valeursNotes.get(0));
            return valeursNotes.get(0);
        }
        
        double differenceTotale = calculerDifferenceTotale(valeursNotes);
        logger.info("Différence totale calculée: {}", differenceTotale);
        
        List<Parametre> parametres = parametreRepository.findByMatiereId(matiereId);
        logger.info("Paramètres trouvés pour matière {}: {}", matiereId, parametres.size());
        
        if (parametres.isEmpty()) {
            logger.info("Aucun paramètre trouvé, retour de la moyenne");
            return valeursNotes.stream().mapToDouble(Double::doubleValue).average().orElse(valeursNotes.get(0));
        }
        
        // Logique complète : trouver le paramètre éligible le plus proche
        Parametre parametreChoisi = trouverParametreEligibleLePlusProche(parametres, differenceTotale);
        
        if (parametreChoisi == null) {
            logger.info("Aucun paramètre éligible trouvé, retour de la moyenne par défaut");
            return valeursNotes.stream().mapToDouble(Double::doubleValue).average().orElse(valeursNotes.get(0));
        }
        
        logger.info("Paramètre choisi: différence={}, résolution={}", 
            parametreChoisi.getDifference(), 
            parametreChoisi.getResolution().getNom());
        
        Double resultat = appliquerResolution(valeursNotes, parametreChoisi.getResolution().getNom());
        logger.info("Résultat final: {}", resultat);
        return resultat;
    }
    
    private boolean toutesNotesIdentiques(List<Double> notes) {
        if (notes.isEmpty()) return true;
        double premiereNote = notes.get(0);
        return notes.stream().allMatch(note -> note == premiereNote);
    }
    
    private Parametre trouverParametreEligibleLePlusProche(List<Parametre> parametres, double differenceTotale) {
        List<Parametre> parametresEligibles = new ArrayList<>();
        
        logger.info("Recherche des paramètres éligibles pour différence totale: {}", differenceTotale);
        
        // Étape 1 : Filtrer les paramètres éligibles
        for (Parametre parametre : parametres) {
            String operateur = parametre.getOperateur().getOperateur();
            int differenceParametre = parametre.getDifference();
            
            boolean condition = evaluerCondition(differenceTotale, operateur, differenceParametre);
            
            logger.info("Test paramètre différence={} avec opérateur '{}': {}", 
                differenceParametre, operateur, condition ? "ÉLIGIBLE" : "non éligible");
            
            if (condition) {
                parametresEligibles.add(parametre);
            }
        }
        
        if (parametresEligibles.isEmpty()) {
            logger.info("Aucun paramètre éligible trouvé");
            return null;
        }
        
        logger.info("Paramètres éligibles trouvés: {}", parametresEligibles.size());
        
        // Étape 2 : Parmi les éligibles, trouver le plus proche
        Parametre parametreLePlusProche = parametresEligibles.get(0);
        double ecartMin = Math.abs(parametresEligibles.get(0).getDifference() - differenceTotale);
        
        for (Parametre parametre : parametresEligibles) {
            double ecartActuel = Math.abs(parametre.getDifference() - differenceTotale);
            
            logger.info("Paramètre différence={}, écart={}", parametre.getDifference(), ecartActuel);
            
            if (ecartActuel < ecartMin) {
                ecartMin = ecartActuel;
                parametreLePlusProche = parametre;
                logger.info("Nouvel écart minimum trouvé: {} pour le paramètre {}", ecartMin, parametre.getDifference());
            } else if (ecartActuel == ecartMin && parametre.getDifference() < parametreLePlusProche.getDifference()) {
                parametreLePlusProche = parametre;
                logger.info("Égalité d'écart, sélection du paramètre le plus petit: {}", parametre.getDifference());
            }
        }
        
        logger.info("Paramètre le plus proche sélectionné: différence={}", parametreLePlusProche.getDifference());
        return parametreLePlusProche;
    }
    
    private Double trouverNoteLaPlusProche(List<Double> notes, int differenceParametre) {
        Double noteLaPlusProche = notes.get(0);
        double ecartMin = Math.abs(notes.get(0) - differenceParametre);
        
        logger.info("Recherche de la note la plus proche de {}", differenceParametre);
        
        for (int i = 0; i < notes.size(); i++) {
            Double noteActuelle = notes.get(i);
            double ecartActuel = Math.abs(noteActuelle - differenceParametre);
            
            logger.info("Note: {}, écart: {}", noteActuelle, ecartActuel);
            
            if (ecartActuel < ecartMin) {
                ecartMin = ecartActuel;
                noteLaPlusProche = noteActuelle;
                logger.info("Nouvel écart minimum trouvé: {} pour la note {}", ecartMin, noteLaPlusProche);
            } else if (ecartActuel == ecartMin && noteActuelle < noteLaPlusProche) {
                noteLaPlusProche = noteActuelle;
                logger.info("Égalité d'écart, sélection de la note la plus petite: {}", noteLaPlusProche);
            }
        }
        
        logger.info("Note finale sélectionnée: {}", noteLaPlusProche);
        return noteLaPlusProche;
    }
    
    private boolean evaluerCondition(double differenceTotale, String operateur, int differenceParametre) {
        switch (operateur) {
            case ">":
                return differenceTotale > differenceParametre;
            case "<":
                return differenceTotale < differenceParametre;
            case ">=":
                return differenceTotale >= differenceParametre;
            case "<=":
                return differenceTotale <= differenceParametre;
            case "==":
                return differenceTotale == differenceParametre;
            default:
                return false;
        }
    }
    
    private Double appliquerResolution(List<Double> notes, String resolutionNom) {
        switch (resolutionNom.toLowerCase()) {
            case "plus petite":
            case "petit":
                return notes.stream().min(Double::compare).orElse(notes.get(0));
            case "plus grande":
            case "grand":
                return notes.stream().max(Double::compare).orElse(notes.get(0));
            case "moyenne":
                return notes.stream().mapToDouble(Double::doubleValue).average().orElse(notes.get(0));
            default:
                return notes.get(0);
        }
    }
    
    private double calculerDifferenceTotale(List<Double> notes) {
        double differenceTotale = 0;
        for (int i = 0; i < notes.size(); i++) {
            for (int j = i + 1; j < notes.size(); j++) {
                differenceTotale += Math.abs(notes.get(i) - notes.get(j));
            }
        }
        return differenceTotale;
    }
    
    public List<Note> getNotesByCandidat(Long candidatId) {
        return noteRepository.findByCandidatId(candidatId);
    }
    
    public List<Note> getAllNotes() {
        try {
            javax.persistence.Query query = entityManager.createQuery("SELECT n FROM Note n", Note.class);
            return query.getResultList();
        } catch (Exception e) {
            logger.error("Erreur dans getAllNotes avec EntityManager: {}", e.getMessage(), e);
            throw new RuntimeException("Erreur lors de la récupération des notes", e);
        }
    }
    
    public long countNotes() {
        return noteRepository.count();
    }
    
    public Optional<Note> getNoteById(Long id) {
        return noteRepository.findById(id);
    }
    
    public Note saveNote(Note note) {
        // Pour la modification, on autorise la mise à jour de la note existante
        if (note.getId() != null) {
            // C'est une modification, on récupère la note existante
            Note existingNote = noteRepository.findById(note.getId()).orElse(null);
            if (existingNote != null) {
                // On met à jour seulement les champs nécessaires
                existingNote.setNote(note.getNote());
                if (note.getCandidat() != null && note.getCandidat().getId() != null) {
                    existingNote.setCandidat(candidatRepository.findById(note.getCandidat().getId()).orElse(null));
                }
                if (note.getMatiere() != null && note.getMatiere().getId() != null) {
                    existingNote.setMatiere(matiereRepository.findById(note.getMatiere().getId()).orElse(null));
                }
                if (note.getCorrecteur() != null && note.getCorrecteur().getId() != null) {
                    existingNote.setCorrecteur(correcteurRepository.findById(note.getCorrecteur().getId()).orElse(null));
                }
                return noteRepository.save(existingNote);
            }
        }
        
        // Pour la création, on vérifie si le correcteur a déjà donné une note pour cette matière à ce candidat
        if (note.getCandidat() != null && note.getMatiere() != null && note.getCorrecteur() != null) {
            List<Note> existingNotes = noteRepository.findByCandidatAndMatiere(note.getCandidat().getId(), note.getMatiere().getId());
            boolean alreadyExists = existingNotes.stream()
                .anyMatch(existingNote -> existingNote.getCorrecteur().getId().equals(note.getCorrecteur().getId()));
            
            if (alreadyExists) {
                throw new RuntimeException("Ce correcteur a déjà donné une note pour cette matière à ce candidat");
            }
        }
        
        // S'assurer que les relations sont bien établies
        if (note.getCandidat() != null && note.getCandidat().getId() != null) {
            note.setCandidat(candidatRepository.findById(note.getCandidat().getId()).orElse(null));
        }
        if (note.getMatiere() != null && note.getMatiere().getId() != null) {
            note.setMatiere(matiereRepository.findById(note.getMatiere().getId()).orElse(null));
        }
        if (note.getCorrecteur() != null && note.getCorrecteur().getId() != null) {
            note.setCorrecteur(correcteurRepository.findById(note.getCorrecteur().getId()).orElse(null));
        }
        return noteRepository.save(note);
    }
    
    public void deleteNote(Long id) {
        noteRepository.deleteById(id);
    }
}
