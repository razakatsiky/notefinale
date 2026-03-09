package com.example.notefinale.service;

import com.example.notefinale.model.Parametre;
import com.example.notefinale.repository.ParametreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ParametreService {

    @Autowired
    private ParametreRepository parametreRepository;

    public List<Parametre> getAllParametres() {
        return parametreRepository.findAll();
    }

    public Optional<Parametre> getParametreById(Long id) {
        return parametreRepository.findById(id);
    }

    public Parametre saveParametre(Parametre parametre) {
        return parametreRepository.save(parametre);
    }

    public void deleteParametre(Long id) {
        parametreRepository.deleteById(id);
    }
}
