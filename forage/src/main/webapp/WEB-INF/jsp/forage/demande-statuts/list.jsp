<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Demandes - Statuts</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #fafafa;
            color: #333;
            line-height: 1.6;
        }

        /* Header */
        .header {
            position: sticky;
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

        /* Navbar */
        .navbar {
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

/* Statistiques modernes et élégantes */
.page-title {
    font-size: 1.8rem;
    font-weight: 700;
    color: #111;
    margin-bottom: 4px;
}

.page-subtitle {
    font-size: 1rem;
    color: #666;
    margin-bottom: 32px;
}

.stats-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 16px;
    margin-bottom: 32px;
}

.stat-card {
    background: white;
    border: 1px solid #eef0f2;
    border-radius: 12px;
    padding: 20px;
    display: flex;
    align-items: center;
    gap: 16px;
    text-decoration: none;
    color: inherit;
    transition: all 0.2s ease;
    box-shadow: 0 2px 4px rgba(0,0,0,0.02);
}

.stat-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 8px 16px rgba(0,0,0,0.06);
    border-color: #ddd;
}

.stat-icon-wrapper {
    width: 44px;
    height: 44px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.2rem;
    flex-shrink: 0;
}

.stat-info {
    display: flex;
    flex-direction: column;
}

.stat-title {
    font-size: 0.8rem;
    font-weight: 600;
    color: #888;
    text-transform: uppercase;
    letter-spacing: 0.5px;
}

.stat-value {
    font-size: 1.6rem;
    font-weight: 700;
    color: #111;
    line-height: 1.2;
}

