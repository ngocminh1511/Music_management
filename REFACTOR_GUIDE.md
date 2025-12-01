# HƯỚNG DẪN REFACTOR PROJECT - GenZ Beats Music Management

## 📋 TỔNG QUAN REFACTORING

Đây là bản hướng dẫn chi tiết để refactor project theo yêu cầu:
1. Redesign giao diện playlist với layout 7-3
2. Thêm lyrics cho bài hát
3. Tạo view riêng cho single song, category với lyrics panel
4. Thêm user profile với avatar
5. Tách code thành các component JSP nhỏ
6. Tách JavaScript thành các module riêng

---

## 1️⃣ DATABASE MIGRATION

### File đã tạo: `src/main/resources/db/migration.sql`

**Chạy script này sau khi chạy init.sql:**

```sql
-- Thêm cột lyrics vào bảng songs
ALTER TABLE songs ADD COLUMN lyrics TEXT;

-- Thêm cột added_date vào playlist_song để sắp xếp
ALTER TABLE playlist_song ADD COLUMN added_date DATETIME DEFAULT CURRENT_TIMESTAMP;

-- Thêm avatar, bio cho users
ALTER TABLE users 
ADD COLUMN avatar VARCHAR(255) DEFAULT '/assets/avatars/default-user.png',
ADD COLUMN bio TEXT,
ADD COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
```

**Format lưu lyrics:** Sử dụng định dạng LRC (time-synced lyrics)
```
[00:15.50] I've been waiting for you
[00:20.30] Through the night and day
```

---

## 2️⃣ CẤU TRÚC FOLDER MỚI

```
webapp/
├── assets/
│   ├── js/
│   │   ├── playlist-manager.js      (Quản lý playlist)
│   │   ├── music-player.js          (Player logic + lyrics sync)
│   │   ├── mode-switcher.js         (Chuyển đổi views)
│   │   ├── ui-utils.js              (Utilities: carousel, etc)
│   │   └── main.js                  (Entry point)
│   ├── css/
│   │   ├── common.css               (Global styles)
│   │   ├── admin.css
│   │   ├── player.css               (Music player specific)
│   │   └── lyrics.css               (Lyrics panel)
│   └── avatars/
│       └── default-user.png
│
└── WEB-INF/views/
    ├── index.jsp                     (Main container - simplified)
    ├── components/
    │   ├── discover-view.jsp         (Mode 1: Khám phá)
    │   ├── playlist-view.jsp         (Mode 2: Playlist detail)
    │   ├── song-view.jsp             (Mode 3: Single song)
    │   ├── category-view.jsp         (Mode 4: Category songs)
    │   └── lyrics-panel.jsp          (Reusable lyrics component)
    └── fragments/
        ├── header.jsp                (Updated với avatar dropdown)
        └── footer.jsp
```

---

## 3️⃣ REDESIGN PLAYLIST VIEW (7-3 LAYOUT)

### File: `components/playlist-view.jsp`

```jsp
<div class="playlist-view">
    <!-- Header với tên + 3 dots menu + play button -->
    <div class="playlist-header-new">
        <div class="playlist-info">
            <h2 id="playlistTitle">${playlist.name}</h2>
            <p>${songs.size()} bài hát</p>
        </div>
        <div class="playlist-controls">
            <button class="btn-play-all" onclick="playAllSongs()">
                <i class='bx bx-play-circle'></i> Phát tất cả
            </button>
            <div class="dropdown">
                <button class="btn-menu" onclick="togglePlaylistMenu()">
                    <i class='bx bx-dots-horizontal-rounded'></i>
                </button>
                <div id="playlistDropdown" class="dropdown-menu">
                    <a onclick="renamePlaylist()"><i class='bx bx-edit'></i> Đổi tên</a>
                    <a onclick="deletePlaylist()"><i class='bx bx-trash'></i> Xóa</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Body: 70% song list + 30% now playing -->
    <div class="playlist-body">
        <!-- Left 70%: Song List -->
        <div class="song-list-panel">
            <c:forEach var="song" items="${songs}">
                <div class="playlist-song-item" onclick="playSong(${song.id})">
                    <img src="${song.thumbnail}" alt="${song.title}">
                    <div class="song-details">
                        <h4>${song.title}</h4>
                        <p>${singerMap[song.singerId]}</p>
                    </div>
                    <span class="song-duration">3:45</span>
                    <button class="btn-remove" onclick="removeSong(${song.id})">
                        <i class='bx bx-x'></i>
                    </button>
                </div>
            </c:forEach>
        </div>

        <!-- Right 30%: Now Playing + Lyrics -->
        <div class="now-playing-panel">
            <div id="currentSongDisplay" class="current-song-empty">
                <i class='bx bx-music' style="font-size: 4rem; opacity: 0.3;"></i>
                <p>Chọn bài hát để phát</p>
            </div>
            
            <!-- Lyrics Container -->
            <div id="lyricsContainer" class="lyrics-display">
                <jsp:include page="lyrics-panel.jsp" />
            </div>
        </div>
    </div>
</div>
```

