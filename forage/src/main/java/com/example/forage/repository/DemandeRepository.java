package com.example.forage.repository;

import com.example.forage.model.Demande;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface DemandeRepository extends JpaRepository<Demande, Long> {
    
    List<Demande> findByClientId(Long clientId);
    
    List<Demande> findByLieuContaining(String lieu);
    
    List<Demande> findByDateDemandeBetween(LocalDate startDate, LocalDate endDate);
    
    @Query("SELECT d FROM Demande d WHERE d.client.nom LIKE %:nom%")
    List<Demande> findByClientNomContaining(@Param("nom") String nom);
    
    @Query("SELECT d FROM Demande d WHERE d.lieu LIKE %:lieu% AND d.dateDemande >= :date")
    List<Demande> findByLieuAndDateAfter(@Param("lieu") String lieu, @Param("date") LocalDate date);
}
