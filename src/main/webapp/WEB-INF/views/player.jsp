<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="fragments/header.jsp">
    <jsp:param name="pageTitle" value="${playlistTitle} - GenZ Beats Player" />
</jsp:include>

<style>
.player-page {
    display: flex;
    gap: 2rem;
    padding: 2rem;
    min-height: calc(100vh - 180px);
    background: var(--bg-dark);
}

.player-main {
    flex: 1;
    max-width: 600px;
}

.player-card {
    background: var(--bg-card);
    border-radius: 20px;
    padding: 2rem;
    text-align: center;
}

.player-artwork {
    width: 100%;
    max-width: 400px;
    aspect-ratio: 1;
    border-radius: 15px;
    object-fit: cover;
    margin: 0 auto 1.5rem;
    box-shadow: 0 20px 60px rgba(122, 92, 255, 0.3);
}

.player-title {
    font-size: 1.8rem;
    font-weight: 700;
    color: var(--text-primary);
    margin-bottom: 0.5rem;
}

.player-artist {
    font-size: 1.2rem;
    color: var(--text-secondary);
    margin-bottom: 2rem;
}

.audio-player {
    width: 100%;
    margin: 1.5rem 0;
}

.player-controls {
    display: flex;
    justify-content: center;
    gap: 1rem;
    margin-top: 1.5rem;
}

.player-btn {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    background: var(--gradient-primary);
    border: none;
    color: white;
    font-size: 1.2rem;
    cursor: pointer;
    transition: all 0.3s;
}

.player-btn:hover {
    transform: scale(1.1);
    box-shadow: 0 5px 20px rgba(122, 92, 255, 0.5);
}

.player-btn.play-pause {
    width: 70px;
    height: 70px;
    font-size: 1.5rem;
}

.playlist-sidebar {
    flex: 1;
    max-width: 400px;
    background: var(--bg-card);
    border-radius: 15px;
    padding: 1.5rem;
    max-height: 80vh;
    overflow-y: auto;
}

.playlist-header {
    font-size: 1.3rem;
    font-weight: 700;
    color: var(--accent-purple);
    margin-bottom: 1rem;
    padding-bottom: 0.5rem;
    border-bottom: 2px solid rgba(122, 92, 255, 0.3);
}

.playlist-item {
    display: flex;
    align-items: center;
    gap: 1rem;
    padding: 0.8rem;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.3s;
    margin-bottom: 0.5rem;
}

.playlist-item:hover {
    background: rgba(122, 92, 255, 0.1);
}

.playlist-item.active {
    background: rgba(122, 92, 255, 0.2);
    border-left: 3px solid var(--accent-purple);
}

.playlist-thumb {
    width: 50px;
    height: 50px;
    border-radius: 8px;
    object-fit: cover;
}

.playlist-info {
    flex: 1;
    min-width: 0;
}

.playlist-song-title {
    font-weight: 600;
    color: var(--text-primary);
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
}

.playlist-song-artist {
    font-size: 0.85rem;
    color: var(--text-secondary);
}

.playlist-index {
    font-size: 0.9rem;
    color: var(--text-secondary);
    min-width: 25px;
}

.add-to-playlist-btn {
    background: rgba(122, 92, 255, 0.2);
    border: 1px solid var(--accent-purple);
    border-radius: 8px;
    padding: 0.7rem 1.5rem;
    color: var(--text-primary);
    cursor: pointer;
    margin-top: 1rem;
    width: 100%;
}

.add-to-playlist-btn:hover {
    background: var(--accent-purple);
    color: white;
}

@media (max-width: 768px) {
    .player-page {
        flex-direction: column;
    }
    .player-main, .playlist-sidebar {
        max-width: 100%;
    }
}
</style>