### CSS cho layout 7-3:

```css
.playlist-body {
    display: flex;
    gap: 1.5rem;
    margin-top: 1.5rem;
}

.song-list-panel {
    flex: 7;
    overflow-y: auto;
    max-height: calc(100vh - 250px);
}

.now-playing-panel {
    flex: 3;
    position: sticky;
    top: 100px;
}

.current-song-display {
    background: var(--bg-card);
    border-radius: 12px;
    padding: 1.5rem;
    text-align: center;
    margin-bottom: 1rem;
}

.current-song-display img {
    width: 100%;
    aspect-ratio: 1;
    border-radius: 8px;
    margin-bottom: 1rem;
}
```

---

## 4️⃣ SINGLE SONG VIEW

### File: `components/song-view.jsp`

```jsp
<div class="song-view">
    <div class="song-detail-container">
        <!-- Left: Song Info + Player -->
        <div class="song-main">
            <div class="song-hero">
                <img src="${song.thumbnail}" alt="${song.title}">
                <div class="song-meta">
                    <h1>${song.title}</h1>
                    <h3>${singerMap[song.singerId]}</h3>
                    <p>${song.viewCount} lượt nghe</p>
                </div>
            </div>
            
            <div class="player-controls">
                <audio id="audioPlayer" src="${song.filePath}" controls></audio>
            </div>
            
            <button onclick="addToPlaylist(${song.id})">
                <i class='bx bx-plus'></i> Thêm vào playlist
            </button>
        </div>

        <!-- Right: Lyrics -->
        <div class="song-lyrics">
            <h3><i class='bx bx-note'></i> Lời bài hát</h3>
            <div class="lyrics-scrollable">
                <jsp:include page="lyrics-panel.jsp">
                    <jsp:param name="lyrics" value="${song.lyrics}" />
                </jsp:include>
            </div>
        </div>
    </div>
</div>
```

---

## 5️⃣ LYRICS PANEL COMPONENT

### File: `components/lyrics-panel.jsp`

```jsp
<%@ page contentType="text/html; charset=UTF-8" %>
<div class="lyrics-panel" id="lyricsPanel">
    <c:choose>
        <c:when test="${not empty lyrics}">
            <div class="lyrics-content" data-lyrics="${lyrics}">
                <!-- JavaScript sẽ parse và hiển thị lyrics có time-sync -->
            </div>
        </c:when>
        <c:otherwise>
            <p class="no-lyrics">
                <i class='bx bx-info-circle'></i>
                Không có lời bài hát
            </p>
        </c:otherwise>
    </c:choose>
</div>
```

### CSS:

```css
.lyrics-panel {
    background: var(--bg-card);
    border-radius: 12px;
    padding: 1.5rem;
    max-height: 500px;
    overflow-y: auto;
}

.lyrics-content .lyric-line {
    padding: 0.5rem 0;
    transition: all 0.3s;
    color: var(--text-secondary);
}

.lyrics-content .lyric-line.active {
    color: var(--accent-purple);
    font-weight: 600;
    font-size: 1.1rem;
    transform: scale(1.05);
}
```

---

## 6️⃣ JAVASCRIPT MODULES

### File: `assets/js/music-player.js`

