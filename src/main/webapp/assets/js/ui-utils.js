// UI Utilities - Carousel, Sidebar, Dropdowns
(function() {
    'use strict';
    
    // Check if already loaded
    if (window.UIUtils) {
        console.log('UIUtils already loaded, skipping...');
        return;
    }

class UIUtils {
    constructor() {
        this.init();
    }

    init() {
        this.initCarousel();
        this.initSidebar();
        this.initDropdowns();
    }

    initCarousel() {
        // Carousel scroll functionality
        window.scrollCarousel = (id, direction) => {
            const track = document.getElementById(id + '-track');
            if (!track) return;
            
            const scrollAmount = 280;
            track.scrollBy({
                left: direction * scrollAmount,
                behavior: 'smooth'
            });
        };
    }

    initSidebar() {
        // Sidebar toggle
        window.toggleSidebar = () => {
            const sidebar = document.getElementById('playlistSidebar');
            if (sidebar) {
                sidebar.classList.toggle('collapsed');
            }
        };
        
        // View profile function
        window.viewProfile = () => {
            const ctx = window.APP_CONTEXT || '';
            window.location.href = `${ctx}/profile`;
        };
    }

    initDropdowns() {
        // Toggle user menu
        window.toggleUserMenu = (event) => {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }
            const menu = document.getElementById('userDropdownMenu');
            if (menu) {
                // Close other dropdowns
                document.querySelectorAll('.dropdown-menu').forEach(m => {
                    if (m !== menu) m.classList.remove('active');
                });
                menu.classList.toggle('active');
            }
        };

        // Toggle playlist menu
        window.togglePlaylistMenu = (event) => {
            if (event) {
                event.preventDefault();
                event.stopPropagation();
            }
            const menu = document.getElementById('playlistDropdown');
            if (menu) {
                document.querySelectorAll('.dropdown-menu').forEach(m => {
                    if (m !== menu) m.classList.remove('active');
                });
                menu.classList.toggle('active');
            }
        };
        
        // Close dropdowns when clicking outside - delay to avoid conflict with toggle
        setTimeout(() => {
            document.addEventListener('click', (e) => {
                if (!e.target.closest('.user-dropdown') && !e.target.closest('.dropdown')) {
                    document.querySelectorAll('.dropdown-menu').forEach(menu => {
                        menu.classList.remove('active');
                    });
                }
            });
        }, 100);
    }
}

// Notification system
class NotificationManager {
    static show(message, type = 'info', duration = 3000) {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        
        const iconMap = {
            success: 'bx-check-circle',
            error: 'bx-error-circle',
            warning: 'bx-error',
            info: 'bx-info-circle'
        };
        
        notification.innerHTML = `
            <i class='bx ${iconMap[type]}'></i>
            <span>${message}</span>
        `;
        
        notification.style.cssText = `
            position: fixed;
            top: 100px;
            right: 20px;
            padding: 1rem 1.5rem;
            background: linear-gradient(135deg, ${this.getColorForType(type)});
            color: white;
            border-radius: 8px;
            z-index: 10000;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.3);
            animation: slideInRight 0.3s ease;
        `;
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.style.animation = 'slideOutRight 0.3s ease';
            setTimeout(() => notification.remove(), 300);
        }, duration);
    }

    static getColorForType(type) {
        const colors = {
            success: 'rgba(16, 185, 129, 0.95) 0%, rgba(5, 150, 105, 0.95) 100%',
            error: 'rgba(239, 68, 68, 0.95) 0%, rgba(220, 38, 38, 0.95) 100%',
            warning: 'rgba(245, 158, 11, 0.95) 0%, rgba(217, 119, 6, 0.95) 100%',
            info: 'rgba(59, 130, 246, 0.95) 0%, rgba(37, 99, 235, 0.95) 100%'
        };
        return colors[type] || colors.info;
    }
}