/* Couleurs des icônes */
.statut-cree { background: rgba(52, 152, 219, 0.1); color: #3498db; }
.statut-confirme { background: rgba(46, 204, 113, 0.1); color: #2ecc71; }
.statut-annule { color: #e74c3c; }
.statut-default { background: rgba(149, 165, 166, 0.1); color: #95a5a6; }

/* Main content */
.container {
    margin-top: 20px;
    padding: 40px 32px;
    max-width: 1200px;
    margin-left: auto;
    margin-right: auto;
}

        /* Messages */
        .message {
            background: #d4edda;
            color: #155724;
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 24px;
            border-left: 4px solid #28a745;
        }

        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 16px 20px;
            border-radius: 8px;
            margin-bottom: 24px;
            border-left: 4px solid #dc3545;
        }

        /* Tableau */
        .table-container {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: #f8f9fa;
            padding: 16px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #666;
            border-bottom: 2px solid #e9ecef;
        }

        td {
            padding: 16px;
            border-bottom: 1px solid #e9ecef;
            font-size: 14px;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover {
            background: #f8f9fa;
        }

        /* Statuts */
        .statut-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .statut-cree {
            background: #e3f2fd;
            color: #1976d2;
        }

        .statut-confirme {
            background: #e8f5e8;
            color: #2e7d32;
        }

        .statut-annule {
            color: #c62828;
        }

        /* Actions */
        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn {
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 500;
            transition: all 0.2s ease;
            border: none;
            cursor: pointer;
            display: inline-block;
        }

        .btn-update {
            border: 1px solid #27ae60;
        color: #27ae60;
        }

        .btn-update:hover {
            background-color: #27ae60;
            color: white;
        }

        .btn-edit {
            border: 1px solid #3498db;
            color: #3498db;
            font-size: 11px;
            padding: 4px 8px;
        }

        .btn-edit:hover {
            background-color: #3498db;
            color: white;
        }


        .btn-confirmer {
            background: #28a745;
            color: white;
        }

        .btn-confirmer:hover {
            background: #218838;
        }

        .btn-annuler {
            border: 1px solid #dc3545;
            color: #dc3545;
        }

        .btn-annuler:hover {
            background: #c82333;
        }


        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
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
            
            .container {
                margin-top: 140px;
                padding: 24px 20px;
            }
            
            table {
                font-size: 12px;
            }
            
            th, td {
                padding: 12px 8px;
            }
            
            .actions {
                flex-direction: column;
                gap: 4px;
            }
        }

        /* Conteneur principal des demandes */
        .demandes-container {
            display: flex;
            flex-direction: column;
            gap: 32px;
        }

        /* Bloc individuel de demande */
        .demande-block {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            border: 1px solid #e9ecef;
        }

        /* En-tête de demande */
        .demande-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 24px 32px;
            border-bottom: 2px solid #dee2e6;
        }

        .demande-title {
            margin: 0 0 16px 0;
            font-size: 1.5rem;
            font-weight: 700;
            color: #212529;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .demande-number {
            color: #495057;
            font-weight: 500;
        }

        .demande-meta {
            display: flex;
            gap: 24px;
            flex-wrap: wrap;
        }

        .meta-item {
            font-size: 0.9rem;
            color: #6c757d;
        }

        .meta-item strong {
            color: #495057;
        }

        /* Tableau de statuts */
        .statut-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }

        .statut-table th {
            background: #f8f9fa;
            padding: 16px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }

        .statut-table td {
            padding: 16px;
            border-bottom: 1px solid #e9ecef;
            font-size: 14px;
            vertical-align: top;
        }

        /* Lignes de statut */
        .statut-row.current-statut {
            background: #e8f5e8;
            font-weight: 600;
        }

        .statut-row.old-statut {
            background: #f8f9fa;
            opacity: 0.8;
        }

        .statut-row:hover {
            background: #e3f2fd;
        }

        .current-statut:hover {
            background: #c8e6c9;
        }

        /* Badges de statut */
        .statut-badge {
            padding: 6px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .current-label {
            background: rgba(255, 255, 255, 0.3);
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 10px;
            font-weight: 700;
        }

        .statut-cree {
            background: #6c757d;
            color: white;
        }

        .statut-confirmee {
            background: #28a745;
            color: white;
        }

        .statut-annulee {
            background: transparent !important;
            color: #dc3545;
        }

        /* Valeurs */
        .date-value {
            font-family: 'Courier New', monospace;
            font-weight: 500;
            color: #495057;
        }

        .observation-text {
            color: #212529;
            line-height: 1.5;
            font-style: italic;
        }

        /* Pas de données */
        .no-data {
            text-align: center;
            padding: 32px;
            color: #6c757d;
            font-style: italic;
        }

        /* Séparateur entre demandes */
        .demande-separator {
            height: 1px;
            background: linear-gradient(90deg, transparent 0%, #dee2e6 50%, transparent 100%);
            margin: 16px 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
        <div class="header">
            <h1>Demande Statuts</h1>
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

        <div class="demande-statuts-header" style="margin-top: 32px;">
            <h1 class="page-title">Gestion des Statuts</h1>
            <p class="page-subtitle">Suivi en temps réel de l'avancement des demandes</p>
        </div>

        <!-- Statistiques par statut (Style Minimaliste Bordé) -->
        <h2 style="font-size: 1.1rem; font-weight: 600; margin-bottom: 16px; color: #333; text-transform: uppercase; letter-spacing: 1px;">État Global des Forages</h2>
        <div style="border: 1px solid black; border-radius: 4px; display: flex; flex-wrap: wrap; width: 100%; background: white; margin-bottom: 40px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.05);">
            <!-- Case TOTAL -->
            <div style="flex: 1; min-width: 130px; border-right: 1px solid black; padding: 25px 10px; text-align: center; background: #f9f9f9; display: flex; flex-direction: column; justify-content: center;">
                <a href="${pageContext.request.contextPath}/demande-statuts" style="text-decoration: none; color: inherit; border: none; padding: 0; display: block;">
                    <div style="text-transform: uppercase; font-size: 0.65rem; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 10px; color: #111;">TOTAL</div>
                    <div style="font-size: 1.8rem; font-weight: 700; color: #000; line-height: 1; margin-bottom: 5px;">${totalGlobal}</div>
                    <div style="font-size: 0.7rem; color: #666;">global</div>
                </a>
            </div>
            
            <c:forEach var="statut" items="${allStatuts}" varStatus="loop">
                <c:set var="count" value="${statsParStatut[statut.nom]}" />
                <c:set var="isActive" value="${statut.nom == statutFiltre}" />
                <div style="flex: 1; min-width: 130px; border-right: ${loop.last ? 'none' : '1px solid black'}; padding: 25px 10px; text-align: center; background: ${isActive ? '#f1f3f5' : 'white'}; display: flex; flex-direction: column; justify-content: center; position: relative;">
                    <c:if test="${isActive}">
                        <div style="position: absolute; bottom: 0; left: 0; right: 0; height: 3px; background: black;"></div>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/demande-statuts/statut/${statut.nom}" style="text-decoration: none; color: inherit; border: none; padding: 0; display: block;">
                        <div style="text-transform: uppercase; font-size: 0.65rem; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 10px; color: ${isActive ? '#000' : '#555'};">${statut.nom}</div>
                        <div style="font-size: 1.8rem; font-weight: 700; color: #000; line-height: 1; margin-bottom: 5px;">${count != null ? count : 0}</div>
                        <div style="font-size: 0.7rem; color: #888;">demande${count > 1 ? 's' : ''}</div>
                    </a>
                </div>
            </c:forEach>
        </div>

        
        <!-- Messages -->
        <c:if test="${not empty message}">
            <div class="message">${message}</div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>
        
        <!-- Message de filtrage par statut -->
        <c:if test="${not empty statutFiltre}">
            <div style="background: #e3f2fd; color: #1e40af; padding: 16px 20px; border-radius: 8px; margin-bottom: 20px; border-left: 4px solid #1e40af;">
                <strong>Filtrage par statut : ${statutFiltre}</strong>
                <div style="margin-top: 8px; font-size: 0.9rem; color: #666;">
                    Affichage des demandes ayant le statut <strong>"${statutFiltre}"</strong>
                </div>
            </div>
        </c:if>

        <!-- Conteneur principal des demandes -->
        <div class="demandes-container">
            <c:forEach items="${demandes}" var="demande" varStatus="loop">
                <div class="demande-block">
                    <!-- Titre de la demande -->
                    <div class="demande-header">
                        <h2 class="demande-title">
                            <span class="demande-number">DEMANDE ${demande.id}</span>
                        </h2>
                        <div class="demande-meta">
                            <span class="meta-item">
                                <strong>Client:</strong> ${demande.client.nom}
                            </span>
                            <span class="meta-item">
                                <strong>Lieu:</strong> ${demande.lieu}
                            </span>
                            <span class="meta-item">
                                <strong>Date:</strong> ${demande.dateDemande.dayOfMonth}/${demande.dateDemande.monthValue}/${demande.dateDemande.year}
                            </span>
                        </div>
                    </div>

                    <!-- Tableau des statuts de cette demande -->
                    <div class="table-container">
                        <table class="statut-table">
                            <thead>
                                <tr>
                                    <th>Statut</th>
                                    <th>Date</th>
                                    <th>Observation</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:set var="historique" value="${historiqueMap[demande.id]}"/>
                                <c:if test="${empty historique}">
                                    <tr>
                                        <td colspan="4" class="no-data">
                                            <span class="statut-badge statut-cree">Aucun statut défini</span>
                                        </td>
                                    </tr>
                                </c:if>
                                
                                <c:forEach items="${historique}" var="statut" varStatus="statutLoop">
                                    <tr class="statut-row ${statutLoop.first ? 'current-statut' : 'old-statut'}">
                                        <td>
                                            <span class="statut-badge statut-${statut.statut.nom.toLowerCase()}">
                                                ${statut.statut.nom}
                                                <c:if test="${statutLoop.first}">
                                                    <span class="current-label"> (Actuel)</span>
                                                </c:if>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="date-value">
                                                ${statut.dateStatut.dayOfMonth}/${statut.dateStatut.monthValue}/${statut.dateStatut.year} 
                                                ${statut.dateStatut.hour}:${statut.dateStatut.minute}
                                            </span>
                                        </td>
                                        <td>
                                            <span class="observation-text">${statut.observation}</span>
                                        </td>
                                        <td>
                                            <div class="actions">
                                                <c:if test="${statutLoop.first}">
                                                    <a href="${pageContext.request.contextPath}/demande-statuts/mettre-a-jour/${demande.id}" 
                                                       class="btn btn-update">Mettre à jour statut</a>
                                                </c:if>
                                                <a href="${pageContext.request.contextPath}/demande-statuts/modifier-ligne/${demande.id}/${statut.id}" 
                                                   class="btn btn-edit">Modifier ligne</a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Séparateur entre les demandes -->
                <c:if test="${not loop.last}">
                    <div class="demande-separator"></div>
                </c:if>
            </c:forEach>
        </div>
    </div>
</body>
</html>
