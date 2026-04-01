package com.example.forage.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.forage.model.TypeDevis;

@Repository
public interface TypeDevisRepository extends JpaRepository<TypeDevis, Long> {
}
