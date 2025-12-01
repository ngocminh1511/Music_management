<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="fragments/header.jsp">
    <jsp:param name="pageTitle" value="Khám phá âm nhạc - GenZ Beats" />
</jsp:include>

<style>
.music-player-page {
    display: flex;
    min-height: calc(100vh - 80px - 400px);
    background: var(--bg-dark);
    padding: 100px 0 0 0;
    gap: 0;
    max-width: 100%;
    margin: 0 auto;
}
.sidebar-left {
    width: 320px;
    min-width: 320px;
    max-width: 320px;
    padding: 1.5rem;
    background: var(--bg-card);
    border-radius: 12px;
    margin-left: 1rem;
    margin-right: 1.5rem;
    height: fit-content;
    position: sticky;
    top: 100px;
    transition: all 0.3s ease;
    max-height: 85vh;
    overflow-y: auto;
    flex-shrink: 0;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}
.sidebar-left::-webkit-scrollbar {
    width: 6px;
}
.sidebar-left::-webkit-scrollbar-track {
    background: rgba(122, 92, 255, 0.1);
    border-radius: 10px;
}
.sidebar-left::-webkit-scrollbar-thumb {
    background: var(--accent-purple);
    border-radius: 10px;
}
.sidebar-left::-webkit-scrollbar-thumb:hover {
    background: var(--accent-blue);
}
.sidebar-left.collapsed {
    width: 70px;
    min-width: 70px;
    max-width: 70px;
    padding: 0.5rem;
    margin-right: 1.5rem;
}
.sidebar-left.collapsed .playlist-content {
    display: none;
}
.content-mode {
    display: none;
}
.content-mode.active {
    display: block;
}
.sidebar-left h5 {
    color: var(--accent-purple);
    margin-bottom: 1.2rem;
    font-size: 1.15rem;
    font-weight: 700;
    padding-bottom: 0.7rem;
    border-bottom: 2px solid rgba(122, 92, 255, 0.2);
}
.toggle-sidebar {
    width: 100%;
    padding: 0.6rem;
    background: rgba(122, 92, 255, 0.2);
    border: none;
    border-radius: 8px;
    color: var(--text-primary);
    cursor: pointer;
    margin-bottom: 1.2rem;
    font-size: 1.3rem;
    transition: all 0.3s;
}
.toggle-sidebar:hover {
    background: rgba(122, 92, 255, 0.3);
    transform: scale(1.05);
}
.playlist-item {
    padding: 0.9rem 1rem;
    background: rgba(122, 92, 255, 0.05);
    border-radius: 10px;
    margin-bottom: 0.7rem;
    cursor: pointer;
    transition: all 0.3s;
    border: 2px solid transparent;
    position: relative;
    overflow: hidden;
}
.playlist-item::before {
    content: '';
    position: absolute;
    left: 0;
    top: 0;
    bottom: 0;
    width: 4px;
    background: var(--accent-purple);
    transform: scaleY(0);
    transition: transform 0.3s;
}
.playlist-item:hover {
    background: rgba(122, 92, 255, 0.15);
    transform: translateX(5px);
    border-color: rgba(122, 92, 255, 0.3);
}
.playlist-item:hover::before {
    transform: scaleY(1);
}
.playlist-item.active {
    background: linear-gradient(135deg, rgba(122, 92, 255, 0.25) 0%, rgba(0, 194, 255, 0.15) 100%);
    border-color: var(--accent-purple);
    box-shadow: 0 4px 15px rgba(122, 92, 255, 0.3);
}
.playlist-item.active::before {
    transform: scaleY(1);
}
.playlist-item-text {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: var(--text-primary);
    font-weight: 500;
    font-size: 0.95rem;
}
.playlist-item.active .playlist-item-text {
    color: var(--accent-purple);
    font-weight: 600;
}
.main-content {
    flex: 1;
    padding: 0 1rem 0 0;
    width: 100%;
    min-width: 0;
}
.section-title {
    color: var(--text-primary);
    font-size: 1.5rem;
    margin-bottom: 1.5rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}
