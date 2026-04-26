<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../forage/index.jsp">
    <jsp:param name="title" value="${parametre.id != null ? 'Modifier Paramètre de Remise' : 'Nouveau Paramètre de Remise'}"/>
</jsp:include>

<div class="container">
    <div style="margin-bottom: 32px;">
        <h2 style="font-size: 1.75rem; font-weight: 600; color: black;">
            ${parametre.id != null ? 'Modifier Paramètre de Remise' : 'Nouveau Paramètre de Remise'}
        </h2>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="error">${errorMessage}</div>
    </c:if>

    <div style="background: white; border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 8px; padding: 32px;">
        <form action="${pageContext.request.contextPath}/remises/save" method="post">
            <input type="hidden" name="id" value="${parametre.id}">

            <!-- Seuil de prix -->
            <div style="margin-bottom: 24px;">
                <label for="seuilPrix" style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Seuil de Prix *</label>
                <input type="number" id="seuilPrix" name="seuilPrix" required
                       value="<fmt:formatNumber value='${parametre.seuilPrix}' pattern='#,##0.00'/>"
                       step="0.01" min="0"
                       style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
                <small style="display: block; margin-top: 4px; color: #666;">
                    Prix à partir duquel la remise s'applique (ex: 1000000 pour 1 000 000 Ar)
                </small>
            </div>

            <!-- Taux de remise -->
            <div style="margin-bottom: 24px;">
                <label for="tauxRemise" style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Taux de Remise (%) *</label>
                <input type="number" id="tauxRemise" name="tauxRemise" required
                       value="<fmt:formatNumber value='${parametre.tauxRemise}' pattern='#,##0.00'/>"
                       step="0.01" min="0" max="100"
                       style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
                <small style="display: block; margin-top: 4px; color: #666;">
                    Pourcentage de remise (ex: 10 pour 10%)
                </small>
            </div>

            <!-- Opérateur -->
            <div style="margin-bottom: 24px;">
                <label for="operateur" style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Opérateur de Comparaison *</label>
                <select id="operateur" name="operateur" required
                        style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
                    <option value="">Sélectionner un opérateur</option>
                    <option value=">=" ${parametre.operateur == '>=' ? 'selected' : ''}>&gt;= (Supérieur ou égal)</option>
                    <option value=">" ${parametre.operateur == '>' ? 'selected' : ''}>&gt; (Supérieur)</option>
                    <option value="<=" ${parametre.operateur == '<=' ? 'selected' : ''}>&lt;= (Inférieur ou égal)</option>
                    <option value="<" ${parametre.operateur == '<' ? 'selected' : ''}>&lt; (Inférieur)</option>
                </select>
                <small style="display: block; margin-top: 4px; color: #666;">
                    Définit comment le prix est comparé au seuil
                </small>
            </div>

            <!-- Statut -->
            <div style="margin-bottom: 24px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Statut</label>
                <div style="display: flex; align-items: center; gap: 8px;">
                    <input type="checkbox" id="actif" name="actif" value="true" 
                           ${parametre.actif == null || parametre.actif ? 'checked' : ''}
                           style="width: 18px; height: 18px;">
                    <label for="actif" style="color: black; cursor: pointer;">
                        Actif (cochez pour que ce paramètre soit appliqué)
                    </label>
                </div>
            </div>

            <!-- Exemple de calcul -->
            <div style="margin-bottom: 32px; padding: 20px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid black;">
                <h4 style="margin-bottom: 12px; color: black;">Exemple de calcul</h4>
                <div id="exempleCalcul" style="color: #666;">
                    <p>Avec les paramètres actuels :</p>
                    <ul style="margin: 8px 0; padding-left: 20px;">
                        <li>Prix unitaire : <strong>1 000 000 Ar</strong></li>
                        <li id="exempleRemise">Remise : <strong>-</strong></li>
                        <li id="exempleFinal">Prix final : <strong>-</strong></li>
                    </ul>
                </div>
            </div>

            <!-- Actions du formulaire -->
            <div style="display: flex; gap: 16px; margin-top: 32px;">
                <button type="submit" style="background: black; color: white; padding: 12px 24px; border: none; border-radius: 4px; font-weight: 500; cursor: pointer;">
                    Enregistrer
                </button>
                <a href="${pageContext.request.contextPath}/remises" style="background: white; color: black; padding: 12px 24px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-weight: 500; text-decoration: none; display: inline-block;">
                    Annuler
                </a>
            </div>
        </form>
    </div>
</div>

<script>
function updateExemple() {
    const seuil = parseFloat(document.getElementById('seuilPrix').value) || 0;
    const taux = parseFloat(document.getElementById('tauxRemise').value) || 0;
    const operateur = document.getElementById('operateur').value;
    const prixExemple = 1000000; // 1 000 000 Ar
    
    let eligible = false;
    switch (operateur) {
        case '>=':
            eligible = prixExemple >= seuil;
            break;
        case '>':
            eligible = prixExemple > seuil;
            break;
        case '<=':
            eligible = prixExemple <= seuil;
            break;
        case '<':
            eligible = prixExemple < seuil;
            break;
    }
    
    const remiseEl = document.getElementById('exempleRemise');
    const finalEl = document.getElementById('exempleFinal');
    
    if (eligible && taux > 0) {
        const montantRemise = (prixExemple * taux) / 100;
        const prixFinal = prixExemple - montantRemise;
        
        remiseEl.innerHTML = 'Remise : <strong style="color: #e74c3c;">-' + montantRemise.toLocaleString('fr-FR') + ' Ar (' + taux + '%)</strong>';
        finalEl.innerHTML = 'Prix final : <strong style="color: #27ae60;">' + prixFinal.toLocaleString('fr-FR') + ' Ar</strong>';
    } else {
        remiseEl.innerHTML = 'Remise : <strong>0 Ar (non éligible)</strong>';
        finalEl.innerHTML = 'Prix final : <strong>' + prixExemple.toLocaleString('fr-FR') + ' Ar</strong>';
    }
}

// Mettre à jour l'exemple lors des changements
document.getElementById('seuilPrix').addEventListener('input', updateExemple);
document.getElementById('tauxRemise').addEventListener('input', updateExemple);
document.getElementById('operateur').addEventListener('change', updateExemple);

// Initialiser l'exemple au chargement
document.addEventListener('DOMContentLoaded', updateExemple);
</script>