```javascript
// Music Player với lyrics sync
class MusicPlayer {
    constructor() {
        this.audio = document.getElementById('audioPlayer');
        this.currentSong = null;
        this.lyrics = [];
        this.init();
    }

    init() {
        if (this.audio) {
            this.audio.addEventListener('timeupdate', () => this.syncLyrics());
        }
    }

    playSong(songId, songData) {
        this.currentSong = songData;
        this.audio.src = songData.filePath;
        this.audio.play();
        
        // Load lyrics
        this.loadLyrics(songData.lyrics);
        
        // Update UI
        this.updateNowPlaying(songData);
    }

    loadLyrics(lrcText) {
        if (!lrcText) {
            this.lyrics = [];
            return;
        }

        // Parse LRC format
        const lines = lrcText.split('\n');
        this.lyrics = lines.map(line => {
            const match = line.match(/\[(\d{2}):(\d{2}\.\d{2})\](.*)/);
            if (match) {
                const time = parseInt(match[1]) * 60 + parseFloat(match[2]);
                return { time, text: match[3].trim() };
            }
            return null;
        }).filter(l => l !== null);

        this.renderLyrics();
    }

    syncLyrics() {
        if (!this.lyrics.length) return;

        const currentTime = this.audio.currentTime;
        let activeIndex = -1;

        for (let i = 0; i < this.lyrics.length; i++) {
            if (this.lyrics[i].time <= currentTime) {
                activeIndex = i;
            } else {
                break;
            }
        }

        // Highlight active line
        document.querySelectorAll('.lyric-line').forEach((el, idx) => {
            el.classList.toggle('active', idx === activeIndex);
        });

        // Auto scroll
        if (activeIndex >= 0) {
            const activeLine = document.querySelector('.lyric-line.active');
            if (activeLine) {
                activeLine.scrollIntoView({ behavior: 'smooth', block: 'center' });
            }
        }
    }

    renderLyrics() {
        const container = document.querySelector('.lyrics-content');
        if (!container) return;

        container.innerHTML = this.lyrics
            .map(l => `<div class="lyric-line">${l.text}</div>`)
            .join('');
    }

    updateNowPlaying(song) {
        const display = document.getElementById('currentSongDisplay');
        display.innerHTML = `
            <img src="${song.thumbnail}" alt="${song.title}">
            <h4>${song.title}</h4>
            <p>${song.artist}</p>
        `;
    }
}

// Global instance
const player = new MusicPlayer();
```

### File: `assets/js/mode-switcher.js`

```javascript
// Mode management
const ViewMode = {
    DISCOVER: 1,
    PLAYLIST: 2,
    SONG: 3,
    CATEGORY: 4
};

class ModeSwitcher {
    constructor() {
        this.currentMode = ViewMode.DISCOVER;
    }

    switchTo(mode, data = {}) {
        // Hide all views
        document.querySelectorAll('.content-mode').forEach(el => {
            el.classList.remove('active');
        });

        // Show target view
        const viewId = this.getViewId(mode);
        const view = document.getElementById(viewId);
        if (view) {
            view.classList.add('active');
        }

        // Load content
        this.loadContent(mode, data);

        // Update URL
        this.updateURL(mode, data);

        this.currentMode = mode;
    }

    getViewId(mode) {
        switch(mode) {
            case ViewMode.DISCOVER: return 'modeDiscover';
            case ViewMode.PLAYLIST: return 'modePlaylist';
            case ViewMode.SONG: return 'modeSong';
            case ViewMode.CATEGORY: return 'modeCategory';
            default: return 'modeDiscover';
        }
    }

    async loadContent(mode, data) {
        const view = document.getElementById(this.getViewId(mode));
        
        let url = '';
        switch(mode) {
            case ViewMode.PLAYLIST:
                url = `/playlist/view?id=${data.playlistId}`;
                break;
            case ViewMode.SONG:
                url = `/song/view?id=${data.songId}`;
                break;
            case ViewMode.CATEGORY:
                url = `/song/category?id=${data.categoryId}`;
                break;
        }

        if (url) {
            const response = await fetch(url);
            const html = await response.text();
            view.innerHTML = html;
        }
    }

    updateURL(mode, data) {
        let url = '/?mode=' + mode;
        if (data.playlistId) url += '&id=' + data.playlistId;
        if (data.songId) url += '&song=' + data.songId;
        if (data.categoryId) url += '&category=' + data.categoryId;
        
        history.pushState({ mode, data }, '', url);
    }
}

const modeSwitcher = new ModeSwitcher();

// Global navigation functions
function viewSong(songId) {
    modeSwitcher.switchTo(ViewMode.SONG, { songId });
}

function viewPlaylist(playlistId) {
    modeSwitcher.switchTo(ViewMode.PLAYLIST, { playlistId });
}

function viewCategory(categoryId) {
    modeSwitcher.switchTo(ViewMode.CATEGORY, { categoryId });
}

function viewDiscover() {
    modeSwitcher.switchTo(ViewMode.DISCOVER);
}
```

