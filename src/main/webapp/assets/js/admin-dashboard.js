// Admin Dashboard Dynamic Features - ES5 Compatible
var AdminDashboard = {
  ctxPath: '',
  charts: {
    monthlyChart: null
  },
  statsCache: {},
  notificationCount: 0,
  activityItems: [],
  refreshInterval: null,
  
  init: function(ctxPath) {
    this.ctxPath = ctxPath;
    this.setupCounterAnimation();
    this.setupNotificationCenter();
    this.setupActivityTracker();
    this.setupAutoRefresh();
    this.loadInitialData();
  },
  
  animateCounter: function(element, targetValue, duration) {
    duration = duration || 1000;
    var startValue = parseInt(element.textContent) || 0;
    var increment = (targetValue - startValue) / (duration / 16);
    var current = startValue;
    var self = this;
    
    element.classList.add('counting');
    var card = element.closest('.stat-card');
    if (card) card.classList.add('updated');
    
    var timer = setInterval(function() {
      current += increment;
      if ((increment > 0 && current >= targetValue) || (increment < 0 && current <= targetValue)) {
        current = targetValue;
        clearInterval(timer);
        element.classList.remove('counting');
        if (card) {
          setTimeout(function() { card.classList.remove('updated'); }, 600);
        }
      }
      element.textContent = self.formatNumber(Math.floor(current));
    }, 16);
  },
  
  setupCounterAnimation: function() {
    this.statsCache = {
      songs: 0,
      playlists: 0,
      singers: 0,
      views: 0,
      viewsInRange: 0,
      songsInRange: 0,
      newUsers: 0
    };
  },
  
  updateStatCard: function(id, newValue, format) {
    format = (format === undefined) ? true : format;
    var element = document.getElementById(id);
    if (!element) return;
    
    var oldValue = this.statsCache[id] || 0;
    if (oldValue !== newValue) {
      this.animateCounter(element, newValue);
      this.statsCache[id] = newValue;
    } else if (format) {
      element.textContent = this.formatNumber(newValue);
    } else {
      element.textContent = newValue;
    }
  },
  
  loadInitialData: function() {
    var self = this;
    Promise.all([
      self.loadBasicStats(),
      self.loadDynamicStats(),
      self.loadNotifications(),
      self.loadActivities()
    ]).catch(function(e) {
      console.error('Error loading initial data:', e);
    });
  },
  
  loadBasicStats: function() {
    var self = this;
    return fetch(this.ctxPath + '/admin/api/stats')
      .then(function(res) { return res.json(); })
      .then(function(data) {
        self.updateStatCard('statSongs', data.countSongs || 0);
        self.updateStatCard('statPlaylists', data.countPlaylists || 0);
        self.updateStatCard('statSingers', data.countSingers || 0);
        
        self.updateTopList('topSingersList', data.topSingers || [], function(s, idx) {
          return '<span class="rank">' + (idx + 1) + '</span><span class="name">' + s.name + '</span>';
        });
        
        self.updateTopList('topPlaylistsList', data.topPlaylists || [], function(p, idx) {
          return '<span class="rank">' + (idx + 1) + '</span><span class="name">' + p.name + '</span><span class="value">' + p.songCount + ' bài</span>';
        });
      })
      .catch(function(e) {
        console.error('Error loading basic stats:', e);
      });
  },
  
  loadDynamicStats: function(period, year) {
    period = period || 'day';
    year = year || new Date().getFullYear();
    var self = this;
    var url = this.ctxPath + '/admin/api/stats/dynamic?period=' + period + '&year=' + year;
    
    return fetch(url)
      .then(function(res) { return res.json(); })
      .then(function(data) {
        self.updateStatCard('statViewsInRange', data.viewsInRange || 0);
        self.updateStatCard('statSongsInRange', data.songsInRange || 0);
        self.updateStatCard('statNewUsers', data.newUsers || 0);
        
        self.updateTopList('topSongsList', data.topSongsInRange || [], function(s, idx) {
          return '<span class="rank">' + (idx + 1) + '</span><span class="name">' + s.title + '</span><span class="value">' + self.formatNumber(s.views) + ' lượt</span>';
        });
        
        self.updateTopList('topUsersList', data.topUsers || [], function(u, idx) {
          return '<span class="rank">' + (idx + 1) + '</span><span class="name">' + u.username + '</span><span class="value">' + u.playlistCount + ' playlist</span>';
        });
        
        self.updateChart('monthlyChart', data.viewsByMonth || [], 'line');
      })
      .catch(function(e) {
        console.error('Error loading dynamic stats:', e);
      });
  },
  
  updateTopList: function(containerId, items, renderFn) {
    var container = document.getElementById(containerId);
    if (!container) return;
    
    container.innerHTML = '';
    if (items.length === 0) {
      container.innerHTML = '<div class="text-muted small">Chưa có dữ liệu</div>';
      return;
    }
    
    items.forEach(function(item, idx) {
      var div = document.createElement('div');
      div.className = 'top-list-item';
      div.innerHTML = renderFn(item, idx);
      container.appendChild(div);
    });
  },
  
  updateChart: function(canvasId, data, chartType, options) {
    chartType = chartType || 'line';
    options = options || {};
    this._updateChartInternal(canvasId, data, chartType, options, 'month');
  },
  
  updateChartBySingers: function(canvasId, data, chartType) {
    chartType = chartType || 'bar';
    this._updateChartInternal(canvasId, data, chartType, {}, 'singer');
  },
  
  updateChartByCategories: function(canvasId, data, chartType) {
    chartType = chartType || 'pie';
    this._updateChartInternal(canvasId, data, chartType, {}, 'category');
  },
  
  updateChartComparison: function(canvasId, data, chartType) {
    chartType = chartType || 'bar';
    this._updateChartInternal(canvasId, data, chartType, {}, 'comparison');
  },
  
  _updateChartInternal: function(canvasId, data, chartType, options, dataType) {
    var canvas = document.getElementById(canvasId);
    if (!canvas) return;
    
    var ctx = canvas.getContext('2d');
    
    if (this.charts[canvasId]) {
      this.charts[canvasId].destroy();
      this.charts[canvasId] = null;
    }
    
    var labels = [];
    var values = [];
    var datasets = [];
    
    if (dataType === 'month') {
      var monthNames = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];
      for (var i = 1; i <= 12; i++) {
        labels.push(monthNames[i - 1]);
        var monthData = data.find(function(d) { return d.month === i; });
        values.push(monthData ? monthData.views : 0);
      }
    } else if (dataType === 'singer') {
      labels = data.map(function(d) { return d.name || d.singerName || 'Unknown'; });
      values = data.map(function(d) { return d.views || d.totalViews || 0; });
    } else if (dataType === 'category') {
      labels = data.map(function(d) { return d.name || d.categoryName || 'Unknown'; });
      values = data.map(function(d) { return d.views || d.totalViews || 0; });
    } else if (dataType === 'comparison') {
      labels = data.map(function(d) { return d.label || d.month || 'Unknown'; });
      datasets = [
        {
          label: 'Tháng này',
          data: data.map(function(d) { return d.current || d.thisMonth || 0; }),
          borderColor: '#7a5cff',
          backgroundColor: chartType === 'bar' ? 'rgba(122, 92, 255, 0.5)' : 'rgba(122, 92, 255, 0.1)',
          fill: chartType === 'line'
        },
        {
          label: 'Tháng trước',
          data: data.map(function(d) { return d.previous || d.lastMonth || 0; }),
          borderColor: '#00c2ff',
          backgroundColor: chartType === 'bar' ? 'rgba(0, 194, 255, 0.5)' : 'rgba(0, 194, 255, 0.1)',
          fill: chartType === 'line'
        }
      ];
    }
    
    var chartData = {
      labels: labels,
      datasets: datasets.length > 0 ? datasets : [{
        label: dataType === 'singer' ? 'Lượt nghe ca sĩ' : 
               dataType === 'category' ? 'Lượt nghe thể loại' : 'Lượt nghe',
        data: values,
        borderColor: '#7a5cff',
        backgroundColor: chartType === 'pie' ? [
          'rgba(122, 92, 255, 0.8)',
          'rgba(0, 194, 255, 0.8)',
          'rgba(16, 185, 129, 0.8)',
          'rgba(245, 158, 11, 0.8)',
          'rgba(239, 68, 68, 0.8)',
          'rgba(139, 92, 246, 0.8)'
        ] : (chartType === 'bar' ? 'rgba(122, 92, 255, 0.5)' : 'rgba(122, 92, 255, 0.1)'),
        fill: chartType === 'line',
        tension: chartType === 'line' ? 0.4 : 0,
        pointBackgroundColor: '#00c2ff',
        pointBorderColor: '#fff',
        pointBorderWidth: 2,
        pointRadius: chartType === 'pie' ? 0 : 5
      }]
    };
    
    var mergedOptions = {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: { display: false }
      },
      scales: {
        x: {
          ticks: { color: '#a0a0a0' },
          grid: { color: 'rgba(255, 255, 255, 0.05)' }
        },
        y: {
          ticks: { color: '#a0a0a0' },
          grid: { color: 'rgba(255, 255, 255, 0.05)' }
        }
      }
    };
    
    for (var key in options) {
      if (options.hasOwnProperty(key)) {
        mergedOptions[key] = options[key];
      }
    }
    
    var chartConfig = {
      type: chartType,
      data: chartData,
      options: mergedOptions
    };
    
    this.charts[canvasId] = new Chart(ctx, chartConfig);
    if (canvasId === 'monthlyChart') {
      this.statsCache.viewsByMonth = data;
    }
  },
  
  setupNotificationCenter: function() {
    var self = this;
    var badge = document.getElementById('notificationBadge');
    var center = document.getElementById('notificationCenter');
    
    if (badge) {
      badge.addEventListener('click', function() {
        if (center) {
          center.classList.toggle('open');
          if (center.classList.contains('open')) {
            self.markAllRead();
          }
        }
      });
    }
  },
  
  loadNotifications: function() {
    var notifications = [
      { id: 1, type: 'success', message: 'Bài hát mới được upload: Waiting For You', time: '2 phút trước', read: false },
      { id: 2, type: 'info', message: 'User mới đăng ký: user123', time: '5 phút trước', read: false },
      { id: 3, type: 'warning', message: 'Lượt nghe tăng đột biến: +500 lượt', time: '10 phút trước', read: false }
    ];
    
    this.renderNotifications(notifications);
    this.updateNotificationBadge(notifications.filter(function(n) { return !n.read; }).length);
    return Promise.resolve();
  },
  
  renderNotifications: function(notifications) {
    var container = document.getElementById('notificationList');
    if (!container) return;
    
    container.innerHTML = '';
    notifications.forEach(function(notif) {
      var div = document.createElement('div');
      div.className = 'notification-item ' + (notif.read ? '' : 'unread');
      div.innerHTML = '<div class="d-flex justify-content-between align-items-start">' +
          '<div>' +
            '<div class="text-white small">' + notif.message + '</div>' +
            '<div class="text-muted" style="font-size: 0.75rem;">' + notif.time + '</div>' +
          '</div>' +
        '</div>';
      container.appendChild(div);
    });
  },
  
  updateNotificationBadge: function(count) {
    var badge = document.getElementById('notificationBadge');
    if (badge) {
      badge.textContent = count;
      badge.style.display = count > 0 ? 'flex' : 'none';
      this.notificationCount = count;
    }
  },
  
  markAllRead: function() {
    this.updateNotificationBadge(0);
  },
  
  showToast: function(message, type) {
    type = type || 'info';
    var container = document.getElementById('toastContainer') || this.createToastContainer();
    var toast = document.createElement('div');
    toast.className = 'toast ' + type;
    toast.innerHTML = '<div class="toast-icon">' + this.getToastIcon(type) + '</div>' +
      '<div class="toast-message">' + message + '</div>';
    container.appendChild(toast);
    
    setTimeout(function() {
      toast.style.animation = 'slideOutRight 0.3s ease';
      setTimeout(function() { toast.remove(); }, 300);
    }, 3000);
  },
  
  createToastContainer: function() {
    var container = document.createElement('div');
    container.id = 'toastContainer';
    container.className = 'toast-container';
    document.body.appendChild(container);
    return container;
  },
  
  getToastIcon: function(type) {
    var icons = {
      success: '✓',
      error: '✕',
      warning: '⚠',
      info: 'ℹ'
    };
    return icons[type] || icons.info;
  },
  
  setupActivityTracker: function() {
    var self = this;
    setInterval(function() {
      self.addActivity({
        type: 'listening',
        user: 'user' + Math.floor(Math.random() * 100),
        song: 'Song ' + Math.floor(Math.random() * 50),
        time: 'Vừa xong'
      });
    }, 10000);
  },
  
  loadActivities: function() {
    var activities = [
      { type: 'listening', user: 'user1', song: 'Waiting For You', time: '1 phút trước' },
      { type: 'uploading', user: 'admin', song: 'New Song', time: '2 phút trước' },
      { type: 'creating', user: 'user2', playlist: 'My Playlist', time: '3 phút trước' }
    ];
    
    this.renderActivities(activities);
    return Promise.resolve();
  },
  
  addActivity: function(activity) {
    var container = document.getElementById('activityList');
    if (!container) return;
    
    var div = document.createElement('div');
    div.className = 'activity-item new';
    div.innerHTML = this.renderActivityItem(activity);
    container.insertBefore(div, container.firstChild);
    
    while (container.children.length > 10) {
      container.removeChild(container.lastChild);
    }
    
    setTimeout(function() { div.classList.remove('new'); }, 500);
  },
  
  renderActivities: function(activities) {
    var container = document.getElementById('activityList');
    if (!container) return;
    
    var self = this;
    container.innerHTML = '';
    activities.forEach(function(activity) {
      var div = document.createElement('div');
      div.className = 'activity-item';
      div.innerHTML = self.renderActivityItem(activity);
      container.appendChild(div);
    });
  },
  
  renderActivityItem: function(activity) {
    var icons = {
      listening: { icon: '🎵', class: 'listening', text: 'đang nghe' },
      uploading: { icon: '📤', class: 'uploading', text: 'đang upload' },
      creating: { icon: '➕', class: 'creating', text: 'đang tạo' }
    };
    
    var iconInfo = icons[activity.type] || icons.listening;
    var message = activity.type === 'creating' 
      ? activity.user + ' ' + iconInfo.text + ' playlist "' + activity.playlist + '"'
      : activity.user + ' ' + iconInfo.text + ' "' + activity.song + '"';
    
    return '<div class="activity-icon ' + iconInfo.class + '">' + iconInfo.icon + '</div>' +
      '<div>' +
        '<div class="text-white small">' + message + '</div>' +
        '<div class="text-muted" style="font-size: 0.75rem;">' + activity.time + '</div>' +
      '</div>';
  },
  
  setupAutoRefresh: function() {
    var self = this;
    this.refreshInterval = setInterval(function() {
      self.loadBasicStats();
      var activeBtn = document.querySelector('.filter-btn.active');
      var period = activeBtn ? activeBtn.dataset.period : 'day';
      self.loadDynamicStats(period);
    }, 5000);
  },
  
  destroy: function() {
    if (this.refreshInterval) {
      clearInterval(this.refreshInterval);
    }
    var charts = this.charts;
    Object.keys(charts).forEach(function(key) {
      if (charts[key]) charts[key].destroy();
    });
  },
  
  formatNumber: function(num) {
    return new Intl.NumberFormat('vi-VN').format(num);
  }
};
