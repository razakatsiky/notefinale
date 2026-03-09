package com.example.notefinale.repository;

import com.example.notefinale.model.Parametre;
import com.example.notefinale.model.Matiere;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ParametreRepository extends JpaRepository<Parametre, Long> {
    
    @Query("SELECT p FROM Parametre p WHERE p.matiere.id = :matiereId")
    List<Parametre> findByMatiereId(@Param("matiereId") Long matiereId);
}
