package com.example.forage.controller;

import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.forage.service.ChiffreAffaireService;

@Controller
@RequestMapping("/chiffre-affaire")
public class ChiffreAffaireController {
    
    @Autowired
    private ChiffreAffaireService chiffreAffaireService;
    
    @GetMapping
    public String showChiffreAffaire(Model model) {
        BigDecimal chiffreAffaire = chiffreAffaireService.getChiffreAffaireTotal();
        
        model.addAttribute("chiffreAffaire", chiffreAffaire);
        model.addAttribute("nombreDevis", chiffreAffaireService.getNombreDevis());
        
        return "forage/chiffre-affaire/index";
    }
}
