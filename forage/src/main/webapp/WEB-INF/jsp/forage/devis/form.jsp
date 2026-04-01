<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:include page="../index.jsp">
    <jsp:param name="title" value="${isEdit ? 'Modifier Devis' : 'Nouveau Devis'}"/>
</jsp:include>

<div class="container">
    <div style="margin-bottom: 32px;">
        <h2 style="font-size: 1.75rem; font-weight: 600; color: black;">
            ${isEdit ? 'Modifier Devis' : 'Nouveau Devis'}
        </h2>
    </div>

    <c:if test="${not empty errorMessage}">
        <div class="error">${errorMessage}</div>
    </c:if>

    <div style="background: white; border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 8px; padding: 32px;">
        <form id="devisForm" action="${pageContext.request.contextPath}${isEdit ? '/devis/edit/' : '/devis/save'}${isEdit ? devis.id : ''}" method="post">
            
            <!-- Recherche de demande -->
            <div style="margin-bottom: 24px;">
                <label for="demandeSearch" style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Description de la Demande *</label>
                <div style="display: flex; gap: 12px;">
                    <input type="text" id="demandeSearch" placeholder="Entrez la description de la demande..." 
                           style="flex: 1; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;"
                           value="${isEdit ? (devis.demande.description != null && !devis.demande.description.trim().isEmpty() ? devis.demande.description : devis.client) : ''}">
                </div>
                <div id="demandeResults" style="margin-top: 8px; max-height: 200px; overflow-y: auto; border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 4px; background: white; display: none;"></div>
                <input type="hidden" id="demandeId" name="demande.id" value="${isEdit ? devis.demande.id : ''}">
            </div>

            <!-- Type de devis -->
            <div style="margin-bottom: 24px;">
                <label for="typeDevis" style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Type de Devis *</label>
                <select id="typeDevis" name="typeDevis.id" required
                        style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
                    <option value="">Sélectionner un type</option>
                    <c:forEach var="type" items="${typeDevis}">
                        <option value="${type.id}" ${isEdit && devis.typeDevis.id == type.id ? 'selected' : ''}>${type.libelle}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- Infos de la demande (affichées après sélection) -->
            <div id="demandeInfo" style="display: ${isEdit ? 'block' : 'none'}; margin-bottom: 24px; padding: 20px; background: #f8f9fa; border-radius: 8px; border-left: 4px solid black;">
                <h4 style="margin-bottom: 12px; color: black;">Informations de la Demande</h4>
                <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px;">
                    <div>
                        <strong>Nom Client:</strong> <span id="clientName">${isEdit ? devis.client : ''}</span>
                    </div>
                    <div>
                        <strong>Date Demande:</strong> <span id="dateDemande">${isEdit ? devis.demande.dateDemande : ''}</span>
                    </div>
                    <div>
                        <strong>Lieu:</strong> <span id="lieu">${isEdit ? devis.lieu : ''}</span>
                    </div>
                </div>
                <div style="margin-top: 12px;">
                    <strong>Description:</strong> <span id="description">${isEdit ? (devis.demande.description != null ? devis.demande.description : '') : ''}</span>
                </div>
            </div>

            <!-- Date du devis -->
            <div style="margin-bottom: 24px;">
                <label for="dateDevis" style="display: block; margin-bottom: 8px; font-weight: 500; color: black;">Date Devis *</label>
                <input type="date" id="dateDevis" name="dateDevis" required
                       value="<fmt:formatDate value='${devis.dateDevis}' pattern='yyyy-MM-dd'/>"
                       style="width: 100%; padding: 12px 16px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-size: 14px; background: white; color: black;">
            </div>

            
            <!-- Lignes de devis -->
            <div style="margin-bottom: 24px;">
                <h3 style="margin-bottom: 16px; color: black;">Lignes du Devis</h3>
                <div id="devisLines" style="border: 1px solid rgba(0, 0, 0, 0.1); border-radius: 8px; padding: 16px;">
                    <table style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr>
                                <th style="padding: 12px; text-align: left; border-bottom: 2px solid rgba(0, 0, 0, 0.1);">Libellé</th>
                                <th style="padding: 12px; text-align: right; border-bottom: 2px solid rgba(0, 0, 0, 0.1);">Quantité</th>
                                <th style="padding: 12px; text-align: right; border-bottom: 2px solid rgba(0, 0, 0, 0.1);">Prix Unitaire</th>
                                <th style="padding: 12px; text-align: right; border-bottom: 2px solid rgba(0, 0, 0, 0.1);">Total</th>
                                <th style="padding: 12px; text-align: center; border-bottom: 2px solid rgba(0, 0, 0, 0.1);">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="devisLinesBody">
                            <!-- Les lignes seront ajoutées dynamiquement -->
                        </tbody>
                    </table>
                    
                    <!-- Boutons d'action -->
                    <div style="display: flex; gap: 12px; margin-top: 16px;">
                        <button type="button" id="addLineButton"
                                style="background: #27ae60; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer;">
                            + Ajouter une ligne
                        </button>
                        <button type="button" id="clearLinesButton"
                                style="background: #e74c3c; color: white; padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer;">
                            Supprimer tout
                        </button>
                    </div>
                </div>
            </div>

            <!-- Actions du formulaire -->
            <div style="display: flex; gap: 16px; margin-top: 32px;">
                <button type="submit" style="background: black; color: white; padding: 12px 24px; border: none; border-radius: 4px; font-weight: 500; cursor: pointer;">
                    Enregistrer le Devis
                </button>
                <a href="/forage/devis" style="background: white; color: black; padding: 12px 24px; border: 1px solid rgba(0, 0, 0, 0.2); border-radius: 4px; font-weight: 500; text-decoration: none; display: inline-block;">
                    Annuler
                </a>
            </div>
        </form>
    </div>
