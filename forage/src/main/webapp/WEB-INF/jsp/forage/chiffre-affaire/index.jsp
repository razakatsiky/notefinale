<%--
    Document   : index
    Created on : 2024-03-21
    Author     : Tsiky
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="../template.jsp">
    <jsp:param name="title" value="Chiffre d'Affaire"/>
    <jsp:param name="headerTitle" value="Chiffre d'Affaire"/>
</jsp:include>

<style>
/* Élégant CSS minimaliste - Tout en noir */
.stats-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 32px;
    margin-top: 40px;
    margin-bottom: 60px;
}

.stat-link {
    text-decoration: none;
    color: inherit;
    display: block;
    transition: transform 0.2s ease;
    border: none;
}

.stat-link:hover {
    transform: translateY(-4px);
    border: none;
}

.stat-card {
    background: white;
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 12px;
    padding: 48px 32px;
    text-align: center;
    transition: all 0.3s ease;
}

.stat-card:hover {
    border-color: #000;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
}

.stat-title {
    font-size: 0.9rem;
    font-weight: 600;
    color: rgba(0, 0, 0, 0.5);
    text-transform: uppercase;
    letter-spacing: 0.1em;
    margin-bottom: 24px;
}

.stat-value {
    font-size: 3rem;
    font-weight: 700;
    color: #000;
    line-height: 1;
}

.stat-unit {
    font-size: 1.5rem;
    font-weight: 500;
    margin-left: 8px;
}
</style>

<div class="container">
    <div class="stats-container">
        <!-- Carte Chiffre d'Affaire -->
        <a href="${pageContext.request.contextPath}/devis" class="stat-link">
            <div class="stat-card">
                <div class="stat-title">Chiffre d'Affaire Total</div>
                <div class="stat-value">
                    <fmt:formatNumber value="${chiffreAffaire}" pattern="#,##0"/>
                    <span class="stat-unit">Ar</span>
                </div>
            </div>
        </a>
        
        <!-- Carte Nombre de Devis -->
        <a href="${pageContext.request.contextPath}/devis" class="stat-link">
            <div class="stat-card">
                <div class="stat-title">Nombre de Devis</div>
                <div class="stat-value">${nombreDevis}</div>
            </div>
        </a>
    </div>

    <!-- Pied de page centré -->
    <div style="margin-top: 40px; text-align: center; padding-bottom: 40px;">
        <a href="${pageContext.request.contextPath}/" class="btn">Retour à l'accueil</a>
    </div>
</div>