.category-pills {
    display: flex;
    gap: 1rem;
    margin-bottom: 2rem;
    overflow-x: auto;
    padding-bottom: 0.5rem;
}
.category-pill {
    padding: 0.7rem 1.5rem;
    background: rgba(122, 92, 255, 0.1);
    border: 1px solid var(--accent-purple);
    border-radius: 25px;
    color: var(--text-primary);
    text-decoration: none;
    white-space: nowrap;
    transition: all 0.3s;
}
.category-pill:hover, .category-pill.active {
    background: var(--accent-purple);
    color: white;
    transform: translateY(-2px);
}
.song-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 1.5rem;
    margin-bottom: 3rem;
}
.song-card {
    background: var(--bg-card);
    border-radius: 12px;
    overflow: hidden;
    transition: all 0.3s;
    cursor: pointer;
}
.song-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(122, 92, 255, 0.3);
}
.song-card img {
    width: 100%;
    aspect-ratio: 1;
    object-fit: cover;
}
.song-card-body {
    padding: 1rem;
}
.song-card-title {
    font-size: 0.95rem;
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 0.3rem;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.song-card-artist {
    font-size: 0.85rem;
    color: var(--text-secondary);
}
.top-list {
    list-style: none;
    padding: 0;
}
.top-item {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1rem;
    background: var(--bg-card);
    border-radius: 8px;
    margin-bottom: 0.7rem;
    cursor: pointer;
    transition: all 0.3s;
}
.top-item:hover {
    background: rgba(122, 92, 255, 0.1);
    transform: translateX(5px);
}
.top-rank {
    font-size: 1.5rem;
    font-weight: 700;
    color: var(--accent-purple);
    min-width: 30px;
}
.top-img {
    width: 50px;
    height: 50px;
    border-radius: 8px;
    object-fit: cover;
}
.top-info {
    flex: 1;
}
.top-title {
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 0.2rem;
}
.top-meta {
    font-size: 0.85rem;
    color: var(--text-secondary);
}
.artist-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    gap: 1.5rem;
}
.artist-card {
    text-align: center;
    cursor: pointer;
    transition: all 0.3s;
}
.artist-card:hover {
    transform: translateY(-5px);
}
.artist-avatar {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    object-fit: cover;
    margin: 0 auto 1rem;
    border: 3px solid var(--accent-purple);
}
.artist-name {
    font-weight: 600;
    color: var(--text-primary);
}
.btn-create-playlist {
    width: 100%;
    padding: 0.9rem 1rem;
    background: var(--gradient-primary);
    border: none;
    border-radius: 10px;
    color: white;
    font-weight: 600;
    cursor: pointer;
    margin-bottom: 1.2rem;
    font-size: 0.95rem;
    transition: all 0.3s;
    box-shadow: 0 4px 15px rgba(122, 92, 255, 0.3);
}
.btn-create-playlist:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(122, 92, 255, 0.4);
}
.carousel-container {
    position: relative;
    overflow: hidden;
    padding: 0 3rem;
    margin-bottom: 0;
    height: auto;
}
.carousel-track {
    display: flex;
    gap: 1.5rem;
    overflow-x: auto;
    scroll-behavior: smooth;
    scrollbar-width: none;
    -ms-overflow-style: none;
}
.carousel-track::-webkit-scrollbar {
    display: none;
}
.carousel-btn {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: rgba(122, 92, 255, 0.8);
    border: none;
    color: white;
    font-size: 1.2rem;
    cursor: pointer;
    z-index: 10;
    transition: all 0.3s;
}
.carousel-btn:hover {
    background: var(--accent-purple);
    transform: translateY(-50%) scale(1.1);
}
.carousel-btn.prev { left: 0; }
.carousel-btn.next { right: 0; }
.category-card-carousel {
    min-width: 140px;
    max-width: 250px;
    flex-shrink: 0;
}
.song-card-carousel {
    min-width: 180px;
    max-width: 220px;
    flex-shrink: 0;
}
.artist-card-carousel {
    min-width: 140px;
    max-width: 140px;
    flex-shrink: 0;
    text-align: center;
}
.top-songs-container {
    max-height: 500px;
    overflow-y: auto;
    padding-right: 0.5rem;
}
.top-songs-container::-webkit-scrollbar {
    width: 6px;
}
.top-songs-container::-webkit-scrollbar-track {
    background: rgba(122, 92, 255, 0.1);
    border-radius: 10px;
}
.top-songs-container::-webkit-scrollbar-thumb {
    background: var(--accent-purple);
    border-radius: 10px;
}
.playlist-detail-container {
    padding: 2rem;
    background: var(--bg-dark);
    border-radius: 15px;
}
.playlist-header-edit {
    display: flex;
    align-items: center;
    gap: 1rem;
    margin-bottom: 2rem;
}
.playlist-title-editable {
    font-size: 2rem;
    font-weight: 700;
    color: var(--accent-purple);
    background: transparent;
    border: none;
    border-bottom: 2px solid transparent;
    padding: 0.5rem;
    transition: all 0.3s;
}
.playlist-title-editable:hover,
.playlist-title-editable:focus {
    border-bottom-color: var(--accent-purple);
    outline: none;
}
.playlist-actions {
    display: flex;
    gap: 1rem;
    margin-bottom: 2rem;
}
.btn-action {
    padding: 0.7rem 1.5rem;
    border-radius: 8px;
    border: none;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s;
}
.btn-delete {
    background: rgba(255, 0, 0, 0.2);
    color: #ff4444;
}
.btn-delete:hover {
    background: #ff4444;
    color: white;
}
.modal-overlay {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.7);
    z-index: 1000;
    align-items: center;
    justify-content: center;
}
.modal-overlay.active {
    display: flex;
}
.modal-content {
    background: white;
    border-radius: 15px;
    padding: 2rem;
    max-width: 500px;
    width: 90%;
    max-height: 80vh;
    overflow-y: auto;
}
.modal-header {
    font-size: 1.5rem;
    font-weight: 700;
    color: #333;
    margin-bottom: 1.5rem;
}
.modal-body {
    margin-bottom: 1.5rem;
}
.modal-footer {
    display: flex;
    gap: 1rem;
    justify-content: flex-end;
}
.search-container {
    flex: 1;
    max-width: 500px;
    margin: 0 2rem;
}
.search-form {
    display: flex;
    gap: 0.5rem;
}
.search-input {
    flex: 1;
    padding: 0.7rem 1rem;
    border: 2px solid rgba(122, 92, 255, 0.3);
    border-radius: 25px;
    background: rgba(255, 255, 255, 0.05);
    color: var(--text-primary);
    font-size: 0.95rem;
    transition: all 0.3s;
}
.search-input:focus {
    outline: none;
    border-color: var(--accent-purple);
    background: rgba(255, 255, 255, 0.1);
}
.search-btn {
    padding: 0.7rem 1.2rem;
    background: var(--gradient-primary);
    border: none;
    border-radius: 25px;
    color: white;
    cursor: pointer;
    transition: all 0.3s;
}
.search-btn:hover {
    transform: scale(1.05);
}

