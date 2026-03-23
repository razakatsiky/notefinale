package com.example.forage.controller;

import com.example.forage.model.Client;
import com.example.forage.service.ClientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/forage/clients")
public class ClientController {
    @Autowired
    private ClientService clientService;
    
        
    
    @GetMapping
    public String listClients(Model model) {
        List<Client> clients = clientService.getAllClients();
        model.addAttribute("clients", clients);
        model.addAttribute("title", "Liste des Clients");
        return "forage/clients/list";
    }
    
    @GetMapping("/new")
    public String createClientForm(Model model) {
        model.addAttribute("client", new Client());
        model.addAttribute("title", "Ajouter un Client");
        return "forage/clients/form";
    }
    
    @PostMapping
    public String saveClient(@ModelAttribute Client client, RedirectAttributes redirectAttributes) {
        try {
            if (client.getId() != null) {
                // U
                Client existingClient = clientService.getClientById(client.getId()).orElse(null);
                if (existingClient != null) {
                    existingClient.setNom(client.getNom());
                    existingClient.setContact(client.getContact());
                    clientService.updateClient(client.getId(), existingClient);
                    redirectAttributes.addFlashAttribute("success", "Client modifié avec succès");
                } else {
                    redirectAttributes.addFlashAttribute("error", "Client non trouvé");
                }
            } else {
                // C
                clientService.saveClient(client);
                redirectAttributes.addFlashAttribute("success", "Client ajouté avec succès");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/forage/clients";
    }
    
    @GetMapping("/edit/{id}")
    public String editClientForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Client client = clientService.getClientById(id).orElse(null);
            if (client == null) {
                redirectAttributes.addFlashAttribute("error", "Client non trouvé");
                return "redirect:/forage/clients";
            }
            model.addAttribute("client", client);
            model.addAttribute("title", "Modifier un Client");
            return "forage/clients/form";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
            return "redirect:/forage/clients";
        }
    }
    
    @GetMapping("/delete/{id}")
    public String deleteClient(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            clientService.deleteClient(id);
            redirectAttributes.addFlashAttribute("success", "Client supprimé avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression du client: " + e.getMessage());
        }
        return "redirect:/forage/clients";
    }
}