<div class="player-page">
    <!-- Main Player -->
    <div class="player-main">
        <div class="player-card">
            <img src="${pageContext.request.contextPath}${currentSong.thumbnail}" 
                 alt="${currentSong.title}" 
                 class="player-artwork">
            
            <h1 class="player-title">${currentSong.title}</h1>
            <p class="player-artist">
                <c:if test="${not empty currentSong.singerId}">
                    ${singerMap[currentSong.singerId]}
                </c:if>
            </p>
            
            <audio id="audioPlayer" class="audio-player" controls autoplay>
                <source src="${pageContext.request.contextPath}${currentSong.filePath}" type="audio/mpeg">
                Trình duyệt của bạn không hỗ trợ phát nhạc.
            </audio>
            
            <div class="player-controls">
                <button class="player-btn" onclick="previousSong()">⏮</button>
                <button class="player-btn play-pause" onclick="togglePlay()">⏸</button>
                <button class="player-btn" onclick="nextSong()">⏭</button>
            </div>
            
            <c:if test="${not empty sessionScope.user && not empty userPlaylists}">
                <select class="add-to-playlist-btn" onchange="addToPlaylist(this.value, ${currentSong.id})">
                    <option value="">+ Thêm vào playlist</option>
                    <c:forEach var="pl" items="${userPlaylists}">
                        <option value="${pl.id}">${pl.name}</option>
                    </c:forEach>
                </select>
            </c:if>
        </div>
    </div>
    
    <!-- Playlist Queue -->
    <div class="playlist-sidebar">
        <div class="playlist-header">
            <i class='bx bx-music'></i> ${playlistTitle}
            <span style="font-size: 0.9rem; color: var(--text-secondary);">(${playlist.size()} bài)</span>
        </div>
        
        <div id="playlistQueue">
            <c:forEach var="song" items="${playlist}" varStatus="status">
                <div class="playlist-item ${status.index == 0 ? 'active' : ''}" 
                     data-index="${status.index}"
                     data-song-id="${song.id}"
                     data-file="${pageContext.request.contextPath}${song.filePath}"
                     data-title="${song.title}"
                     data-artist="${singerMap[song.singerId]}"
                     data-thumb="${pageContext.request.contextPath}${song.thumbnail}"
                     onclick="playSongAtIndex(${status.index})">
                    <span class="playlist-index">#${status.index + 1}</span>
                    <img src="${pageContext.request.contextPath}${song.thumbnail}" 
                         class="playlist-thumb" 
                         alt="${song.title}">
                    <div class="playlist-info">
                        <div class="playlist-song-title">${song.title}</div>
                        <div class="playlist-song-artist">
                            <c:if test="${not empty song.singerId}">
                                ${singerMap[song.singerId]}
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
const audioPlayer = document.getElementById('audioPlayer');
const playlistItems = document.querySelectorAll('.playlist-item');
let currentIndex = 0;

function playSongAtIndex(index) {
    const items = Array.from(playlistItems);
    const item = items[index];
    
    if (!item) return;
    
    // Update UI
    items.forEach(i => i.classList.remove('active'));
    item.classList.add('active');
    
    // Update player
    audioPlayer.src = item.dataset.file;
    audioPlayer.load();
    audioPlayer.play();
    
    // Update info
    document.querySelector('.player-title').textContent = item.dataset.title;
    document.querySelector('.player-artist').textContent = item.dataset.artist || '';
    document.querySelector('.player-artwork').src = item.dataset.thumb;
    
    currentIndex = index;
    
    // Increase view count via AJAX (optional)
    fetch('${pageContext.request.contextPath}/api/song/view?id=' + item.dataset.songId, {
        method: 'POST'
    }).catch(e => console.log('View count update failed', e));
}

function togglePlay() {
    if (audioPlayer.paused) {
        audioPlayer.play();
        document.querySelector('.play-pause').textContent = '⏸';
    } else {
        audioPlayer.pause();
        document.querySelector('.play-pause').textContent = '▶';
    }
}

function nextSong() {
    const nextIndex = (currentIndex + 1) % playlistItems.length;
    playSongAtIndex(nextIndex);
}

function previousSong() {
    const prevIndex = (currentIndex - 1 + playlistItems.length) % playlistItems.length;
    playSongAtIndex(prevIndex);
}

// Auto play next song when current ends
audioPlayer.addEventListener('ended', nextSong);

// Update play/pause button
audioPlayer.addEventListener('play', () => {
    document.querySelector('.play-pause').textContent = '⏸';
});
audioPlayer.addEventListener('pause', () => {
    document.querySelector('.play-pause').textContent = '▶';
});

function addToPlaylist(playlistId, songId) {
    if (!playlistId) return;
    
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '${pageContext.request.contextPath}/playlist/addSong';
    
    const pInput = document.createElement('input');
    pInput.type = 'hidden';
    pInput.name = 'playlistId';
    pInput.value = playlistId;
    
    const sInput = document.createElement('input');
    sInput.type = 'hidden';
    sInput.name = 'songId';
    sInput.value = songId;
    
    form.appendChild(pInput);
    form.appendChild(sInput);
    document.body.appendChild(form);
    form.submit();
}
</script>

<jsp:include page="fragments/footer.jsp" />
