package com.example.forage.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.forage.model.TypeDevis;
import com.example.forage.service.TypeDevisService;

@Controller
@RequestMapping("/type-devis")
public class TypeDevisController {
    
    @Autowired
    private TypeDevisService typeDevisService;
    
    @GetMapping
    public String listTypeDevis(Model model) {
        List<TypeDevis> typeDevis = typeDevisService.getAllTypeDevis();
        model.addAttribute("typeDevis", typeDevis);
        return "forage/type-devis/list";
    }
    
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("typeDevis", new TypeDevis());
        return "forage/type-devis/form";
    }
    
    @PostMapping("/save")
    public String saveTypeDevis(TypeDevis typeDevis, RedirectAttributes redirectAttributes) {
        try {
            typeDevisService.saveTypeDevis(typeDevis);
            redirectAttributes.addFlashAttribute("successMessage", "Type de devis créé avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur lors de la création du type de devis");
        }
        return "redirect:/type-devis";
    }
    
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            TypeDevis typeDevis = typeDevisService.getTypeDevisById(id)
                .orElseThrow(() -> new RuntimeException("Type devis non trouvé"));
            model.addAttribute("typeDevis", typeDevis);
            return "forage/type-devis/form";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Type de devis non trouvé");
            return "redirect:/type-devis";
        }
    }
    
    @PostMapping("/update/{id}")
    public String updateTypeDevis(@PathVariable Long id, TypeDevis typeDevis, RedirectAttributes redirectAttributes) {
        try {
            typeDevisService.updateTypeDevis(id, typeDevis);
            redirectAttributes.addFlashAttribute("successMessage", "Type de devis mis à jour avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur lors de la mise à jour du type de devis");
        }
        return "redirect:/type-devis";
    }
    
    @GetMapping("/delete/{id}")
    public String deleteTypeDevis(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            typeDevisService.deleteTypeDevis(id);
            redirectAttributes.addFlashAttribute("successMessage", "Type de devis supprimé avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur lors de la suppression du type de devis");
        }
        return "redirect:/type-devis";
    }
}
