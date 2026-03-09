package com.example.notefinale.controller;

import com.example.notefinale.model.Note;
import com.example.notefinale.model.Candidat;
import com.example.notefinale.model.Matiere;
import com.example.notefinale.model.Correcteur;
import com.example.notefinale.service.CandidatService;
import com.example.notefinale.service.MatiereService;
import com.example.notefinale.service.CorrecteurService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.util.Optional;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import org.springframework.transaction.annotation.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/notes-crud")
@Transactional
public class NoteCrudController {

    private static final Logger logger = LoggerFactory.getLogger(NoteCrudController.class);

    @PersistenceContext
    private EntityManager entityManager;
    
    @Autowired
    private CandidatService candidatService;
    
    @Autowired
    private MatiereService matiereService;
    
    @Autowired
    private CorrecteurService correcteurService;

    @GetMapping
    public String listNotes(Model model) {
        try {
            Query query = entityManager.createQuery("SELECT n FROM Note n", Note.class);
            List<Note> notes = query.getResultList();
            model.addAttribute("notes", notes);
            return "notes-crud/list";
        } catch (Exception e) {
            model.addAttribute("error", "Erreur lors du chargement des notes: " + e.getMessage());
            return "error";
        }
    }

    @GetMapping("/new")
    public String createNoteForm(Model model) {
        model.addAttribute("note", new Note());
        model.addAttribute("candidats", candidatService.getAllCandidats());
        model.addAttribute("matieres", matiereService.getAllMatieres());
        model.addAttribute("correcteurs", correcteurService.getAllCorrecteurs());
        return "notes-crud/form";
    }

    @PostMapping
    public String saveNote(
            @RequestParam(required = false) Long id,
            @RequestParam Long candidatId,
            @RequestParam Long matiereId,
            @RequestParam Long correcteurId,
            @RequestParam Double noteValue,
            RedirectAttributes redirectAttributes) {
        
        try {
            logger.info("Reçu: id={}, candidatId={}, matiereId={}, correcteurId={}, noteValue={}", 
                id, candidatId, matiereId, correcteurId, noteValue);
            
            if (id != null) {
                // Modification
                logger.info("Modification de la note ID: {}", id);
                Note existingNote = entityManager.find(Note.class, id);
                if (existingNote != null) {
                    existingNote.setNote(noteValue);
                    
                    Candidat candidat = entityManager.find(Candidat.class, candidatId);
                    Matiere matiere = entityManager.find(Matiere.class, matiereId);
                    Correcteur correcteur = entityManager.find(Correcteur.class, correcteurId);
                    
                    existingNote.setCandidat(candidat);
                    existingNote.setMatiere(matiere);
                    existingNote.setCorrecteur(correcteur);
                    
                    logger.info("Note modifiée avec succès");
                } else {
                    logger.warn("Note ID {} non trouvée", id);
                }
            } else {
                // Création
                logger.info("Création d'une nouvelle note");
                Note newNote = new Note();
                newNote.setNote(noteValue);
                
                Candidat candidat = entityManager.find(Candidat.class, candidatId);
                Matiere matiere = entityManager.find(Matiere.class, matiereId);
                Correcteur correcteur = entityManager.find(Correcteur.class, correcteurId);
                
                newNote.setCandidat(candidat);
                newNote.setMatiere(matiere);
                newNote.setCorrecteur(correcteur);
                
                entityManager.persist(newNote);
                logger.info("Note créée avec succès");
            }
            redirectAttributes.addFlashAttribute("success", "Note enregistrée avec succès");
        } catch (RuntimeException e) {
            logger.error("Erreur: {}", e.getMessage(), e);
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/notes-crud";
    }

    @GetMapping("/edit/{id}")
    public String editNoteForm(@PathVariable Long id, Model model) {
        Note note = entityManager.find(Note.class, id);
        if (note == null) {
            return "redirect:/notes-crud";
        }
        model.addAttribute("note", note);
        model.addAttribute("candidats", candidatService.getAllCandidats());
        model.addAttribute("matieres", matiereService.getAllMatieres());
        model.addAttribute("correcteurs", correcteurService.getAllCorrecteurs());
        return "notes-crud/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteNote(@PathVariable Long id) {
        Note note = entityManager.find(Note.class, id);
        if (note != null) {
            entityManager.remove(note);
        }
        return "redirect:/notes-crud";
    }
}
