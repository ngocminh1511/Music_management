(function() {
    'use strict';
    
    // Check if already loaded
    if (window.musicPlayer) {
        console.log('MusicPlayer already loaded, skipping...');
        return;
    }

class MusicPlayer {
    constructor() {
        this.audio = null;
        this.currentSong = null;
        this.lyrics = [];
    }

    init() {
        // Get audio element
        this.audio = document.getElementById('audioPlayer');
        if (!this.audio) {
            console.error('[Player] Audio element #audioPlayer not found!');
            return;
        }
        
        console.log('[Player] Initialized successfully');
        
        this.audio.addEventListener('timeupdate', () => {
            this.syncLyrics();
            this.updateProgress();
        });
        
        this.audio.addEventListener('loadedmetadata', () => {
            this.updateDuration();
        });
        
        this.audio.addEventListener('play', () => {
            this.updatePlayButton(true);
        });
        
        this.audio.addEventListener('pause', () => {
            this.updatePlayButton(false);
        });
        
        // Player controls
        const btnPlayPause = document.getElementById('btnPlayPause');
        const btnStop = document.getElementById('btnStop');
        const volumeSlider = document.getElementById('volumeSlider');
        const btnLyricsToggle = document.getElementById('btnLyricsToggle');
        const btnCloseLyrics = document.getElementById('btnCloseLyrics');
        const progressBar = document.getElementById('progressBar');
        
        if (btnPlayPause) {
            btnPlayPause.addEventListener('click', () => this.togglePlay());
        }
        
        if (btnStop) {
            btnStop.addEventListener('click', () => this.stop());
        }
        
        if (volumeSlider) {
            volumeSlider.addEventListener('input', (e) => {
                this.audio.volume = e.target.value / 100;
            });
            this.audio.volume = 0.8;
        }
        
        if (btnLyricsToggle) {
            btnLyricsToggle.addEventListener('click', () => {
                document.getElementById('lyricsSidebar').classList.toggle('active');
            });
        }
        
        if (btnCloseLyrics) {
            btnCloseLyrics.addEventListener('click', () => {
                document.getElementById('lyricsSidebar').classList.remove('active');
            });
        }
        
        if (progressBar) {
            progressBar.addEventListener('click', (e) => {
                const rect = progressBar.getBoundingClientRect();
                const percent = (e.clientX - rect.left) / rect.width;
                this.audio.currentTime = percent * this.audio.duration;
            });
        }
    }

    playSong(songId, songData) {
        console.log('[Player] Playing song:', songId, songData);
        
        // Check if player is initialized
        if (!this.audio) {
            console.error('[Player] Audio element not initialized!');
            this.init(); // Try to initialize
            if (!this.audio) {
                alert('Không thể phát nhạc. Vui lòng tải lại trang.');
                return;
            }
        }
        
        this.currentSong = songData;
        
        // Ensure paths are absolute
        const ctx = window.APP_CONTEXT || '';
        let audioSrc = songData.filePath;
        if (audioSrc && !audioSrc.startsWith('http') && !audioSrc.startsWith(ctx)) {
            audioSrc = ctx + audioSrc;
        }
        
        console.log('[Player] Audio source:', audioSrc);
        this.audio.src = audioSrc;
        // Update UI BEFORE playing
        this.updateNowPlaying(songData);
        
        // Show player bar
        const playerBar = document.getElementById('musicPlayerBar');
        if (playerBar) {
            playerBar.style.display = 'flex';
            console.log('[Player] Player bar shown');
        }
        
        // Load lyrics if available
        if (songData.lyrics) {
            this.loadLyrics(songData.lyrics);
        } else {
            // Try to fetch lyrics from API
            this.fetchLyrics(songId);
        }
        
        // Play audio
        this.audio.play().catch(err => {
            console.error('[Player] Play failed:', err);
            alert('Không thể phát nhạc: ' + err.message);
        });
    }
    
    togglePlay() {
        if (this.audio.paused) {
            this.audio.play();
        } else {
            this.audio.pause();
        }
    }
    
    stop() {
        this.audio.pause();
        this.audio.currentTime = 0;
    }
    
    updatePlayButton(isPlaying) {
        const btn = document.getElementById('btnPlayPause');
        if (btn) {
            btn.innerHTML = isPlaying ? '<i class="bx bx-pause"></i>' : '<i class="bx bx-play"></i>';
        }
    }
    
    updateProgress() {
        const fill = document.getElementById('progressFill');
        const current = document.getElementById('timeeCurrent');
        
        if (fill && this.audio.duration) {
            const percent = (this.audio.currentTime / this.audio.duration) * 100;
            fill.style.width = percent + '%';
        }
        
        if (current) {
            current.textContent = this.formatTime(this.audio.currentTime);
        }
    }
    
    updateDuration() {
        const total = document.getElementById('timeTotal');
        if (total) {
            total.textContent = this.formatTime(this.audio.duration);
        }
    }
    
    formatTime(seconds) {
        if (!seconds || isNaN(seconds)) return '0:00';
        const mins = Math.floor(seconds / 60);
        const secs = Math.floor(seconds % 60);
        return mins + ':' + (secs < 10 ? '0' : '') + secs;
    }

    fetchLyrics(songId) {
        const ctx = window.APP_CONTEXT || '';
        console.log('[Player] Fetching lyrics for song:', songId);
        
        fetch(ctx + '/song/api/get?id=' + songId)
            .then(response => response.json())
            .then(data => {
                if (data.lyrics) {
                    this.loadLyrics(data.lyrics);
                } else {
                    console.log('[Player] No lyrics available');
                    this.lyrics = [];
                    this.renderLyrics();
                }
            })
            .catch(err => {
                console.error('[Player] Error fetching lyrics:', err);
                this.lyrics = [];
                this.renderLyrics();
            });
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
        const container = document.getElementById('lyricsContent');
        if (!container) return;
        
        const lines = container.querySelectorAll('.lyric-line');
        lines.forEach((el, idx) => {
            el.classList.toggle('active', idx === activeIndex);
        });

        // Auto scroll
        if (activeIndex >= 0 && lines[activeIndex]) {
            lines[activeIndex].scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
    }

    renderLyrics() {
        const container = document.getElementById('lyricsContent');
        if (!container) {
            console.warn('[Player] Lyrics container not found');
            return;
        }
        
        console.log('[Player] Rendering lyrics, count:', this.lyrics.length);

        if (this.lyrics.length === 0) {
            container.innerHTML = '<p class="no-lyrics">Chưa có lời bài hát</p>';
            return;
        }

        container.innerHTML = this.lyrics
            .map(l => `<div class="lyric-line">${l.text}</div>`)
            .join('');
    }

    updateNowPlaying(song) {
        const ctx = window.APP_CONTEXT || '';
        let thumbnail = song.thumbnail;
        if (thumbnail && !thumbnail.startsWith('http') && !thumbnail.startsWith(ctx)) {
            thumbnail = ctx + thumbnail;
        }
        
        console.log('[Player] Updating now playing:', song.title, 'thumbnail:', thumbnail);
        
        // Update player bar display at bottom
        const display = document.getElementById('currentSongDisplay');
        if (display) {
            const ctx = window.APP_CONTEXT || '';
            display.innerHTML = `
                <img src="${thumbnail}" alt="${song.title || 'Song'}" onerror="this.src='${ctx}/assets/thumbs/default.png'">
                <div class="song-text">
                    <h4>${song.title || 'Unknown'}</h4>
                    <p>${song.artist || 'Unknown Artist'}</p>
                </div>
            `;
            console.log('[Player] Player bar updated');
        }
        
        // Update category sidebar display (if exists)
        const categorySongDisplay = document.getElementById('categorySongDisplay');
        if (categorySongDisplay) {
            const ctx = window.APP_CONTEXT || '';
            categorySongDisplay.innerHTML = `
                <img src="${thumbnail}" alt="${song.title}" onerror="this.src='${ctx}/assets/thumbs/default.png'">
                <h4>${song.title || 'Unknown'}</h4>
                <p>${song.artist || 'Unknown Artist'}</p>
            `;
            console.log('[Player] Category sidebar updated');
        }

        // Update playlist sidebar display (if exists)
        const nowPlayingDisplay = document.getElementById('nowPlayingDisplay');
        if (nowPlayingDisplay) {
            const ctx = window.APP_CONTEXT || '';
            nowPlayingDisplay.innerHTML = `
                <img src="${thumbnail}" alt="${song.title}" onerror="this.src='${ctx}/assets/thumbs/default.png'">
                <h4>${song.title || 'Unknown'}</h4>
                <p>${song.artist || 'Unknown Artist'}</p>
            `;
            console.log('[Player] Playlist sidebar updated');
        }
        
        // Update lyrics panel title
        const lyricsTitle = document.getElementById('lyricsSongTitle');
        if (lyricsTitle) {
            lyricsTitle.textContent = song.title || 'Lời bài hát';
        }
    }
}

// Global instance - initialize after DOM ready
const musicPlayer = new MusicPlayer();
window.musicPlayer = musicPlayer;

// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        console.log('[Player] DOM ready, initializing player');
        musicPlayer.init();
    });
} else {
    console.log('[Player] DOM already ready, initializing player');
    musicPlayer.init();
}

console.log('MusicPlayer loaded successfully');

})();