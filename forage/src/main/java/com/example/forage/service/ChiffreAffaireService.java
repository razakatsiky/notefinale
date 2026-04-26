package com.example.forage.service;

import java.math.BigDecimal;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.Query;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.forage.model.Devis;
import com.example.forage.repository.DevisRepository;

@Service
public class ChiffreAffaireService {
    
    @Autowired
    private DevisRepository devisRepository;
    
    @Autowired
    private EntityManager entityManager;
    
    /**
     * Calcule le chiffre d'affaire total avec votre requête SQL
     */
    public BigDecimal getChiffreAffaireTotal() {
        Query query = entityManager.createNativeQuery(
            "SELECT SUM((prix_unitaire - remise_unitaire) * quantite) as total FROM details_devis"
        );
        
        Object result = query.getSingleResult();
        if (result != null) {
            return new BigDecimal(result.toString());
        }
        return BigDecimal.ZERO;
    }
    
    /**
     * Récupère le nombre total de devis
     */
    public int getNombreDevis() {
        List<Devis> devis = devisRepository.findAll();
        return devis.size();
    }
}
