package com.example.forage.controller;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.forage.model.Demande;
import com.example.forage.model.DetailsDevis;
import com.example.forage.model.Devis;
import com.example.forage.model.Statut;
import com.example.forage.model.TypeDevis;
import com.example.forage.service.DemandeService;
import com.example.forage.service.DetailsDevisService;
import com.example.forage.service.DevisService;
import com.example.forage.service.StatutService;
import com.example.forage.service.TypeDevisService;
@Controller
@RequestMapping("/devis")
public class DevisController {
    
    @Autowired
    private DevisService devisService;
    
    @Autowired
    private DemandeService demandeService;
    
    @Autowired
    private TypeDevisService typeDevisService;
    
    @Autowired
    private StatutService statutService;
    
    @Autowired
    private DetailsDevisService detailsDevisService;
    
    @GetMapping
    public String listDevis(Model model) {
        List<Devis> devis = devisService.getAllDevis();
        model.addAttribute("devis", devis);
        return "forage/devis/list";
    }
    
    @GetMapping("/add")
    public String showAddForm(Model model) {
        model.addAttribute("devis", new Devis());
        model.addAttribute("demandes", demandeService.getAllDemandes());
        model.addAttribute("typeDevis", typeDevisService.getAllTypeDevis());
        model.addAttribute("detailsDevis", new DetailsDevis());
        model.addAttribute("isEdit", false);
        return "forage/devis/form";
    }
    
    @GetMapping("/test")
    @ResponseBody
    public String testEndpoint() {
        return "DevisController is working!";
    }
    
    @PostMapping("/test-save")
    @ResponseBody
    public String testSaveEndpoint() {
        return "POST endpoint is working!";
    }
    
