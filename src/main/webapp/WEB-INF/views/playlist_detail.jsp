<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Playlist Detail Content (No Header/Footer - for AJAX loading) -->
<style>
.playlist-detail-wrapper {
    width: 100%;
}
.playlist-header-section {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 1.5rem;
    margin-bottom: 1.5rem;
    background: linear-gradient(135deg, rgba(122, 92, 255, 0.15) 0%, rgba(0, 194, 255, 0.1) 100%);
    padding: 1.5rem 2rem;
    border-radius: 12px;
    border: 1px solid rgba(122, 92, 255, 0.2);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}
.playlist-title-input {
    font-size: 1.8rem;
    font-weight: 700;
    background: transparent;
    border: none;
    border-bottom: 2px solid transparent;
    background: linear-gradient(135deg, var(--accent-purple) 0%, var(--accent-blue) 100%);
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
    padding: 0.5rem 0;
    transition: all 0.3s;
    flex: 1;
}
.playlist-title-input:hover,
.playlist-title-input:focus {
    border-bottom-color: var(--accent-purple);
    outline: none;
}
.playlist-actions {
    display: flex;
    gap: 1rem;
}
.btn-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: none;
    cursor: pointer;
    font-size: 1.2rem;
    transition: all 0.3s;
}
.btn-delete-playlist {
    background: rgba(255, 0, 0, 0.2);
    color: #ff4444;
}
.btn-delete-playlist:hover {
    background: #ff4444;
    color: white;
}
.content-wrapper {
    display: flex;
    gap: 2rem;
}
.songs-list {
    flex: 1;
    min-width: 0;
}

.songs-section {
    background: var(--bg-card);
    border-radius: 12px;
    padding: 1.5rem;
    margin-bottom: 1.5rem;
    border: 1px solid rgba(122, 92, 255, 0.1);
}

.songs-section h3 {
    color: var(--accent-purple);
    margin-bottom: 1rem;
    font-size: 1.2rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}
.search-panel {
    width: 380px;
    background: linear-gradient(135deg, rgba(26, 26, 27, 0.95) 0%, rgba(10, 10, 11, 0.95) 100%);
    border-radius: 12px;
    padding: 1.5rem;
    height: fit-content;
    position: sticky;
    top: 100px;
    border: 1px solid rgba(122, 92, 255, 0.2);
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
}
.search-box {
    display: flex;
    gap: 0.5rem;
    margin-bottom: 1.5rem;
}
.search-input {
    flex: 1;
    padding: 0.8rem;
    border: 1px solid var(--accent-purple);
    border-radius: 8px;
    background: rgba(122, 92, 255, 0.05);
    color: var(--text-primary);
}
.search-btn {
    padding: 0.8rem 1.5rem;
    background: var(--gradient-primary);
    border: none;
    border-radius: 8px;
    color: white;
    cursor: pointer;
}
.song-item {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 1rem;
    background: var(--bg-card);
    border-radius: 10px;
    margin-bottom: 0.7rem;
    transition: all 0.3s;
}
.song-item:hover {
    background: rgba(122, 92, 255, 0.1);
}
.song-thumb {
    width: 60px;
    height: 60px;
    border-radius: 8px;
    object-fit: cover;
}
.song-info {
    flex: 1;
    min-width: 0;
}
.song-title {
    font-weight: 600;
    color: var(--text-primary);
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}
.song-meta {
    font-size: 0.85rem;
    color: var(--text-secondary);
}
.btn-remove {
    padding: 0.5rem 1rem;
    background: rgba(255, 0, 0, 0.2);
    border: none;
    border-radius: 6px;
    color: #ff4444;
    cursor: pointer;
    font-size: 0.9rem;
}
.btn-remove:hover {
    background: #ff4444;
    color: white;
}
.btn-add {
    padding: 0.5rem 1rem;
    background: var(--accent-purple);
    border: none;
    border-radius: 6px;
    color: white;
    cursor: pointer;
    font-size: 0.9rem;
}
.btn-add:hover {
    background: var(--accent-blue);
}
.btn-back-home {
    padding: 0.8rem 1.5rem;
    background: rgba(122, 92, 255, 0.2);
    border: 1px solid var(--accent-purple);
    border-radius: 8px;
    color: var(--accent-purple);
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s;
    margin-bottom: 1.5rem;
}
.btn-back-home:hover {
    background: var(--accent-purple);
    color: white;
}
</style>

