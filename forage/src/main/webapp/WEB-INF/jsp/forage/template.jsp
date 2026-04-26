<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

/* Conteneur principal */
.container {
    margin-top: 120px;
    padding: 40px 32px;
    max-width: 1200px;
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

/* Boutons standard */
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
}

.btn:hover {
    background-color: black;
    color: white;
    text-decoration: none;
}

/* Alerts */
/* .message {
    padding: 16px 20px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-weight: 500;
    border-left: 4px solid;
}

.message.success {
    border-color: #27ae60;
    background: rgba(39, 174, 96, 0.1);
    color: #27ae60;
}

.message.error {
    border-color: #e74c3c;
    background: rgba(231, 76, 60, 0.1);
    color: #e74c3c;
} */

/* Responsive */
@media (max-width: 768px) {
    .header .container {
        padding: 0 16px;
    }
    
    .navbar {
        padding: 8px 16px;
    }
    
    .nav-button {
        padding: 12px 10px;
        font-size: 13px;
    }
    
    .container {
        margin-top: 140px;
        padding: 24px 16px;
    }
}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <div class="container" style="margin-top: 0; padding: 0 32px;">
                <h1>${empty param.headerTitle ? 'Système de Forage - ETU3637' : param.headerTitle}</h1>
            </div>
        </div>
        
        <div class="navbar">
            <div class="navbar-links">
                <a href="/forage/" class="nav-button">Accueil</a>
                <a href="/forage/clients" class="nav-button">Clients</a>
                <a href="/forage/demandes" class="nav-button">Demandes</a>
                <a href="/forage/demande-statuts" class="nav-button">Demande-Statuts</a>
                <a href="/forage/type-devis" class="nav-button">Types Devis</a>
                <a href="/forage/devis" class="nav-button">Devis</a>
                <a href="/forage/statuts" class="nav-button">Statuts</a>
                <a href="${pageContext.request.contextPath}/chiffre-affaire" class="nav-button">Chiffre d'Affaire</a>
            </div>
        </div>
        
        <div class="content">
            <div class="message">${message}</div>
        </div>
    </div>
</body>
</html>
