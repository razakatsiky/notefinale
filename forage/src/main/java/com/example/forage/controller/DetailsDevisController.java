package com.example.forage.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.forage.model.DetailsDevis;
import com.example.forage.service.DetailsDevisService;

@Controller
@RequestMapping("/details-devis")
public class DetailsDevisController {
    
    @Autowired
    private DetailsDevisService detailsDevisService;
    
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            DetailsDevis detail = detailsDevisService.getDetailsDevisById(id);

            if (detail == null) {
                throw new RuntimeException("Détail devis non trouvé");
            }

            model.addAttribute("detail", detail);
            return "details-devis/form";

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Détail devis non trouvé");
            return "redirect:/devis";
        }
    }
    
    @PostMapping("/update/{id}")
    public String updateDetail(@PathVariable Long id, DetailsDevis detail, RedirectAttributes redirectAttributes) {
        try {
            DetailsDevis updatedDetail = detailsDevisService.updateDetailsDevis(id, detail);

            redirectAttributes.addFlashAttribute("successMessage", "Détail mis à jour avec succès");

            return "redirect:/devis/details/" + updatedDetail.getDevis().getId();

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur lors de la mise à jour du détail");
            return "redirect:/devis";
        }
    }
    
    @GetMapping("/delete/{id}")
    public String deleteDetail(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            DetailsDevis detail = detailsDevisService.getDetailsDevisById(id);

            if (detail == null) {
                throw new RuntimeException("Détail devis non trouvé");
            }

            Long devisId = detail.getDevis().getId();

            detailsDevisService.deleteDetailsDevis(id);

            redirectAttributes.addFlashAttribute("successMessage", "Détail supprimé avec succès");

            return "redirect:/devis/details/" + devisId;

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur lors de la suppression du détail");
            return "redirect:/devis";
        }
    }
}