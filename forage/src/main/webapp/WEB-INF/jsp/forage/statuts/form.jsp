<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    <style>
/* Élégant CSS minimaliste - Tout en noir */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    color: black;
    background-color: white;
    line-height: 1.6;
    padding: 0;
    font-weight: 400;
    letter-spacing: 0.01em;
}

/* Navbar épurée */
.header {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    z-index: 1000;
    background: white;
    border-bottom: 1px solid rgba(0, 0, 0, 0.08);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.header .container {
    max-width: 100%;
    padding: 0 32px;
}

.header h1 {
    color: black;
    margin: 0;
    font-size: 1.5rem;
    font-weight: 600;
    padding: 16px 0;
}

.navbar {
    position: fixed;
    top: 60px;
    left: 0;
    right: 0;
    text-align: right;
    border-bottom: 1px solid rgba(0, 0, 0, 0.08);
    background: white;
    padding: 8px 32px;
    z-index: 999;
}

.navbar-links {
    display: inline-flex;
    align-items: center;
    gap: 0;
}

.nav-button {
    color: #333;
    text-decoration: none;
    padding: 16px 20px;
    display: block;
    transition: all 0.2s ease;
    font-size: 14px;
    font-weight: 500;
    letter-spacing: 0.3px;
    border: none;
    position: relative;
    border-bottom: 3px solid transparent;
}

.nav-button::after {
    content: '';
    position: absolute;
    bottom: -3px;
    left: 0;
    right: 0;
    height: 3px;
    background: #000;
    transform: scaleX(0);
    transition: transform 0.2s ease;
    transform-origin: center;
}

.nav-button:hover::after {
    transform: scaleX(1);
}

.nav-button:hover {
    color: #000;
}

/* Main content */
.container {
    margin-top: 120px;
    padding: 40px 32px;
    max-width: 1200px;
    margin-left: auto;
    margin-right: auto;
}

.main-content {
    margin-top: 180px;
    padding: 40px 32px;
    max-width: 600px;
    margin-left: auto;
    margin-right: auto;
}

/* Typographie élégante */
h1, h2, h3, h4, h5, h6 {
    color: black;
    margin-bottom: 16px;
    font-weight: 500;
    line-height: 1.3;
    letter-spacing: -0.02em;
}

h1 {
    font-size: 2.5rem;
    font-weight: 600;
    margin-bottom: 24px;
}

h2 {
    font-size: 2rem;
    margin-top: 40px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    padding-bottom: 8px;
}

h3 {
    font-size: 1.5rem;
    margin-top: 32px;
}

p {
    color: black;
    margin-bottom: 20px;
    font-size: 1.1rem;
}

/* Liens élégants */
a {
    color: black;
    text-decoration: none;
    border-bottom: 1px solid rgba(0, 0, 0, 0.3);
    transition: border-color 0.2s ease;
}

a:hover {
    border-bottom-color: black;
    text-decoration: none;
}

/* Formulaires épurés */
input, textarea, select {
    border: 1px solid rgba(0, 0, 0, 0.2);
    border-radius: 6px;
    padding: 10px 12px;
    color: black;
    background-color: white;
    font-size: 1rem;
    transition: border-color 0.2s ease;
    width: 100%;
    max-width: 400px;
}

input:focus, textarea:focus, select:focus {
    outline: none;
    border-color: black;
}

.btn {
    border: 1px solid black;
    border-radius: 6px;
    padding: 10px 24px;
    color: black;
    background-color: white;
    cursor: pointer;
    font-size: 0.95rem;
    font-weight: 500;
    transition: all 0.2s ease;
    text-decoration: none;
    display: inline-block;
    margin: 2px;
}

.btn:hover {
    background-color: black;
    color: white;
    text-decoration: none;
}

.btn-success {
    border: 1px solid #27ae60;
    color: #27ae60;
}

.btn-success:hover {
    background-color: #27ae60;
    color: white;
}

.btn-danger {
    border: 1px solid #e74c3c;
    color: #e74c3c;
}

.btn-danger:hover {
    background-color: #e74c3c;
    color: white;
}

.btn-secondary {
    border: 1px solid #6c757d;
    color: #6c757d;
}

.btn-secondary:hover {
    background-color: #6c757d;
    color: white;
}

.form-group {
    margin-bottom: 20px;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: bold;
    color: black;
}

/* Alerts */
.success {
    padding: 16px 20px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-weight: 500;
    border-left: 4px solid #27ae60;
    background: rgba(39, 174, 96, 0.1);
    color: #27ae60;
}

.error {
    padding: 16px 20px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-weight: 500;
    border-left: 4px solid #e74c3c;
    background: rgba(231, 76, 60, 0.1);
    color: #e74c3c;
}

.alert {
    padding: 16px 20px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-weight: 500;
}

.alert-success {
    border-left: 4px solid #27ae60;
    background: rgba(39, 174, 96, 0.1);
    color: #27ae60;
}

.alert-danger {
    border-left: 4px solid #e74c3c;
    background: rgba(231, 76, 60, 0.1);
    color: #e74c3c;
}

.form-container {
    background: white;
    padding: 32px;
    border-radius: 8px;
    border: 1px solid rgba(0, 0, 0, 0.1);
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.form-actions {
    margin-top: 32px;
    padding-top: 20px;
    border-top: 1px solid rgba(0, 0, 0, 0.1);
}

.back-link {
    display: inline-block;
    margin-top: 20px;
    color: black;
    text-decoration: none;
    border-bottom: 1px solid rgba(0, 0, 0, 0.3);
    transition: border-color 0.2s ease;
}

.back-link:hover {
    border-bottom-color: black;
}

/* Responsive */
@media (max-width: 768px) {
    .header {
        padding: 12px 20px;
    }
    
    .navbar {
        padding: 8px 20px;
    }
    
    .navbar-links {
        flex-wrap: wrap;
        gap: 4px;
    }
    
    .nav-button {
        padding: 8px 12px;
        font-size: 13px;
    }
    
    .container, .main-content {
        margin-top: 140px;
        padding: 24px 20px;
    }
    
    h1 {
        font-size: 2rem;
    }
    
    h2 {
        font-size: 1.75rem;
    }
    
    p {
        font-size: 1rem;
    }
}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>${title}</h1>
        </div>
        
        <div class="navbar">
            <div class="navbar-links">
                <a href="/forage" class="nav-button">Accueil</a>
                <a href="/forage/clients" class="nav-button">Clients</a>
                <a href="/forage/demandes" class="nav-button">Demandes</a>
                <a href="/forage/statuts" class="nav-button">Statuts</a>
            </div>
        </div>
        
        <div class="main-content">
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            
            <div class="form-container">
                <form action="<c:if test="${statut.id != null}">/forage/statuts/update/${statut.id}</c:if><c:if test="${statut.id == null}">/forage/statuts</c:if>" 
                      method="post">
                    
                    <div class="form-group">
                        <label for="nom">Nom du statut :</label>
                        <input type="text" 
                               id="nom" 
                               name="nom" 
                               value="${statut.nom}"
                               required 
                               maxlength="50"
                               placeholder="Ex: créé, en cours, terminé...">
                    </div>
                    
                    <div class="form-actions">
                        <button type="submit" class="btn btn-success">
                            <c:if test="${statut.id == null}">Ajouter</c:if>
                            <c:if test="${statut.id != null}">Modifier</c:if>
                        </button>
                        <a href="/forage/statuts" class="btn btn-secondary">Annuler</a>
                    </div>
                </form>
            </div>
            
            <a href="/forage/statuts" class="back-link">← Retour à la liste des statuts</a>
        </div>
    </div>
</body>
</html>
