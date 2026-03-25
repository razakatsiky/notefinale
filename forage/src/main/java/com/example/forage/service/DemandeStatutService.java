package com.example.forage.service;

import com.example.forage.model.DemandeStatut;
import com.example.forage.repository.DemandeStatutRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
public class DemandeStatutService {
    
    @Autowired
    private DemandeStatutRepository demandeStatutRepository;
    
    public List<DemandeStatut> getAllDemandeStatuts() {
        return demandeStatutRepository.findAll();
    }
    
    public Optional<DemandeStatut> getDemandeStatutById(Long id) {
        return demandeStatutRepository.findById(id);
    }
    
    public DemandeStatut saveDemandeStatut(DemandeStatut demandeStatut) {
        return demandeStatutRepository.save(demandeStatut);
    }
    
    public void deleteDemandeStatut(Long id) {
        demandeStatutRepository.deleteById(id);
    }
    
    public List<DemandeStatut> getStatutsByDemandeId(Long demandeId) {
        return demandeStatutRepository.findByDemandeIdOrderByDateStatutDesc(demandeId);
    }
    
    public Optional<DemandeStatut> getLatestStatutByDemandeId(Long demandeId) {
        return demandeStatutRepository.findLatestByDemandeId(demandeId);
    }
    
    public List<DemandeStatut> getDemandesByStatutId(Long statutId) {
        return demandeStatutRepository.findByStatutIdOrderByDateStatutDesc(statutId);
    }
}