/* Responsive */
@media (max-width: 768px) {
    .music-player-page {
        flex-direction: column;
        padding-top: 80px;
    }
    .sidebar-left {
        width: 100%;
        max-width: 100%;
        min-width: 100%;
        margin-left: 0;
        margin-right: 0;
        margin-bottom: 1rem;
        position: relative;
        top: auto;
    }
    .sidebar-left.collapsed {
        width: 100%;
        max-width: 100%;
        min-width: 100%;
    }
    .main-content {
        max-width: 100%;
        padding: 0 1rem;
    }
}
</style>

<div class="music-player-page">
    <!-- Sidebar Left - Playlist Management -->
    <div class="sidebar-left" id="playlistSidebar">
        <button class="toggle-sidebar" onclick="toggleSidebar()">☰</button>
        <div class="playlist-content">
            <h5><i class='bx bx-list-ul'></i> Playlist của tôi</h5>
            <c:if test="${not empty sessionScope.user}">
                <button class="btn-create-playlist" onclick="createNewPlaylist()">
                    + Tạo Playlist Mới
                </button>
                <div id="playlistList">
                    <!-- Playlists will be loaded here via AJAX -->
                </div>
            </c:if>
            <c:if test="${empty sessionScope.user}">
                <p style="color: var(--text-secondary); font-size: 0.9rem;">
                    <a href="${pageContext.request.contextPath}/login" style="color: var(--accent-purple);">Đăng nhập</a> 
                    để quản lý playlist
                </p>
            </c:if>
        </div>
    </div>

    <!-- Main Content Area -->
    <div class="main-content" id="mainContent">
        <!-- Mode 1: Khám phá (Categories, Songs, Singers) -->
        <div class="content-mode active" id="modeDiscover">
            <!-- Search Results Section (when searching) -->
            <c:if test="${not empty param.q or not empty param.category or not empty param.singer}">
                <section style="margin-bottom: 2rem;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                        <h3 class="section-title">
                            <i class='bx bx-search'></i> 
                            <c:choose>
                                <c:when test="${not empty param.q}">
                                    Kết quả tìm kiếm: "${param.q}"
                                </c:when>
                                <c:when test="${not empty param.category}">
                                    Bài hát theo danh mục
                                </c:when>
                                <c:when test="${not empty param.singer}">
                                    Bài hát của ca sĩ
                                </c:when>
                            </c:choose>
                        </h3>
                        <a href="${pageContext.request.contextPath}/" style="color: var(--accent-purple); text-decoration: none;">
                            <i class='bx bx-x-circle'></i> Xóa bộ lọc
                        </a>
                    </div>
                    <div class="song-grid">
                        <c:forEach var="s" items="${songs}">
                            <div class="song-card" onclick="window.location.href='${pageContext.request.contextPath}/song?id=${s.id}'">
                                <img src="${pageContext.request.contextPath}${s.thumbnail}" alt="${s.title}">
                                <div class="song-card-body">
                                    <div class="song-card-title">${s.title}</div>
                                    <div class="song-card-artist">
                                        <c:if test="${not empty s.singerId}">
                                            ${singerMap[s.singerId]}
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <c:if test="${empty songs}">
                        <p style="text-align: center; color: var(--text-secondary); padding: 2rem;">
                            Không tìm thấy kết quả nào
                        </p>
                    </c:if>
                </section>
            </c:if>
            
            <!-- Categories -->
            <section style="margin-bottom: 2rem;">
                <h3 class="section-title"><i class='bx bx-category-alt'></i> Danh mục</h3>
                <div class="carousel-container">
                    <button class="carousel-btn prev" onclick="scrollCarousel('categories', -1)">‹</button>
                    <div class="carousel-track" id="categories-track">
                        <c:forEach var="cat" items="${categories}">
                            <a href="${pageContext.request.contextPath}/song/category?id=${cat.id}" 
                               class="category-card category-card-carousel"
                               style="text-decoration: none; background: var(--bg-card); border-radius: 12px; overflow: hidden; transition: all 0.3s; display: block;">
                                <img src="${pageContext.request.contextPath}${cat.thumbnail}" 
                                     alt="${cat.name}"
                                     style="width: 100%; aspect-ratio: 1; object-fit: cover;"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/thumbs/default.png'">
                                <div style="padding: 0.7rem; text-align: center;">
                                    <div style="font-weight: 600; color: var(--text-primary); font-size: 0.9rem;">${cat.name}</div>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                <button class="carousel-btn next" onclick="scrollCarousel('categories', 1)">›</button>
            </div>
        </section>

        <!-- Top Songs by Views -->
        <!-- <section style="margin-bottom: 0rem;"> -->
        <section>
            <h3 class="section-title"><i class='bx bxs-hot'></i> Top bài hát được nghe nhiều</h3>
            <div class="top-songs-container">
                <ul class="top-list">
                    <c:forEach var="song" items="${topSongs}" varStatus="status">
                        <li class="top-item" onclick="window.location.href='${pageContext.request.contextPath}/song?id=${song.id}'">
                            <div class="top-rank">#${status.index + 1}</div>
                            <img src="${pageContext.request.contextPath}${song.thumbnail}" class="top-img" alt="${song.title}">
                            <div class="top-info">
                                <div class="top-title">${song.title}</div>
                                <div class="top-meta">
                                    <c:if test="${not empty song.singerId}">
                                        ${singerMap[song.singerId]} • 
                                    </c:if>
                                    ${song.viewCount} lượt nghe
                                </div>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </section>
        <!-- Song Grid -->
        <section style="margin-bottom: 3rem;">
            <h3 class="section-title"><i class='bx bx-headphone'></i> Bài hát mới nhất</h3>
            <div class="carousel-container">
                <button class="carousel-btn prev" onclick="scrollCarousel('songs', -1)">‹</button>
                <div class="carousel-track" id="songs-track">
                    <c:forEach var="s" items="${songs}" varStatus="status">
                        <c:if test="${status.index < 10}">
                            <div class="song-card song-card-carousel" onclick="window.location.href='${pageContext.request.contextPath}/song?id=${s.id}'">
                                <img src="${pageContext.request.contextPath}${s.thumbnail}" alt="${s.title}">
                                <div class="song-card-body">
                                    <div class="song-card-title">${s.title}</div>
                                    <div class="song-card-artist">
                                        <c:if test="${not empty s.singerId}">
                                            ${singerMap[s.singerId]}
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
                <button class="carousel-btn next" onclick="scrollCarousel('songs', 1)">›</button>
            </div>
        </section>
        <!-- Top Singers -->
        <section>
            <h3 class="section-title"><i class='bx bxs-star'></i> Ca sĩ nổi tiếng</h3>
            <div class="carousel-container">
                <button class="carousel-btn prev" onclick="scrollCarousel('singers', -1)">‹</button>
                <div class="carousel-track" id="singers-track">
                    <c:forEach var="singer" items="${topSingers}" varStatus="status">
                        <c:if test="${status.index < 10}">
                            <div class="artist-card artist-card-carousel" onclick="window.location.href='${pageContext.request.contextPath}/song/singer?id=${singer.id}'">
                                <img src="${pageContext.request.contextPath}${singer.avatar}" 
                                     class="artist-avatar" 
                                     alt="${singer.name}"
                                     onerror="this.src='${pageContext.request.contextPath}/assets/avatars/default.png'">
                                <div class="artist-name">${singer.name}</div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
                <button class="carousel-btn next" onclick="scrollCarousel('singers', 1)">›</button>
            </div>
        </section>
        </div>
        <!-- End Mode 1: Khám phá -->
        
        <!-- Mode 2: Playlist Detail -->
        <div class="content-mode" id="modePlaylist">
            <!-- Playlist detail will be loaded here via AJAX -->
            <div style="text-align: center; padding: 3rem; color: var(--text-secondary);">
                <h3>Chọn một playlist từ sidebar để xem chi tiết</h3>
            </div>
        </div>
        <!-- End Mode 2: Playlist Detail -->
    </div>