</div>

<script>
// Variables globales
let selectedDemande = null;
let devisLines = [];
let lineIdCounter = 0;

console.log('Script started');

function searchDemande(query) {
    console.log('Searching for: ' + query);
    const url = '/forage/demandes/search?q=' + encodeURIComponent(query);
    console.log('URL: ' + url);
    const xhr = new XMLHttpRequest();
    xhr.open('GET', url, true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            console.log('AJAX Status: ' + xhr.status);
            console.log('AJAX Response: ' + xhr.responseText);
            
            if (xhr.status === 200) {
                try {
                    const data = JSON.parse(xhr.responseText);
                    console.log('Parsed data length:', data ? data.length : 0);
                    console.log('Parsed data:', JSON.stringify(data));
                    displayResults(data, query);
                } catch (e) {
                    console.error('JSON parse error:', e);
                    displayResults([], query);
                }
            } else {
                console.error('AJAX error, status:', xhr.status);
                displayResults([], query);
            }
        }
    };
    xhr.send();
}

function displayResults(data, originalQuery) {
    const resultsDiv = document.getElementById('demandeResults');
    resultsDiv.innerHTML = '';
    
    console.log('Displaying results - data type:', typeof data, ', is array:', Array.isArray(data), ', length:', data ? data.length : 'null');
    console.log('Original query: "' + originalQuery + '"');
    
    if (!data || data.length === 0) {
        console.log('No results found');
        resultsDiv.innerHTML = '<div style="padding:8px;color:#dc3545;font-weight:500;">Aucune demande à cette description</div>';
        resultsDiv.style.display = 'block';
        setTimeout(() => { resultsDiv.style.display = 'none'; }, 2000);
    } else {
        const exactMatch = data.find(d => {
            const displayText = d.displayText || d.description || '';
            return displayText.toLowerCase() === originalQuery.toLowerCase();
        });
        
        if (exactMatch) {
            console.log('Exact match found');
            selectDemande(exactMatch);
        } else {
            console.log('No exact match, showing message');
            resultsDiv.innerHTML = '<div style="padding:8px;color:#dc3545;font-weight:500;">Aucune demande à cette description</div>';
            resultsDiv.style.display = 'block';
            setTimeout(() => { resultsDiv.style.display = 'none'; }, 2000);
        }
    }
}

