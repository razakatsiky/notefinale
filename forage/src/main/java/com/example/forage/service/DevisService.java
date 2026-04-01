package com.example.forage.service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.forage.model.DetailsDevis;
import com.example.forage.model.Devis;
import com.example.forage.repository.DetailsDevisRepository;
import com.example.forage.repository.DevisRepository;

@Service
public class DevisService {
    
    @Autowired
    private DevisRepository devisRepository;
    
    @Autowired
    private DetailsDevisRepository detailsDevisRepository;
    
    public List<Devis> getAllDevis() {
        return devisRepository.findAll();
    }
    
    public Optional<Devis> getDevisById(Long id) {
        return devisRepository.findByIdWithDetails(id);
    }
    
    public List<Devis> getDevisByDemandeId(Long demandeId) {
        return devisRepository.findByDemandeId(demandeId);
    }
    
    public List<Devis> getDevisByClientId(Long clientId) {
        return devisRepository.findByClientId(clientId);
    }
    
    public List<Devis> getDevisByDateBetween(LocalDate dateDebut, LocalDate dateFin) {
        return devisRepository.findByDateDevisBetween(dateDebut, dateFin);
    }
    

    
    @Transactional
    public Devis saveDevis(Devis devis) {
        System.out.println("=== DevisService.saveDevis ===");
        
        if (devis.getDetailsDevis() != null && !devis.getDetailsDevis().isEmpty()) {
            System.out.println("Devis has " + devis.getDetailsDevis().size() + " details");
            for (int i = 0; i < devis.getDetailsDevis().size(); i++) {
                DetailsDevis detail = devis.getDetailsDevis().get(i);
                System.out.println("  Detail " + i + ": libelle=" + detail.getLibelle() + 
                    ", prixUnitaire=" + (detail.getPrixUnitaire() != null ? detail.getPrixUnitaire() : "null") + 
                    ", quantite=" + (detail.getQuantite() != null ? detail.getQuantite() : "null"));
                detail.setDevis(devis);
            }
            
            Devis savedDevis = devisRepository.save(devis);
            System.out.println("Devis saved with ID: " + savedDevis.getId());
            System.out.println("Details should be cascaded: " + (savedDevis.getDetailsDevis() != null ? savedDevis.getDetailsDevis().size() : 0));
            
            for (DetailsDevis detail : savedDevis.getDetailsDevis()) {
                detail.setDevis(savedDevis);
                DetailsDevis savedDetail = detailsDevisRepository.save(detail);
                System.out.println("Detail saved: id=" + savedDetail.getId() + ", libelle=" + savedDetail.getLibelle());
            }

            return savedDevis;
        } else {
            System.out.println("No details in devis");
            Devis savedDevis = devisRepository.save(devis);
            System.out.println("Devis saved without details, ID: " + savedDevis.getId());
            return savedDevis;
        }
    }
    
    @Transactional
    public Devis updateDevis(Long id, Devis devisDetails) {
        Devis devis = devisRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Devis non trouvé avec l'ID: " + id));
        
        devis.setDemande(devisDetails.getDemande());
        devis.setTypeDevis(devisDetails.getTypeDevis());
        devis.setDateDevis(devisDetails.getDateDevis());
        devis.setLieu(devisDetails.getLieu());
        devis.setClient(devisDetails.getClient());
        
        if (devisDetails.getDetailsDevis() != null) {
            devis.getDetailsDevis().clear();
            devis.getDetailsDevis().addAll(devisDetails.getDetailsDevis());
        }
        
        return devisRepository.save(devis);
    }
    
    @Transactional
    public void deleteDevis(Long id) {
        devisRepository.deleteById(id);
    }
    
    // @Transactional
    // public DetailsDevis addDetailDevis(Long devisId, DetailsDevis detail) {
    //     try {
    //         System.out.println("=== addDetailDevis ===");
    //         System.out.println("devisId: " + devisId);
    //         System.out.println("detail libelle: " + detail.getLibelle());
    //         System.out.println("detail quantite: " + detail.getQuantite());
    //         System.out.println("detail prixUnitaire: " + detail.getPrixUnitaire());

    //         Devis devis = devisRepository.findById(devisId)
    //                 .orElseThrow(() -> new RuntimeException("Devis non trouvé avec l'ID: " + devisId));

    //         detail.setDevis(devis);

    //         DetailsDevis savedDetail = detailsDevisRepository.save(detail);

    //         if (devis.getDetailsDevis() == null) {
    //             devis.setDetailsDevis(new java.util.ArrayList<>());
    //         }
    //         devis.getDetailsDevis().add(savedDetail);

    //         System.out.println("Detail saved successfully with ID: " + savedDetail.getId());
    //         return savedDetail;
    //     } catch (Exception e) {
    //         System.out.println("ERROR in addDetailDevis: " + e.getMessage());
    //         e.printStackTrace();
    //         throw e;
    //     }
    // }
    
   @Transactional
public DetailsDevis addDetailDevis(Long devisId, DetailsDevis detail) {

    Devis devis = devisRepository.findById(devisId)
            .orElseThrow(() -> new RuntimeException("Devis introuvable"));

    detail.setDevis(devis);

    return detailsDevisRepository.save(detail);
}


    @Transactional
    public DetailsDevis updateDetailDevis(Long detailId, DetailsDevis detailDetails) {
        DetailsDevis detail = detailsDevisRepository.findById(detailId)
            .orElseThrow(() -> new RuntimeException("Détail devis non trouvé avec l'ID: " + detailId));
        
        detail.setLibelle(detailDetails.getLibelle());
        detail.setPrixUnitaire(detailDetails.getPrixUnitaire());
        detail.setQuantite(detailDetails.getQuantite());
        
        return detailsDevisRepository.save(detail);
    }
    
    @Transactional
    public void deleteDetailDevis(Long detailId) {
        DetailsDevis detail = detailsDevisRepository.findById(detailId)
            .orElseThrow(() -> new RuntimeException("Détail devis non trouvé avec l'ID: " + detailId));
        
        detailsDevisRepository.delete(detail);
    }

    
}
