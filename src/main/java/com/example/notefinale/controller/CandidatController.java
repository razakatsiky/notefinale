package com.example.notefinale.controller;

import com.example.notefinale.model.Candidat;
import com.example.notefinale.service.CandidatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/candidats")
public class CandidatController {

    @Autowired
    private CandidatService candidatService;

    @GetMapping
    public String listCandidats(Model model) {
        model.addAttribute("candidats", candidatService.getAllCandidats());
        return "candidats/list";
    }

    @GetMapping("/new")
    public String createCandidatForm(Model model) {
        model.addAttribute("candidat", new Candidat());
        return "candidats/form";
    }

    @PostMapping
    public String saveCandidat(@ModelAttribute Candidat candidat) {
        candidatService.saveCandidat(candidat);
        return "redirect:/candidats";
    }

    @GetMapping("/edit/{id}")
    public String editCandidatForm(@PathVariable Long id, Model model) {
        model.addAttribute("candidat", candidatService.getCandidatById(id).orElse(null));
        return "candidats/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteCandidat(@PathVariable Long id) {
        candidatService.deleteCandidat(id);
        return "redirect:/candidats";
    }
}
