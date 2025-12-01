<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
.playlist-view {
    display: flex;
    gap: 1.5rem;
}

.playlist-main-content {
    flex: 6;
}

.playlist-sidebar {
    flex: 0 0 350px;
    position: sticky;
    top: 100px;
    height: fit-content;
    background: rgba(26, 26, 27, 0.6);
    border-radius: 12px;
    padding: 1.5rem;
    border: 1px solid rgba(122, 92, 255, 0.2);
}

.playlist-song-item {
    background: rgba(122, 92, 255, 0.05);
    border: 1px solid rgba(122, 92, 255, 0.1);
    border-radius: 8px;
    padding: 1rem;
    display: flex;
    align-items: center;
    gap: 1rem;
    cursor: pointer;
    transition: all 0.3s;
    margin-bottom: 0.8rem;
}

.playlist-song-item:hover {
    background: rgba(122, 92, 255, 0.15);
    border-color: var(--accent-purple);
    transform: translateX(5px);
}

.playlist-song-item.playing {
    background: rgba(122, 92, 255, 0.2);
    border-color: var(--accent-purple);
}

.now-playing-display {
    text-align: center;
    padding: 2rem 1rem;
}

.now-playing-display img {
    width: 100%;
    border-radius: 12px;
    margin-bottom: 1rem;
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}

.now-playing-display h4 {
    color: var(--text-primary);
    margin: 0.5rem 0;
}

.now-playing-display p {
    color: var(--text-secondary);
    margin: 0;
}

.btn-play-all {
    padding: 0.8rem 2rem;
    background: var(--gradient-primary);
    color: white;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    display: inline-flex;
    align-items: center;
    gap: 0.5rem;
    transition: all 0.3s;
}

.btn-play-all:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(122, 92, 255, 0.4);
}

.playlist-header {
    display: flex;
    gap: 1.5rem;
    align-items: center;
    margin-bottom: 1.5rem;
    padding: 2rem;
    background: linear-gradient(135deg, rgba(122, 92, 255, 0.15) 0%, rgba(0, 194, 255, 0.1) 100%);
    border: 1px solid rgba(122, 92, 255, 0.2);
    border-radius: 12px;
}

.playlist-header-info {
    flex: 1;
}

.playlist-actions {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}
</style>

<div class="playlist-view">
    <!-- Main Content (60%): Song List -->
    <div class="playlist-main-content">
        <div class="playlist-header">
            <div class="playlist-header-info">
                <h1 id="playlistTitle">
                    <i class='bx bx-list-ul'></i>
                    ${playlist.name}
                </h1>
                <div class="playlist-info">
                    <p style="margin: 0.5rem 0 0 0; color: var(--text-secondary);">${songs.size()} bài hát</p>
                </div>
            </div>
            <div class="playlist-actions">
                <c:if test="${not empty songs}">
                    <button class="btn-play-all" onclick="window.playAllPlaylistSongs()" style="margin-right: 1rem;">
                        <i class='bx bx-play-circle'></i> Phát tất cả
                    </button>
                </c:if>
                <button class="btn-icon btn-rename" data-playlist-id="${playlist.id}" data-playlist-name="${playlist.name}">
                    <i class='bx bx-edit-alt'></i>
                </button>
                <button class="btn-icon btn-danger btn-delete" data-playlist-id="${playlist.id}">
                    <i class='bx bx-trash'></i>
                </button>
            </div>
        </div>

        <div class="playlist-songs">
            <c:forEach var="song" items="${songs}">
                <div class="playlist-song-item" id="song-${song.id}" data-song-id="${song.id}">
                    <div class="song-thumbnail">
                        <img src="${pageContext.request.contextPath}${song.thumbnail}" 
                             alt="${song.title}"
                             onerror="this.src='${pageContext.request.contextPath}/assets/thumbs/default.png'">
                    </div>
                    <div class="song-info">
                        <h4>${song.title}</h4>
                        <p>
                            <c:if test="${not empty song.singerId}">
                                ${singerMap[song.singerId]}
                            </c:if>
                        </p>
                    </div>
                    <button class="btn-remove" data-playlist-id="${playlist.id}" data-song-id="${song.id}">
                        <i class='bx bx-x'></i>
                    </button>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty songs}">
            <p style="text-align: center; color: var(--text-secondary); padding: 3rem;">
                Chưa có bài hát trong playlist này
            </p>
        </c:if>
    </div>

    <!-- Sidebar (40%): Now Playing + Lyrics -->
    <div class="playlist-sidebar">
        <div id="nowPlayingDisplay" class="now-playing-display">
            <i class='bx bx-music' style="font-size: 4rem; opacity: 0.3; color: var(--accent-purple);"></i>
            <p style="color: var(--text-secondary); margin-top: 1rem;">Chọn bài hát để phát</p>
        </div>
        
        <jsp:include page="lyrics-panel.jsp" />
    </div>