---

## 7️⃣ UPDATE HEADER VỚI AVATAR

### File: `fragments/header.jsp` (cập nhật)

```jsp
<c:when test="${not empty sessionScope.user}">
    <!-- Avatar Dropdown -->
    <li class="user-dropdown">
        <div class="user-avatar" onclick="toggleUserMenu()">
            <img src="${sessionScope.user.avatar}" alt="${sessionScope.user.username}">
            <span>${sessionScope.user.username}</span>
            <i class='bx bx-chevron-down'></i>
        </div>
        <div id="userDropdownMenu" class="dropdown-menu">
            <a href="javascript:viewProfile()">
                <i class='bx bx-user'></i> Hồ sơ
            </a>
            <a href="${ctx}/logout">
                <i class='bx bx-log-out'></i> Đăng xuất
            </a>
        </div>
    </li>
</c:when>
```

---

## 8️⃣ SIMPLIFIED INDEX.JSP

```jsp
<%@ include file="fragments/header.jsp" %>

<div class="music-player-page">
    <!-- Sidebar Playlist -->
    <div class="sidebar-left" id="playlistSidebar">
        <!-- Playlist management (giữ nguyên) -->
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

<!-- Load all JS modules -->
<script src="${ctx}/assets/js/ui-utils.js"></script>
<script src="${ctx}/assets/js/playlist-manager.js"></script>
<script src="${ctx}/assets/js/music-player.js"></script>
<script src="${ctx}/assets/js/mode-switcher.js"></script>
<script src="${ctx}/assets/js/main.js"></script>

<%@ include file="fragments/footer.jsp" %>
```

---

## 9️⃣ CONTROLLER UPDATES

### SongController - thêm view method:

```java
@WebServlet("/song/view")
public class SongViewController extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) {
        int songId = Integer.parseInt(req.getParameter("id"));
        Song song = songBO.getById(songId);
        
        req.setAttribute("song", song);
        req.setAttribute("singerMap", getSingerMap());
        
        // Return fragment, not full page
        req.getRequestDispatcher("/WEB-INF/views/components/song-view.jsp")
           .forward(req, resp);
    }
}
```

---

## 🎯 CHECKLIST TRIỂN KHAI

- [ ] 1. Chạy migration.sql để update database
- [ ] 2. Update Song.java và User.java beans (đã làm)
- [ ] 3. Update SongDAO để select lyrics
- [ ] 4. Update UserDAO để select avatar, bio
- [ ] 5. Tạo folder structure mới
- [ ] 6. Tạo các JSP components
- [ ] 7. Tạo các JavaScript modules
- [ ] 8. Tạo lyrics.css và player.css
- [ ] 9. Update controllers
- [ ] 10. Test từng view một
- [ ] 11. Test lyrics sync với audio player
- [ ] 12. Test avatar dropdown và profile

---

## 📝 GHI CHÚ

**Về lyrics format:** LRC là format tốt nhất vì:
- Time-synced (đồng bộ với thời gian)
- Dễ parse
- Có thể highlight từng dòng khi phát nhạc
- Standard format được dùng rộng rãi

**Về architecture:**
- Sử dụng AJAX để load các view components
- Single Page App behavior với multiple modes
- No page reload khi chuyển view
- Clean separation of concerns

---

## 🚀 NEXT STEPS

1. Chạy migration SQL
2. Tạo các file JavaScript modules trước
3. Tạo các JSP components
4. Test integration từng phần
5. Polish UI/UX
6. Optimize performance

Chúc may mắn với việc refactor! 🎵
