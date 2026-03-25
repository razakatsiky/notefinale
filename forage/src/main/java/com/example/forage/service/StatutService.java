package com.example.forage.service;

import com.example.forage.model.Statut;
import com.example.forage.repository.StatutRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class StatutService {
    
    @Autowired
    private StatutRepository statutRepository;
    
    public List<Statut> getAllStatuts() {
        return statutRepository.findAll();
    }
    
    public Optional<Statut> getStatutById(Long id) {
        return statutRepository.findById(id);
    }
    
    public Optional<Statut> getStatutByNom(String nom) {
        return statutRepository.findByNom(nom);
    }
    
    public Statut saveStatut(Statut statut) {
        // S'assurer que libelle est initialisé si null
        if (statut.getLibelle() == null) {
            statut.setLibelle(statut.getNom());
        }
        return statutRepository.save(statut);
    }
    
    public void deleteStatut(Long id) {
        statutRepository.deleteById(id);
    }
    
    public Statut getOrCreateStatut(String nom) {
        return getStatutByNom(nom).orElseGet(() -> saveStatut(new Statut(nom)));
    }
}
