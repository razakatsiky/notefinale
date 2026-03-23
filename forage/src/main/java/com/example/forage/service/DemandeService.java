package com.example.forage.service;

import com.example.forage.model.Demande;
import com.example.forage.repository.DemandeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class DemandeService {
    
    @Autowired
    private DemandeRepository demandeRepository;
    
    public List<Demande> getAllDemandes() {
        return demandeRepository.findAll();
    }
    
    public Optional<Demande> getDemandeById(Long id) {
        return demandeRepository.findById(id);
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
    
    public void deleteDemande(Long id) {
        demandeRepository.deleteById(id);
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
}
