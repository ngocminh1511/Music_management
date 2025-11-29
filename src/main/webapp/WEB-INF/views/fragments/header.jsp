<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle != null ? param.pageTitle : 'GenZ Beats - Âm nhạc cho thế hệ mới'}</title>
    <link rel="stylesheet" href="${ctx}/assets/css/index_css.css">
    <link rel="stylesheet" href="${ctx}/assets/css/common.css">
</head>
<body>
    <header class="header" id="header">
        <nav class="nav-container">
            <a href="${ctx}/" class="logo">
                <div class="logo-icon">
                    <div class="logo-prism">
                        <div class="prism-shape"></div>
                    </div>
                </div>
                <span class="logo-text">
                    <span class="prism">GENZ</span>
                    <span class="flux">BEATS</span>
                </span>
            </a>
            
            <!-- Search Bar -->
            
            
            <ul class="nav-menu" id="navMenu">
                <li><a href="${ctx}/" class="nav-link" title="Trang chủ">🏠</a></li>
                <div class="search-container">
                    <form action="${ctx}/home" method="get" class="search-form">
                        <input type="text" name="q" class="search-input" placeholder="Tìm kiếm bài hát, ca sĩ..." value="${param.q}">
                        <button type="submit" class="search-btn">🔍</button>
                    </form>
                </div>
                <li><a href="${ctx}/home" class="nav-link">Khám phá</a></li>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <c:if test="${sessionScope.user.role == 'ADMIN'}">
                            <li><a href="${ctx}/admin/" class="nav-link">Quản trị</a></li>
                        </c:if>
                        <li><a href="${ctx}/playlist/" class="nav-link">Playlist</a></li>
                        <li><span class="nav-link" style="opacity:0.7;">Hi, ${sessionScope.user.username}</span></li>
                        <li><a href="${ctx}/logout" class="nav-link">Đăng xuất</a></li>
                    </c:when>
                    <c:otherwise>
                        <li><a href="${ctx}/login" class="nav-link">Đăng nhập</a></li>
                        <li><a href="${ctx}/register" class="nav-link">Đăng ký</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
            
            <div class="menu-toggle" id="menuToggle">
                <span></span>
                <span></span>
                <span></span>
            </div>
        </nav>
    </header>
    <main class="main-content">