// Playlist Manager - Quản lý playlists
(function() {
    'use strict';
    
    // Check if already loaded
    if (window.playlistManager) {
        console.log('PlaylistManager already loaded, skipping...');
        return;
    }

class PlaylistManager {
    constructor() {
        this.playlists = [];
        this.currentPlaylistId = null;
    }

    init() {
        // Wait for DOM to be ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => {
                console.log('[Playlist] DOM ready, loading playlists');
                this.loadUserPlaylists();
            });
        } else {
            console.log('[Playlist] DOM already ready, loading playlists');
            this.loadUserPlaylists();
        }
    }

    async loadUserPlaylists() {
        try {
            const ctx = this.getContextPath();
            console.log('[Playlist] Loading playlists from:', ctx + '/playlist/api/list');
            
            const response = await fetch(ctx + '/playlist/api/list');
            
            if (!response.ok) {
                console.error('[Playlist] API error:', response.status, response.statusText);
                throw new Error('API returned ' + response.status);
            }
            
            const data = await response.json();
            console.log('[Playlist] Loaded playlists:', data.length, 'items');
            
            this.playlists = data;
            this.renderPlaylistList();
        } catch (error) {
            console.error('[Playlist] Error loading playlists:', error);
            // Show empty state instead of breaking
            this.playlists = [];
            this.renderPlaylistList();
        }
    }

    renderPlaylistList() {
        const container = document.getElementById('playlistList');
        console.log('[Playlist] Rendering to container:', container ? 'found' : 'NOT FOUND');
        
        if (!container) {
            console.error('[Playlist] Container #playlistList not found in DOM');
            return;
        }

        if (this.playlists.length === 0) {
            container.innerHTML = '<p style="color: var(--text-secondary); font-size: 0.85rem; text-align: center; padding: 1rem;">Chưa có playlist</p>';
            return;
        }

        console.log('[Playlist] Rendering', this.playlists.length, 'playlists');
        let html = '';
        for (let i = 0; i < this.playlists.length; i++) {
            const pl = this.playlists[i];
            const activeClass = pl.id === this.currentPlaylistId ? 'active' : '';
            html += '<div class="playlist-item ' + activeClass + '" data-playlist-id="' + pl.id + '" onclick="playlistManager.viewPlaylist(' + pl.id + ', \'' + this.escapeHtml(pl.name) + '\')">';
            html += '<div class="playlist-item-text">';
            html += '<span><i class="bx bx-music"></i></span>';
            html += '<span>' + this.escapeHtml(pl.name) + '</span>';
            html += '</div>';
            html += '</div>';
        }
        container.innerHTML = html;
    }

    viewPlaylist(playlistId, playlistName) {
        this.currentPlaylistId = playlistId;
        this.renderPlaylistList(); // Re-render to update active state
        
        if (window.viewPlaylist) {
            window.viewPlaylist(playlistId);
        } else {
            console.error('window.viewPlaylist is not defined');
        }
    }

    async createPlaylist() {
        const name = prompt('Tên playlist mới:');
        if (!name || !name.trim()) return;

        try {
            const ctx = this.getContextPath();
            const formData = new FormData();
            formData.append('name', name.trim());

            const response = await fetch(ctx + '/playlist/create', {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                await this.loadUserPlaylists();
                this.showNotification('Tạo playlist thành công!');
            } else {
                throw new Error('Failed to create playlist');
            }
        } catch (error) {
            console.error('Error creating playlist:', error);
            this.showNotification('Lỗi tạo playlist!', 'error');
        }
    }

    async renamePlaylist(playlistId, currentName) {
        const newName = prompt('Tên playlist mới:', currentName);
        if (!newName || !newName.trim() || newName === currentName) return;

        try {
            const ctx = this.getContextPath();
            const formData = new FormData();
            formData.append('id', playlistId);
            formData.append('name', newName.trim());

            const response = await fetch(ctx + '/playlist/rename', {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                await this.loadUserPlaylists();
                this.showNotification('Đổi tên thành công!');
                
                // Update header if viewing this playlist
                if (this.currentPlaylistId === playlistId) {
                    const header = document.getElementById('playlistTitle');
                    if (header) header.textContent = newName;
                }
            } else {
                throw new Error('Failed to rename');
            }
        } catch (error) {
            console.error('Error renaming playlist:', error);
            this.showNotification('Lỗi đổi tên!', 'error');
        }
    }

    async deletePlaylist(playlistId) {
        if (!confirm('Bạn có chắc muốn xóa playlist này?')) return;

        try {
            const ctx = this.getContextPath();
            const formData = new FormData();
            formData.append('id', playlistId);

            const response = await fetch(ctx + '/playlist/delete', {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                await this.loadUserPlaylists();
                this.showNotification('Xóa playlist thành công!');
                
                // Navigate back to discover if deleted current playlist
                if (this.currentPlaylistId === playlistId && window.modeSwitcher) {
                    modeSwitcher.switchTo(ViewMode.DISCOVER);
                }
            } else {
                throw new Error('Failed to delete');
            }
        } catch (error) {
            console.error('Error deleting playlist:', error);
            this.showNotification('Lỗi xóa playlist!', 'error');
        }
    }

    async addSongToPlaylist(playlistId, songId) {
        try {
            const ctx = this.getContextPath();
            const formData = new FormData();
            formData.append('playlistId', playlistId);
            formData.append('songId', songId);

            const response = await fetch(ctx + '/playlist/addSong', {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                this.showNotification('Đã thêm vào playlist!');
            } else {
                throw new Error('Failed to add song');
            }
        } catch (error) {
            console.error('Error adding song:', error);
            this.showNotification('Lỗi thêm bài hát!', 'error');
        }
    }

    async removeSongFromPlaylist(playlistId, songId) {
        try {
            const ctx = this.getContextPath();
            const formData = new FormData();
            formData.append('playlistId', playlistId);
            formData.append('songId', songId);

            const response = await fetch(ctx + '/playlist/removeSong', {
                method: 'POST',
                body: formData
            });

            if (response.ok) {
                this.showNotification('Đã xóa khỏi playlist!');
                
                // Remove from UI
                const songElement = document.getElementById('song-' + songId);
                if (songElement) {
                    songElement.remove();
                }
                
                // Update song count
                this.updateSongCount();
            } else {
                throw new Error('Failed to remove song');
            }
        } catch (error) {
            console.error('Error removing song:', error);
            this.showNotification('Lỗi xóa bài hát!', 'error');
        }
    }

    updateSongCount() {
        const songs = document.querySelectorAll('.playlist-song-item');
        const countElement = document.querySelector('.playlist-info p');
        if (countElement) {
            countElement.textContent = songs.length + ' bài hát';
        }
    }

    showNotification(message, type = 'success') {
        // Simple notification
        const notification = document.createElement('div');
        notification.className = 'notification ' + type;
        notification.textContent = message;
        notification.style.cssText = `
            position: fixed;
            top: 100px;
            right: 20px;
            padding: 1rem 1.5rem;
            background: ${type === 'success' ? 'rgba(16, 185, 129, 0.9)' : 'rgba(239, 68, 68, 0.9)'};
            color: white;
            border-radius: 8px;
            z-index: 10000;
            animation: slideIn 0.3s ease;
        `;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.style.animation = 'slideOut 0.3s ease';
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }

    getContextPath() {
        // Use global APP_CONTEXT if available, otherwise parse from URL
        const ctx = window.APP_CONTEXT || window.location.pathname.substring(0, window.location.pathname.indexOf("/", 2)) || '';
        console.log('[Playlist] Context path:', ctx);
        return ctx;
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }
}

// Global instance - initialize after DOM ready
const playlistManager = new PlaylistManager();
window.playlistManager = playlistManager;
playlistManager.init();

// Global functions for compatibility
window.createNewPlaylist = function() {
    playlistManager.createPlaylist();
};

window.loadUserPlaylists = function() {
    playlistManager.loadUserPlaylists();
};

window.loadPlaylistDetail = function(id, name) {
    playlistManager.viewPlaylist(id, name);
};

console.log('PlaylistManager loaded successfully');

})();
