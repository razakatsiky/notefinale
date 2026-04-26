<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Demandes - Statut : ${statutFiltre}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
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
        .statut-annule { background: rgba(231, 76, 60, 0.1); color: #e74c3c; }
        .statut-default { background: rgba(149, 165, 166, 0.1); color: #95a5a6; }

        /* Conteneur principal */
        .container {
            margin-top: 20px;
            padding: 40px 32px;
            max-width: 1200px;
            margin-left: auto;
            margin-right: auto;
        }

        /* Filtre info banner */
        .filter-banner {
            background: white;
            border: 1px solid #e0e0e0;
            border-radius: 12px;
            padding: 24px 32px;
            margin-bottom: 32px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 16px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .filter-info {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .filter-badge {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 24px;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: white;
        }

        .filter-badge.badge-creee,
        .filter-badge.badge-créée {
            background: linear-gradient(135deg, #3498db, #2980b9);
        }

        .filter-badge.badge-confirmee,
        .filter-badge.badge-confirmée {
            background: linear-gradient(135deg, #2ecc71, #27ae60);
        }

        .filter-badge.badge-annulee,
        .filter-badge.badge-annulée {
            background: linear-gradient(135deg, #e74c3c, #c0392b);
        }

        .filter-badge.badge-default {
            background: linear-gradient(135deg, #95a5a6, #7f8c8d);
        }

        .filter-text {
            font-size: 1rem;
            color: #555;
        }

        .filter-text strong {
            color: #111;
        }

        .filter-count {
            font-size: 0.9rem;
            color: #888;
            background: #f5f5f5;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 500;
        }

        /* Back link */
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #666;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
            padding: 10px 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            transition: all 0.2s ease;
        }

        .back-link:hover {
            background: #111;
            color: white;
            border-color: #111;
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

        /* Conteneur principal des demandes */
        .demandes-container {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        /* Bloc individuel de demande */
        .demande-block {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            overflow: hidden;
            border: 1px solid #e9ecef;
            transition: all 0.3s ease;
            animation: fadeInUp 0.4s ease forwards;
            opacity: 0;
        }

        .demande-block:nth-child(1) { animation-delay: 0.05s; }
        .demande-block:nth-child(2) { animation-delay: 0.1s; }
        .demande-block:nth-child(3) { animation-delay: 0.15s; }
        .demande-block:nth-child(4) { animation-delay: 0.2s; }
        .demande-block:nth-child(5) { animation-delay: 0.25s; }
        .demande-block:nth-child(6) { animation-delay: 0.3s; }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(12px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .demande-block:hover {
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        /* En-tête de demande */
        .demande-header {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            padding: 24px 32px;
            border-bottom: 2px solid #dee2e6;
        }

        .demande-title {
            margin: 0 0 12px 0;
            font-size: 1.3rem;
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
        .table-container {
            overflow-x: auto;
        }

        .statut-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
        }

        .statut-table th {
            background: #f8f9fa;
            padding: 14px 16px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #495057;
            border-bottom: 2px solid #dee2e6;
        }

        .statut-table td {
            padding: 14px 16px;
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

        .statut-créée,
        .statut-cree {
            background: #3498db;
            color: white;
        }

        .statut-confirmée,
        .statut-confirmee {
            background: #28a745;
            color: white;
        }

        .statut-annulée,
        .statut-annulee {
            color: #495057;
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

        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 12px;
            border: 1px solid #e9ecef;
        }

        .empty-state-icon {
            font-size: 3rem;
            margin-bottom: 16px;
            color: #ccc;
        }

        .empty-state-text {
            font-size: 1.1rem;
            color: #888;
            font-weight: 500;
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
                padding: 24px 16px;
            }

            .filter-banner {
                flex-direction: column;
                align-items: flex-start;
            }

            .actions {
                flex-direction: column;
                gap: 4px;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
        <div class="header">
            <h1>Demandes filtrées par statut</h1>
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
                <a href="${pageContext.request.contextPath}/demande-statuts/statistiques" class="nav-button">Statistiques</a>
                <a href="${pageContext.request.contextPath}/chiffre-affaire" class="nav-button">Chiffre d'Affaire</a>
            </div>
        </div>

        <!-- Messages -->
        <c:if test="${not empty message}">
            <div class="message">${message}</div>
        </c:if>
        
        <c:if test="${not empty error}">
            <div class="error">${error}</div>
        </c:if>

        <!-- Statistiques par statut -->
        <!-- Statistiques par statut (Style Minimaliste Bordé avec Highlight) -->
        <h2 style="font-size: 1.1rem; font-weight: 600; margin-bottom: 16px; color: #333; text-transform: uppercase; letter-spacing: 1px;">Vue filtrée par Statut</h2>
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
                $      <div style="position: absolute; bottom: 0; left: 0; right: 0; height: 3px; background: black;"></div>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/demande-statuts/statut/${statut.nom}" style="text-decoration: none; color: inherit; border: none; padding: 0; display: block;">
                        <div style="text-transform: uppercase; font-size: 0.65rem; font-weight: 700; letter-spacing: 1.5px; margin-bottom: 10px; color: ${isActive ? '#000' : '#555'};">${statut.nom}</div>
                        <div style="font-size: 1.8rem; font-weight: 700; color: #000; line-height: 1; margin-bottom: 5px;">${count != null ? count : 0}</div>
                        <div style="font-size: 0.7rem; color: #888;">demande${count > 1 ? 's' : ''}</div>
                    </a>
                </div>
            </c:forEach>
        </div>

        <!-- Bannière de filtre -->
        <div class="filter-banner">
            <div class="filter-info">
                <c:set var="badgeClass" value="badge-default" />
                <c:if test="${statutFiltre == 'Créée' || statutFiltre == 'Creee'}">
                    <c:set var="badgeClass" value="badge-créée" />
                </c:if>
                <c:if test="${statutFiltre == 'Confirmée' || statutFiltre == 'Confirmee'}">
                    <c:set var="badgeClass" value="badge-confirmée" />
                </c:if>
                <c:if test="${statutFiltre == 'Annulée' || statutFiltre == 'Annulee'}">
                    <c:set var="badgeClass" value="badge-annulée" />
                </c:if>
                
                <span class="filter-badge ${badgeClass}">${statutFiltre}</span>
                <span class="filter-text">
                    Demandes dont le statut actuel est <strong>"${statutFiltre}"</strong>
                </span>
                <span class="filter-count">${nbResultats} résultat${nbResultats > 1 ? 's' : ''}</span>
            </div>
        </div>

        <!-- Contenu -->
        <c:if test="${empty demandes}">
            <div class="empty-state">
                <div class="empty-state-icon">&#128196;</div>
                <div class="empty-state-text">Aucune demande avec le statut "${statutFiltre}"</div>
            </div>
        </c:if>

        <!-- Liste des demandes filtrées -->
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
            </c:forEach>
        </div>
    </div>
</body>
</html>
