package com.example.forage.repository;

import com.example.forage.model.Statut;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StatutRepository extends JpaRepository<Statut, Long> {
    
    Optional<Statut> findByNom(String nom);
}
