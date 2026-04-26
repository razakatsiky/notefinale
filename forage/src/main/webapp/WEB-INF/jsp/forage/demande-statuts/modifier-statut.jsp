<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<jsp:include page="../template.jsp">
    <jsp:param name="title" value="Modifier le statut"/>
</jsp:include>

<div class="container" style="margin-top: -70px !important;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
        <div>
            <h2 style="font-size: 1.75rem; font-weight: 600; color: black;">Modifier le statut de la demande #${demande.id}</h2>
            <p style="color: rgba(0, 0, 0, 0.6); margin-top: 8px;">
                ${demande.client.nom} - ${demande.lieu}
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/demande-statuts" class="btn" style="background: black; color: white; padding: 12px 24px; text-decoration: none; border-radius: 4px; font-weight: 500;">Retour</a>
    </div>

    <!-- Messages -->
    <c:if test="${not empty message}">
        <div style="background: #d4edda; color: #155724; padding: 12px 16px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
            ${message}
        </div>
    </c:if>
    
    <c:if test="${not empty error}">
        <div style="background: #f8d7da; color: #721c24; padding: 12px 16px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
            ${error}
        </div>
    </c:if>

    <!-- Informations de la demande -->
    <div style="background: white; border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 8px; padding: 24px; margin-bottom: 24px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
            <h3 style="font-size: 1.25rem; font-weight: 600; margin: 0;">Informations de la demande</h3>
        </div>
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
            <div>
                <strong style="color: rgba(0, 0, 0, 0.7);">Client:</strong> ${demande.client.nom}
            </div>
            <div>
                <strong style="color: rgba(0, 0, 0, 0.7);">Lieu:</strong> ${demande.lieu}
            </div>
            <div>
                <strong style="color: rgba(0, 0, 0, 0.7);">Date:</strong> ${demande.dateDemande.dayOfMonth}/${demande.dateDemande.monthValue}/${demande.dateDemande.year}
            </div>
            <div>
                <strong style="color: rgba(0, 0, 0, 0.7);">Statut actuel:</strong> 
                <c:if test="${not empty demande.latestStatut and not empty demande.latestStatut.statut}">
                    <span style="display: inline-block; color: #27ae60; padding: 6px 12px; border-radius: 12px; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin-left: 8px;">
                        ${demande.latestStatut.statut.nom}
                    </span>
                </c:if>
                <c:if test="${empty demande.latestStatut or empty demande.latestStatut.statut}">
                    <span style="display: inline-block; color: #6c757d; padding: 6px 12px; border-radius: 12px; font-size: 12px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; margin-left: 8px;">
                        Non défini
                    </span>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Formulaire de modification de statut -->
    <div style="background: white; border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 8px; padding: 24px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
            <h3 style="font-size: 1.25rem; font-weight: 600; margin: 0;">Changer le statut</h3>
        </div>
        
        <form action="${pageContext.request.contextPath}/demande-statuts/modifier-statut/${demande.id}" method="post">
            <div style="margin-bottom: 16px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Nouveau statut *</label>
                <select name="statutId" required style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
                    <option value="">-- Sélectionner un statut --</option>
                    <c:forEach var="statut" items="${statuts}">
                        <option value="${statut.id}" ${not empty demande.latestStatut and demande.latestStatut.statut.id == statut.id ? 'selected' : ''}>${statut.libelle}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div style="margin-bottom: 16px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Observation (optionnel)</label>
                <textarea name="observation" rows="4" placeholder="Entrez une observation pour ce changement de statut..." 
                          style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black; resize: vertical; line-height: 1.5;"></textarea>
            </div>
            
            <div style="display: flex; gap: 12px;">
                <button type="submit" style="background: black; color: white; padding: 12px 24px; border: none; border-radius: 4px; cursor: pointer; font-weight: 500;">Modifier statut</button>
                <button type="button" onclick="history.back()" style="background: white; color: black; padding: 12px 24px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; cursor: pointer; font-weight: 500;">Annuler</button>
            </div>
        </form>
    </div>
</body>
</html>
