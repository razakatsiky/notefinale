package com.example.forage.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.forage.model.Devis;

@Repository
public interface DevisRepository extends JpaRepository<Devis, Long> {
    
    @Query("SELECT d FROM Devis d LEFT JOIN FETCH d.detailsDevis WHERE d.id = :id")
    Optional<Devis> findByIdWithDetails(@Param("id") Long id);
    
    @Query("SELECT DISTINCT d FROM Devis d LEFT JOIN FETCH d.detailsDevis")
    List<Devis> findAllWithDetails();
    
    List<Devis> findByDemandeId(Long demandeId);
    
    List<Devis> findByTypeDevisId(Long typeDevisId);
    
    @Query("SELECT d FROM Devis d WHERE d.demande.client.id = :clientId")
    List<Devis> findByClientId(@Param("clientId") Long clientId);
    
    @Query("SELECT d FROM Devis d WHERE d.dateDevis BETWEEN :dateDebut AND :dateFin")
    List<Devis> findByDateDevisBetween(@Param("dateDebut") java.time.LocalDate dateDebut, 
                                       @Param("dateFin") java.time.LocalDate dateFin);
}
