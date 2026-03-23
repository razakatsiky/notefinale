package com.example.forage.repository;

import com.example.forage.model.Client;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ClientRepository extends JpaRepository<Client, Long> {
    
    List<Client> findByNomContaining(String nom);
    
    Optional<Client> findByContact(String contact);
    
    boolean existsByNom(String nom);
    
    boolean existsByContact(String contact);
}
