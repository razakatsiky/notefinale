package com.example.notefinale.controller;

import com.example.notefinale.model.Parametre;
import com.example.notefinale.model.Matiere;
import com.example.notefinale.model.Operateur;
import com.example.notefinale.model.Resolution;
import com.example.notefinale.service.ParametreService;
import com.example.notefinale.service.MatiereService;
import com.example.notefinale.service.OperateurService;
import com.example.notefinale.service.ResolutionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/parametres")
public class ParametreController {

    @Autowired
    private ParametreService parametreService;
    
    @Autowired
    private MatiereService matiereService;
    
    @Autowired
    private OperateurService operateurService;
    
    @Autowired
    private ResolutionService resolutionService;

    @GetMapping
    public String listParametres(Model model) {
        model.addAttribute("parametres", parametreService.getAllParametres());
        return "parametres/list";
    }

    @GetMapping("/new")
    public String createParametreForm(Model model) {
        model.addAttribute("parametre", new Parametre());
        model.addAttribute("matieres", matiereService.getAllMatieres());
        model.addAttribute("operateurs", operateurService.getAllOperateurs());
        model.addAttribute("resolutions", resolutionService.getAllResolutions());
        return "parametres/form";
    }

    @PostMapping
    public String saveParametre(@ModelAttribute Parametre parametre) {
        parametreService.saveParametre(parametre);
        return "redirect:/parametres";
    }

    @GetMapping("/edit/{id}")
    public String editParametreForm(@PathVariable Long id, Model model) {
        model.addAttribute("parametre", parametreService.getParametreById(id).orElse(null));
        model.addAttribute("matieres", matiereService.getAllMatieres());
        model.addAttribute("operateurs", operateurService.getAllOperateurs());
        model.addAttribute("resolutions", resolutionService.getAllResolutions());
        return "parametres/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteParametre(@PathVariable Long id) {
        parametreService.deleteParametre(id);
        return "redirect:/parametres";
    }
}