function selectDemande(demande) {
    console.log('Selecting demande:', JSON.stringify(demande));
    selectedDemande = demande;
    
    const demandeIdEl = document.getElementById('demandeId');
    const demandeSearchEl = document.getElementById('demandeSearch');
    const demandeResultsEl = document.getElementById('demandeResults');
    const demandeInfoEl = document.getElementById('demandeInfo');
    const clientNameEl = document.getElementById('clientName');
    const dateDemandeEl = document.getElementById('dateDemande');
    const lieuEl = document.getElementById('lieu');
    const descriptionEl = document.getElementById('description');
    const dateDevisEl = document.getElementById('dateDevis');
    
    console.log('Elements found:', {
        demandeIdEl: !!demandeIdEl,
        demandeSearchEl: !!demandeSearchEl,
        demandeResultsEl: !!demandeResultsEl,
        demandeInfoEl: !!demandeInfoEl,
        clientNameEl: !!clientNameEl
    });
    
    if (demandeIdEl) {
        demandeIdEl.value = demande.id;
        console.log('Set demandeId to:', demande.id);
    }
    if (demandeSearchEl) {
        demandeSearchEl.value = demande.displayText || demande.description || 'Demande ' + demande.id;
        console.log('Set demandeSearch to:', demandeSearchEl.value);
    }
    if (demandeResultsEl) {
        demandeResultsEl.style.display = 'none';
    }

    if (clientNameEl) {
        clientNameEl.textContent = demande.client ? demande.client.nom : 'No client';
        console.log('Set clientName to:', clientNameEl.textContent);
    }
    if (dateDemandeEl) {
        dateDemandeEl.textContent = demande.dateDemande ? new Date(demande.dateDemande).toLocaleDateString('fr-FR') : '';
        console.log('Set dateDemande to:', dateDemandeEl.textContent);
    }
    if (lieuEl) {
        lieuEl.textContent = demande.lieu || '';
        console.log('Set lieu to:', lieuEl.textContent);
    }
    if (descriptionEl) {
        descriptionEl.textContent = demande.description || 'Aucune description';
        console.log('Set description to:', descriptionEl.textContent);
    }
    if (demandeInfoEl) {
        demandeInfoEl.style.display = 'block';
        console.log('demandeInfo is now visible');
    }
    if (dateDevisEl) {
        dateDevisEl.value = new Date().toISOString().split('T')[0];
    }
}

function addDevisLine() {
    console.log('addDevisLine called');
    const lineId = ++lineIdCounter;
    const line = {id: lineId, libelle: '', quantite: 1, prixUnitaire: 0};
    devisLines.push(line);
    renderDevisLine(line);
}

function addDevisLineWithData(libelle, quantite, prixUnitaire, detailId) {
    const lineId = ++lineIdCounter;
    const line = {id: lineId, libelle: libelle, quantite: quantite, prixUnitaire: prixUnitaire, detailId: detailId};
    devisLines.push(line);
    renderDevisLine(line);
}

function renderDevisLine(line) {
    const tbody = document.getElementById('devisLinesBody');
    if (!tbody) {
        console.error('devisLinesBody not found');
        return;
    }
    const tr = document.createElement('tr');
    tr.id = 'line-' + line.id;
    
    const total = (line.quantite * line.prixUnitaire).toFixed(2);
    
    tr.innerHTML = 
        '<td><input type="text" value="' + line.libelle + '" placeholder="Libellé" onchange="updateLine(' + line.id + ', \'libelle\', this.value)" style="width:100%;padding:8px;border:1px solid #ddd;border-radius:4px;"></td>' +
        '<td style="text-align:right;"><input type="number" value="' + line.quantite + '" min="1" onchange="updateLine(' + line.id + ', \'quantite\', this.value)" style="width:80px;padding:8px;text-align:right;"></td>' +
        '<td style="text-align:right;"><input type="number" value="' + line.prixUnitaire + '" min="0" step="0.01" onchange="updateLine(' + line.id + ', \'prixUnitaire\', this.value)" style="width:100px;padding:8px;text-align:right;"></td>' +
        '<td style="text-align:right;font-weight:600;">' + total + '</td>' +
        '<td style="text-align:center;"><button type="button" onclick="removeDevisLine(' + line.id + ')" style="background:#e74c3c;color:white;border:none;padding:4px 8px;border-radius:4px;cursor:pointer;">Supprimer</button></td>';
    
    tbody.appendChild(tr);
}

function updateLine(lineId, field, value) {
    const line = devisLines.find(l => l.id === lineId);
    if (line) {
        if (field === 'quantite' || field === 'prixUnitaire') {
            line[field] = parseFloat(value);
        } else {
            line[field] = value;
        }
        
        const totalCell = document.querySelector('#line-' + lineId + ' td:nth-child(4)');
        if (totalCell) {
            totalCell.textContent = (line.quantite * line.prixUnitaire).toFixed(2);
        }
    }
}

function removeDevisLine(lineId) {
    devisLines = devisLines.filter(l => l.id !== lineId);
    const el = document.getElementById('line-' + lineId);
    if (el) {
        el.remove();
    }
}

