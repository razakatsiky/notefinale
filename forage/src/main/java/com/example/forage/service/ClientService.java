package com.example.forage.service;

import com.example.forage.model.Client;
import com.example.forage.repository.ClientRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ClientService {
    
    @Autowired
    private ClientRepository clientRepository;
    
    public List<Client> getAllClients() {
        return clientRepository.findAll();
    }
    
    public Optional<Client> getClientById(Long id) {
        return clientRepository.findById(id);
    }
    
    public Client saveClient(Client client) {
        return clientRepository.save(client);
    }
    
    public Client updateClient(Long id, Client clientDetails) {
        Optional<Client> optionalClient = clientRepository.findById(id);
        if (optionalClient.isPresent()) {
            Client client = optionalClient.get();
            client.setNom(clientDetails.getNom());
            client.setContact(clientDetails.getContact());
            return clientRepository.save(client);
        }
        return null;
    }
    
    public void deleteClient(Long id) {
        clientRepository.deleteById(id);
    }
    
    public List<Client> searchClientsByNom(String nom) {
        return clientRepository.findByNomContaining(nom);
    }
    
    public boolean existsByNom(String nom) {
        return clientRepository.existsByNom(nom);
    }
    
    public boolean existsByContact(String contact) {
        return clientRepository.existsByContact(contact);
    }
}
