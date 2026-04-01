package com.example.forage.service;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.forage.model.TypeDevis;
import com.example.forage.repository.TypeDevisRepository;

@Service
public class TypeDevisService {
    
    @Autowired
    private TypeDevisRepository typeDevisRepository;
    
    public List<TypeDevis> getAllTypeDevis() {
        return typeDevisRepository.findAll();
    }
    
    public Optional<TypeDevis> getTypeDevisById(Long id) {
        return typeDevisRepository.findById(id);
    }
    
    public TypeDevis saveTypeDevis(TypeDevis typeDevis) {
        return typeDevisRepository.save(typeDevis);
    }
    
    public TypeDevis updateTypeDevis(Long id, TypeDevis typeDevisDetails) {
        TypeDevis typeDevis = typeDevisRepository.findById(id)
            .orElseThrow(() -> new RuntimeException("Type devis non trouvé avec l'ID: " + id));
        
        typeDevis.setLibelle(typeDevisDetails.getLibelle());
        
        return typeDevisRepository.save(typeDevis);
    }
    
    public void deleteTypeDevis(Long id) {
        typeDevisRepository.deleteById(id);
    }
}