</div>

<script>
var currentMode = 1; // 1 = Discover, 2 = Playlist Detail
function scrollCarousel(id, direction) {
    const track = document.getElementById(id + '-track');
    const scrollAmount = 280;
    track.scrollBy({
        left: direction * scrollAmount,
        behavior: 'smooth'
    });
}

function toggleSidebar() {
    const sidebar = document.getElementById('playlistSidebar');
    sidebar.classList.toggle('collapsed');
}

function createNewPlaylist() {
    const name = prompt('Tên playlist mới:');
    if (name && name.trim()) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/playlist/create';
        
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'name';
        input.value = name.trim();
        
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }
}

// Load user playlists
window.addEventListener('DOMContentLoaded', function() {
    <c:if test="${not empty sessionScope.user}">
    loadPlaylists();
    </c:if>
    
    // Check URL for mode parameter
    var urlParams = new URLSearchParams(window.location.search);
    var mode = urlParams.get('mode');
    var playlistId = urlParams.get('id');
    var hasSearch = urlParams.get('q') || urlParams.get('category') || urlParams.get('singer');
    
    // If there's a search parameter, stay in discover mode to show results
    if (hasSearch) {
        switchMode(1);
    } else if (mode === '2' && playlistId) {
        // Load playlist detail
        loadPlaylistDetail(parseInt(playlistId), '');
    } else if (mode === '2') {
        // Just switch to playlist mode
        switchMode(2);
    } else {
        // Default to discover mode
        switchMode(1);
    }
});