    @PostMapping("/save")
    public String saveDevis(
            @RequestParam("demande.id") Long demandeId,
            @RequestParam("typeDevis.id") Long typeDevisId,
            @RequestParam("dateDevis") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date dateDevis,
            @RequestParam(value = "lineLibelle", required = false) List<String> lineLibelles,
            @RequestParam(value = "lineQuantite", required = false) List<Integer> lineQuantites,
            @RequestParam(value = "linePrixUnitaire", required = false) List<Double> linePrixUnitaires,
            RedirectAttributes redirectAttributes) {
        try {
            System.out.println("=== DEBUG SAVE DEVIS ===");
            System.out.println("demandeId: " + demandeId);
            System.out.println("typeDevisId: " + typeDevisId);
            System.out.println("lineLibelles: " + lineLibelles);
            System.out.println("lineQuantites: " + lineQuantites);
            System.out.println("linePrixUnitaires: " + linePrixUnitaires);
            Demande demande = demandeService.getDemandeById(demandeId)
                .orElseThrow(() -> new RuntimeException("Demande non trouvée"));
            
            // Récupérer le type de devis
            TypeDevis typeDevis = typeDevisService.getTypeDevisById(typeDevisId)
                .orElseThrow(() -> new RuntimeException("Type de devis non trouvé"));
            
            // Récupérer le premier statut (par défaut "Devis créé!")
            Statut statut = statutService.getStatutById(1L)
                .orElseGet(() -> {
                    Statut defaultStatut = new Statut();
                    defaultStatut.setNom("Devis créé!");
                    return statutService.saveStatut(defaultStatut);
                });
            
            // Créer le devis
            Devis devis = new Devis();
            devis.setDemande(demande);
            devis.setTypeDevis(typeDevis);
            devis.setDateDevis(dateDevis);
            devis.setClient(demande.getClient().getNom());
            devis.setLieu(demande.getLieu());
            devis.setStatut(statut);
            
            // Initialiser la liste des détails
            java.util.List<DetailsDevis> detailsList = new java.util.ArrayList<>();
            devis.setDetailsDevis(detailsList);
            
            // Ajouter les lignes de devis dans la table details_devis
            java.math.BigDecimal montantTotal = java.math.BigDecimal.ZERO;

            if (lineLibelles != null) {
                for (int i = 0; i < lineLibelles.size(); i++) {
                    String libelle = lineLibelles.get(i);
                    Integer quantite = (lineQuantites != null && lineQuantites.size() > i) ? lineQuantites.get(i) : null;
                    Double prix = (linePrixUnitaires != null && linePrixUnitaires.size() > i) ? linePrixUnitaires.get(i) : null;

                    if (libelle != null && !libelle.trim().isEmpty() && quantite != null && quantite > 0 && prix != null && prix > 0) {
                        DetailsDevis detail = new DetailsDevis();
                        detail.setLibelle(libelle.trim());
                        detail.setQuantite(quantite);
                        detail.setPrixUnitaire(java.math.BigDecimal.valueOf(prix));
                        detail.setDevis(devis);
                        detailsList.add(detail);
                        montantTotal = montantTotal.add(java.math.BigDecimal.valueOf(prix).multiply(java.math.BigDecimal.valueOf(quantite)));
                        System.out.println("Detail " + i + " added: " + libelle);
                    }
                }
            }

            System.out.println("Total details to save: " + detailsList.size());
            System.out.println("First detail: " + (detailsList.size() > 0 ? detailsList.get(0).getLibelle() : "none"));
            System.out.println("ALL PARAMS - lineLibelles: " + lineLibelles + ", lineQuantites: " + lineQuantites + ", linePrixUnitaires: " + linePrixUnitaires);
            
            // Sauvegarder le devis avec ses détails
            devisService.saveDevis(devis);
            redirectAttributes.addFlashAttribute("successMessage", "Devis créé avec succès");
        } catch (Exception e) {
            System.out.println("ERREUR: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur lors de la création du devis: " + e.getMessage());
        }
        return "redirect:/devis";
    }
    
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Devis devis = devisService.getDevisById(id)
                .orElseThrow(() -> new RuntimeException("Devis non trouvé"));
            model.addAttribute("devis", devis);
            model.addAttribute("demandes", demandeService.getAllDemandes());
            model.addAttribute("typeDevis", typeDevisService.getAllTypeDevis());
            model.addAttribute("isEdit", true);
            return "forage/devis/form";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Devis non trouvé");
            return "redirect:/devis";
        }
    }
    
    @PostMapping("/edit/{id}")
    public String updateDevis(@PathVariable Long id,
                           @RequestParam("demande.id") Long demandeId,
                           @RequestParam("typeDevis.id") Long typeDevisId,
                           @RequestParam("dateDevis") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) Date dateDevis,
                           @RequestParam(value = "lineLibelle", required = false) List<String> lineLibelles,
                           @RequestParam(value = "lineQuantite", required = false) List<Integer> lineQuantites,
                           @RequestParam(value = "linePrixUnitaire", required = false) List<Double> linePrixUnitaires,
                           RedirectAttributes redirectAttributes) {
        try {
            Devis devis = devisService.getDevisById(id)
                .orElseThrow(() -> new RuntimeException("Devis non trouvé"));

            Demande demande = demandeService.getDemandeById(demandeId)
                .orElseThrow(() -> new RuntimeException("Demande non trouvée"));

            TypeDevis typeDevis = typeDevisService.getTypeDevisById(typeDevisId)
                .orElseThrow(() -> new RuntimeException("Type de devis non trouvé"));

            Statut statut = statutService.getStatutById(1L)
                .orElseGet(() -> {
                    Statut defaultStatut = new Statut();
                    defaultStatut.setNom("Devis créé!");
                    return statutService.saveStatut(defaultStatut);
                });

            devis.setDemande(demande);
            devis.setTypeDevis(typeDevis);
            devis.setDateDevis(dateDevis);
            devis.setClient(demande.getClient().getNom());
            devis.setLieu(demande.getLieu());
            devis.setStatut(statut);

            java.util.List<DetailsDevis> detailsList = new java.util.ArrayList<>();
            devis.setDetailsDevis(detailsList);

            // Ajouter les lignes de devis dans la table details_devis
            if (lineLibelles != null) {
                for (int i = 0; i < lineLibelles.size(); i++) {
                    String libelle = lineLibelles.get(i);
                    Integer quantite = (lineQuantites != null && lineQuantites.size() > i) ? lineQuantites.get(i) : null;
                    Double prix = (linePrixUnitaires != null && linePrixUnitaires.size() > i) ? linePrixUnitaires.get(i) : null;

                    if (libelle != null && !libelle.trim().isEmpty() && quantite != null && quantite > 0 && prix != null && prix > 0) {
                        DetailsDevis detail = new DetailsDevis();
                        detail.setLibelle(libelle.trim());
                        detail.setQuantite(quantite);
                        detail.setPrixUnitaire(java.math.BigDecimal.valueOf(prix));
                        detail.setDevis(devis);
                        detailsList.add(detail);
                    }
                }
            }

            devisService.saveDevis(devis);
            redirectAttributes.addFlashAttribute("successMessage", "Devis modifié avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur lors de la modification du devis: " + e.getMessage());
        }
        return "redirect:/devis";
    }
    
    @GetMapping("/delete/{id}")
    public String deleteDevis(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            devisService.deleteDevis(id);
            redirectAttributes.addFlashAttribute("successMessage", "Devis supprimé avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur lors de la suppression du devis");
        }
        return "redirect:/devis";
    }
    
    @GetMapping("/details/{id}")
    public String showDetails(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Devis devis = devisService.getDevisById(id)
                .orElseThrow(() -> new RuntimeException("Devis non trouvé"));
            
            if (devis.getDetailsDevis() == null) {
                devis.setDetailsDevis(new java.util.ArrayList<>());
            }
            
            model.addAttribute("devis", devis);
            model.addAttribute("newDetail", new DetailsDevis());
            model.addAttribute("allTypeDevis", typeDevisService.getAllTypeDevis());
            return "forage/devis/details";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Devis non trouvé");
            return "redirect:/devis";
        }
    }
    
    @PostMapping("/update-info/{id}")
    public String updateDevisInfo(@PathVariable Long id,
            @RequestParam(value = "demande.id", required = false) Long demandeId,
            @RequestParam(value = "typeDevis.id", required = false) Long typeDevisId,
            RedirectAttributes redirectAttributes) {
        try {
            Devis devis = devisService.getDevisById(id)
                    .orElseThrow(() -> new RuntimeException("Devis non trouvé"));
            
            System.out.println("=== UPDATE DEVIS INFO ===");
            System.out.println("devisId: " + id);
            System.out.println("demandeId received: " + demandeId);
            System.out.println("typeDevisId received: " + typeDevisId);
            
            if (demandeId != null) {
                Demande demande = demandeService.getDemandeById(demandeId)
                        .orElseThrow(() -> new RuntimeException("Demande non trouvée: " + demandeId));
                System.out.println("Demande found: " + demande.getDescription());
                devis.setDemande(demande);
                devis.setClient(demande.getClient().getNom());
                devis.setLieu(demande.getLieu());
            } else {
                System.out.println("No demandeId provided, keeping existing demande");
            }
            
            if (typeDevisId != null) {
                TypeDevis typeDevis = typeDevisService.getTypeDevisById(typeDevisId)
                        .orElseThrow(() -> new RuntimeException("Type de devis non trouvé: " + typeDevisId));
                System.out.println("TypeDevis found: " + typeDevis.getLibelle());
                devis.setTypeDevis(typeDevis);
            }
            
            devisService.saveDevis(devis);
            System.out.println("Devis updated successfully");
            redirectAttributes.addFlashAttribute("successMessage", "Informations du devis mises à jour avec succès");
        } catch (Exception e) {
            System.out.println("ERROR: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("errorMessage", "Erreur: " + e.getMessage());
        }
        return "redirect:/devis/details/" + id;
    }

    @PostMapping("/details/add/{devisId}")
public String addDetail(
        @PathVariable Long devisId,
        DetailsDevis detail,
        RedirectAttributes redirectAttributes) {

    detailsDevisService.saveDetailsDevis(devisId, detail);

    redirectAttributes.addFlashAttribute("successMessage", "Détail ajouté avec succès");

    return "redirect:/devis/details/" + devisId;
}
}
