package com.example.forage.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.forage.model.Client;
import com.example.forage.model.Demande;
import com.example.forage.model.DemandeStatut;
import com.example.forage.service.ClientService;
import com.example.forage.service.DemandeService;
import com.example.forage.service.StatutService;

@Controller
@RequestMapping("/demandes")
public class DemandeController {
    
    @Autowired
    private DemandeService demandeService;
    
    @Autowired
    private ClientService clientService;
    
    @Autowired
    private StatutService statutService;
    
    @GetMapping
    public String listDemandes(Model model) {
        List<Demande> demandes = demandeService.getAllDemandes();
        
        // Récupérer les statuts actuels pour chaque demande et créer un Map simple
        Map<Long, String> statutsMap = new HashMap<>();
        Map<Long, String> datesMap = new HashMap<>();
        
        for (Demande demande : demandes) {
            Optional<DemandeStatut> currentStatut = demandeService.getCurrentStatut(demande.getId());
            if (currentStatut.isPresent()) {
                statutsMap.put(demande.getId(), currentStatut.get().getStatut().getNom());
                datesMap.put(demande.getId(), currentStatut.get().getDateStatut().toString());
            } else {
                statutsMap.put(demande.getId(), "Non défini");
                datesMap.put(demande.getId(), "");
            }
        }
        
        model.addAttribute("demandes", demandes);
        model.addAttribute("statutsMap", statutsMap);
        model.addAttribute("datesMap", datesMap);
        model.addAttribute("title", "Liste des Demandes");
        return "forage/demandes/list";
    }
    
    @GetMapping("/new")
    public String createDemandeForm(Model model) {
        Demande demande = new Demande();
        demande.setDateDemande(LocalDate.now());
        model.addAttribute("demande", demande);
        model.addAttribute("clients", clientService.getAllClients());
        model.addAttribute("title", "Ajouter une Demande");
        model.addAttribute("today", LocalDate.now());
        return "forage/demandes/form";
    }
    
    @PostMapping
    public String saveDemande(@ModelAttribute Demande demande,
                              @RequestParam(value = "clientId", required = false) String clientIdValue,
                              RedirectAttributes redirectAttributes) {
        try {
            if (clientIdValue == null || clientIdValue.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Veuillez sélectionner un client.");
                return "redirect:/demandes/new";
            }

            Long clientId;
            try {
                clientId = Long.valueOf(clientIdValue);
            } catch (NumberFormatException e) {
                redirectAttributes.addFlashAttribute("error", "Client invalide.");
                return "redirect:/demandes/new";
            }

            Client client = clientService.getClientById(clientId).orElse(null);
            if (client == null) {
                redirectAttributes.addFlashAttribute("error", "Client non trouvé.");
                return "redirect:/demandes/new";
            }
            demande.setClient(client);
            
            if (demande.getId() != null) {
                // U
                Demande existingDemande = demandeService.getDemandeById(demande.getId()).orElse(null);
                if (existingDemande != null) {
                    existingDemande.setClient(client);
                    existingDemande.setDateDemande(demande.getDateDemande());
                    existingDemande.setLieu(demande.getLieu());
                    existingDemande.setDescription(demande.getDescription());
                    demandeService.updateDemande(demande.getId(), existingDemande);
                    redirectAttributes.addFlashAttribute("success", "Demande modifiée avec succès");
                } else {
                    redirectAttributes.addFlashAttribute("error", "Demande non trouvée");
                }
            } else {
                // C - utilisation automatique du statut "créé"
                demandeService.saveDemandeWithStatut(demande);
                redirectAttributes.addFlashAttribute("success", "Demande ajoutée avec succès");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/demandes";
    }
    
    @GetMapping("/edit/{id}")
    public String editDemandeForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Demande demande = demandeService.getDemandeById(id).orElse(null);
            if (demande == null) {
                redirectAttributes.addFlashAttribute("error", "Demande non trouvée");
                return "redirect:/demandes";
            }
            model.addAttribute("demande", demande);
            model.addAttribute("clients", clientService.getAllClients());
            model.addAttribute("title", "Modifier une Demande");
            return "forage/demandes/form";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
            return "redirect:/demandes";
        }
    }
    
    @GetMapping("/delete/{id}")
    public String deleteDemande(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            demandeService.deleteDemande(id);
            redirectAttributes.addFlashAttribute("success", "Demande supprimée avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression de la demande: " + e.getMessage());
        }
        return "redirect:/demandes";
    }
    
    @GetMapping(value = "/search", produces = "application/json")
    @ResponseBody
    public List<Map<String, Object>> searchDemandes(@RequestParam(value = "q", required = false, defaultValue = "") String q) {
        System.out.println("=== SEARCH DEMANDES ===");
        System.out.println("Query: '" + q + "'");
        
        List<Demande> allDemandes = demandeService.getAllDemandes();
        System.out.println("Total demandes in DB: " + allDemandes.size());
        
        List<Map<String, Object>> results = new ArrayList<>();
        
        if (q == null || q.trim().isEmpty()) {
            System.out.println("Empty query, returning all demandes");
            for (Demande d : allDemandes) {
                results.add(createDemandeMap(d));
            }
        } else {
            String query = q.toLowerCase().trim();
            System.out.println("Searching with query: '" + query + "'");
            for (Demande demande : allDemandes) {
                String description = demande.getDescription() != null ? demande.getDescription().toLowerCase() : "";
                String clientNom = demande.getClient().getNom().toLowerCase();
                String lieu = demande.getLieu() != null ? demande.getLieu().toLowerCase() : "";
                
                boolean matches = description.contains(query) || 
                                clientNom.contains(query) || 
                                lieu.contains(query);
                
                System.out.println("Checking ID " + demande.getId() + ": desc='" + description + "', client='" + clientNom + "', lieu='" + lieu + "', match=" + matches);
                
                if (matches) {
                    results.add(createDemandeMap(demande));
                }
            }
        }
        
        System.out.println("Results found: " + results.size());
        return results;
    }
    
    private Map<String, Object> createDemandeMap(Demande demande) {
        Map<String, Object> result = new HashMap<>();
        result.put("id", demande.getId());
        result.put("client", Map.of(
            "nom", demande.getClient().getNom(),
            "contact", demande.getClient().getContact() != null ? demande.getClient().getContact() : ""
        ));
        result.put("lieu", demande.getLieu());
        result.put("dateDemande", demande.getDateDemande().toString());
        result.put("description", demande.getDescription() != null ? demande.getDescription() : "");
        result.put("displayText", demande.getDescription() != null && !demande.getDescription().trim().isEmpty() 
            ? demande.getDescription() : demande.getClient().getNom() + " - " + demande.getLieu());
        return result;
    }
}
