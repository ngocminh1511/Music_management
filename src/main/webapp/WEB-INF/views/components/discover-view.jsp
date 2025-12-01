<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
.discover-view {
    padding: 1rem;
}
.section-title {
    color: var(--accent-purple);
    margin-bottom: 1.5rem;
    font-size: 1.3rem;
    font-weight: 700;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}
.category-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 1.5rem;
    margin-bottom: 3rem;
}
.category-card {
    background: var(--bg-card);
    border-radius: 12px;
    overflow: hidden;
    transition: all 0.3s;
    cursor: pointer;
    border: 2px solid transparent;
}
.category-card:hover {
    border-color: var(--accent-purple);
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(122, 92, 255, 0.3);
}
.category-card img {
    width: 100%;
    aspect-ratio: 1;
    object-fit: cover;
}
.category-card-body {
    padding: 1rem;
    text-align: center;
}
.category-card-title {
    font-weight: 600;
    color: var(--text-primary);
    font-size: 1rem;
}
.song-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
}
.song-card {
    background: var(--bg-card);
    border-radius: 12px;
    overflow: hidden;
    transition: all 0.3s;
    cursor: pointer;
    border: 2px solid transparent;
}
.song-card:hover {
    border-color: var(--accent-purple);
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
.carousel-container {
    position: relative;
    overflow: hidden;
    padding: 0 3rem;
    margin-bottom: 2rem;
}
.carousel-track {
    display: flex;
    gap: 1.5rem;
    overflow-x: auto;
    scroll-behavior: smooth;
    scrollbar-width: none;
    -ms-overflow-style: none;
    padding: 1rem 0;
}
.carousel-track::-webkit-scrollbar {
    display: none;
}
.carousel-btn {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    width: 45px;
    height: 45px;
    border-radius: 50%;
    background: rgba(122, 92, 255, 0.9);
    border: none;
    color: white;
    font-size: 1.5rem;
    cursor: pointer;
    z-index: 10;
    transition: all 0.3s;
    display: flex;
    align-items: center;
    justify-content: center;
}
.carousel-btn:hover {
    background: var(--accent-purple);
    transform: translateY(-50%) scale(1.15);
}
.carousel-btn.prev { left: 0.5rem; }
.carousel-btn.next { right: 0.5rem; }
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
    cursor: pointer;
    transition: all 0.3s;
}
.artist-card-carousel:hover {
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
</style>

<!-- Discover View Component -->
<div class="discover-view">
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
                    <div class="song-card" data-song-id="${s.id}">
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
    <section style="margin-bottom: 3rem;">
        <h3 class="section-title"><i class='bx bx-category-alt'></i> Danh mục âm nhạc</h3>
        <div class="category-grid">
            <c:forEach var="cat" items="${categories}">
                <div class="category-card" data-category-id="${cat.id}">
                    <img src="${pageContext.request.contextPath}${cat.thumbnail}" 
                         alt="${cat.name}"
                         onerror="this.src='${pageContext.request.contextPath}/assets/thumbs/default.png'">
                    <div class="category-card-body">
                        <div class="category-card-title">${cat.name}</div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- Top Songs -->
    <section>
        <h3 class="section-title"><i class='bx bxs-hot'></i> Top bài hát được nghe nhiều</h3>
        <div class="top-songs-container">
            <ul class="top-list">
                <c:forEach var="song" items="${topSongs}" varStatus="status">
                    <li class="top-item" data-song-id="${song.id}">
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

    <!-- Latest Songs Carousel -->
    <section style="margin-bottom: 2rem;">
        <h3 class="section-title"><i class='bx bx-headphone'></i> Bài hát mới nhất</h3>
        <div class="carousel-container">
            <button class="carousel-btn prev" onclick="scrollCarousel('songs', -1)">‹</button>
            <div class="carousel-track" id="songs-track">
                <c:forEach var="s" items="${songs}" varStatus="status">
                    <c:if test="${status.index < 10}">
                        <div class="song-card song-card-carousel" data-song-id="${s.id}">
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
                        <div class="artist-card artist-card-carousel" data-singer-id="${singer.id}">
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

<script>
// Event delegation for all interactive elements
(function() {
    // Wait a bit for DOM to be ready if needed
    function initDiscoverEvents() {
        // Category cards
        document.querySelectorAll('.category-card').forEach(card => {
            card.addEventListener('click', function() {
                const categoryId = parseInt(this.dataset.categoryId);
                if (window.viewCategory) window.viewCategory(categoryId);
            });
        });
        
        // Song cards
        document.querySelectorAll('.song-card').forEach(card => {
            card.addEventListener('click', function() {
                const songId = parseInt(this.dataset.songId);
                if (window.viewSong) window.viewSong(songId);
            });
        });
        
        // Top items
        document.querySelectorAll('.top-item').forEach(item => {
            item.addEventListener('click', function() {
                const songId = parseInt(this.dataset.songId);
                if (window.viewSong) window.viewSong(songId);
            });
        });
        
        // Artist cards
        document.querySelectorAll('.artist-card').forEach(card => {
            card.addEventListener('click', function() {
                const singerId = parseInt(this.dataset.singerId);
                if (window.viewSinger) window.viewSinger(singerId);
            });
        });
    }
    
    // Run immediately if DOM is ready, otherwise wait
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initDiscoverEvents);
    } else {
        initDiscoverEvents();
    }
})();
</script>
