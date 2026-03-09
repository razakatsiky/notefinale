package com.example.notefinale.controller;

import com.example.notefinale.model.Resolution;
import com.example.notefinale.service.ResolutionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/resolutions")
public class ResolutionController {

    @Autowired
    private ResolutionService resolutionService;

    @GetMapping
    public String listResolutions(Model model) {
        model.addAttribute("resolutions", resolutionService.getAllResolutions());
        return "resolutions/list";
    }

    @GetMapping("/new")
    public String createResolutionForm(Model model) {
        model.addAttribute("resolution", new Resolution());
        return "resolutions/form";
    }

    @PostMapping
    public String saveResolution(@ModelAttribute Resolution resolution) {
        resolutionService.saveResolution(resolution);
        return "redirect:/resolutions";
    }

    @GetMapping("/edit/{id}")
    public String editResolutionForm(@PathVariable Long id, Model model) {
        model.addAttribute("resolution", resolutionService.getResolutionById(id).orElse(null));
        return "resolutions/form";
    }

    @GetMapping("/delete/{id}")
    public String deleteResolution(@PathVariable Long id) {
        resolutionService.deleteResolution(id);
        return "redirect:/resolutions";
    }
}