</div>

<script>
// Make functions global for inline onclick handlers
(function() {
    'use strict';
    
    const playlistSongs = [];
    <c:forEach var="song" items="${songs}">
    try {
        playlistSongs.push({
            id: parseInt('${song.id}'),
            title: '<c:out value="${song.title}" escapeXml="true"/>',
            artist: '<c:if test="${not empty song.singerId}"><c:out value="${singerMap[song.singerId]}" escapeXml="true"/></c:if>',
            thumbnail: '<c:out value="${song.thumbnail}" escapeXml="false"/>'
        });
    } catch (e) {
        console.error('Error parsing song ${song.id}:', e);
    }
    </c:forEach>
    
    console.log('Playlist songs loaded:', playlistSongs.length);

    // Event delegation for song items
    document.querySelectorAll('.playlist-song-item').forEach(item => {
        item.addEventListener('click', function(e) {
            if (e.target.closest('.btn-remove')) return;
            
            const songId = parseInt(this.dataset.songId);
            window.playPlaylistSong(songId);
            
            // Highlight playing song
            document.querySelectorAll('.playlist-song-item').forEach(i => i.classList.remove('playing'));
            this.classList.add('playing');
        });
    });

    // Rename button
    document.querySelectorAll('.btn-rename').forEach(btn => {
        btn.addEventListener('click', function() {
            const playlistId = parseInt(this.dataset.playlistId);
            const playlistName = this.dataset.playlistName;
            if (window.playlistManager) {
                window.playlistManager.renamePlaylist(playlistId, playlistName);
            }
        });
    });

    // Delete button
    document.querySelectorAll('.btn-delete').forEach(btn => {
        btn.addEventListener('click', function() {
            const playlistId = parseInt(this.dataset.playlistId);
            if (window.playlistManager) {
                window.playlistManager.deletePlaylist(playlistId);
            }
        });
    });

    // Remove song buttons
    document.querySelectorAll('.btn-remove').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            const playlistId = parseInt(this.dataset.playlistId);
            const songId = parseInt(this.dataset.songId);
            if (window.playlistManager) {
                window.playlistManager.removeSongFromPlaylist(playlistId, songId);
            }
        });
    });

    window.playPlaylistSong = function(songId) {
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
                
                // Update sidebar display
                const displayDiv = document.getElementById('nowPlayingDisplay');
                if (displayDiv) {
                    displayDiv.innerHTML = `
                        <img src="${data.thumbnail}" 
                             alt="${data.title}"
                             onerror="this.src='${ctx}/assets/thumbs/default.png'">
                        <h4>${data.title}</h4>
                        <p>${data.artist || 'Unknown Artist'}</p>
                    `;
                }
                
                if (window.musicPlayer) {
                    window.musicPlayer.playSong(songId, data);
                }
                
                // Highlight playing song
                document.querySelectorAll('.playlist-song-item').forEach(item => {
                    item.classList.toggle('playing', parseInt(item.dataset.songId) === songId);
                });
            })
            .catch(err => console.error('Error loading song:', err));
    };

    window.playAllPlaylistSongs = function() {
        if (playlistSongs.length > 0) {
            window.playPlaylistSong(playlistSongs[0].id);
            // Highlight first song
            const firstItem = document.querySelector('.playlist-song-item');
            if (firstItem) {
                firstItem.classList.add('playing');
            }
        }
    };
})();
</script>
