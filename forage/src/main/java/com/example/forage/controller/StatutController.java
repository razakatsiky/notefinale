package com.example.forage.controller;

import com.example.forage.model.Statut;
import com.example.forage.service.StatutService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/forage/statuts")
public class StatutController {
    
    @Autowired
    private StatutService statutService;
    
    @GetMapping
    public String listStatuts(Model model) {
        List<Statut> statuts = statutService.getAllStatuts();
        model.addAttribute("statuts", statuts);
        model.addAttribute("title", "Gestion des Statuts");
        return "forage/statuts/list";
    }
    
    @GetMapping("/new")
    public String createStatutForm(Model model) {
        model.addAttribute("statut", new Statut());
        model.addAttribute("title", "Ajouter un Statut");
        return "forage/statuts/form";
    }
    
    @PostMapping
    public String saveStatut(@ModelAttribute Statut statut, RedirectAttributes redirectAttributes) {
        try {
            // Vérifier si le statut existe déjà
            Optional<Statut> existingStatut = statutService.getStatutByNom(statut.getNom());
            if (existingStatut.isPresent()) {
                redirectAttributes.addFlashAttribute("error", "Ce statut existe déjà !");
                return "redirect:/forage/statuts/new";
            }
            
            statutService.saveStatut(statut);
            redirectAttributes.addFlashAttribute("success", "Statut ajouté avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/forage/statuts";
    }
    
    @GetMapping("/edit/{id}")
    public String editStatutForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Optional<Statut> statut = statutService.getStatutById(id);
            if (statut.isPresent()) {
                model.addAttribute("statut", statut.get());
                model.addAttribute("title", "Modifier un Statut");
                return "forage/statuts/form";
            } else {
                redirectAttributes.addFlashAttribute("error", "Statut non trouvé");
                return "redirect:/forage/statuts";
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
            return "redirect:/forage/statuts";
        }
    }
    
    @PostMapping("/update/{id}")
    public String updateStatut(@PathVariable Long id, @ModelAttribute Statut statut, RedirectAttributes redirectAttributes) {
        try {
            Optional<Statut> existingStatut = statutService.getStatutById(id);
            if (existingStatut.isPresent()) {
                // Vérifier si un autre statut avec le même nom existe
                Optional<Statut> statutWithSameName = statutService.getStatutByNom(statut.getNom());
                if (statutWithSameName.isPresent() && !statutWithSameName.get().getId().equals(id)) {
                    redirectAttributes.addFlashAttribute("error", "Un autre statut avec ce nom existe déjà !");
                    return "redirect:/forage/statuts/edit/" + id;
                }
                
                Statut statutToUpdate = existingStatut.get();
                statutToUpdate.setNom(statut.getNom());
                statutService.saveStatut(statutToUpdate);
                redirectAttributes.addFlashAttribute("success", "Statut modifié avec succès");
            } else {
                redirectAttributes.addFlashAttribute("error", "Statut non trouvé");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/forage/statuts";
    }
    
    @GetMapping("/delete/{id}")
    public String deleteStatut(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            Optional<Statut> statut = statutService.getStatutById(id);
            if (statut.isPresent()) {
                statutService.deleteStatut(id);
                redirectAttributes.addFlashAttribute("success", "Statut supprimé avec succès");
            } else {
                redirectAttributes.addFlashAttribute("error", "Statut non trouvé");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
        }
        return "redirect:/forage/statuts";
    }
}
