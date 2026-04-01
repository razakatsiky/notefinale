<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../forage/index.jsp">
    <jsp:param name="title" value="Modifier Détail Devis"/>
</jsp:include>

<div class="container">
    <div style="margin-bottom: 32px;">
        <h2 style="font-size: 1.75rem; font-weight: 600; color: black;">
            Modifier Détail Devis
        </h2>
        <p style="color: rgba(0, 0, 0, 0.6); margin-top: 8px;">
            Devis #${detail.devis.id} - ${detail.devis.typeDevis.libelle}
        </p>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="error">${errorMessage}</div>
    </c:if>

    <div style="background: white; border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 8px; padding: 32px; max-width: 600px;">
        <form action="${pageContext.request.contextPath}/details-devis/update/${detail.id}" method="post">

            <div style="margin-bottom: 24px;">
                <label for="libelle" style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Libellé *</label>
                <input type="text" id="libelle" name="libelle" required
                       value="${detail.libelle}"
                       style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
            </div>

            <div style="margin-bottom: 24px;">
                <label for="prixUnitaire" style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Prix Unitaire *</label>
                <input type="number" id="prixUnitaire" name="prixUnitaire" step="0.01" min="0" required
                       value="${detail.prixUnitaire}"
                       style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
            </div>

            <div style="margin-bottom: 24px;">
                <label for="quantite" style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Quantité *</label>
                <input type="number" id="quantite" name="quantite" min="1" required
                       value="${detail.quantite}"
                       style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
            </div>

            <div style="margin-bottom: 24px; padding: 16px; background: rgba(0, 0, 0, 0.02); border-radius: 4px;">
                <strong>Montant Total Calculé:</strong>
                <span id="montantTotal" style="font-weight: 600; margin-left: 8px;">
                    <fmt:formatNumber value="${detail.prixUnitaire * detail.quantite}" pattern="#,##0.00" currencySymbol="Ar" type="currency"/>
                </span>
            </div>

            <div style="display: flex; gap: 16px; margin-top: 32px;">
                <button type="submit" style="background: black; color: white; padding: 12px 24px; border: none; border-radius: 4px; font-weight: 500; cursor: pointer;">
                    Mettre à jour
                </button>
                <a href="${pageContext.request.contextPath}/devis/details/${detail.devis.id}" style="background: white; color: black; padding: 12px 24px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-weight: 500; text-decoration: none; display: inline-block;">
                    Annuler
                </a>
            </div>
        </form>
    </div>
</div>

<script>
document.getElementById('prixUnitaire').addEventListener('input', updateTotal);
document.getElementById('quantite').addEventListener('input', updateTotal);

function updateTotal() {
    const prix = parseFloat(document.getElementById('prixUnitaire').value) || 0;
    const quantite = parseInt(document.getElementById('quantite').value) || 0;
    const total = prix * quantite;

    document.getElementById('montantTotal').textContent = total.toLocaleString('fr-FR', {
        style: 'currency',
        currency: 'MGA',
        minimumFractionDigits: 2
    });
}
</script>