function loadPlaylists() {
    fetch('${pageContext.request.contextPath}/playlist/api/list')
        .then(function(response) { return response.json(); })
        .then(function(data) {
            var container = document.getElementById('playlistList');
            if (data && data.length > 0) {
                var html = '';
                for (var i = 0; i < data.length; i++) {
                    var pl = data[i];
                    html += '<div class="playlist-item" data-playlist-id="' + pl.id + '" onclick="loadPlaylistDetail(' + pl.id + ', \'' + pl.name.replace(/'/g, "\\'") + '\')">'
                    html += '<div class="playlist-item-text">';
                    html += '<span><i class="bx bx-music"></i></span>';
                    html += '<span>' + pl.name + '</span>';
                    html += '</div>';
                    html += '</div>';
                }
                container.innerHTML = html;
            } else {
                container.innerHTML = '<p style="color: var(--text-secondary); font-size: 0.85rem; text-align: center; padding: 1rem;">Chưa có playlist</p>';
            }
        })
        .catch(function() {
            var container = document.getElementById('playlistList');
            container.innerHTML = '<p style="color: var(--text-secondary); font-size: 0.85rem; text-align: center; padding: 1rem;">Lỗi tải playlist</p>';
        });
}

// Alias for reloading playlists
function loadUserPlaylists() {
    loadPlaylists();
}

// Switch between modes
function switchMode(mode) {
    currentMode = mode;
    
    // Hide all modes
    var modes = document.querySelectorAll('.content-mode');
    for (var i = 0; i < modes.length; i++) {
        modes[i].classList.remove('active');
    }
    
    // Show selected mode
    if (mode === 1) {
        document.getElementById('modeDiscover').classList.add('active');
        // Update URL without reload
        if (window.history.pushState) {
            window.history.pushState({mode: 1}, '', '${pageContext.request.contextPath}/?mode=1');
        }
    } else if (mode === 2) {
        document.getElementById('modePlaylist').classList.add('active');
        // Update URL without reload
        if (window.history.pushState) {
            window.history.pushState({mode: 2}, '', '${pageContext.request.contextPath}/?mode=2');
        }
    }
}

function loadPlaylistDetail(playlistId, playlistName) {
    // Switch to playlist mode
    switchMode(2);
    
    // Highlight selected playlist
    var allPlaylists = document.querySelectorAll('.playlist-item');
    for (var i = 0; i < allPlaylists.length; i++) {
        allPlaylists[i].classList.remove('active');
    }
    var selectedPlaylist = document.querySelector('.playlist-item[data-playlist-id="' + playlistId + '"]');
    if (selectedPlaylist) {
        selectedPlaylist.classList.add('active');
    }
    
    var modePlaylist = document.getElementById('modePlaylist');
    
    // Show loading
    modePlaylist.innerHTML = '<div style="text-align: center; padding: 3rem; color: var(--text-primary);"><h3><i class="bx bx-loader-alt bx-spin"></i> Đang tải playlist...</h3></div>';
    
    // Load playlist detail via AJAX
    fetch('${pageContext.request.contextPath}/playlist/view?id=' + playlistId)
        .then(function(response) { return response.text(); })
        .then(function(html) {
            // Extract just the playlist detail content (not the full page with header/footer)
            var parser = new DOMParser();
            var doc = parser.parseFromString(html, 'text/html');
            
            // Try to find the playlist content wrapper
            var playlistContent = doc.querySelector('.playlist-detail-wrapper');
            if (playlistContent) {
                modePlaylist.innerHTML = playlistContent.outerHTML;
            } else {
                // Fallback: load the entire body content
                modePlaylist.innerHTML = html;
            }
            
            // Re-execute any scripts in the loaded content
            var scripts = modePlaylist.querySelectorAll('script');
            scripts.forEach(function(script) {
                var newScript = document.createElement('script');
                newScript.textContent = script.textContent;
                script.parentNode.replaceChild(newScript, script);
            });
            
            // Update URL
            if (window.history.pushState) {
                window.history.pushState({mode: 2, playlistId: playlistId}, '', '${pageContext.request.contextPath}/?mode=2&id=' + playlistId);
            }
        })
        .catch(function(err) {
            console.error('Error loading playlist:', err);
            modePlaylist.innerHTML = '<div style="text-align: center; padding: 3rem; color: #ff4444;"><h3><i class="bx bx-error-circle"></i> Lỗi tải playlist</h3><p>Vui lòng thử lại</p></div>';
        });
}

function loadHomeContent() {
    // Remove highlight from all playlists
    var allPlaylists = document.querySelectorAll('.playlist-item');
    for (var i = 0; i < allPlaylists.length; i++) {
        allPlaylists[i].classList.remove('active');
    }
    
    // Switch back to discover mode
    switchMode(1);
}

// Alias for compatibility
function loadHomePage() {
    loadHomeContent();
}

function showRenameModal(playlistId, currentName) {
    const modal = document.createElement('div');
    modal.className = 'modal-overlay active';
    modal.innerHTML = `
        <div class="modal-content">
            <div class="modal-header">Đổi tên Playlist</div>
            <div class="modal-body">
                <input type="text" id="newPlaylistName" value="${currentName}" 
                       style="width: 100%; padding: 0.8rem; border: 2px solid var(--accent-purple); border-radius: 8px; font-size: 1rem;">
            </div>
            <div class="modal-footer">
                <button class="btn-action" style="background: #ddd; color: #333;" onclick="this.closest('.modal-overlay').remove()">Hủy</button>
                <button class="btn-action" style="background: var(--accent-purple); color: white;" onclick="renamePlaylist(${playlistId})">Lưu</button>
            </div>
        </div>
    `;
    document.body.appendChild(modal);
}

function renamePlaylist(playlistId) {
    const newName = document.getElementById('newPlaylistName').value;
    if (newName && newName.trim()) {
        // TODO: Implement rename API endpoint
        alert('Tính năng đổi tên sẽ được thêm trong phiên bản tiếp theo');
        document.querySelector('.modal-overlay').remove();
    }
}

</script>

<jsp:include page="fragments/footer.jsp" />