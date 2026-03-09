package com.example.notefinale.controller;

import com.example.notefinale.model.Correcteur;
import com.example.notefinale.service.CorrecteurService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/correcteurs")
public class CorrecteurController {

    @Autowired
    private CorrecteurService correcteurService;

    @GetMapping
    public String listCorrecteurs(Model model) {
        model.addAttribute("correcteurs", correcteurService.getAllCorrecteurs());
        return "correcteurs/list";
    }

    @GetMapping("/new")
    public String createCorrecteurForm(Model model) {
        model.addAttribute("correcteur", new Correcteur());
        return "correcteurs/form";
    }

    @PostMapping
    public String saveCorrecteur(@ModelAttribute Correcteur correcteur) {
        correcteurService.saveCorrecteur(correcteur);
        return "redirect:/correcteurs";
    }

    @GetMapping("/edit/{id}")
    public String editCorrecteurForm(@PathVariable Long id, Model model) {
        model.addAttribute("correcteur", correcteurService.getCorrecteurById(id).orElse(null));
        return "correcteurs/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteCorrecteur(@PathVariable Long id) {
        correcteurService.deleteCorrecteur(id);
        return "redirect:/correcteurs";
    }
}
