<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GenZ Beats - Music Player</title>
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link rel="stylesheet" href="${ctx}/assets/css/index_css.css">
    <link rel="stylesheet" href="${ctx}/assets/css/common.css">
    <link rel="stylesheet" href="${ctx}/assets/css/player.css">
    <link rel="stylesheet" href="${ctx}/assets/css/lyrics.css">
    <link rel="stylesheet" href="${ctx}/assets/css/music-player-bar.css">
    
    <!-- Load JS utilities FIRST to make functions available -->
    <script>window.APP_CONTEXT='${ctx}';</script>
    <script src="${ctx}/assets/js/ui-utils.js"></script>
</head>
<body>
    <!-- Header inline (not included) -->
    <!-- <header class="header" id="header">
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
                        <c:if test="${sessionScope.user.role == 'ADMIN'}">
                            <li><a href="${ctx}/admin/" class="nav-link"><i class='bx bx-cog'></i> Quản trị</a></li>
                        </c:if>
                        <li class="user-dropdown">
                            <div class="user-avatar" onclick="toggleUserMenu(event)">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.user.avatar}">
                                        <img src="${ctx}${sessionScope.user.avatar}" alt="${sessionScope.user.username}" onerror="this.src='${ctx}/assets/avatars/default.png'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${ctx}/assets/avatars/default.png" alt="${sessionScope.user.username}">
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
    </header> -->
    <jsp:include page="fragments/header.jsp" />

    <div class="music-player-page">
        <!-- Sidebar Playlist - Always visible -->
        <div class="sidebar-left" id="playlistSidebar">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div class="playlist-sidebar-header">
                        <h3><i class='bx bx-list-ul'></i> <span>Playlists của tôi</span></h3>
                        <div class="sidebar-actions">
                            <button onclick="playlistManager.createPlaylist()" class="btn-add-playlist" title="Tạo playlist">
                                <i class='bx bx-plus'></i>
                            </button>
                            <button onclick="toggleSidebar()" class="btn-toggle-sidebar" title="Thu gọn">
                                <i class='bx bx-chevron-left'></i>
                            </button>
                        </div>
                    </div>
                    
                    <div class="playlist-list" id="playlistList">
                        <!-- Playlists will be loaded by JavaScript -->
                        <div style="padding: 1rem; text-align: center; color: var(--text-secondary);">
                            <i class='bx bx-loader-alt bx-spin'></i> Đang tải playlists...
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="sidebar-login-prompt">
                        <i class='bx bx-user-circle' style="font-size: 4rem; color: var(--accent-purple); margin-bottom: 1rem;"></i>
                        <h4 style="color: var(--text-primary); margin-bottom: 0.5rem;">Chào bạn!</h4>
                        <p style="color: var(--text-secondary); margin-bottom: 1.5rem; text-align: center;">Đăng nhập để tương tác với playlist</p>
                        <a href="${pageContext.request.contextPath}/login" class="btn-login-sidebar">
                            <i class='bx bx-log-in'></i> Đăng nhập
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn-register-sidebar">
                            <i class='bx bx-user-plus'></i> Đăng ký
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Main Content Area -->
        <div class="main-content" id="mainContent">
            <!-- Mode 1: Discover -->
            <div class="content-mode active" id="modeDiscover">
                <jsp:include page="components/discover-view.jsp" />
            </div>

            <!-- Mode 2: Playlist -->
            <div class="content-mode" id="modePlaylist">
                <!-- Content loaded via AJAX -->
            </div>

            <!-- Mode 3: Song -->
            <div class="content-mode" id="modeSong">
                <!-- Content loaded via AJAX -->
            </div>

            <!-- Mode 4: Category -->
            <div class="content-mode" id="modeCategory">
                <!-- Content loaded via AJAX -->
            </div>
        </div>
    </div>

    <!-- Audio Player (hidden) - MUST BE BEFORE SCRIPTS -->
    <audio id="audioPlayer" preload="metadata"></audio>
    
    <!-- Floating Music Player Bar -->
    <div class="music-player-bar" id="musicPlayerBar" style="display: none;">
        <div class="player-song-info" id="currentSongDisplay">
            <img src="${ctx}/assets/thumbs/default.png" alt="Song">
            <div class="song-text">
                <h4>Chưa phát bài hát</h4>
                <p>Chọn bài hát để bắt đầu</p>
            </div>
        </div>
        <div class="player-controls">
            <button class="btn-player" id="btnPlayPause"><i class='bx bx-play'></i></button>
            <button class="btn-player" id="btnStop"><i class='bx bx-stop'></i></button>
        </div>
        <div class="player-progress">
            <span class="time-current" id="timeeCurrent">0:00</span>
            <div class="progress-bar" id="progressBar">
                <div class="progress-fill" id="progressFill"></div>
            </div>
            <span class="time-total" id="timeTotal">0:00</span>
        </div>
        <div class="player-volume">
            <i class='bx bx-volume-full'></i>
            <input type="range" min="0" max="100" value="80" id="volumeSlider">
        </div>
        <button class="btn-lyrics-toggle" id="btnLyricsToggle" title="Hiện lời bài hát">
            <i class='bx bx-book-content'></i>
        </button>
    </div>
    
    <!-- Lyrics Sidebar -->
    <div class="lyrics-sidebar" id="lyricsSidebar">
        <div class="lyrics-header">
            <h3 id="lyricsSongTitle">Lời bài hát</h3>
            <button class="btn-close-lyrics" id="btnCloseLyrics"><i class='bx bx-x'></i></button>
        </div>
        <div class="lyrics-content" id="lyricsContent">
            <p class="no-lyrics">Chưa có lời bài hát</p>
        </div>
    </div>

    <%@ include file="fragments/footer.jsp" %>
    
    <!-- Load remaining JS modules - AFTER all DOM elements -->
    <script src="${ctx}/assets/js/playlist-manager.js"></script>
    <script src="${ctx}/assets/js/music-player.js"></script>
    <script src="${ctx}/assets/js/mode-switcher.js"></script>
</body>
</html>