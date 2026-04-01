<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../index.jsp">
    <jsp:param name="title" value="Modifier Détail Devis"/>
</jsp:include>

<div class="container">
    <div style="margin-bottom: 32px;">
        <h2 style="font-size: 1.75rem; font-weight: 600; color: black;">Modifier Détail Devis</h2>
    </div>

    <c:if test="${not empty errorMessage}">
        <div style="background: #f8d7da; color: #721c24; padding: 12px 16px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
            ${errorMessage}
        </div>
    </c:if>

    <div style="background: white; border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 8px; padding: 32px;">
        <form action="<c:url value='/details-devis/update/${detail.id}'/>" method="post">
            
            <div style="margin-bottom: 24px;">
                <label for="libelle" style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Libellé *</label>
                <input type="text" id="libelle" name="libelle" value="${detail.libelle}" required
                       style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 24px;">
                <div>
                    <label for="prixUnitaire" style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Prix Unitaire *</label>
                    <input type="number" id="prixUnitaire" name="prixUnitaire" value="${detail.prixUnitaire}" step="0.01" min="0" required
                           style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
                </div>

                <div>
                    <label for="quantite" style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Quantité *</label>
                    <input type="number" id="quantite" name="quantite" value="${detail.quantite}" min="1" required
                           style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
                </div>
            </div>

            <div style="background: rgba(0, 0, 0, 0.02); padding: 16px; border-radius: 4px; margin-bottom: 24px;">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span style="font-weight: 500;">Montant Total:</span>
                    <span style="font-size: 1.125rem; font-weight: 600;">
                        <fmt:formatNumber value="${detail.montantTotal}" pattern="#,##0.00" currencySymbol="Ar" type="currency"/>
                    </span>
                </div>
            </div>

            <div style="display: flex; gap: 16px; margin-top: 32px;">
                <button type="submit" style="background: black; color: white; padding: 12px 24px; border: none; border-radius: 4px; font-weight: 500; cursor: pointer;">
                    Mettre à jour
                </button>
                <a href="<c:url value='/devis/details/${detail.devis.id}'/>" style="background: white; color: black; padding: 12px 24px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-weight: 500; text-decoration: none; display: inline-block;">
                    Annuler
                </a>
            </div>
        </form>
    </div>
</div>
