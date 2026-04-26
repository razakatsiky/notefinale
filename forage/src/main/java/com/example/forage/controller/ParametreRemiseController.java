package com.example.forage.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.forage.model.ParametreRemise;
import com.example.forage.service.ParametreRemiseService;

@Controller
@RequestMapping("/remises")
public class ParametreRemiseController {

    @Autowired
    private ParametreRemiseService parametreRemiseService;


    @GetMapping("/active")
    @ResponseBody
    public ResponseEntity<ParametreRemise> getActiveRemise() {
        List<ParametreRemise> actives = parametreRemiseService.findParametreRemisesActives();
        if (!actives.isEmpty()) {
            return ResponseEntity.ok(actives.get(0)); // Retourne le premier paramètre actif
        }
        return ResponseEntity.ok(null);
    }

 
    @GetMapping
    public String listParametreRemises(Model model) {
        List<ParametreRemise> parametres = parametreRemiseService.findAllParametreRemises();
        model.addAttribute("parametres", parametres);
        return "remises/list";
    }

   
    @GetMapping("/form")
    public String showForm(@RequestParam(required = false) Long id, Model model) {
        ParametreRemise parametre;
        if (id != null) {
            parametre = parametreRemiseService.findParametreRemiseById(id);
        } else {
            parametre = new ParametreRemise();
        }
        model.addAttribute("parametre", parametre);
        return "remises/form";
    }

    @PostMapping("/save")
    public String saveParametreRemise(ParametreRemise parametre) {
        parametreRemiseService.saveParametreRemise(parametre);
        return "redirect:/remises";
    }

 
    @PostMapping("/toggle/{id}")
    public String toggleActif(@PathVariable Long id) {
        parametreRemiseService.toggleActif(id);
        return "redirect:/remises";
    }


    @PostMapping("/delete/{id}")
    public String deleteParametreRemise(@PathVariable Long id) {
        parametreRemiseService.deleteParametreRemise(id);
        return "redirect:/remises";
    }
}
