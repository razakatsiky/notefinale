package com.example.notefinale.service;

import com.example.notefinale.model.Correcteur;
import com.example.notefinale.repository.CorrecteurRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CorrecteurService {

    @Autowired
    private CorrecteurRepository correcteurRepository;

    public List<Correcteur> getAllCorrecteurs() {
        return correcteurRepository.findAll();
    }

    public Optional<Correcteur> getCorrecteurById(Long id) {
        return correcteurRepository.findById(id);
    }

    public Correcteur saveCorrecteur(Correcteur correcteur) {
        return correcteurRepository.save(correcteur);
    }

    public void deleteCorrecteur(Long id) {
        correcteurRepository.deleteById(id);
    }
}