// Loading overlay
class LoadingManager {
    static show(message = 'Đang tải...') {
        let overlay = document.getElementById('loadingOverlay');
        
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.id = 'loadingOverlay';
            overlay.innerHTML = `
                <div class="loading-spinner"></div>
                <p>${message}</p>
            `;
            overlay.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(10, 10, 11, 0.9);
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                z-index: 9999;
                backdrop-filter: blur(5px);
            `;
            
            const spinner = overlay.querySelector('.loading-spinner');
            if (spinner) {
                spinner.style.cssText = `
                    width: 50px;
                    height: 50px;
                    border: 4px solid rgba(122, 92, 255, 0.3);
                    border-top-color: var(--accent-purple);
                    border-radius: 50%;
                    animation: spin 1s linear infinite;
                    margin-bottom: 1rem;
                `;
            }
            
            const p = overlay.querySelector('p');
            if (p) {
                p.style.cssText = `
                    color: var(--text-primary);
                    font-size: 1rem;
                `;
            }
            
            document.body.appendChild(overlay);
        }
        
        overlay.style.display = 'flex';
    }

    static hide() {
        const overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            overlay.style.display = 'none';
        }
    }
}

// Confirmation dialog
class ConfirmDialog {
    static show(message, onConfirm, onCancel = null) {
        const dialog = document.createElement('div');
        dialog.className = 'confirm-dialog-overlay';
        dialog.innerHTML = `
            <div class="confirm-dialog">
                <div class="confirm-header">
                    <i class='bx bx-help-circle'></i>
                    <h3>Xác nhận</h3>
                </div>
                <div class="confirm-body">
                    <p>${message}</p>
                </div>
                <div class="confirm-footer">
                    <button class="btn-cancel">Hủy</button>
                    <button class="btn-confirm">Xác nhận</button>
                </div>
            </div>
        `;
        
        dialog.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.7);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10000;
            backdrop-filter: blur(5px);
        `;
        
        document.body.appendChild(dialog);
        
        const confirmBtn = dialog.querySelector('.btn-confirm');
        const cancelBtn = dialog.querySelector('.btn-cancel');
        
        confirmBtn.onclick = () => {
            if (onConfirm) onConfirm();
            dialog.remove();
        };
        
        cancelBtn.onclick = () => {
            if (onCancel) onCancel();
            dialog.remove();
        };
        
        dialog.onclick = (e) => {
            if (e.target === dialog) {
                if (onCancel) onCancel();
                dialog.remove();
            }
        };
    }
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
@keyframes slideInRight {
    from { transform: translateX(100%); opacity: 0; }
    to { transform: translateX(0); opacity: 1; }
}

@keyframes slideOutRight {
    from { transform: translateX(0); opacity: 1; }
    to { transform: translateX(100%); opacity: 0; }
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

.confirm-dialog {
    background: var(--bg-card);
    border-radius: 12px;
    padding: 2rem;
    max-width: 400px;
    width: 90%;
    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
}

.confirm-header {
    display: flex;
    align-items: center;
    gap: 0.5rem;
    margin-bottom: 1rem;
    color: var(--accent-purple);
}

.confirm-header i {
    font-size: 2rem;
}

.confirm-body {
    margin-bottom: 1.5rem;
    color: var(--text-primary);
}

.confirm-footer {
    display: flex;
    gap: 1rem;
    justify-content: flex-end;
}

.confirm-footer button {
    padding: 0.7rem 1.5rem;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 600;
    transition: all 0.3s;
}

.btn-cancel {
    background: rgba(255, 255, 255, 0.1);
    color: var(--text-primary);
}

.btn-cancel:hover {
    background: rgba(255, 255, 255, 0.2);
}

.btn-confirm {
    background: var(--gradient-primary);
    color: white;
}

.btn-confirm:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(122, 92, 255, 0.4);
}
`;
document.head.appendChild(style);

// Initialize
const uiUtils = new UIUtils();

// Export global utilities
window.UIUtils = UIUtils;
window.NotificationManager = NotificationManager;
window.LoadingManager = LoadingManager;
window.ConfirmDialog = ConfirmDialog;

console.log('UIUtils loaded successfully');

})();
