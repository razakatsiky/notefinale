package com.example.forage;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class ForageApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(ForageApplication.class, args);
        System.out.println("Application Forage démarrée avec succès !");
        System.out.println("Accès: http://localhost:8080/forage/");
    }
    
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(ForageApplication.class);
    }
}
