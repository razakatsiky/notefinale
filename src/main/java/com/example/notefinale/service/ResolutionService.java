package com.example.notefinale.service;

import com.example.notefinale.model.Resolution;
import com.example.notefinale.repository.ResolutionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ResolutionService {

    @Autowired
    private ResolutionRepository resolutionRepository;

    public List<Resolution> getAllResolutions() {
        return resolutionRepository.findAll();
    }

    public Optional<Resolution> getResolutionById(Long id) {
        return resolutionRepository.findById(id);
    }

    public Resolution saveResolution(Resolution resolution) {
        return resolutionRepository.save(resolution);
    }

    public void deleteResolution(Long id) {
        resolutionRepository.deleteById(id);
    }
}
