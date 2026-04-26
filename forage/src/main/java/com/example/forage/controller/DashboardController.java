package com.example.forage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.forage.model.Client;
import com.example.forage.model.DemandeStatut;
import com.example.forage.model.Devis;
import com.example.forage.model.Statut;
import com.example.forage.service.ClientService;
import com.example.forage.service.DemandeStatutService;
import com.example.forage.service.DevisService;
import com.example.forage.service.StatutService;

@Controller
public class DashboardController {
    
    @Autowired
    private ClientService clientService;
    
    @Autowired
    private DevisService devisService;
    
    @Autowired
    private DemandeStatutService demandeStatutService;
    
    @Autowired
    private StatutService statutService;
    
    @GetMapping("/")
    public String dashboard(Model model) {
        // Nombre de clients
        List<Client> clients = clientService.getAllClients();
        int nbClients = clients.size();
        
        // Nombre de devis
        List<Devis> allDevis = devisService.getAllDevis();
        int nbDevis = allDevis.size();
        
        // Chiffre d'affaire total
        double chiffreAffaire = 0;
        for (Devis devis : allDevis) {
            if (devis.getMontantTotalCalcule() != null) {
                chiffreAffaire += devis.getMontantTotalCalcule().doubleValue();
            }
        }
        
        // Statistiques par statut - Afficher TOUS les statuts même ceux avec 0
        List<Statut> allStatuts = statutService.getAllStatuts();
        Map<String, Integer> statsParStatut = new java.util.LinkedHashMap<>();
        
        // Compter les demandes par statut actuel (ID le plus élevé)
        Map<Long, DemandeStatut> latestByDemande = new HashMap<>();
        List<DemandeStatut> allDemandeStatuts = demandeStatutService.getAllDemandeStatuts();
        for (DemandeStatut ds : allDemandeStatuts) {
            Long demandeId = ds.getDemande().getId();
            if (!latestByDemande.containsKey(demandeId) || 
                ds.getId() > latestByDemande.get(demandeId).getId()) { // Comparer par ID au lieu de date
                latestByDemande.put(demandeId, ds);
            }
        }
        
        // Compter les statuts actuels
        Map<String, Integer> counts = new HashMap<>();
        for (DemandeStatut ds : latestByDemande.values()) {
            String statutNom = ds.getStatut().getNom();
            counts.put(statutNom, counts.getOrDefault(statutNom, 0) + 1);
        }
        
        // Ajouter TOUS les statuts avec leur comptage (0 si non trouvé) dans l'ordre de allStatuts
        for (Statut statut : allStatuts) {
            statsParStatut.put(statut.getNom(), counts.getOrDefault(statut.getNom(), 0));
        }
        
        // Calculer le total global
        int totalGlobal = 0;
        for (int count : statsParStatut.values()) {
            totalGlobal += count;
        }
        
        // Debug
        System.out.println("=== DEBUG DASHBOARD ===");
        System.out.println("nbClients: " + nbClients);
        System.out.println("nbDevis: " + nbDevis);
        System.out.println("chiffreAffaire: " + chiffreAffaire);
        System.out.println("statsParStatut: " + statsParStatut);
        System.out.println("totalGlobal: " + totalGlobal);
        System.out.println("========================");
        
        // Ajouter les données au modèle
        model.addAttribute("nbClients", nbClients);
        model.addAttribute("nbDevis", nbDevis);
        model.addAttribute("chiffreAffaire", chiffreAffaire);
        model.addAttribute("statsParStatut", statsParStatut);
        model.addAttribute("allStatuts", allStatuts);
        model.addAttribute("totalGlobal", totalGlobal);
        model.addAttribute("totalDemandes", totalGlobal);
        
        return "forage/index";
    }
}
