package com.example.forage.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.forage.model.DetailsDevis;
import com.example.forage.model.Devis;
import com.example.forage.repository.DetailsDevisRepository;
import com.example.forage.repository.DevisRepository;

@Service
public class DetailsDevisService {

    @Autowired
    private DetailsDevisRepository detailsDevisRepository;

    @Autowired
    private DevisRepository devisRepository;

    @Transactional
    public DetailsDevis saveDetailsDevis(Long devisId, DetailsDevis detail) {

        Devis devis = devisRepository.findById(devisId)
                .orElseThrow(() -> new RuntimeException("Devis introuvable"));

        detail.setDevis(devis);

        return detailsDevisRepository.save(detail);
    }

    public List<DetailsDevis> getDetailsByDevisId(Long devisId) {
        return detailsDevisRepository.findByDevisId(devisId);
    }

    public DetailsDevis getDetailsDevisById(Long id) {
        return detailsDevisRepository.findById(id).orElse(null);
    }

    @Transactional
    public DetailsDevis updateDetailsDevis(Long id, DetailsDevis detail) {

        DetailsDevis existing = detailsDevisRepository.findById(id).orElse(null);

        if (existing != null) {
            existing.setLibelle(detail.getLibelle());
            existing.setPrixUnitaire(detail.getPrixUnitaire());
            existing.setQuantite(detail.getQuantite());

            return detailsDevisRepository.save(existing);
        }

        return null;
    }

    @Transactional
    public void deleteDetailsDevis(Long id) {
        detailsDevisRepository.deleteById(id);
    }
}