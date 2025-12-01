<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${param.pageTitle != null ? param.pageTitle : 'GenZ Beats - Âm nhạc cho thế hệ mới'}</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="${ctx}/assets/css/index_css.css">
    <link rel="stylesheet" href="${ctx}/assets/css/common.css">
    <script>window.APP_CONTEXT='${ctx}';</script>
    <!-- <script src="${ctx}/assets/js/ui-utils.js"></script> -->
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
                <li><a href="${ctx}/" class="nav-link home-icon" title="Trang chủ"><i class='bx bx-home-alt'></i></a></li>
                <div class="search-container">
                    <form action="${ctx}/home" method="get" class="search-form">
                        <input type="text" name="q" class="search-input" placeholder="Tìm kiếm bài hát, ca sĩ..." value="${param.q}">
                        <button type="submit" class="search-btn"><i class='bx bx-search'></i></button>
                    </form>
                </div>
                <li><a href="${ctx}/home" class="nav-link">Khám phá</a></li>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <!-- Admin Link for Admin Users -->
                        <c:if test="${sessionScope.user.role == 'ADMIN'}">
                            <li><a href="${ctx}/admin/" class="nav-link"><i class='bx bx-cog'></i> Quản trị</a></li>
                        </c:if>
                        <!-- Avatar Dropdown -->
                        <li class="user-dropdown">
                            <div class="user-avatar" onclick="toggleUserMenu(event)">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.avatar}">
                                        <img src="${pageContext.request.contextPath}${sessionScope.user.avatar}" alt="${sessionScope.user.username}" onerror="this.src='${pageContext.request.contextPath}/assets/avatars/default.png'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/avatars/default.png" alt="${sessionScope.user.username}">
                                    </c:otherwise>
                                </c:choose>
                                <span>${sessionScope.user.username}</span>
                                <i class='bx bx-chevron-down'></i>
                            </div>
                            <div id="userDropdownMenu" class="dropdown-menu">
                                <a href="javascript:void(0)" onclick="viewProfile()">
                                    <i class='bx bx-user'></i> Hồ sơ
                                </a>
                                <a href="${ctx}/logout">
                                    <i class='bx bx-log-out'></i> Đăng xuất
                                </a>
                            </div>
                        </li>
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