<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
.song-detail-view {
    padding: 2rem;
    max-width: 1200px;
    margin: 0 auto;
}

.song-main-section {
    display: grid;
    grid-template-columns: 400px 1fr;
    gap: 3rem;
    margin-bottom: 3rem;
    padding: 2rem;
    background: linear-gradient(135deg, rgba(122, 92, 255, 0.1) 0%, rgba(0, 194, 255, 0.05) 100%);
    border-radius: 16px;
    border: 1px solid rgba(122, 92, 255, 0.2);
}

.song-artwork {
    position: relative;
}

.song-artwork img {
    width: 100%;
    aspect-ratio: 1;
    border-radius: 12px;
    object-fit: cover;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
}

.song-info-main {
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.song-title-large {
    font-size: 2.5rem;
    font-weight: 700;
    color: var(--text-primary);
    margin-bottom: 1rem;
    line-height: 1.2;
}

.song-artist-link {
    font-size: 1.3rem;
    color: var(--text-secondary);
    margin-bottom: 1.5rem;
    cursor: pointer;
    transition: color 0.3s ease;
    display: inline-block;
}

.song-artist-link:hover {
    color: var(--accent-purple);
}

.song-meta-info {
    display: flex;
    flex-wrap: wrap;
    gap: 2rem;
    margin-bottom: 2rem;
    padding: 1.5rem;
    background: rgba(122, 92, 255, 0.05);
    border-radius: 8px;
}

.meta-info-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    color: var(--text-secondary);
}

.meta-info-item i {
    font-size: 1.3rem;
    color: var(--accent-purple);
}

.song-actions-main {
    display: flex;
    gap: 1rem;
}

.btn-play-main {
    flex: 1;
    padding: 1rem 2rem;
    background: var(--gradient-primary);
    color: white;
    border: none;
    border-radius: 30px;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(122, 92, 255, 0.3);
}

.btn-play-main:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 25px rgba(122, 92, 255, 0.5);
}

.btn-add-to-playlist {
    padding: 1rem 1.5rem;
    background: rgba(122, 92, 255, 0.1);
    color: var(--accent-purple);
    border: 2px solid var(--accent-purple);
    border-radius: 30px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 1.1rem;
}

.btn-add-to-playlist:hover {
    background: var(--accent-purple);
    color: white;
}

.suggestions-section {
    margin-top: 3rem;
}

.suggestions-header {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin-bottom: 1.5rem;
    color: var(--text-primary);
    font-size: 1.5rem;
    font-weight: 600;
}

.suggestions-carousel-container {
    position: relative;
    padding: 0 3rem;
    overflow: hidden;
}

.suggestions-carousel-track {
    display: flex;
    gap: 1.5rem;
    scroll-behavior: smooth;
    overflow-x: auto;
    scrollbar-width: none; /* Firefox */
    -ms-overflow-style: none; /* IE/Edge */
}

.suggestions-carousel-track::-webkit-scrollbar {
    display: none; /* Chrome/Safari */
}

.suggestions-carousel-btn {
    position: absolute;
    top: 50%;
    transform: translateY(-50%);
    background: rgba(122, 92, 255, 0.8);
    color: white;
    border: none;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    font-size: 1.5rem;
    cursor: pointer;
    z-index: 10;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
}

.suggestions-carousel-btn:hover {
    background: var(--accent-purple);
    transform: translateY(-50%) scale(1.1);
}

.suggestions-carousel-btn.prev {
    left: 0;
}

.suggestions-carousel-btn.next {
    right: 0;
}

.suggestion-card {
    background: rgba(122, 92, 255, 0.05);
    border: 1px solid rgba(122, 92, 255, 0.1);
    border-radius: 12px;
    padding: 1rem;
    cursor: pointer;
    transition: all 0.3s ease;
    width: 200px;
    flex-shrink: 0;
}

.suggestion-card:hover {
    background: rgba(122, 92, 255, 0.15);
    border-color: var(--accent-purple);
    transform: translateY(-5px);
    box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
}

.suggestion-thumbnail {
    width: 100%;
    aspect-ratio: 1;
    border-radius: 8px;
    object-fit: cover;
    margin-bottom: 0.8rem;
}

.suggestion-title {
    font-weight: 600;
    color: var(--text-primary);
    margin-bottom: 0.3rem;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    font-size: 0.95rem;
}

