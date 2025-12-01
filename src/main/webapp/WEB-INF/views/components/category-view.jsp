<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
.category-view {
    display: flex;
    gap: 1.5rem;
}

.category-content {
    flex: 6;
}

.category-header {
    background: linear-gradient(135deg, rgba(122, 92, 255, 0.15) 0%, rgba(0, 194, 255, 0.1) 100%);
    padding: 2rem;
    border-radius: 12px;
    margin-bottom: 1.5rem;
    border: 1px solid rgba(122, 92, 255, 0.2);
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.category-header h1 {
    color: var(--accent-purple);
    margin: 0;
}

.category-header .header-left {
    flex: 1;
}

.category-header .header-right {
    display: flex;
    gap: 1rem;
    align-items: center;
}

.btn-play-all {
    padding: 0.8rem 2rem;
    background: var(--gradient-primary);
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    display: flex;
    align-items: center;
    gap: 0.5rem;
    transition: all 0.3s;
}

.btn-play-all:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(122, 92, 255, 0.4);
}

.category-songs-list {
    display: flex;
    flex-direction: column;
    gap: 0.8rem;
}

.category-song-item {
    background: rgba(122, 92, 255, 0.05);
    border: 1px solid rgba(122, 92, 255, 0.1);
    border-radius: 8px;
    padding: 1rem;
    display: flex;
    align-items: center;
    gap: 1rem;
    cursor: pointer;
    transition: all 0.3s;
}

.category-song-item:hover {
    background: rgba(122, 92, 255, 0.15);
    border-color: var(--accent-purple);
    transform: translateX(5px);
}

.category-song-item.playing {
    background: rgba(122, 92, 255, 0.2);
    border-color: var(--accent-purple);
}

.category-song-item .song-number {
    width: 30px;
    text-align: center;
    color: var(--text-secondary);
    font-weight: 600;
}

.category-song-item .song-thumb {
    width: 50px;
    height: 50px;
    border-radius: 6px;
    overflow: hidden;
}

.category-song-item .song-thumb img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.category-song-item .song-info-text {
    flex: 1;
}

.category-song-item .song-info-text h4 {
    margin: 0 0 0.25rem 0;
    color: var(--text-primary);
}

.category-song-item .song-info-text p {
    margin: 0;
    color: var(--text-secondary);
    font-size: 0.9rem;
}

.category-sidebar {
    flex: 4;
    position: sticky;
    top: 100px;
    height: fit-content;
    background: rgba(26, 26, 27, 0.6);
    border-radius: 12px;
    padding: 1.5rem;
    border: 1px solid rgba(122, 92, 255, 0.2);
}

.current-song-display {
    text-align: center;
    padding: 2rem 1rem;
}

.current-song-display img {
    width: 100%;
    max-width: 300px;
    border-radius: 12px;
    margin-bottom: 1rem;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

.current-song-display h4 {
    color: var(--text-primary);
    margin: 0.5rem 0;
}

.current-song-display p {
    color: var(--text-secondary);
    margin: 0;
}
</style>

<div class="category-view">
    <!-- Main Content (60%): Song List -->
    <div class="category-content">
        <div class="category-header">
            <div class="header-left">
                <h1>
                    <i class='bx bx-category-alt'></i>
                    ${category.name}
                </h1>
                <p style="margin: 0.5rem 0 0 0; color: var(--text-secondary);">${songs.size()} bài hát</p>
            </div>
            <div class="header-right">
                <c:if test="${not empty songs}">
                    <button class="btn-play-all" onclick="window.playAllCategorySongs()">
                        <i class='bx bx-play-circle'></i> Phát tất cả
                    </button>
                </c:if>
            </div>
        </div>

        <div class="category-songs-list">
            <c:forEach var="song" items="${songs}" varStatus="status">
                <div class="category-song-item" data-song-id="${song.id}" data-song-index="${status.index}">
                    <div class="song-number">${status.index + 1}</div>
                    <div class="song-thumb">
                        <img src="${pageContext.request.contextPath}${song.thumbnail}" 
                             alt="${song.title}"
                             onerror="this.src='${pageContext.request.contextPath}/assets/thumbs/default.png'">
                    </div>
                    <div class="song-info-text">
                        <h4>${song.title}</h4>
                        <p>
                            <c:if test="${not empty song.singerId}">
                                ${singerMap[song.singerId]}
                            </c:if>
                        </p>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty songs}">
            <p style="text-align: center; color: var(--text-secondary); padding: 3rem;">
                Chưa có bài hát trong danh mục này
            </p>
        </c:if>
    </div>

    <!-- Sidebar (40%): Current Song + Lyrics -->
    <div class="category-sidebar" id="categorySidebar">
        <div id="categorySongDisplay" class="current-song-display">
            <i class='bx bx-music' style="font-size: 4rem; opacity: 0.3; color: var(--accent-purple);"></i>
            <p style="color: var(--text-secondary); margin-top: 1rem;">Chọn bài hát để phát</p>
        </div>
        
        <jsp:include page="lyrics-panel.jsp" />
    </div>
</div>

<script>
// Make functions global for inline onclick handlers
(function() {
    const categorySongs = [];
    <c:forEach var="song" items="${songs}">
        categorySongs.push({
            id: parseInt('${song.id}'),
            title: '${song.title}',
            artist: '<c:if test="${not empty song.singerId}">${singerMap[song.singerId]}</c:if>',
            thumbnail: '${song.thumbnail}'
        });
    </c:forEach>

    document.querySelectorAll('.category-song-item').forEach(item => {
        item.addEventListener('click', function() {
            const songId = parseInt(this.dataset.songId);
            window.playCategorySong(songId);
            
            // Highlight playing song
            document.querySelectorAll('.category-song-item').forEach(i => i.classList.remove('playing'));
            this.classList.add('playing');
        });
    });

    window.playCategorySong = function(songId) {
        const ctx = window.APP_CONTEXT || '';
        
        fetch(ctx + '/song/api/get?id=' + songId)
            .then(response => response.json())
            .then(data => {
                // Add context to paths if needed
                if (data.filePath && !data.filePath.startsWith('http') && !data.filePath.startsWith(ctx)) {
                    data.filePath = ctx + data.filePath;
                }
                if (data.thumbnail && !data.thumbnail.startsWith('http') && !data.thumbnail.startsWith(ctx)) {
                    data.thumbnail = ctx + data.thumbnail;
                }
                
                if (window.musicPlayer) {
                    window.musicPlayer.playSong(songId, data);
                }
                
                // Highlight playing song
                document.querySelectorAll('.category-song-item').forEach(item => {
                    item.classList.toggle('playing', parseInt(item.dataset.songId) === songId);
                });
            })
            .catch(err => console.error('Error loading song:', err));
    };

    window.playAllCategorySongs = function() {
        if (categorySongs.length > 0) {
            window.playCategorySong(categorySongs[0].id);
            // Highlight first song
            const firstSong = document.querySelector('.category-song-item');
            if (firstSong) {
                firstSong.classList.add('playing');
            }
        }
    };
})();
</script>
