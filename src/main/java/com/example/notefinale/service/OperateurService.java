package com.example.notefinale.service;

import com.example.notefinale.model.Operateur;
import com.example.notefinale.repository.OperateurRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class OperateurService {

    @Autowired
    private OperateurRepository operateurRepository;

    public List<Operateur> getAllOperateurs() {
        return operateurRepository.findAll();
    }

    public Optional<Operateur> getOperateurById(Long id) {
        return operateurRepository.findById(id);
    }

    public Operateur saveOperateur(Operateur operateur) {
        return operateurRepository.save(operateur);
    }

    public void deleteOperateur(Long id) {
        operateurRepository.deleteById(id);
    }
}