<div class="playlist-detail-wrapper">
    <!-- Back Button -->
    <button class="btn-back-home" onclick="loadHomePage()">
        ← Quay lại trang chủ
    </button>

    <!-- Header -->
    <div class="playlist-header-section">
        <input type="text" 
               class="playlist-title-input" 
               id="playlistNameInput"
               value="${playlist.name}" 
               readonly
               onclick="this.readOnly = false; this.select();"
               onblur="savePlaylistName(${playlist.id})"
               onkeypress="if(event.key==='Enter') this.blur();">
        
        <div class="playlist-actions">
            <button class="btn-icon btn-delete-playlist" 
                    onclick="deletePlaylist(${playlist.id})"
                    title="Xóa playlist"><i class='bx bx-trash'></i></button>
        </div>
    </div>

    <!-- Content -->
    <div class="content-wrapper">
        <!-- Songs List -->
        <div class="songs-list">
            <div class="songs-section">
                <h3>
                    <i class='bx bx-music'></i> 
                    Danh sách bài hát (<span id="songCount">${songs.size()}</span>)
                </h3>
            
                <div id="playlistSongsList">
                <c:forEach var="song" items="${songs}">
                    <div class="song-item" id="song-${song.id}">
                        <img src="${pageContext.request.contextPath}${song.thumbnail}" 
                             alt="${song.title}" 
                             class="song-thumb"
                             onerror="this.src='${pageContext.request.contextPath}/assets/thumbs/default.png'">
                        <div class="song-info">
                            <div class="song-title">${song.title}</div>
                            <div class="song-meta">
                                <c:if test="${not empty singerMap[song.singerId]}">
                                    ${singerMap[song.singerId]} • 
                                </c:if>
                                ${song.viewCount} lượt nghe
                            </div>
                        </div>
                        <button class="btn-remove" 
                                onclick="removeSongFromPlaylist(${playlist.id}, ${song.id})">
                            Xóa
                        </button>
                    </div>
                </c:forEach>
                </div>
            
                <c:if test="${empty songs}">
                    <p style="color: var(--text-secondary); text-align: center; padding: 2rem;">
                        Playlist trống. Tìm kiếm và thêm bài hát từ bên phải ➡️
                    </p>
                </c:if>
            </div>
        </div>

        <!-- Search Panel -->
        <div class="search-panel">
            <h5 style="color: var(--accent-purple); margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem;">
                <i class='bx bx-search'></i> Tìm bài hát
            </h5>
            
            <div class="search-box">
                <input type="text" 
                       class="search-input" 
                       id="songSearchInput"
                       placeholder="Nhập tên bài hát..."
                       onkeypress="if(event.key==='Enter') searchSongs()">
                <button class="search-btn" onclick="searchSongs()">Tìm</button>
            </div>

            <div id="searchResults">
                <c:if test="${not empty searchResults}">
                    <h6 style="color: var(--text-primary); margin-bottom: 0.7rem;">
                        Kết quả tìm kiếm:
                    </h6>
                    <c:forEach var="song" items="${searchResults}">
                        <div class="song-item">
                            <img src="${pageContext.request.contextPath}${song.thumbnail}" 
                                 alt="${song.title}" 
                                 class="song-thumb"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/thumbs/default.png'">
                            <div class="song-info">
                                <div class="song-title">${song.title}</div>
                                <div class="song-meta">
                                    <c:if test="${not empty singerMap[song.singerId]}">
                                        ${singerMap[song.singerId]}
                                    </c:if>
                                </div>
                            </div>
                            <button class="btn-add" 
                                    onclick="addSongToPlaylist(${playlist.id}, ${song.id})">
                                + Thêm
                            </button>
                        </div>
                    </c:forEach>
                </c:if>
                <c:if test="${empty searchResults && not empty searchQuery}">
                    <p style="color: var(--text-secondary); font-size: 0.9rem;">
                        Không tìm thấy bài hát nào.
                    </p>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script>
var ctxPath = '${pageContext.request.contextPath}';
var currentPlaylistId = ${playlist.id};

function savePlaylistName(playlistId) {
    var newName = document.getElementById('playlistNameInput').value.trim();
    if (!newName) {
        alert('Tên playlist không được để trống!');
        return;
    }
    
    fetch(ctxPath + '/playlist/rename', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'id=' + playlistId + '&name=' + encodeURIComponent(newName)
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
        if (data.success) {
            // Reload playlist list in sidebar
            loadUserPlaylists();
        } else {
            alert(data.message || 'Không thể đổi tên playlist');
        }
    })
    .catch(function(err) {
        console.error('Error renaming playlist:', err);
        alert('Lỗi khi đổi tên playlist');
    });
}

function deletePlaylist(playlistId) {
    if (!confirm('Bạn có chắc muốn xóa playlist này?')) return;
    
    var form = document.createElement('form');
    form.method = 'POST';
    form.action = ctxPath + '/playlist/delete';
    
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = 'id';
    input.value = playlistId;
    form.appendChild(input);
    
    document.body.appendChild(form);
    form.submit();
    
    // Reload home page after deletion
    setTimeout(function() {
        loadHomePage();
        loadUserPlaylists();
    }, 500);
}

function searchSongs() {
    var query = document.getElementById('songSearchInput').value.trim();
    if (!query) {
        alert('Nhập tên bài hát để tìm kiếm');
        return;
    }
    
    // Reload page with search query
    window.location.href = ctxPath + '/playlist/view?id=' + currentPlaylistId + '&q=' + encodeURIComponent(query);
}

function addSongToPlaylist(playlistId, songId) {
    fetch(ctxPath + '/playlist/addSong', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'playlistId=' + playlistId + '&songId=' + songId
    })
    .then(function() {
        // Reload playlist detail
        loadPlaylistDetail(playlistId);
    })
    .catch(function(err) {
        console.error('Error adding song:', err);
        alert('Lỗi khi thêm bài hát');
    });
}

function removeSongFromPlaylist(playlistId, songId) {
    if (!confirm('Xóa bài hát khỏi playlist?')) return;
    
    fetch(ctxPath + '/playlist/removeSong', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: 'playlistId=' + playlistId + '&songId=' + songId
    })
    .then(function() {
        // Remove song from UI
        var songEl = document.getElementById('song-' + songId);
        if (songEl) {
            songEl.remove();
            // Update count
            var countEl = document.getElementById('songCount');
            if (countEl) {
                var count = parseInt(countEl.textContent) - 1;
                countEl.textContent = count;
            }
        }
    })
    .catch(function(err) {
        console.error('Error removing song:', err);
        alert('Lỗi khi xóa bài hát');
    });
}

function loadHomePage() {
    // This function will be defined in index.jsp
    if (window.parent && window.parent.loadHomePage) {
        window.parent.loadHomePage();
    } else if (typeof loadHomeContent !== 'undefined') {
        loadHomeContent();
    } else if (typeof switchMode !== 'undefined') {
        switchMode(1);
    } else {
        window.location.href = ctxPath + '/?mode=1';
    }
}
</script>
