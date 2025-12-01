<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<style>
.singer-view {
    display: flex;
    gap: 1.5rem;
}

.singer-content {
    flex: 1;
}

.singer-header {
    display: flex;
    align-items: center;
    gap: 2rem;
    padding: 2rem;
    background: linear-gradient(135deg, rgba(122, 92, 255, 0.15) 0%, rgba(0, 194, 255, 0.1) 100%);
    border-radius: 12px;
    margin-bottom: 1.5rem;
    border: 1px solid rgba(122, 92, 255, 0.2);
}

.singer-avatar {
    width: 150px;
    height: 150px;
    border-radius: 50%;
    object-fit: cover;
    border: 4px solid rgba(122, 92, 255, 0.3);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
}

.singer-info h1 {
    color: var(--accent-purple);
    margin: 0 0 0.5rem 0;
    font-size: 2rem;
}

.singer-stats {
    display: flex;
    gap: 2rem;
    margin-top: 1rem;
    color: var(--text-secondary);
}

.stat-item {
    display: flex;
    align-items: center;
    gap: 0.5rem;
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
    margin-top: 1rem;
}

.btn-play-all:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(122, 92, 255, 0.4);
}

.singer-songs-list {
    display: flex;
    flex-direction: column;
    gap: 0.8rem;
}

.singer-song-item {
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

.singer-song-item:hover {
    background: rgba(122, 92, 255, 0.15);
    border-color: var(--accent-purple);
    transform: translateX(5px);
}

.singer-song-item.playing {
    background: rgba(122, 92, 255, 0.2);
    border-color: var(--accent-purple);
}

.singer-song-item .song-number {
    width: 30px;
    text-align: center;
    color: var(--text-secondary);
    font-weight: 600;
}

.singer-song-item .song-thumb {
    width: 50px;
    height: 50px;
    border-radius: 6px;
    overflow: hidden;
}

.singer-song-item .song-thumb img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.singer-song-item .song-info-text {
    flex: 1;
}

.singer-song-item .song-info-text h4 {
    margin: 0 0 0.25rem 0;
    color: var(--text-primary);
}

.singer-song-item .song-info-text p {
    margin: 0;
    color: var(--text-secondary);
    font-size: 0.9rem;
}

.singer-sidebar {
    flex: 0 0 350px;
    position: sticky;
    top: 100px;
    height: fit-content;
}
</style>

<div class="singer-view">
    <div class="singer-content">
        <div class="singer-header">
            <img src="${ctx}${singer.avatar}" 
                 alt="${singer.name}" 
                 class="singer-avatar"
                 onerror="this.src='${ctx}/assets/avatars/default.png'">
            
            <div class="singer-info">
                <h1>
                    <i class='bx bx-user-circle'></i>
                    ${singer.name}
                </h1>
                
                <div class="singer-stats">
                    <div class="stat-item">
                        <i class='bx bx-music'></i>
                        <span>${songs.size()} bài hát</span>
                    </div>
                </div>
                
                <c:if test="${not empty songs}">
                    <button class="btn-play-all" onclick="window.playAllSingerSongs()">
                        <i class='bx bx-play-circle'></i> Phát tất cả
                    </button>
                </c:if>
            </div>
        </div>

        <div class="singer-songs-list">
            <c:forEach var="song" items="${songs}" varStatus="status">
                <div class="singer-song-item" data-song-id="${song.id}" data-song-index="${status.index}">
                    <div class="song-number">${status.index + 1}</div>
                    <div class="song-thumb">
                        <img src="${ctx}${song.thumbnail}" 
                             alt="${song.title}"
                             onerror="this.src='${ctx}/assets/thumbs/default.png'">
                    </div>
                    <div class="song-info-text">
                        <h4>${song.title}</h4>
                        <p>${singer.name}</p>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty songs}">
            <p style="text-align: center; color: var(--text-secondary); padding: 3rem;">
                Chưa có bài hát nào của ca sĩ này
            </p>
        </c:if>
    </div>

    <div class="singer-sidebar">
        <div id="singerSongDisplay" class="current-song-display">
            <i class='bx bx-music' style="font-size: 4rem; opacity: 0.3; color: var(--accent-purple);"></i>
            <p style="color: var(--text-secondary); margin-top: 1rem;">Chọn bài hát để phát</p>
        </div>
        
        <jsp:include page="lyrics-panel.jsp" />
    </div>
</div>

<script>
(function() {
    'use strict';
    
    const ctx = window.APP_CONTEXT || '';
    const singerSongs = [];
    
    <c:forEach var="song" items="${songs}">
    try {
        singerSongs.push({
            id: parseInt('${song.id}'),
            title: '<c:out value="${song.title}" escapeXml="true"/>',
            artist: '<c:out value="${singer.name}" escapeXml="true"/>',
            thumbnail: '<c:out value="${song.thumbnail}" escapeXml="false"/>',
            filePath: '<c:out value="${song.filePath}" escapeXml="false"/>'
        });
    } catch (e) {
        console.error('Error parsing song ${song.id}:', e);
    }
    </c:forEach>
    
    console.log('Singer songs loaded:', singerSongs.length);

    document.querySelectorAll('.singer-song-item').forEach(item => {
        item.addEventListener('click', function() {
            const songId = parseInt(this.dataset.songId);
            window.playSingerSong(songId);
            
            document.querySelectorAll('.singer-song-item').forEach(i => i.classList.remove('playing'));
            this.classList.add('playing');
        });
    });

    window.playSingerSong = function(songId) {
        const ctx = window.APP_CONTEXT || '';
        
        fetch(ctx + '/song/api/get?id=' + songId)
            .then(response => response.json())
            .then(data => {
                if (data.filePath && !data.filePath.startsWith('http') && !data.filePath.startsWith(ctx)) {
                    data.filePath = ctx + data.filePath;
                }
                if (data.thumbnail && !data.thumbnail.startsWith('http') && !data.thumbnail.startsWith(ctx)) {
                    data.thumbnail = ctx + data.thumbnail;
                }
                
                if (window.musicPlayer) {
                    window.musicPlayer.playSong(songId, data);
                }
                
                document.querySelectorAll('.singer-song-item').forEach(item => {
                    item.classList.toggle('playing', parseInt(item.dataset.songId) === songId);
                });
            })
            .catch(err => console.error('Error loading song:', err));
    };

    window.playAllSingerSongs = function() {
        if (singerSongs.length > 0) {
            window.playSingerSong(singerSongs[0].id);
            const firstSong = document.querySelector('.singer-song-item');
            if (firstSong) {
                firstSong.classList.add('playing');
            }
        }
    };
})();
</script>
