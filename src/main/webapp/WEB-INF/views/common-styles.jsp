<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    text-align: right;
    border-bottom: 1px solid rgba(0, 0, 0, 0.08);
    background: white;
    padding: 8px 32px;
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
    margin-top: 120px;
    padding: 40px 32px;
    max-width: 900px;
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

/* Tables minimalistes */
table {
    width: 100%;
    border-collapse: collapse;
    margin: 32px 0;
    font-size: 0.95rem;
}

th, td {
    border: none;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    padding: 12px 8px;
    text-align: left;
    color: black;
}

th {
    background-color: transparent;
    font-weight: 600;
    border-bottom-width: 2px;
    text-transform: uppercase;
    font-size: 0.85rem;
    letter-spacing: 0.03em;
}

tr:hover {
    background-color: rgba(0, 0, 0, 0.02);
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

.result {
    border: 1px solid rgba(0, 0, 0, 0.1);
    padding: 20px;
    margin-top: 20px;
    border-radius: 8px;
}

.note-finale {
    font-size: 24px;
    font-weight: bold;
    text-align: center;
    margin: 20px 0;
}

.notes-list {
    margin-top: 20px;
}

.note-item {
    border: 1px solid rgba(0, 0, 0, 0.1);
    padding: 10px;
    margin: 5px 0;
    border-left: 2px solid black;
    border-radius: 4px;
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

.actions {
    white-space: nowrap;
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
