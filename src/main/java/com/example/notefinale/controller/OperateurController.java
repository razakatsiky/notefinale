package com.example.notefinale.controller;

import com.example.notefinale.model.Operateur;
import com.example.notefinale.service.OperateurService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/operateurs")
public class OperateurController {

    @Autowired
    private OperateurService operateurService;

    @GetMapping
    public String listOperateurs(Model model) {
        model.addAttribute("operateurs", operateurService.getAllOperateurs());
        return "operateurs/list";
    }

    @GetMapping("/new")
    public String createOperateurForm(Model model) {
        model.addAttribute("operateur", new Operateur());
        return "operateurs/form";
    }

    @PostMapping
    public String saveOperateur(@RequestParam("operateurValue") String operateurValue, 
                                @RequestParam(value = "id", required = false) Long id) {
        Operateur operateur = new Operateur();
        operateur.setOperateur(operateurValue);
        if (id != null) {
            operateur.setId(id);
        }
        operateurService.saveOperateur(operateur);
        return "redirect:/operateurs";
    }

    @GetMapping("/edit/{id}")
    public String editOperateurForm(@PathVariable Long id, Model model) {
        model.addAttribute("operateur", operateurService.getOperateurById(id).orElse(null));
        return "operateurs/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteOperateur(@PathVariable Long id) {
        operateurService.deleteOperateur(id);
        return "redirect:/operateurs";
    }
}
