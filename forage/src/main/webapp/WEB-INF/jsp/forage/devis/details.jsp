<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../index.jsp">
    <jsp:param name="title" value="Détails du Devis"/>
</jsp:include>

<div class="container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
        <div>
            <h2 style="font-size: 1.75rem; font-weight: 600; color: black;">Détails du Devis #${devis.id}</h2>
            <p style="color: rgba(0, 0, 0, 0.6); margin-top: 8px;">
                ${devis.typeDevis.libelle} - ${devis.dateDevis}
            </p>
        </div>
        <a href="${pageContext.request.contextPath}/devis" class="btn" style="background: black; color: white; padding: 12px 24px; text-decoration: none; border-radius: 4px; font-weight: 500;">Retour</a>
    </div>

    <c:if test="${not empty successMessage}">
        <div style="background: #d4edda; color: #155724; padding: 12px 16px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #c3e6cb;">
            ${successMessage}
        </div>
    </c:if>

    <c:if test="${not empty errorMessage}">
        <div style="background: #f8d7da; color: #721c24; padding: 12px 16px; border-radius: 4px; margin-bottom: 20px; border: 1px solid #f5c6cb;">
            ${errorMessage}
        </div>
    </c:if>

    <!-- Informations du devis -->
    <div style="background: white; border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 8px; padding: 24px; margin-bottom: 24px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
            <h3 style="font-size: 1.25rem; font-weight: 600; margin: 0;">Informations générales</h3>
            <button type="button" onclick="toggleEditDevis()" style="background: black; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-weight: 500;">Modifier</button>
        </div>
        
        <div id="devisInfo">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                <div>
                    <strong style="color: rgba(0, 0, 0, 0.7);">Demande:</strong> ${devis.demande.client.nom} - ${devis.demande.lieu}
                </div>
                <div>
                    <strong style="color: rgba(0, 0, 0, 0.7);">Type:</strong> ${devis.typeDevis.libelle}
                </div>
                <div>
                    <strong style="color: rgba(0, 0, 0, 0.7);">Date:</strong> ${devis.dateDevis}
                </div>
                <div>
                    <strong style="color: rgba(0, 0, 0, 0.7);">Lieu:</strong> ${devis.lieu}
                </div>
            </div>
        </div>
        
        <div id="devisEditForm" style="display: none; margin-top: 16px; padding-top: 16px; border-top: 1px solid rgba(0, 0, 0, 0.1);">
            <form action="${pageContext.request.contextPath}/devis/update-info/${devis.id}" method="post">
                <input type="hidden" id="editDemandeId" name="demande.id" value="${devis.demande.id}">
                
                <div style="margin-bottom: 16px;">
                    <label style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Description de la Demande *</label>
                    <input type="text" id="editDemandeSearch" placeholder="Entrez la description de la demande..." 
                           value="${devis.demande.description}" 
                           style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
                    <div id="editDemandeResults" style="margin-top: 8px; max-height: 200px; overflow-y: auto; border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 4px; background: white; display: none;"></div>
                    <div id="editDemandeInfo" style="margin-top: 12px; padding: 12px; background: #f8f9fa; border-radius: 4px; display: block; border-left: 4px solid #27ae60;">
                        <div><strong>Client:</strong> <span id="editClientName">${devis.demande.client.nom}</span></div>
                        <div><strong>Date:</strong> <span id="editDateDemande">${devis.demande.dateDemande}</span></div>
                        <div><strong>Lieu:</strong> <span id="editLieu">${devis.demande.lieu}</span></div>
                        <div><strong>Description:</strong> <span id="editDescription">${devis.demande.description}</span></div>
                    </div>
                </div>
                
                <div style="display: grid; grid-template-columns: 1fr; gap: 16px; margin-bottom: 16px;">
                    <div>
                        <label style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Type de Devis *</label>
                        <select name="typeDevis.id" required style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
                            <c:forEach var="t" items="${allTypeDevis}">
                                <option value="${t.id}" ${devis.typeDevis.id == t.id ? 'selected' : ''}>${t.libelle}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div style="display: flex; gap: 12px;">
                    <button type="submit" style="background: black; color: white; padding: 12px 24px; border: none; border-radius: 4px; cursor: pointer; font-weight: 500;">Enregistrer</button>
                    <button type="button" onclick="toggleEditDevis()" style="background: white; color: black; padding: 12px 24px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; cursor: pointer; font-weight: 500;">Annuler</button>
                </div>
            </form>
        </div>
    </div>

    <script>
    let editSelectedDemande = {
        id: ${devis.demande.id},
        client: { nom: '${devis.demande.client.nom}' },
        lieu: '${devis.demande.lieu}',
        description: '${devis.demande.description}'
    };
    
    function searchDemandeEdit(query) {
        if (query.length < 1) return;
        const xhr = new XMLHttpRequest();
        xhr.open('GET', '/forage/demandes/search?q=' + encodeURIComponent(query), true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                const data = JSON.parse(xhr.responseText);
                displayEditResults(data, query);
            }
        };
        xhr.send();
    }
    
    function displayEditResults(data, originalQuery) {
        const resultsDiv = document.getElementById('editDemandeResults');
        resultsDiv.innerHTML = '';
        
        if (!data || data.length === 0) {
            resultsDiv.innerHTML = '<div style="padding:8px;color:#dc3545;font-weight:500;">Aucune demande à cette description</div>';
            resultsDiv.style.display = 'block';
            setTimeout(() => { resultsDiv.style.display = 'none'; }, 2000);
        } else {
            const exactMatch = data.find(d => {
                const displayText = d.displayText || d.description || '';
                return displayText.toLowerCase() === originalQuery.toLowerCase();
            });
            
            if (exactMatch) {
                selectEditDemande(exactMatch);
            } else {
                resultsDiv.innerHTML = '<div style="padding:8px;color:#dc3545;font-weight:500;">Aucune demande à cette description</div>';
                resultsDiv.style.display = 'block';
                setTimeout(() => { resultsDiv.style.display = 'none'; }, 2000);
            }
        }
    }
    
    function selectEditDemande(demande) {
        editSelectedDemande = demande;
        document.getElementById('editDemandeId').value = demande.id;
        document.getElementById('editDemandeSearch').value = demande.displayText || demande.description || '';
        document.getElementById('editDemandeResults').style.display = 'none';
        
        document.getElementById('editClientName').textContent = demande.client ? demande.client.nom : '';
        document.getElementById('editDateDemande').textContent = demande.dateDemande ? new Date(demande.dateDemande).toLocaleDateString('fr-FR') : '';
        document.getElementById('editLieu').textContent = demande.lieu || '';
        document.getElementById('editDescription').textContent = demande.description || '';
        document.getElementById('editDemandeInfo').style.display = 'block';
        document.getElementById('editDemandeInfo').style.borderLeft = '4px solid #27ae60';
    }
    
    function clearEditDemande() {
        editSelectedDemande = null;
        document.getElementById('editDemandeId').value = '';
        document.getElementById('editDemandeSearch').value = '';
        document.getElementById('editClientName').textContent = '';
        document.getElementById('editDateDemande').textContent = '';
        document.getElementById('editLieu').textContent = '';
        document.getElementById('editDescription').textContent = '';
        document.getElementById('editDemandeInfo').style.display = 'none';
    }
    
    function toggleEditDevis() {
        var info = document.getElementById('devisInfo');
        var form = document.getElementById('devisEditForm');
        if (info.style.display === 'none') {
            info.style.display = 'block';
            form.style.display = 'none';
        } else {
            info.style.display = 'none';
            form.style.display = 'block';
        }
    }
    
    document.getElementById('editDemandeSearch').oninput = function() {
        const q = this.value.trim();
        if (q.length === 0) {
            clearEditDemande();
        } else if (editSelectedDemande && editSelectedDemande.description) {
            const displayText = editSelectedDemande.displayText || editSelectedDemande.description || '';
            if (q.toLowerCase() !== displayText.toLowerCase()) {
                clearEditDemande();
            }
        }
    };
    
    document.getElementById('editDemandeSearch').onblur = function() {
        const q = this.value.trim();
        if (q.length >= 1 && !editSelectedDemande) {
            searchDemandeEdit(q);
        } else if (q.length >= 1 && editSelectedDemande && editSelectedDemande.description) {
            const displayText = editSelectedDemande.displayText || editSelectedDemande.description || '';
            if (q.toLowerCase() !== displayText.toLowerCase()) {
                searchDemandeEdit(q);
            }
        }
        setTimeout(() => {
            document.getElementById('editDemandeResults').style.display = 'none';
        }, 2000);
    };
    
    document.querySelector('#devisEditForm form').onsubmit = function(e) {
        if (!editSelectedDemande || !editSelectedDemande.id) {
            e.preventDefault();
            alert('Veuillez sélectionner une demande valide');
            return;
        }
    };
    </script>

    <!-- Ajouter un détail -->
    <div style="background: white; border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 8px; padding: 24px; margin-bottom: 24px;">
        <h3 style="font-size: 1.25rem; font-weight: 600; margin-bottom: 16px;">Ajouter une ligne de détail</h3>
        <form action="${pageContext.request.contextPath}/devis/details/add/${devis.id}" method="post">
            <div style="display: grid; grid-template-columns: 2fr 1fr 1fr auto; gap: 16px; align-items: end;">
                <div>
                    <label style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Libellé *</label>
                    <input type="text" name="libelle" required
                           style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
                </div>
                <div>
                    <label style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Prix Unitaire *</label>
                    <input type="number" name="prixUnitaire" step="0.01" min="0" required
                           style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
                </div>
                <div>
                    <label style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Quantité *</label>
                    <input type="number" name="quantite" min="1" required
                           style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
                </div>
                <div>
                    <button type="submit" style="background: black; color: white; padding: 12px 24px; border: none; border-radius: 4px; font-weight: 500; cursor: pointer; height: 44px;">
                        Ajouter
                    </button>
                </div>
            </div>
        </form>
    </div>

    <!-- Liste des détails -->
    <div style="background: white; border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 8px; overflow: hidden;">
        <div style="padding: 24px; border-bottom: 1px solid rgba(0, 0, 0, 0.1);">
            <h3 style="font-size: 1.25rem; font-weight: 600; margin: 0;">Détails du devis</h3>
        </div>
        
        <table style="width: 100%; border-collapse: collapse;">
            <thead style="background: rgba(0, 0, 0, 0.02);">
                <tr>
                    <th style="padding: 16px; text-align: left; font-weight: 600;">Libellé</th>
                    <th style="padding: 16px; text-align: right; font-weight: 600;">Prix Unitaire</th>
                    <th style="padding: 16px; text-align: right; font-weight: 600;">Quantité</th>
                    <th style="padding: 16px; text-align: right; font-weight: 600;">Montant Total</th>
                    <th style="padding: 16px; text-align: center; font-weight: 600;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="detail" items="${devis.detailsDevis}">
                    <tr style="border-bottom: 1px solid rgba(0, 0, 0, 0.05);">
                        <td style="padding: 16px;">${detail.libelle}</td>
                        <td style="padding: 16px; text-align: right;">
                            <fmt:formatNumber value="${detail.prixUnitaire}" pattern="#,##0.00" currencySymbol="Ar" type="currency"/>
                        </td>
                        <td style="padding: 16px; text-align: right;">${detail.quantite}</td>
                        <td style="padding: 16px; text-align: right; font-weight: 600;">
                            <fmt:formatNumber value="${detail.prixUnitaire * detail.quantite}" pattern="#,##0.00" currencySymbol="Ar" type="currency"/>
                        </td>
                        <td style="padding: 16px; text-align: center;">
                            <a href="<c:url value='/details-devis/edit/${detail.id}'/>" style="color: black; text-decoration: none; margin: 0 4px; font-weight: 500;">Modifier</a>
                            <a href="<c:url value='/details-devis/delete/${detail.id}'/>" onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette ligne ?')" style="color: #dc3545; text-decoration: none; margin: 0 4px; font-weight: 500;">Supprimer</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
            <tfoot>
                <tr style="background: rgba(0, 0, 0, 0.02); font-weight: 600;">
                    <td colspan="3" style="padding: 16px; text-align: right;">Total:</td>
                    <td style="padding: 16px; text-align: right; font-size: 1.125rem;">
                        <fmt:formatNumber value="${devis.montantTotalCalcule}" pattern="#,##0.00" currencySymbol="Ar" type="currency"/>
                    </td>
                    <td></td>
                </tr>
            </tfoot>
        </table>
        
        <c:if test="${empty devis.detailsDevis}">
            <div style="padding: 48px; text-align: center; color: rgba(0, 0, 0, 0.6);">
                Aucun détail trouvé pour ce devis
            </div>
        </c:if>
    </div>
</div>
