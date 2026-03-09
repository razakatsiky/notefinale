<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Erreur</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .error { color: red; background: #ffe6e6; padding: 20px; border-radius: 5px; white-space: pre-wrap; font-family: monospace; }
        .links { margin: 20px 0; }
        .links a { margin-right: 15px; padding: 8px 15px; background: #007bff; color: white; text-decoration: none; border-radius: 3px; }
    </style>
</head>
<body>
    <h1>Erreur Détailée</h1>
    <div class="error">${error}</div>
    
    <div class="links">
        <a href="/notes-crud/new">Retour au formulaire</a> | 
        <a href="/candidats">Voir les candidats</a> |
        <a href="/matieres">Voir les matières</a> |
        <a href="/correcteurs">Voir les correcteurs</a>
    </div>
</body>
</html>
