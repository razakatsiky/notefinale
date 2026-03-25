package com.example.forage.service;

import com.example.forage.model.Demande;
import com.example.forage.model.DemandeStatut;
import com.example.forage.model.Statut;
import com.example.forage.repository.DemandeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class DemandeService {
    
    @Autowired
    private DemandeRepository demandeRepository;
    
    @Autowired
    private StatutService statutService;
    
    @Autowired
    private DemandeStatutService demandeStatutService;
    
    public List<Demande> getAllDemandes() {
        return demandeRepository.findAll();
    }
    
    public Optional<Demande> getDemandeById(Long id) {
        return demandeRepository.findById(id);
    }
    
    @Transactional
    public Demande saveDemandeWithStatut(Demande demande, String statutIdValue) {
        try {
            // Sauvegarder la demande
            Demande savedDemande = demandeRepository.save(demande);
            System.out.println("Demande sauvegardée avec ID: " + savedDemande.getId());
            
            // Si un statut est sélectionné, l'utiliser
            if (statutIdValue != null && !statutIdValue.trim().isEmpty()) {
                Long statutId = Long.valueOf(statutIdValue);
                Optional<Statut> selectedStatut = statutService.getStatutById(statutId);
                
                if (selectedStatut.isPresent()) {
                    System.out.println("Utilisation du statut sélectionné: " + selectedStatut.get().getNom());
                    
                    // Créer l'entrée dans demande_statut
                    DemandeStatut demandeStatut = new DemandeStatut(
                        savedDemande, 
                        selectedStatut.get(), 
                        LocalDateTime.now()
                    );
                    demandeStatutService.saveDemandeStatut(demandeStatut);
                } else {
                    System.out.println("Statut sélectionné non trouvé - demande créée sans statut");
                }
            } else {
                System.out.println("Aucun statut sélectionné - demande créée sans statut");
            }
            
            return savedDemande;
        } catch (Exception e) {
            System.err.println("Erreur dans saveDemandeWithStatut: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    @Transactional
    public Demande saveDemandeWithStatut(Demande demande) {
        try {
            // Sauvegarder la demande
            Demande savedDemande = demandeRepository.save(demande);
            System.out.println("Demande sauvegardée avec ID: " + savedDemande.getId());
            
            // Vérifier s'il y a des statuts disponibles
            List<Statut> allStatuts = statutService.getAllStatuts();
            if (allStatuts.isEmpty()) {
                System.out.println("Aucun statut disponible - création automatique du statut 'créé'");
                // Créer automatiquement le statut "créé" si aucun n'existe
                Statut defaultStatut = new Statut("créé");
                statutService.saveStatut(defaultStatut);
                
                // Créer l'entrée dans demande_statut
                DemandeStatut demandeStatut = new DemandeStatut(
                    savedDemande, 
                    defaultStatut, 
                    LocalDateTime.now()
                );
                demandeStatutService.saveDemandeStatut(demandeStatut);
            } else {
                // Utiliser le statut "créé" s'il existe, sinon le premier disponible
                Statut statutToUse = allStatuts.stream()
                    .filter(s -> "créé".equalsIgnoreCase(s.getNom()))
                    .findFirst()
                    .orElse(allStatuts.get(0));
                
                System.out.println("Utilisation automatique du statut: " + statutToUse.getNom());
                
                // Créer l'entrée dans demande_statut
                DemandeStatut demandeStatut = new DemandeStatut(
                    savedDemande, 
                    statutToUse, 
                    LocalDateTime.now()
                );
                demandeStatutService.saveDemandeStatut(demandeStatut);
            }
            
            return savedDemande;
        } catch (Exception e) {
            System.err.println("Erreur dans saveDemandeWithStatut: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    public Demande saveDemande(Demande demande) {
        return demandeRepository.save(demande);
    }
    
    public Demande updateDemande(Long id, Demande demandeDetails) {
        Optional<Demande> optionalDemande = demandeRepository.findById(id);
        if (optionalDemande.isPresent()) {
            Demande demande = optionalDemande.get();
            demande.setClient(demandeDetails.getClient());
            demande.setDateDemande(demandeDetails.getDateDemande());
            demande.setLieu(demandeDetails.getLieu());
            demande.setDescription(demandeDetails.getDescription());
            return demandeRepository.save(demande);
        }
        return null;
    }
    
    @Transactional
    public void deleteDemande(Long id) {
        try {
            System.out.println("Tentative de suppression de la demande ID: " + id);
            
            // D'abord supprimer les enregistrements dans demande_statut
            List<DemandeStatut> statutsToDelete = demandeStatutService.getStatutsByDemandeId(id);
            System.out.println("Nombre de statuts à supprimer: " + statutsToDelete.size());
            
            for (DemandeStatut statut : statutsToDelete) {
                System.out.println("Suppression du demande_statut ID: " + statut.getId());
                demandeStatutService.deleteDemandeStatut(statut.getId());
            }
            
            // Ensuite supprimer la demande
            System.out.println("Suppression de la demande ID: " + id);
            demandeRepository.deleteById(id);
            
            System.out.println("Demande " + id + " supprimée avec succès");
        } catch (Exception e) {
            System.err.println("Erreur lors de la suppression de la demande " + id + ": " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
    
    public List<Demande> getDemandesByClient(Long clientId) {
        return demandeRepository.findByClientId(clientId);
    }
    
    public List<Demande> searchDemandesByLieu(String lieu) {
        return demandeRepository.findByLieuContaining(lieu);
    }
    
    public List<Demande> getDemandesByDateRange(LocalDate startDate, LocalDate endDate) {
        return demandeRepository.findByDateDemandeBetween(startDate, endDate);
    }
    
    public List<Demande> searchDemandesByClientNom(String clientNom) {
        return demandeRepository.findByClientNomContaining(clientNom);
    }
    
    public Optional<DemandeStatut> getCurrentStatut(Long demandeId) {
        return demandeStatutService.getLatestStatutByDemandeId(demandeId);
    }
}
