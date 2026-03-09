package com.example.notefinale.controller;

import com.example.notefinale.model.Candidat;
import com.example.notefinale.model.Matiere;
import com.example.notefinale.model.Note;
import com.example.notefinale.service.CandidatService;
import com.example.notefinale.service.MatiereService;
import com.example.notefinale.service.NoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
public class NoteController {

    @Autowired
    private NoteService noteService;
    
    @Autowired
    private CandidatService candidatService;
    
    @Autowired
    private MatiereService matiereService;

    @GetMapping("/")
    public String index() {
        return "index";
    }

    @GetMapping("/calculer-note")
    public String afficherFormulaire(Model model) {
        List<Candidat> candidats = candidatService.getAllCandidats();
        List<Matiere> matieres = matiereService.getAllMatieres();
        
        model.addAttribute("candidats", candidats);
        model.addAttribute("matieres", matieres);
        
        return "calculer-note";
    }

    @PostMapping("/calculer-note")
    public String calculerNote(@RequestParam Long candidatId, 
                              @RequestParam Long matiereId, 
                              Model model) {
        try {
            Double noteFinale = noteService.calculerNoteFinale(candidatId, matiereId);
            List<Note> notes = noteService.getNotesByCandidat(candidatId);
            
            Candidat candidat = candidatService.getCandidatById(candidatId).orElse(null);
            Matiere matiere = matiereService.getMatiereById(matiereId).orElse(null);
            
            model.addAttribute("noteFinale", noteFinale);
            model.addAttribute("notes", notes);
            model.addAttribute("candidat", candidat);
            model.addAttribute("matiere", matiere);
            model.addAttribute("success", true);
            
            List<Candidat> candidats = candidatService.getAllCandidats();
            List<Matiere> matieres = matiereService.getAllMatieres();
            model.addAttribute("candidats", candidats);
            model.addAttribute("matieres", matieres);
            
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            
            List<Candidat> candidats = candidatService.getAllCandidats();
            List<Matiere> matieres = matiereService.getAllMatieres();
            model.addAttribute("candidats", candidats);
            model.addAttribute("matieres", matieres);
        }
        
        return "calculer-note";
    }
}
