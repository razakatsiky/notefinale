package com.example.forage.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.forage.model.ParametreRemise;
import com.example.forage.repository.ParametreRemiseRepository;

@Service
public class ParametreRemiseService {

    @Autowired
    private ParametreRemiseRepository parametreRemiseRepository;


    public Optional<ParametreRemise> findMeilleureRemise(BigDecimal prix) {
        return parametreRemiseRepository.findApplicableRemise(prix);
    }


    public BigDecimal calculerRemise(BigDecimal prix) {
        Optional<ParametreRemise> remiseOpt = findMeilleureRemise(prix);
        if (remiseOpt.isPresent()) {
            return remiseOpt.get().calculerRemise(prix);
        }
        return BigDecimal.ZERO;
    }

    public BigDecimal calculerPrixApresRemise(BigDecimal prix) {
        Optional<ParametreRemise> remiseOpt = findMeilleureRemise(prix);
        if (remiseOpt.isPresent()) {
            return remiseOpt.get().calculerPrixApresRemise(prix);
        }
        return prix;
    }


    public boolean estEligibleRemise(BigDecimal prix) {
        return findMeilleureRemise(prix).isPresent();
    }


    public List<ParametreRemise> findAllRemisesApplicables(BigDecimal prix) {
        return parametreRemiseRepository.findAllApplicableRemises(prix);
    }

 
    @Transactional
    public ParametreRemise saveParametreRemise(ParametreRemise parametreRemise) {
        return parametreRemiseRepository.save(parametreRemise);
    }

 
    public List<ParametreRemise> findAllParametreRemises() {
        return parametreRemiseRepository.findAll();
    }


    public List<ParametreRemise> findParametreRemisesActives() {
        return parametreRemiseRepository.findByActifTrue();
    }

    public ParametreRemise findParametreRemiseById(Long id) {
        return parametreRemiseRepository.findById(id).orElse(null);
    }

  
    @Transactional
    public void deleteParametreRemise(Long id) {
        parametreRemiseRepository.deleteById(id);
    }

  
    @Transactional
    public ParametreRemise toggleActif(Long id) {
        ParametreRemise parametre = findParametreRemiseById(id);
        if (parametre != null) {
            parametre.setActif(!parametre.getActif());
            return saveParametreRemise(parametre);
        }
        return null;
    }
}
