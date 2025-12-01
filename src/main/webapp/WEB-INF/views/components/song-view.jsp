<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="song-view">
    <div class="song-main">
        <div class="song-hero">
            <img src="${pageContext.request.contextPath}${song.thumbnail}" 
                 alt="${song.title}"
                 onerror="this.src='${pageContext.request.contextPath}/assets/thumbs/default.png'">
        </div>
        <div class="song-details">
            <h1>${song.title}</h1>
            <p class="artist">
                <c:if test="${not empty song.singerId}">
                    ${singerMap[song.singerId]}
                </c:if>
            </p>
            <div class="song-meta">
                <c:if test="${not empty song.duration}">
                    <span><i class='bx bx-time'></i> ${song.duration}</span>
                </c:if>
                <c:if test="${not empty song.categoryId}">
                    <span><i class='bx bx-category'></i> ${categoryMap[song.categoryId]}</span>
                </c:if>
            </div>
            <button class="btn-play-large" data-song-id="${song.id}">
                <i class='bx bx-play'></i> Phát nhạc
            </button>
            <div class="song-actions">
                <button class="btn-secondary btn-add-to-playlist" data-song-id="${song.id}">
                    <i class='bx bx-list-plus'></i> Thêm vào playlist
                </button>
            </div>
        </div>
    </div>

    <div class="song-lyrics">
        <jsp:include page="lyrics-panel.jsp">
            <jsp:param name="lyrics" value="${song.lyrics}" />
        </jsp:include>
    </div>
</div>

<script>
// Play button
const playBtn = document.querySelector('.btn-play-large');
if (playBtn) {
    playBtn.addEventListener('click', function() {
        const songId = parseInt(this.dataset.songId);
        playSingleSong(songId);
    });
}

// Add to playlist button
const addBtn = document.querySelector('.btn-add-to-playlist');
if (addBtn) {
    addBtn.addEventListener('click', function() {
        const songId = parseInt(this.dataset.songId);
        showAddToPlaylistDialog(songId);
    });
}

function playSingleSong(songId) {
    const ctx = window.APP_CONTEXT || '';
    
    fetch(ctx + '/song/api/get?id=' + songId)
        .then(response => response.json())
        .then(data => {
            if (window.musicPlayer) {
                // Add context to paths if needed
                if (data.filePath && !data.filePath.startsWith('http') && !data.filePath.startsWith(ctx)) {
                    data.filePath = ctx + data.filePath;
                }
                if (data.thumbnail && !data.thumbnail.startsWith('http') && !data.thumbnail.startsWith(ctx)) {
                    data.thumbnail = ctx + data.thumbnail;
                }
                window.musicPlayer.playSong(songId, data);
            }
        })
        .catch(err => console.error('Error playing song:', err));
}

function showAddToPlaylistDialog(songId) {
    if (!window.playlistManager || !window.playlistManager.playlists) {
        alert('Chưa load được danh sách playlist');
        return;
    }
    
    const playlists = window.playlistManager.playlists;
    
    if (playlists.length === 0) {
        if (confirm('Bạn chưa có playlist nào. Tạo mới?')) {
            window.playlistManager.createPlaylist();
        }
        return;
    }
    
    let html = '<div class="playlist-select-dialog">';
    html += '<h3>Chọn playlist</h3>';
    html += '<div class="playlist-list">';
    
    for (let i = 0; i < playlists.length; i++) {
        const pl = playlists[i];
        html += '<div class="playlist-option" data-playlist-id="' + pl.id + '" data-song-id="' + songId + '">';
        html += '<i class="bx bx-music"></i> ' + pl.name;
        html += '</div>';
    }
    
    html += '</div>';
    html += '<button class="btn-cancel-dialog">Hủy</button>';
    html += '</div>';
    
    const overlay = document.createElement('div');
    overlay.id = 'playlistDialogOverlay';
    overlay.className = 'dialog-overlay';
    overlay.innerHTML = html;
    document.body.appendChild(overlay);
    
    // Event listeners for options
    overlay.querySelectorAll('.playlist-option').forEach(option => {
        option.addEventListener('click', function() {
            const playlistId = parseInt(this.dataset.playlistId);
            const songId = parseInt(this.dataset.songId);
            addToPlaylistConfirmed(playlistId, songId);
        });
    });
    
    overlay.querySelector('.btn-cancel-dialog').addEventListener('click', closePlaylistDialog);
}

function addToPlaylistConfirmed(playlistId, songId) {
    if (window.playlistManager) {
        window.playlistManager.addSongToPlaylist(playlistId, songId);
    }
    closePlaylistDialog();
}

function closePlaylistDialog() {
    const overlay = document.getElementById('playlistDialogOverlay');
    if (overlay) overlay.remove();
}
</script>
