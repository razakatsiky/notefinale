package com.example.forage.repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.forage.model.ParametreRemise;

@Repository
public interface ParametreRemiseRepository extends JpaRepository<ParametreRemise, Long> {

    /**
     * Trouve tous les paramètres de remise actifs
     */
    List<ParametreRemise> findByActifTrue();

    /**
     * Trouve le premier paramètre de remise applicable pour un prix donné
     */
    @Query("SELECT pr FROM ParametreRemise pr WHERE pr.actif = true AND " +
           "((pr.operateur = '>=' AND ?1 >= pr.seuilPrix) OR " +
           "(pr.operateur = '>' AND ?1 > pr.seuilPrix) OR " +
           "(pr.operateur = '<=' AND ?1 <= pr.seuilPrix) OR " +
           "(pr.operateur = '<' AND ?1 < pr.seuilPrix)) " +
           "ORDER BY pr.seuilPrix DESC")
    Optional<ParametreRemise> findApplicableRemise(BigDecimal prix);

    /**
     * Trouve tous les paramètres de remise applicables pour un prix donné
     */
    @Query("SELECT pr FROM ParametreRemise pr WHERE pr.actif = true AND " +
           "((pr.operateur = '>=' AND ?1 >= pr.seuilPrix) OR " +
           "(pr.operateur = '>' AND ?1 > pr.seuilPrix) OR " +
           "(pr.operateur = '<=' AND ?1 <= pr.seuilPrix) OR " +
           "(pr.operateur = '<' AND ?1 < pr.seuilPrix)) " +
           "ORDER BY pr.seuilPrix DESC")
    List<ParametreRemise> findAllApplicableRemises(BigDecimal prix);
}
