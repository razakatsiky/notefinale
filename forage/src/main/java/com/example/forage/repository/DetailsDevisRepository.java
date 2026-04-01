package com.example.forage.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.forage.model.DetailsDevis;

public interface DetailsDevisRepository extends JpaRepository<DetailsDevis, Long> {

    List<DetailsDevis> findByDevisId(Long devisId);

}