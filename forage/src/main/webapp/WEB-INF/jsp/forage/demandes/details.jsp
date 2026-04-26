<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../template.jsp">
    <jsp:param name="title" value="${title}"/>
    <jsp:param name="headerTitle" value="Détails de la Demande"/>
</jsp:include>
    <style>
/* Élégant CSS minimaliste - Tout en noir */
.demande-container {
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    padding: 32px;
    margin-bottom: 32px;
}

.demande-info {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 24px;
    margin-bottom: 32px;
}

.info-item {
    border-bottom: 1px solid rgba(0, 0, 0, 0.05);
    padding-bottom: 12px;
}

.info-label {
    font-weight: 600;
    color: rgba(0, 0, 0, 0.5);
    margin-bottom: 8px;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.info-value {
    color: black;
    font-size: 1.1rem;
    font-weight: 500;
}

.statut-actuel {
    border: 1px solid rgba(0, 0, 0, 0.1);
    padding: 24px;
    border-radius: 8px;
    margin-bottom: 32px;
}

.statut-actuel h3 {
    color: black;
    margin: 0 0 16px 0;
    font-size: 1.25rem;
}

.statut-badge {
    display: inline-block;
    padding: 8px 16px;
    border-radius: 4px;
    font-size: 0.9rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.03em;
}

.statut-cree { background: #f5f5f5; color: #333; border: 1px solid rgba(0,0,0,0.1); }
.statut-confirmee { background: #e8f5e8; color: #2e7d32; border: 1px solid rgba(39, 174, 96, 0.2); }
.statut-annulee { background: #ffebee; color: #c62828; border: 1px solid rgba(231, 76, 60, 0.2); }
.statut-encours { background: #fff3e0; color: #f57c00; border: 1px solid rgba(245, 124, 0, 0.2); }

.historique-container {
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    padding: 32px;
}

.historique-container h3 {
    color: black;
    margin-bottom: 24px;
    font-size: 1.5rem;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    padding-bottom: 8px;
}

.historique-table {
    width: 100%;
    border-collapse: collapse;
}

.historique-table th,
.historique-table td {
    padding: 16px 8px;
    text-align: left;
    border-bottom: 1px solid rgba(0, 0, 0, 0.08);
}

.historique-table th {
    font-weight: 600;
    text-transform: uppercase;
    font-size: 0.85rem;
    letter-spacing: 0.05em;
    color: rgba(0, 0, 0, 0.5);
}

.statut-row.current {
    background: rgba(39, 174, 96, 0.05);
}

.actions {
    margin-top: 32px;
    display: flex;
    gap: 16px;
}

.btn {
    border: 1px solid black;
    border-radius: 6px;
    padding: 12px 24px;
    color: black;
    background-color: white;
    cursor: pointer;
    font-size: 0.95rem;
    font-weight: 500;
    transition: all 0.2s ease;
    text-decoration: none;
    display: inline-flex;
    align-items: center;
}

.btn:hover {
    background-color: black;
    color: white;
}

.btn-primary {
    background-color: black;
    color: white;
}

.btn-warning {
    border-color: rgba(0, 0, 0, 0.3);
}

.back-link {
    display: inline-block;
    margin-bottom: 24px;
    color: black;
    text-decoration: none;
    border-bottom: 1px solid rgba(0, 0, 0, 0.3);
    transition: border-color 0.2s ease;
}

.back-link:hover {
    border-bottom-color: black;
}

.devis-info {
    border: 1px solid rgba(0, 0, 0, 0.1);
    padding: 24px;
    border-radius: 8px;
    margin-top: 16px;
}
    </style>

<div class="container">
    <a href="${pageContext.request.contextPath}/demandes" class="back-link">&#8592; Retour aux demandes</a>
    
    <div class="demande-container">
        <div class="demande-info">
            <div class="info-item">
                <div class="info-label">ID Demande</div>
                <div class="info-value">#${demande.id}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">Date</div>
                <div class="info-value">${demande.dateDemande}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">Lieu</div>
                <div class="info-value">${demande.lieu}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">Client</div>
                <div class="info-value">${demande.client.nom}</div>
            </div>
            
            <div class="info-item">
                <div class="info-label">Contact</div>
                <div class="info-value">${demande.client.contact}</div>
            </div>
        </div>
        
        <c:if test="${demande.latestStatut != null}">
            <div class="statut-actuel">
                <h3>Statut Actuel</h3>
                <div class="statut-badge statut-${demande.latestStatut.statut.nom.toLowerCase().replace('é', 'e').replace('è', 'e')}">
                    ${demande.latestStatut.statut.nom}
                </div>
                <p style="margin-top: 10px; color: #666; font-size: 0.9rem;">
                    Mis à jour le ${demande.latestStatut.dateStatut}
                </p>
                <c:if test="${not empty demande.latestStatut.observation}">
                    <p style="margin-top: 10px; color: #333; font-style: italic;">
                        <strong>Observation:</strong> ${demande.latestStatut.observation}
                    </p>
                </c:if>
            </div>
        </c:if>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/demande-statuts/mettre-a-jour/${demande.id}" class="btn btn-primary">
                Mettre à jour le statut
            </a>
            
            <a href="${pageContext.request.contextPath}/demandes/edit/${demande.id}" class="btn btn-warning">
                Modifier la demande
            </a>
            
            <a href="${pageContext.request.contextPath}/devis?demandeId=${demande.id}" class="btn btn-info">
                Créer un devis
            </a>
        </div>
        
        <!-- Section Devis Associé -->
        <div class="devis-section" style="margin-top: 30px;">
            <h3 style="color: #333; margin-bottom: 20px; font-size: 1.2rem;">Devis Associé</h3>
            
            <div class="devis-info">
                <c:choose>
                    <c:when test="${not empty demande.devisList}">
                        <div style="display: grid; gap: 15px;">
                            <c:forEach items="${demande.devisList}" var="devis">
                                <div style="background: white; border: 1px solid #dee2e6; border-radius: 6px; padding: 15px;">
                                    <div style="display: flex; justify-content: space-between; align-items: center;">
                                        <div>
                                            <strong>Devis #${devis.id}</strong>
                                            <div style="color: #666; font-size: 0.9rem; margin-top: 5px;">
                                                Date: ${devis.dateDevis}
                                            </div>
                                            <div style="color: #333; font-weight: 600; margin-top: 5px;">
                                                Montant: ${devis.montantTotalCalcule} Ar
                                            </div>
                                            <div style="margin-top: 5px;">
                                                <span class="statut-badge statut-${devis.statut.nom.toLowerCase().replace('é', 'e').replace('è', 'e')}" style="font-size: 0.8rem;">
                                                    ${devis.statut.nom}
                                                </span>
                                            </div>
                                        </div>
                                        <div style="display: flex; gap: 10px;">
                                            <a href="${pageContext.request.contextPath}/devis/details/${devis.id}" class="btn btn-info" style="padding: 8px 15px; font-size: 0.85rem;">
                                                Voir
                                            </a>
                                            <a href="${pageContext.request.contextPath}/devis/edit/${devis.id}" class="btn btn-warning" style="padding: 8px 15px; font-size: 0.85rem;">
                                                Modifier
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="text-align: center; padding: 30px; color: #6c757d;">
                            <p style="margin: 0;">Aucun devis associé à cette demande</p>
                            <a href="${pageContext.request.contextPath}/devis?demandeId=${demande.id}" class="btn btn-primary" style="margin-top: 15px;">
                                Créer un devis
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <div class="historique-container">
        <h3>Historique des Statuts</h3>
        
        <c:choose>
            <c:when test="${empty historique}">
                <div class="empty-historique">
                    <p>Aucun historique de statut disponible</p>
                </div>
            </c:when>
            <c:otherwise>
                <table class="historique-table">
                    <thead>
                        <tr>
                            <th>Statut</th>
                            <th>Date</th>
                            <th>Observation</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${historique}" var="statut" varStatus="loop">
                            <tr class="${statut.id == demande.latestStatut.id ? 'statut-row current' : ''}">
                                <td>
                                    <span class="statut-badge statut-${statut.statut.nom.toLowerCase().replace('é', 'e').replace('è', 'e')}">
                                        ${statut.statut.nom}
                                        <c:if test="${statut.id == demande.latestStatut.id}">
                                            <span style="margin-left: 8px; font-size: 0.8rem; color: #2e7d32;">Actuel</span>
                                        </c:if>
                                    </span>
                                </td>
                                <td>
                                    ${statut.dateStatut}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${empty statut.observation}">
                                            <span style="color: #999; font-style: italic;">Aucune observation</span>
                                        </c:when>
                                        <c:otherwise>
                                            ${statut.observation}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/demande-statuts/modifier-ligne/${demande.id}/${statut.id}" 
                                       class="btn btn-secondary" style="padding: 5px 10px; font-size: 0.8rem;">
                                        Modifier
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div style="margin-top: 40px; text-align: center; padding-bottom: 40px;">
    <a href="${pageContext.request.contextPath}/" class="btn">Retour à l'accueil</a>
</div>
