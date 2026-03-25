package com.example.forage.repository;

import com.example.forage.model.DemandeStatut;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DemandeStatutRepository extends JpaRepository<DemandeStatut, Long> {
    
    List<DemandeStatut> findByDemandeIdOrderByDateStatutDesc(Long demandeId);
    
    @Query("SELECT ds FROM DemandeStatut ds WHERE ds.demande.id = :demandeId ORDER BY ds.dateStatut DESC")
    Optional<DemandeStatut> findLatestByDemandeId(@Param("demandeId") Long demandeId);
    
    List<DemandeStatut> findByStatutIdOrderByDateStatutDesc(Long statutId);
}
