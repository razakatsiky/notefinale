package com.example.notefinale.controller;

import com.example.notefinale.model.Matiere;
import com.example.notefinale.service.MatiereService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/matieres")
public class MatiereController {

    @Autowired
    private MatiereService matiereService;

    @GetMapping
    public String listMatieres(Model model) {
        model.addAttribute("matieres", matiereService.getAllMatieres());
        return "matieres/list";
    }

    @GetMapping("/new")
    public String createMatiereForm(Model model) {
        model.addAttribute("matiere", new Matiere());
        return "matieres/form";
    }

    @PostMapping
    public String saveMatiere(@ModelAttribute Matiere matiere) {
        matiereService.saveMatiere(matiere);
        return "redirect:/matieres";
    }

    @GetMapping("/edit/{id}")
    public String editMatiereForm(@PathVariable Long id, Model model) {
        model.addAttribute("matiere", matiereService.getMatiereById(id).orElse(null));
        return "matieres/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteMatiere(@PathVariable Long id) {
        matiereService.deleteMatiere(id);
        return "redirect:/matieres";
    }
}
