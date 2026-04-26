package com.example.forage.controller;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.forage.model.Demande;
import com.example.forage.model.DemandeStatut;
import com.example.forage.model.Statut;
import com.example.forage.repository.DemandeStatutRepository;
import com.example.forage.service.DemandeService;
import com.example.forage.service.DemandeStatutService;
import com.example.forage.service.StatutService;

@Controller
@RequestMapping("/demande-statuts")
public class DemandeStatutController {
    
    @Autowired
    private DemandeStatutRepository demandeStatutRepository;
    
    @Autowired
    private DemandeStatutService demandeStatutService;
    
    @Autowired
    private DemandeService demandeService;
    
    @Autowired
    private StatutService statutService;
    
    @GetMapping("")
    public String listDemandeStatuts(Model model) {
        // Récupérer toutes les demandes
        List<Demande> demandes = demandeService.getAllDemandes();
        
        // Préparer l'historique et le dernier statut pour chaque demande
        Map<Long, List<DemandeStatut>> historiqueMap = new HashMap<>();
        for (Demande demande : demandes) {
            // Récupérer tous les statuts de la demande, ordonnés par ID décroissant (le plus récent)
            List<DemandeStatut> statuts = demandeStatutRepository.findByDemandeIdOrderByIdDesc(demande.getId());
            
            // Forcer la mise à jour du latestStatut avec le statut ayant l'ID le plus élevé
            if (!statuts.isEmpty()) {
                DemandeStatut latestStatut = statuts.get(0); // Celui avec l'ID le plus élevé
                demande.setLatestStatut(latestStatut);
                
                // Sauvegarder la demande pour persister le latestStatut
                demandeService.saveDemande(demande);
                
                System.out.println("DEBUG: Demande " + demande.getId() + " - LatestStatut mis à jour: " + 
                                 latestStatut.getStatut().getNom() + " (ID: " + latestStatut.getId() + ")");
            }
            
            historiqueMap.put(demande.getId(), statuts);
        }
        
        // Ajouter les statistiques pour la bannière
        List<Statut> allStatuts = statutService.getAllStatuts();
        Map<String, Integer> statsParStatut = calculerStatsParStatut();
        
        // Calculer le total global
        int totalGlobal = 0;
        for (int count : statsParStatut.values()) {
            totalGlobal += count;
        }
        
        model.addAttribute("demandes", demandes);
        model.addAttribute("historiqueMap", historiqueMap);
        model.addAttribute("allStatuts", allStatuts);
        model.addAttribute("statsParStatut", statsParStatut);
        model.addAttribute("totalGlobal", totalGlobal);
        
        return "forage/demande-statuts/list";
    }
    
    @GetMapping("/mettre-a-jour/{demandeId}")
    public String showMettreAJourForm(@PathVariable Long demandeId, Model model) {
        Demande demande = demandeService.getDemandeById(demandeId)
            .orElseThrow(() -> new RuntimeException("Demande non trouvée"));
        
        // Récupérer le dernier statut de la demande
        List<DemandeStatut> statuts = demandeStatutRepository.findByDemandeIdOrderByDateStatutDescIdDesc(demandeId);
        if (!statuts.isEmpty()) {
            demande.setLatestStatut(statuts.get(0));
        }
        
        List<Statut> allStatuts = statutService.getAllStatuts();
        
        model.addAttribute("demande", demande);
        model.addAttribute("statuts", allStatuts);
        
        return "forage/demande-statuts/mettre-a-jour";
    }
    