function clearAllLines() {
    console.log('clearAllLines called');
    if (confirm('Supprimer toutes les lignes ?')) {
        devisLines = [];
        document.getElementById('devisLinesBody').innerHTML = '';
        addDevisLine();
    }
}

window.onload = function() {
    console.log('Window onload started');
    
    <c:choose>
        <c:when test="${isEdit}">
            if (window.existingDetails && window.existingDetails.length > 0) {
                window.existingDetails.forEach(function(detail) {
                    addDevisLineWithData(detail.libelle, detail.quantite, detail.prixUnitaire);
                });
            } else {
                addDevisLine();
            }
            if (window.existingDemandeId) {
                selectedDemande = {id: window.existingDemandeId, client: {nom: window.existingClient}, lieu: window.existingLieu};
                document.getElementById('demandeInfo').style.display = 'block';
            }
        </c:when>
        <c:otherwise>
            addDevisLine();
        </c:otherwise>
    </c:choose>

    document.getElementById('demandeSearch').oninput = function() {
        const q = this.value.trim();
        const currentDisplayText = selectedDemande ? (selectedDemande.displayText || selectedDemande.description || '') : '';
        
        if (q.length === 0) {
            selectedDemande = null;
            const demandeInfo = document.getElementById('demandeInfo');
            const demandeId = document.getElementById('demandeId');
            if (demandeInfo) demandeInfo.style.display = 'none';
            if (demandeId) demandeId.value = '';
            document.getElementById('demandeResults').style.display = 'none';
        } else if (selectedDemande && q.toLowerCase() !== currentDisplayText.toLowerCase()) {
            selectedDemande = null;
            const demandeInfo = document.getElementById('demandeInfo');
            const demandeId = document.getElementById('demandeId');
            if (demandeInfo) demandeInfo.style.display = 'none';
            if (demandeId) demandeId.value = '';
        }
    };

    document.getElementById('demandeSearch').onblur = function() {
        const q = this.value.trim();
        if (q.length >= 1 && !selectedDemande) {
            searchDemande(q);
        }
        setTimeout(() => {
            const resultsDiv = document.getElementById('demandeResults');
            if (resultsDiv) {
                resultsDiv.style.display = 'none';
            }
        }, 2000);
    };
    
    const addLineButton = document.getElementById('addLineButton');
    const clearLinesButton = document.getElementById('clearLinesButton');
    
    console.log('Buttons found:', {
        addLineButton: !!addLineButton,
        clearLinesButton: !!clearLinesButton
    });
    
    if (addLineButton) {
        addLineButton.onclick = function() {
            console.log('Add line button clicked');
            addDevisLine();
        };
    } else {
        console.error('Add line button not found');
    }
    
    if (clearLinesButton) {
        clearLinesButton.onclick = function() {
            console.log('Clear lines button clicked');
            clearAllLines();
        };
    } else {
        console.error('Clear lines button not found');
    }

    document.getElementById('devisForm').onsubmit = function(e) {
        const demandeIdInput = document.getElementById('demandeId');
        if (!demandeIdInput || !demandeIdInput.value) {
            e.preventDefault();
            alert('Veuillez sélectionner une demande');
            return;
        }
        if (!document.getElementById('typeDevis').value) {
            e.preventDefault();
            alert('Veuillez sélectionner un type de devis');
            return;
        }

        const validLines = devisLines.filter(function(l) {
            return l.libelle && l.quantite > 0;
        });
        
        if (validLines.length === 0) {
            e.preventDefault();
            alert('Veuillez ajouter au moins une ligne avec un libellé');
            return;
        }

        const form = this;
        console.log("Form submission with " + validLines.length + " valid lines");
        
        validLines.forEach(function(line, index) {
            console.log("Adding line " + index + ": " + line.libelle + ", " + line.quantite + ", " + line.prixUnitaire);
            
            const inputL = document.createElement('input');
            inputL.type = 'hidden';
            inputL.name = 'lineLibelle';
            inputL.value = line.libelle;
            form.appendChild(inputL);
            
            const inputQ = document.createElement('input');
            inputQ.type = 'hidden';
            inputQ.name = 'lineQuantite';
            inputQ.value = line.quantite;
            form.appendChild(inputQ);
            
            const inputP = document.createElement('input');
            inputP.type = 'hidden';
            inputP.name = 'linePrixUnitaire';
            inputP.value = line.prixUnitaire;
            form.appendChild(inputP);
        });
    };
    
    console.log('Window onload finished');
};
</script>