.suggestion-artist {
    color: var(--text-secondary);
    font-size: 0.85rem;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

@media (max-width: 768px) {
    .song-main-section {
        grid-template-columns: 1fr;
    }
    
    .song-title-large {
        font-size: 1.8rem;
    }
    
    .suggestions-carousel-container {
        padding: 0 2rem;
    }
    
    .suggestions-carousel-btn {
        width: 35px;
        height: 35px;
        font-size: 1.2rem;
    }
}
</style>

<div class="song-detail-view">
    <div class="song-main-section">
        <div class="song-artwork">
            <img src="${ctx}${song.thumbnail}" 
                 alt="${song.title}"
                 onerror="this.src='${ctx}/assets/thumbs/default.png'">
        </div>
        
        <div class="song-info-main">
            <h1 class="song-title-large">${song.title}</h1>
            
            <c:if test="${not empty singerMap[song.singerId]}">
                <a class="song-artist-link" onclick="window.viewSinger(${song.singerId})">
                    <i class='bx bx-user-circle'></i> ${singerMap[song.singerId]}
                </a>
            </c:if>
            
            <div class="song-meta-info">
                <c:if test="${not empty categoryMap[song.categoryId]}">
                    <div class="meta-info-item">
                        <i class='bx bx-category'></i>
                        <span>${categoryMap[song.categoryId]}</span>
                    </div>
                </c:if>
                <div class="meta-info-item">
                    <i class='bx bx-headphone'></i>
                    <span>${song.viewCount} lượt nghe</span>
                </div>
                <div class="meta-info-item">
                    <i class='bx bx-time'></i>
                    <span>${song.uploadDate}</span>
                </div>
            </div>
            
            <div class="song-actions-main">
                <button class="btn-play-main" onclick="window.playMainSong()">
                    <i class='bx bx-play-circle' style="font-size: 1.5rem;"></i>
                    Phát ngay
                </button>
                <button class="btn-add-to-playlist" onclick="window.showAddToPlaylistDialog(${song.id})">
                    <i class='bx bx-plus' style="font-size: 1.5rem;"></i>
                </button>
            </div>
        </div>
    </div>
    
    <c:if test="${not empty suggestions}">
        <div class="suggestions-section">
            <div class="suggestions-header">
                <i class='bx bx-music'></i>
                <span>Gợi ý từ ${categoryMap[song.categoryId]}</span>
            </div>
            
            <div class="suggestions-carousel-container">
                <button class="suggestions-carousel-btn prev" onclick="scrollSuggestionsCarousel(-1)">‹</button>
                <div class="suggestions-carousel-track" id="suggestions-track">
                    <c:forEach var="suggestedSong" items="${suggestions}">
                        <div class="suggestion-card" onclick="window.viewSong(${suggestedSong.id})">
                            <img src="${ctx}${suggestedSong.thumbnail}" 
                                 alt="${suggestedSong.title}" 
                                 class="suggestion-thumbnail"
                                 onerror="this.src='${ctx}/assets/thumbs/default.png'">
                            <div class="suggestion-title">${suggestedSong.title}</div>
                            <c:if test="${not empty singerMap[suggestedSong.singerId]}">
                                <div class="suggestion-artist">${singerMap[suggestedSong.singerId]}</div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
                <button class="suggestions-carousel-btn next" onclick="scrollSuggestionsCarousel(1)">›</button>
            </div>
        </div>
    </c:if>
</div>

<script>
(function() {
    'use strict';
    
    const ctx = window.APP_CONTEXT || '';
    
    const mainSong = {
        id: ${song.id},
        title: '${song.title}',
        artist: '<c:if test="${not empty singerMap[song.singerId]}">${singerMap[song.singerId]}</c:if>',
        filePath: '${song.filePath}',
        thumbnail: '${song.thumbnail}',
        lyrics: `${song.lyrics != null ? song.lyrics : ''}`
    };

    window.playMainSong = function() {
        console.log('Playing main song:', mainSong);
        
        // Add context path if needed
        if (mainSong.filePath && !mainSong.filePath.startsWith('http') && !mainSong.filePath.startsWith(ctx)) {
            mainSong.filePath = ctx + mainSong.filePath;
        }
        if (mainSong.thumbnail && !mainSong.thumbnail.startsWith('http') && !mainSong.thumbnail.startsWith(ctx)) {
            mainSong.thumbnail = ctx + mainSong.thumbnail;
        }
        
        if (window.musicPlayer) {
            window.musicPlayer.playSong(mainSong.id, mainSong);
        } else {
            console.error('Music player not initialized');
            alert('Không thể phát nhạc. Vui lòng tải lại trang.');
        }
    };

    window.showAddToPlaylistDialog = function(songId) {
        if (!window.playlistManager || !window.playlistManager.playlists) {
            alert('Chưa load được danh sách playlist');
            return;
        }
        
        const playlists = window.playlistManager.playlists;
        if (playlists.length === 0) {
            alert('Bạn chưa có playlist nào. Hãy tạo playlist mới!');
            return;
        }
        
        let html = '<select id="playlistSelect" style="width: 100%; padding: 0.5rem; margin-bottom: 1rem;">';
        playlists.forEach(pl => {
            html += '<option value="' + pl.id + '">' + pl.name + '</option>';
        });
        html += '</select>';
        
        const playlistId = prompt('Chọn playlist (ID):\n' + playlists.map((p, i) => (i + 1) + '. ' + p.name).join('\n'));
        if (playlistId && window.playlistManager) {
            window.playlistManager.addSongToPlaylist(parseInt(playlistId), songId);
        }
    };

    window.scrollSuggestionsCarousel = function(direction) {
        const track = document.getElementById('suggestions-track');
        if (track) {
            const scrollAmount = 400;
            track.scrollBy({
                left: direction * scrollAmount,
                behavior: 'smooth'
            });
        }
    };

    console.log('Song detail view initialized:', mainSong.title);
})();
</script>
