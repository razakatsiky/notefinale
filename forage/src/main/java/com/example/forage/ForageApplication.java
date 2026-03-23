package com.example.forage;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;

@SpringBootApplication
public class ForageApplication {

    public static void main(String[] args) {
        SpringApplication.run(ForageApplication.class, args);
        System.out.println("Application Forage démarrée avec succès !");
        System.out.println("Accès: http://localhost:8080/forage/clients");
    }
}