    @PostMapping("/mettre-a-jour/{demandeId}")
    public String mettreAJourStatut(@PathVariable Long demandeId, 
                                   @RequestParam Long statutId, 
                                   @RequestParam String observation,
                                   @RequestParam(required = false) String dateStatut,
                                   RedirectAttributes redirectAttributes) {
        try {
            // Parser la date depuis le formulaire si fournie, sinon utiliser maintenant
            LocalDateTime parsedDateStatut = LocalDateTime.now();
            if (dateStatut != null && !dateStatut.trim().isEmpty()) {
                try {
                    // Le format datetime-local est "yyyy-MM-dd'T'HH:mm"
                    parsedDateStatut = LocalDateTime.parse(dateStatut);
                } catch (Exception e) {
                    // Si le parsing échoue, utiliser la date actuelle
                    System.err.println("Erreur parsing date: " + dateStatut + ", utilisation de la date actuelle");
                }
            }
            
            // Créer le nouveau statut
            DemandeStatut nouveauStatut = demandeStatutService.creerChangementStatut(demandeId, statutId, observation, parsedDateStatut);
            
            // Debug message
            System.out.println("Nouveau statut créé - ID: " + nouveauStatut.getId() + 
                             ", Demande: " + demandeId + 
                             ", Statut: " + statutId + 
                             ", Date: " + parsedDateStatut + 
                             ", Observation: " + observation);
            
            redirectAttributes.addFlashAttribute("message", "Statut mis à jour avec succès !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la mise à jour du statut : " + e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/demande-statuts";
    }
    
    @GetMapping("/modifier-ligne/{demandeId}/{statutId}")
    public String showModifierLigneForm(@PathVariable Long demandeId, @PathVariable Long statutId, Model model) {
        Demande demande = demandeService.getDemandeById(demandeId)
            .orElseThrow(() -> new RuntimeException("Demande non trouvée"));
        
        DemandeStatut statutAModifier = demandeStatutService.getDemandeStatutById(statutId)
            .orElseThrow(() -> new RuntimeException("Statut non trouvé"));
        
        List<Statut> allStatuts = statutService.getAllStatuts();
        
        model.addAttribute("demande", demande);
        model.addAttribute("statutAModifier", statutAModifier);
        model.addAttribute("statuts", allStatuts);
        
        return "forage/demande-statuts/modifier-ligne";
    }
    
    @PostMapping("/modifier-ligne/{demandeId}/{statutId}")
    public String modifierLigne(@PathVariable Long demandeId, 
                               @PathVariable Long statutId,
                               @RequestParam Long statutNouveauId, 
                               @RequestParam String observation,
                               @RequestParam(required = false) String dateStatut,
                               RedirectAttributes redirectAttributes) {
        try {
            // Parser la date depuis le formulaire si fournie, sinon utiliser maintenant
            LocalDateTime parsedDateStatut = LocalDateTime.now();
            if (dateStatut != null && !dateStatut.trim().isEmpty()) {
                try {
                    parsedDateStatut = LocalDateTime.parse(dateStatut);
                } catch (Exception e) {
                    System.err.println("Erreur parsing date: " + dateStatut + ", utilisation de la date actuelle");
                }
            }
            
            // Mettre à jour la ligne existante
            DemandeStatut statut = demandeStatutService.getDemandeStatutById(statutId)
                .orElseThrow(() -> new RuntimeException("Statut non trouvé"));
            
            Statut nouveauStatut = statutService.getStatutById(statutNouveauId)
                .orElseThrow(() -> new RuntimeException("Nouveau statut non trouvé"));
            
            statut.setStatut(nouveauStatut);
            statut.setObservation(observation);
            statut.setDateStatut(parsedDateStatut);
            
            demandeStatutService.saveDemandeStatut(statut);
            
            // Mettre à jour le latestStatut avec le statut modifié
            Demande demande = statut.getDemande();
            demande.setLatestStatut(statut);
            demandeService.saveDemande(demande);
            
            redirectAttributes.addFlashAttribute("message", "Ligne de statut modifiée avec succès !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la modification de la ligne : " + e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/demande-statuts";
    }
    
        
    @GetMapping("/statut/{nomStatut}")
    public String showDemandesByStatut(@PathVariable String nomStatut, Model model) {
        // Récupérer toutes les demande_statut et trouver le statut avec l'ID le plus élevé par demande
        List<DemandeStatut> allDemandeStatuts = demandeStatutService.getAllDemandeStatuts();
        Map<Long, DemandeStatut> latestByDemande = new HashMap<>();
        for (DemandeStatut ds : allDemandeStatuts) {
            Long demandeId = ds.getDemande().getId();
            if (!latestByDemande.containsKey(demandeId) || 
                ds.getId() > latestByDemande.get(demandeId).getId()) { // Comparer par ID au lieu de date
                latestByDemande.put(demandeId, ds);
            }
        }
        
        // Filtrer par statut spécifique - ne garder que les demandes dont le statut actuel (ID le plus élevé) = nomStatut
        List<DemandeStatut> demandesStatutFiltrees = new ArrayList<>();
        for (DemandeStatut ds : latestByDemande.values()) {
            if (ds.getStatut().getNom().equals(nomStatut)) {
                demandesStatutFiltrees.add(ds);
            }
        }
        
        // Récupérer les demandes filtrées et leur historique
        List<Demande> demandesFiltrees = new ArrayList<>();
        Map<Long, List<DemandeStatut>> historiqueMap = new HashMap<>();
        for (DemandeStatut ds : demandesStatutFiltrees) {
            Demande demande = ds.getDemande();
            demande.setLatestStatut(ds);
            demandesFiltrees.add(demande);
            // Récupérer l'historique ordonné par ID décroissant (le plus récent en premier)
            List<DemandeStatut> historique = demandeStatutRepository.findByDemandeIdOrderByIdDesc(demande.getId());
            historiqueMap.put(demande.getId(), historique);
        }
        
        // Ajouter les statistiques pour la bannière (pour qu'elles soient toujours visibles)
        List<Statut> allStatuts = statutService.getAllStatuts();
        Map<String, Integer> statsParStatut = calculerStatsParStatut();
        
        // Calculer le total global
        int totalGlobal = 0;
        for (int count : statsParStatut.values()) {
            totalGlobal += count;
        }
        
        model.addAttribute("demandes", demandesFiltrees);
        model.addAttribute("historiqueMap", historiqueMap);
        model.addAttribute("statutFiltre", nomStatut);
        model.addAttribute("nbResultats", demandesFiltrees.size());
        model.addAttribute("allStatuts", allStatuts);
        model.addAttribute("statsParStatut", statsParStatut);
        model.addAttribute("totalGlobal", totalGlobal);
        
        return "forage/demande-statuts/par-statut";
    }

    // Méthode helper pour calculer les stats de manière uniforme et complète
    private Map<String, Integer> calculerStatsParStatut() {
        List<Statut> allStatuts = statutService.getAllStatuts();
        List<DemandeStatut> allDemandeStatuts = demandeStatutService.getAllDemandeStatuts();
        
        Map<Long, DemandeStatut> latestByDemande = new HashMap<>();
        for (DemandeStatut ds : allDemandeStatuts) {
            Long demandeId = ds.getDemande().getId();
            if (!latestByDemande.containsKey(demandeId) || 
                ds.getId() > latestByDemande.get(demandeId).getId()) { // Comparer par ID au lieu de date
                latestByDemande.put(demandeId, ds);
            }
        }
        
        Map<String, Integer> counts = new HashMap<>();
        for (DemandeStatut ds : latestByDemande.values()) {
            String statutNom = ds.getStatut().getNom();
            counts.put(statutNom, counts.getOrDefault(statutNom, 0) + 1);
        }
        
        Map<String, Integer> statsParStatut = new HashMap<>();
        for (Statut statut : allStatuts) {
            statsParStatut.put(statut.getNom(), counts.getOrDefault(statut.getNom(), 0));
        }
        return statsParStatut;
    }
    
    @GetMapping("/historique/{demandeId}")
    public String showHistorique(@PathVariable Long demandeId, Model model) {
        Demande demande = demandeService.getDemandeById(demandeId)
            .orElseThrow(() -> new RuntimeException("Demande non trouvée"));
        
        List<DemandeStatut> historique = demandeStatutService.getStatutsByDemandeId(demandeId);
        
        model.addAttribute("demande", demande);
        model.addAttribute("historique", historique);
        return "forage/demande-statuts/historique";
    }
    
    @GetMapping("/confirmer/{demandeId}")
    public String showConfirmerForm(@PathVariable Long demandeId, Model model) {
        Demande demande = demandeService.getDemandeById(demandeId)
            .orElseThrow(() -> new RuntimeException("Demande non trouvée"));
        
        model.addAttribute("demande", demande);
        return "forage/demande-statuts/confirmer";
    }
    
    @PostMapping("/confirmer/{demandeId}")
    public String confirmerDemande(@PathVariable Long demandeId, 
                                 @RequestParam String observation,
                                 RedirectAttributes redirectAttributes) {
        try {
            // Récupérer la demande
            Demande demande = demandeService.getDemandeById(demandeId)
                .orElseThrow(() -> new RuntimeException("Demande non trouvée"));
            
            // Récupérer le statut "Confirmée"
            Statut statutConfirme = statutService.findByNom("Confirmée")
                .orElseGet(() -> {
                    // Créer le statut s'il n'existe pas
                    Statut nouveauStatut = new Statut("Confirmée");
                    return statutService.saveStatut(nouveauStatut);
                });
            
            // Créer le nouveau statut avec observation
            DemandeStatut nouveauStatut = new DemandeStatut(
                demande, 
                statutConfirme, 
                LocalDateTime.now(), 
                observation
            );
            
            demandeStatutService.saveDemandeStatut(nouveauStatut);
            
            redirectAttributes.addFlashAttribute("message", "Demande confirmée avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la confirmation: " + e.getMessage());
        }
        
        return "redirect:/demande-statuts";
    }
    
    @GetMapping("/annuler/{demandeId}")
    public String showAnnulerForm(@PathVariable Long demandeId, Model model) {
        Demande demande = demandeService.getDemandeById(demandeId)
            .orElseThrow(() -> new RuntimeException("Demande non trouvée"));
        
        model.addAttribute("demande", demande);
        return "forage/demande-statuts/annuler";
    }
    
    @PostMapping("/annuler/{demandeId}")
    public String annulerDemande(@PathVariable Long demandeId, 
                               @RequestParam String observation,
                               RedirectAttributes redirectAttributes) {
        try {
            // Récupérer la demande
            Demande demande = demandeService.getDemandeById(demandeId)
                .orElseThrow(() -> new RuntimeException("Demande non trouvée"));
            
            // Récupérer le statut "Annulée"
            Statut statutAnnule = statutService.findByNom("Annulée")
                .orElseGet(() -> {
                    // Créer le statut s'il n'existe pas
                    Statut nouveauStatut = new Statut("Annulée");
                    return statutService.saveStatut(nouveauStatut);
                });
            
            // Créer le nouveau statut avec observation
            DemandeStatut nouveauStatut = new DemandeStatut(
                demande, 
                statutAnnule, 
                LocalDateTime.now(), 
                observation
            );
            
            demandeStatutService.saveDemandeStatut(nouveauStatut);
            
            redirectAttributes.addFlashAttribute("message", "Demande annulée avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'annulation: " + e.getMessage());
        }
        
        return "redirect:/demande-statuts";
    }
    
    @GetMapping("/modifier-statut/{demandeId}")
    public String showModifierStatutForm(@PathVariable Long demandeId, Model model) {
        Demande demande = demandeService.getDemandeById(demandeId)
            .orElseThrow(() -> new RuntimeException("Demande non trouvée"));
        
        // Récupérer le dernier statut de la demande
        List<DemandeStatut> statuts = demandeStatutRepository.findByDemandeIdOrderByDateStatutDescIdDesc(demandeId);
        if (!statuts.isEmpty()) {
            demande.setLatestStatut(statuts.get(0));
        }
        
        List<Statut> allStatuts = statutService.getAllStatuts();
        
        model.addAttribute("demande", demande);
        model.addAttribute("statuts", allStatuts);
        
        return "forage/demande-statuts/modifier-statut";
    }
    
    @PostMapping("/modifier-statut/{demandeId}")
    public String modifierStatut(@PathVariable Long demandeId, 
                               @RequestParam Long statutId, 
                               @RequestParam(required = false) String observation,
                               RedirectAttributes redirectAttributes) {
        try {
            // Créer un nouveau statut avec la date actuelle
            LocalDateTime dateActuelle = LocalDateTime.now();
            DemandeStatut nouveauStatut = demandeStatutService.creerChangementStatut(demandeId, statutId, observation, dateActuelle);
            
            redirectAttributes.addFlashAttribute("message", "Statut modifié avec succès !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la modification du statut : " + e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/demande-statuts";
    }
    
    @GetMapping("/modifier-ligne/{demandeId}")
    public String showModifierLigneForm(@PathVariable Long demandeId, Model model) {
        Demande demande = demandeService.getDemandeById(demandeId)
            .orElseThrow(() -> new RuntimeException("Demande non trouvée"));
        
        // Récupérer le dernier statut de la demande
        List<DemandeStatut> statuts = demandeStatutRepository.findByDemandeIdOrderByDateStatutDescIdDesc(demandeId);
        if (!statuts.isEmpty()) {
            demande.setLatestStatut(statuts.get(0));
        }
        
        model.addAttribute("demande", demande);
        
        return "forage/demande-statuts/modifier-ligne";
    }
    
    @PostMapping("/modifier-ligne/{demandeId}")
    public String modifierLigne(@PathVariable Long demandeId, 
                               @RequestParam String observation,
                               @RequestParam(required = false) String dateStatut,
                               RedirectAttributes redirectAttributes) {
        try {
            // Parser la date depuis le formulaire si fournie, sinon utiliser maintenant
            LocalDateTime parsedDateStatut = LocalDateTime.now();
            if (dateStatut != null && !dateStatut.trim().isEmpty()) {
                try {
                    // Le format datetime-local est "yyyy-MM-dd'T'HH:mm"
                    parsedDateStatut = LocalDateTime.parse(dateStatut);
                } catch (Exception e) {
                    // Si le parsing échoue, utiliser la date actuelle
                    System.err.println("Erreur parsing date: " + dateStatut + ", utilisation de la date actuelle");
                }
            }
            
            // Modifier la ligne existante sans en créer de nouvelle
            demandeStatutService.modifierLigneStatut(demandeId, observation, parsedDateStatut);
            
            redirectAttributes.addFlashAttribute("message", "Ligne de statut modifiée avec succès !");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la modification de la ligne : " + e.getMessage());
            e.printStackTrace();
        }
        
        return "redirect:/demande-statuts";
    }
}
