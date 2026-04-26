<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../forage/index.jsp">
    <jsp:param name="title" value="Paramètres de Remise"/>
</jsp:include>

<div class="container">
    <div style="margin-bottom: 32px; display: flex; justify-content: space-between; align-items: center;">
        <h2 style="font-size: 1.75rem; font-weight: 600; color: black;">
            Paramètres de Remise
        </h2>
        <a href="${pageContext.request.contextPath}/remises/form" 
           style="background: black; color: white; padding: 12px 24px; border: none; border-radius: 4px; font-weight: 500; text-decoration: none; display: inline-block;">
            + Nouveau Paramètre
        </a>
    </div>

    <c:if test="${not empty message}">
        <div class="success" style="background: #d4edda; color: #155724; padding: 12px; border-radius: 4px; margin-bottom: 16px;">
            ${message}
        </div>
    </c:if>

    <div style="background: white; border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 8px; overflow: hidden;">
        <table style="width: 100%; border-collapse: collapse;">
            <thead style="background: #f8f9fa;">
                <tr>
                    <th style="padding: 16px; text-align: left; border-bottom: 1px solid rgba(0, 0, 0, 0.1); font-weight: 600;">Seuil de Prix</th>
                    <th style="padding: 16px; text-align: left; border-bottom: 1px solid rgba(0, 0, 0, 0.1); font-weight: 600;">Taux de Remise</th>
                    <th style="padding: 16px; text-align: left; border-bottom: 1px solid rgba(0, 0, 0, 0.1); font-weight: 600;">Opérateur</th>
                    <th style="padding: 16px; text-align: left; border-bottom: 1px solid rgba(0, 0, 0, 0.1); font-weight: 600;">Statut</th>
                    <th style="padding: 16px; text-align: left; border-bottom: 1px solid rgba(0, 0, 0, 0.1); font-weight: 600;">Date Création</th>
                    <th style="padding: 16px; text-align: center; border-bottom: 1px solid rgba(0, 0, 0, 0.1); font-weight: 600;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="parametre" items="${parametres}">
                    <tr style="border-bottom: 1px solid rgba(0, 0, 0, 0.05);">
                        <td style="padding: 16px;">
                            <fmt:formatNumber value="${parametre.seuilPrix}" pattern="#,##0.00"/> Ar
                        </td>
                        <td style="padding: 16px;">
                            <fmt:formatNumber value="${parametre.tauxRemise}" pattern="#,##0.00"/>%
                        </td>
                        <td style="padding: 16px;">
                            <c:choose>
                                <c:when test="${parametre.operateur == '>='}">Supérieur ou égal (>=)</c:when>
                                <c:when test="${parametre.operateur == '>'}">Supérieur (&gt;)</c:when>
                                <c:when test="${parametre.operateur == '<='}">Inférieur ou egal (&lt;=)</c:when>
                                <c:when test="${parametre.operateur == '<'}">Inférieur (&lt;)</c:when>
                                <c:otherwise>${parametre.operateur}</c:otherwise>
                            </c:choose>
                        </td>
                        <td style="padding: 16px;">
                            <c:choose>
                                <c:when test="${parametre.actif}">
                                    <span style="background: #d4edda; color: #155724; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 500;">
                                        ACTIF
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span style="background: #f8d7da; color: #721c24; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 500;">
                                        INACTIF
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td style="padding: 16px;">
                            <fmt:formatDate value="${parametre.dateCreation}" pattern="dd/MM/yyyy HH:mm"/>
                        </td>
                        <td style="padding: 16px; text-align: center;">
                            <div style="display: flex; gap: 8px; justify-content: center;">
                                <a href="${pageContext.request.contextPath}/remises/form?id=${parametre.id}" 
                                   style="background: #007bff; color: white; padding: 6px 12px; border: none; border-radius: 4px; text-decoration: none; font-size: 12px;">
                                    Modifier
                                </a>
                                <form action="${pageContext.request.contextPath}/remises/toggle/${parametre.id}" method="post" style="display: inline;">
                                    <button type="submit" 
                                            style="background: ${parametre.actif ? '#ffc107' : '#28a745'}; color: white; padding: 6px 12px; border: none; border-radius: 4px; font-size: 12px; cursor: pointer;">
                                        ${parametre.actif ? 'Désactiver' : 'Activer'}
                                    </button>
                                </form>
                                <form action="${pageContext.request.contextPath}/remises/delete/${parametre.id}" method="post" 
                                      style="display: inline;" 
                                      onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer ce paramètre de remise ?');">
                                    <button type="submit" 
                                            style="background: #dc3545; color: white; padding: 6px 12px; border: none; border-radius: 4px; font-size: 12px; cursor: pointer;">
                                        Supprimer
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                
                <c:if test="${empty parametres}">
                    <tr>
                        <td colspan="6" style="padding: 48px; text-align: center; color: #666;">
                            <div style="margin-bottom: 16px;">
                                <strong>Aucun paramètre de remise configuré</strong>
                            </div>
                            <a href="${pageContext.request.contextPath}/remises/form" 
                               style="background: black; color: white; padding: 8px 16px; border: none; border-radius: 4px; text-decoration: none; display: inline-block;">
                                Créer le premier paramètre
                            </a>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>

    <!-- Guide d'utilisation -->
    <div style="margin-top: 32px; padding: 24px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid black;">
        <h3 style="margin-bottom: 16px; color: black;">Guide d'utilisation</h3>
        <div style="color: #666; line-height: 1.6;">
            <p style="margin-bottom: 12px;">
                <strong>Les paramètres de remise permettent d'appliquer automatiquement des réductions sur les prix unitaires dans les devis.</strong>
            </p>
            <ul style="margin: 12px 0; padding-left: 20px;">
                <li><strong>Seuil de Prix :</strong> Le prix minimum à partir duquel la remise s'applique</li>
                <li><strong>Taux de Remise :</strong> Le pourcentage de réduction (ex: 10 pour 10%)</li>
                <li><strong>Opérateur :</strong> La condition d'application (supérieur, inférieur, etc.)</li>
                <li><strong>Statut ACTIF :</strong> Seul un paramètre actif est appliqué dans les devis</li>
            </ul>
            <div style="margin-top: 16px; padding: 12px; background: white; border-radius: 4px;">
                <strong>Exemple :</strong> Seuil = 1 000 000 Ar, Taux = 10%, Opérateur = >=<br>
                Un prix unitaire de 1 200 000 Ar aura une remise de 120 000 Ar (10%)<br>
                Prix final = 1 080 000 Ar
            </div>
        </div>
    </div>
</div>
