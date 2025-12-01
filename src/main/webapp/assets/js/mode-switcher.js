(function() {
    'use strict';
    
    // Check if already loaded
    if (window.modeSwitcher) {
        console.log('ModeSwitcher already loaded, skipping...');
        return;
    }

// Utility managers - use from ui-utils.js if available
if (!window.LoadingManager) {
    window.LoadingManager = {
        show: function(msg) {
            console.log('[Loading]', msg);
        },
        hide: function() {
            console.log('[Loading] Hide');
        }
    };
}

if (!window.NotificationManager) {
    window.NotificationManager = {
        show: function(msg, type) {
            console.log('[Notification]', type || 'info', msg);
            if (type === 'error') {
                alert(msg);
            }
        }
    };
}

const ViewMode = {
    DISCOVER: 1,
    SONG: 2,
    PLAYLIST: 3,
    CATEGORY: 4,
    SINGER: 5
};

class ModeSwitcher {
    constructor() {
        this.currentMode = ViewMode.DISCOVER;
        this.contentArea = document.getElementById('mainContent'); // ← QUAN TRỌNG: Dùng mainContent
    }

    switchTo(mode, data = {}) {
        console.log('Switching to mode:', mode, 'with data:', data);
        
        // Load content vào mainContent
        this.loadContent(mode, data);
        
        // Update URL
        this.updateURL(mode, data);
        
        this.currentMode = mode;
    }

    async loadContent(mode, data) {
        if (!this.contentArea) {
            console.error('Content area #mainContent not found!');
            return;
        }
        
        // Don't reload discover mode (already loaded server-side)
        if (mode === ViewMode.DISCOVER && !data.reload) {
            console.log('Discover mode already loaded');
            return;
        }
        
        const ctx = window.APP_CONTEXT || '';
        let url = '';
        
        switch (mode) {
            case ViewMode.DISCOVER:
                url = `${ctx}/home/discover`;
                break;
            case ViewMode.PLAYLIST:
                url = `${ctx}/playlist/view?id=${data.playlistId}`;
                break;
            case ViewMode.SONG:
                url = `${ctx}/song/view?id=${data.songId}`;
                break;
            case ViewMode.CATEGORY:
                url = `${ctx}/category/view?id=${data.categoryId}`;
                break;
            case ViewMode.SINGER:
                url = `${ctx}/singer/view?id=${data.singerId}`;
                break;
        }

        if (url) {
            try {
                window.LoadingManager.show('Đang tải...');
                console.log('Loading URL:', url);
                
                const response = await fetch(url);
                if (!response.ok) {
                    throw new Error(`HTTP ${response.status}: Failed to load content`);
                }
                
                const html = await response.text();
                console.log('Content loaded, length:', html.length);
                
                // Render vào mainContent
                this.contentArea.innerHTML = html;
                
                // Execute scripts in the loaded content
                this.executeScripts();
                
                window.LoadingManager.hide();
                console.log('Content rendered successfully');
                
            } catch (error) {
                console.error('Error loading content:', error);
                this.contentArea.innerHTML = `
                    <div style="padding: 2rem; text-align: center; color: var(--text-secondary);">
                        <i class='bx bx-error' style="font-size: 3rem;"></i>
                        <p>Không thể tải nội dung. Vui lòng thử lại.</p>
                        <p style="color: red; font-size: 0.9rem;">${error.message}</p>
                    </div>
                `;
                window.LoadingManager.hide();
                window.NotificationManager.show('Không thể tải nội dung: ' + error.message, 'error');
            }
        }
    }
    
    executeScripts() {
        // Find and execute all script tags in the loaded content
        const scripts = this.contentArea.querySelectorAll('script');
        console.log('📜 Executing scripts from loaded content:', scripts.length);
        
        scripts.forEach((script, index) => {
            try {
                const newScript = document.createElement('script');
                newScript.type = 'text/javascript';
                
                if (script.src) {
                    // External script
                    newScript.src = script.src;
                    console.log(`Loading external script ${index + 1}:`, script.src);
                } else {
                    // Inline script
                    newScript.textContent = script.textContent;
                    console.log(`Executing inline script ${index + 1}, length:`, script.textContent.length);
                }
                
                // Append to body to execute
                document.body.appendChild(newScript);
                
                // Keep inline scripts (they execute immediately)
                // Remove external scripts after load
                if (script.src) {
                    newScript.onload = () => {
                        console.log(`✅ External script ${index + 1} loaded`);
                        setTimeout(() => document.body.removeChild(newScript), 100);
                    };
                    newScript.onerror = () => {
                        console.error(`❌ Failed to load script ${index + 1}:`, script.src);
                    };
                } else {
                    // For inline scripts, don't remove immediately
                    console.log(`✅ Inline script ${index + 1} executed`);
                }
            } catch (error) {
                console.error(`❌ Error executing script ${index + 1}:`, error);
            }
        });
        
        console.log('✅ All scripts processed');
    }

    updateURL(mode, data) {
        const ctx = window.APP_CONTEXT || '';
        let url = ctx + '/home?mode=' + mode;
        
        if (data.playlistId) url += '&id=' + data.playlistId;
        if (data.songId) url += '&song=' + data.songId;
        if (data.categoryId) url += '&category=' + data.categoryId;
        
        console.log('Updating URL to:', url);
        history.pushState({ mode, data }, '', url);
    }
}

// Khởi tạo instance global
const modeSwitcher = new ModeSwitcher();
window.modeSwitcher = modeSwitcher; // Export để dùng toàn cục

// Global navigation functions - make available on window immediately
window.viewSong = function(songId) {
    console.log('viewSong called with ID:', songId);
    modeSwitcher.switchTo(ViewMode.SONG, { songId });
};

window.viewPlaylist = function(playlistId) {
    console.log('viewPlaylist called with ID:', playlistId);
    modeSwitcher.switchTo(ViewMode.PLAYLIST, { playlistId });
};

window.viewCategory = function(categoryId) {
    console.log('viewCategory called with ID:', categoryId);
    modeSwitcher.switchTo(ViewMode.CATEGORY, { categoryId });
};

window.viewSinger = function(singerId) {
    console.log('viewSinger called with ID:', singerId);
    modeSwitcher.switchTo(ViewMode.SINGER, { singerId });
};

window.viewDiscover = function() {
    console.log('viewDiscover called');
    modeSwitcher.switchTo(ViewMode.DISCOVER, { reload: true });
};

// Backward compatibility
function viewSong(songId) {
    window.viewSong(songId);
}

function viewPlaylist(playlistId) {
    window.viewPlaylist(playlistId);
}

function viewCategory(categoryId) {
    window.viewCategory(categoryId);
}

function viewSinger(singerId) {
    window.viewSinger(singerId);
}

function viewProfile() {
    const ctx = window.APP_CONTEXT || '';
    console.log('Redirecting to profile');
    window.location.href = ctx + '/profile';
}

console.log('ModeSwitcher initialized successfully');

})();