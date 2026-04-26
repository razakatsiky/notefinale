<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../template.jsp">
    <jsp:param name="title" value="${title}"/>
    <jsp:param name="headerTitle" value="Demandes du Client"/>
</jsp:include>
    <style>
/* Élégant CSS minimaliste - Tout en noir */
.client-info {
    border: 1px solid rgba(0, 0, 0, 0.1);
    padding: 24px;
    border-radius: 8px;
    margin-bottom: 32px;
}

.client-info h2 {
    font-size: 1.75rem;
    color: black;
    margin: 0 0 12px 0;
}

.client-info p {
    color: black;
    margin: 4px 0;
    font-size: 1.1rem;
}

.demandes-container h3 {
    font-size: 1.5rem;
    margin-bottom: 24px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.1);
    padding-bottom: 8px;
}

.demande-card {
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    padding: 24px;
    margin-bottom: 16px;
    transition: background-color 0.2s;
}

.demande-card:hover {
    background-color: rgba(0, 0, 0, 0.02);
}

.demande-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 16px;
}

.demande-id {
    font-weight: 600;
    font-size: 1.2rem;
}

.demande-date {
    color: rgba(0, 0, 0, 0.6);
    font-size: 0.95rem;
}

.demande-lieu {
    font-size: 1.1rem;
    margin-bottom: 12px;
}

.demande-statut {
    display: inline-block;
    padding: 6px 12px;
    border-radius: 4px;
    font-size: 0.85rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.03em;
}

.statut-cree { background: #f5f5f5; color: #333; border: 1px solid rgba(0,0,0,0.1); }
.statut-confirmee { background: #e8f5e8; color: #2e7d32; border: 1px solid rgba(39, 174, 96, 0.2); }
.statut-annulee { background: #ffebee; color: #c62828; border: 1px solid rgba(231, 76, 60, 0.2); }
.statut-encours { background: #fff3e0; color: #f57c00; border: 1px solid rgba(245, 124, 0, 0.2); }

.demande-actions {
    margin-top: 20px;
    display: flex;
    gap: 12px;
}

.btn {
    border: 1px solid black;
    border-radius: 6px;
    padding: 10px 20px;
    color: black;
    background-color: white;
    cursor: pointer;
    font-size: 0.9rem;
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

.btn-primary:hover {
    background-color: rgba(0, 0, 0, 0.8);
}

.btn-info {
    border: 1px solid black;
}

.btn-secondary {
    border: 1px solid rgba(0, 0, 0, 0.3);
    color: rgba(0, 0, 0, 0.7);
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
    </style>

<div class="container">
    <div style="text-align: center; margin-bottom: 24px;">
        <a href="${pageContext.request.contextPath}/demandes" class="btn">Retour aux demandes</a>
    </div>
    
    <div class="client-info">
        <h2>${client.nom}</h2>
        <p><strong>Contact:</strong> ${client.contact}</p>
        <p><strong>ID Client:</strong> ${client.id}</p>
    </div>
    
    <div class="demandes-container">
        <h3>Liste des demandes (${demandes.size()})</h3>
        
        <c:choose>
            <c:when test="${empty demandes}">
                <div class="empty-state">
                    <p>Ce client n'a aucune demande</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="demande" items="${demandes}">
                    <div class="demande-card">
                        <div class="demande-header">
                            <div class="demande-id">DEMANDE ${demande.id}</div>
                            <div class="demande-date">
                                ${demande.dateDemande.dayOfMonth}/${demande.dateDemande.monthValue}/${demande.dateDemande.year}
                            </div>
                        </div>
                        
                        <div class="demande-lieu">
                            <strong>Lieu:</strong> ${demande.lieu}
                        </div>
                        
                        <c:if test="${demande.latestStatut != null}">
                            <div class="demande-statut statut-${demande.latestStatut.statut.nom.toLowerCase().replace('é', 'e').replace('è', 'e')}">
                                ${demande.latestStatut.statut.nom}
                            </div>
                        </c:if>
                        
                        <div class="demande-actions">
                            <a href="${pageContext.request.contextPath}/demandes/details/${demande.id}" class="btn btn-primary">
                                Voir détails
                            </a>
                            
                            <c:if test="${demande.latestStatut != null}">
                                <a href="${pageContext.request.contextPath}/demande-statuts/mettre-a-jour/${demande.id}" class="btn btn-info">
                                    Mettre à jour statut
                                </a>
                            </c:if>
                            
                            <a href="${pageContext.request.contextPath}/demande-statuts?demandeId=${demande.id}" class="btn btn-secondary">
                                Historique statuts
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
    </div>

    <div style="margin-top: 40px; text-align: center; padding-bottom: 40px;">
        <a href="${pageContext.request.contextPath}/" class="btn">Retour à l'accueil</a>
    </div>
</div>
