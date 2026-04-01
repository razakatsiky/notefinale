package com.example.forage.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.forage.model.Client;
import com.example.forage.service.ClientService;

@Controller
@RequestMapping("/clients")
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
        return "redirect:/clients";
    }
    
    @GetMapping("/edit/{id}")
    public String editClientForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        try {
            Client client = clientService.getClientById(id).orElse(null);
            if (client == null) {
                redirectAttributes.addFlashAttribute("error", "Client non trouvé");
                return "redirect:/clients";
            }
            model.addAttribute("client", client);
            model.addAttribute("title", "Modifier un Client");
            return "forage/clients/form";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
            return "redirect:/clients";
        }
    }
    
    @PostMapping("/edit/{id}")
    public String updateClient(@PathVariable Long id, @ModelAttribute Client client, RedirectAttributes redirectAttributes) {
        try {
            Client existingClient = clientService.getClientById(id).orElse(null);
            if (existingClient == null) {
                redirectAttributes.addFlashAttribute("error", "Client non trouvé");
                return "redirect:/clients";
            }
            existingClient.setNom(client.getNom());
            existingClient.setContact(client.getContact());
            clientService.updateClient(id, existingClient);
            redirectAttributes.addFlashAttribute("success", "Client modifié avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/clients";
    }
    
    @GetMapping("/delete/{id}")
    public String deleteClient(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            clientService.deleteClient(id);
            redirectAttributes.addFlashAttribute("success", "Client supprimé avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la suppression du client: " + e.getMessage());
        }
        return "redirect:/clients";
    }
}
