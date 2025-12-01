<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="../fragments/header.jsp" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
<style>
.admin-dashboard {
  padding: 2rem;
  max-width: 1400px;
  margin: 0 auto;
}
.filter-section {
  background: linear-gradient(135deg, rgba(122, 92, 255, 0.1) 0%, rgba(0, 194, 255, 0.1) 100%);
  border-radius: 16px;
  padding: 1.5rem;
  margin-bottom: 2rem;
  border: 1px solid rgba(122, 92, 255, 0.2);
}
.filter-section h5 {
  color: #fff;
  margin-bottom: 1rem;
  font-weight: 600;
}
.filter-buttons {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
}
.filter-btn {
  padding: 0.5rem 1.25rem;
  border: 2px solid rgba(122, 92, 255, 0.3);
  background: rgba(122, 92, 255, 0.1);
  color: #fff;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s;
  font-weight: 500;
}
.filter-btn:hover {
  background: rgba(122, 92, 255, 0.3);
  border-color: rgba(122, 92, 255, 0.5);
  transform: translateY(-2px);
}
.filter-btn.active {
  background: linear-gradient(135deg, #7a5cff 0%, #00c2ff 100%);
  border-color: transparent;
  box-shadow: 0 4px 15px rgba(122, 92, 255, 0.4);
}
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}
.stat-card {
  background: linear-gradient(135deg, rgba(26, 26, 27, 0.9) 0%, rgba(10, 10, 11, 0.9) 100%);
  border-radius: 16px;
  padding: 1.5rem;
  border: 1px solid rgba(122, 92, 255, 0.2);
  box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
  transition: all 0.3s;
}
.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 40px rgba(122, 92, 255, 0.2);
  border-color: rgba(122, 92, 255, 0.4);
}
.stat-label {
  display: block;
  font-size: 0.85rem;
  color: #a0a0a0;
  margin-bottom: 0.5rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}
.stat-value {
  font-size: 2.5rem;
  font-weight: 700;
  background: linear-gradient(135deg, #7a5cff 0%, #00c2ff 100%);
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  line-height: 1;
}
.chart-container {
  background: linear-gradient(135deg, rgba(26, 26, 27, 0.9) 0%, rgba(10, 10, 11, 0.9) 100%);
  border-radius: 16px;
  padding: 1.5rem;
  border: 1px solid rgba(122, 92, 255, 0.2);
  margin-bottom: 1.5rem;
}
.chart-title {
  color: #fff;
  font-size: 1.25rem;
  font-weight: 600;
  margin-bottom: 1rem;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}
.top-list {
  background: linear-gradient(135deg, rgba(26, 26, 27, 0.9) 0%, rgba(10, 10, 11, 0.9) 100%);
  border-radius: 16px;
  padding: 1.5rem;
  border: 1px solid rgba(122, 92, 255, 0.2);
}
.top-list h6 {
  color: #fff;
  font-weight: 600;
  margin-bottom: 1rem;
  padding-bottom: 0.75rem;
  border-bottom: 1px solid rgba(122, 92, 255, 0.2);
}
.top-list-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.75rem 0;
  border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  color: #fff;
}
.top-list-item:last-child {
  border-bottom: none;
}
.top-list-item .rank {
  font-weight: 700;
  color: #7a5cff;
  margin-right: 0.75rem;
  min-width: 24px;
}
.top-list-item .name {
  flex: 1;
}
.top-list-item .value {
  color: #a0a0a0;
  font-size: 0.9rem;
}
.loading {
  text-align: center;
  padding: 2rem;
  color: #a0a0a0;
}
</style>

<div class="admin-dashboard">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h2 class="text-white mb-0"><i class='bx bx-bar-chart-alt-2'></i> Bảng điều khiển quản trị</h2>
    <div>
      <a class="btn btn-primary me-2" href="${pageContext.request.contextPath}/admin/songs">🎵 Bài hát</a>
      <a class="btn btn-primary me-2" href="${pageContext.request.contextPath}/admin/singers">🎤 Ca sĩ</a>
      <a class="btn btn-primary me-2" href="${pageContext.request.contextPath}/admin/categories">📁 Thể loại</a>
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/admin/users">👥 Người dùng</a>
    </div>
  </div>

  <!-- Bộ lọc thời gian -->
  <div class="filter-section">
    <h5><i class='bx bx-filter'></i> Lọc theo thời gian</h5>
    <div class="filter-buttons">
      <button class="filter-btn active" data-period="day" onclick="setPeriod('day')">Hôm nay</button>
      <button class="filter-btn" data-period="week" onclick="setPeriod('week')">Tuần này</button>
      <button class="filter-btn" data-period="month" onclick="setPeriod('month')">Tháng này</button>
      <button class="filter-btn" data-period="quarter" onclick="setPeriod('quarter')">Quý này</button>
      <button class="filter-btn" data-period="year" onclick="setPeriod('year')">Năm nay</button>
      <button class="filter-btn" data-period="custom" onclick="setPeriod('custom')">Tùy chọn</button>
      <button class="filter-btn" data-period="all" onclick="setPeriod('all')">Tất cả</button>
    </div>
    <div class="mt-3 d-flex gap-3 align-items-center flex-wrap">
      <div class="d-flex gap-2 align-items-center">
        <label class="text-white small">Từ ngày:</label>
        <input type="date" id="startDate" class="form-control form-control-sm" 
               style="max-width: 150px; background: rgba(122, 92, 255, 0.1); border-color: rgba(122, 92, 255, 0.3); color: #fff;"
               onchange="updateDateRange()">
      </div>
      <div class="d-flex gap-2 align-items-center">
        <label class="text-white small">Đến ngày:</label>
        <input type="date" id="endDate" class="form-control form-control-sm"
               style="max-width: 150px; background: rgba(122, 92, 255, 0.1); border-color: rgba(122, 92, 255, 0.3); color: #fff;"
               onchange="updateDateRange()">
      </div>
      <div class="d-flex gap-2 align-items-center">
        <label class="text-white small">Năm:</label>
        <select id="yearSelect" class="form-select form-select-sm" 
                style="max-width: 120px; background: rgba(122, 92, 255, 0.1); border-color: rgba(122, 92, 255, 0.3); color: #fff;"
                onchange="updateChartFilters()">
          <option value="2024">2024</option>
          <option value="2025" selected>2025</option>
        </select>
      </div>
    </div>
  </div>

  <!-- Thống kê tổng quan -->
  <div class="stats-grid" id="statsCards">
    <div class="stat-card">
      <span class="stat-label">Tổng bài hát</span>
      <div class="stat-value" id="statSongs">-</div>
    </div>
    <div class="stat-card">
      <span class="stat-label">Tổng playlist</span>
      <div class="stat-value" id="statPlaylists">-</div>
    </div>
    <div class="stat-card">
      <span class="stat-label">Tổng ca sĩ</span>
      <div class="stat-value" id="statSingers">-</div>
    </div>
    <div class="stat-card">
      <span class="stat-label">Lượt nghe (khoảng thời gian)</span>
      <div class="stat-value" id="statViewsInRange">-</div>
    </div>
    <div class="stat-card">
      <span class="stat-label">Bài hát mới (khoảng thời gian)</span>
      <div class="stat-value" id="statSongsInRange">-</div>
    </div>
    <div class="stat-card">
      <span class="stat-label">Người dùng mới</span>
      <div class="stat-value" id="statNewUsers">-</div>
    </div>
  </div>

  <div class="row g-3">
    <!-- Biểu đồ động -->
    <div class="col-lg-8">
      <div class="chart-container">
        <div class="d-flex justify-content-between align-items-center mb-3">
          <div class="chart-title">📈 Biểu đồ thống kê</div>
          <div class="chart-controls">
            <button class="chart-control-btn chart-type-btn active" data-type="line" onclick="changeChartType('line')">📈 Line</button>
            <button class="chart-control-btn chart-type-btn" data-type="bar" onclick="changeChartType('bar')">📊 Bar</button>
            <button class="chart-control-btn chart-type-btn" data-type="pie" onclick="changeChartType('pie')">🥧 Pie</button>
            <button class="chart-control-btn" onclick="toggleChartSeries()">🔄 Bật/Tắt</button>
          </div>
        </div>
        <div class="filter-bar mb-3" style="padding: 0.75rem; background: rgba(10, 10, 11, 0.5);">
          <div class="filter-group" style="min-width: 140px;">
            <label style="font-size: 0.75rem;">Loại thống kê</label>
            <select id="chartStatType" onchange="updateChartFilters()" style="padding: 0.4rem 0.6rem; background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); border-radius: 6px; color: #fff; font-size: 0.85rem;">
              <option value="views">Lượt nghe theo tháng</option>
              <option value="viewsBySinger">Lượt nghe theo ca sĩ</option>
              <option value="viewsByCategory">Lượt nghe theo thể loại</option>
              <option value="monthComparison">So sánh tháng này vs tháng trước</option>
              <option value="singerComparison">So sánh lượt nghe ca sĩ</option>
              <option value="categoryDistribution">Phân bố thể loại</option>
            </select>
          </div>
          <div class="filter-group" style="min-width: 140px;" id="singerFilterGroup">
            <label style="font-size: 0.75rem;">Nghệ sĩ</label>
            <select id="chartSingerFilter" onchange="updateChartFilters()" style="padding: 0.4rem 0.6rem; background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); border-radius: 6px; color: #fff; font-size: 0.85rem;">
              <option value="all">Tất cả</option>
            </select>
          </div>
          <div class="filter-group" style="min-width: 140px;" id="categoryFilterGroup">
            <label style="font-size: 0.75rem;">Thể loại</label>
            <select id="chartCategoryFilter" onchange="updateChartFilters()" style="padding: 0.4rem 0.6rem; background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); border-radius: 6px; color: #fff; font-size: 0.85rem;">
              <option value="all">Tất cả</option>
            </select>
          </div>
        </div>
        <canvas id="monthlyChart" height="80"></canvas>
      </div>
    </div>

    <!-- Top user có nhiều playlist -->
    <div class="col-lg-4">
      <div class="top-list">
        <h6>👑 Top người dùng có nhiều playlist</h6>
        <div id="topUsersList" class="loading">Đang tải...</div>
      </div>
    </div>
  </div>

  <div class="row g-3 mt-3">
    <!-- Top bài hát trong khoảng thời gian -->
    <div class="col-lg-6">
      <div class="top-list">
        <h6><i class='bx bx-music'></i> Top bài hát nhiều lượt nghe (khoảng thời gian)</h6>
        <div id="topSongsList" class="loading">Đang tải...</div>
      </div>
    </div>

    <!-- Top nghệ sĩ & Top playlist -->
    <div class="col-lg-6">
      <div class="top-list">
        <h6><i class='bx bxs-star'></i> Top nghệ sĩ nổi bật</h6>
        <div id="topArtistsList" class="loading">Đang tải...</div>
      </div>
    </div>
    <div class="col-lg-3">
      <div class="top-list">
        <h6>📋 Top playlist nhiều bài hát</h6>
        <div id="topPlaylistsList" class="loading">Đang tải...</div>
      </div>
    </div>
  </div>
</div>

<!-- Notification Center -->
<div id="notificationBadge" class="notification-badge" style="display: none;">0</div>
<div id="notificationCenter" class="notification-center">
  <div class="notification-panel">
    <div class="notification-header">
      <h6>🔔 Thông báo</h6>
      <button class="btn-close" onclick="document.getElementById('notificationCenter').classList.remove('open')">×</button>
    </div>
    <div id="notificationList" class="notification-list"></div>
  </div>
</div>

<!-- Activity Tracker -->
<div class="activity-tracker">
  <div class="activity-header">
    <h6>⚡ Hoạt động thời gian thực</h6>
    <button class="btn-close" onclick="this.closest('.activity-tracker').style.display='none'">×</button>
  </div>
  <div id="activityList" class="activity-list"></div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>window.APP_CONTEXT = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/ui-utils.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/admin-dashboard.js"></script>
<script>
var ctxPath = '${pageContext.request.contextPath}';
var currentPeriod = 'day';
var currentChartType = 'line';
var currentSinger = 'all';
var currentCategory = 'all';
var monthlyChart = null;

// Load dữ liệu cơ bản
function loadBasicStats() {
  return fetch(ctxPath + '/admin/api/stats')
    .then(function(res) { return res.json(); })
    .then(function(data) {
    
    document.getElementById('statSongs').textContent = data.countSongs || 0;
    document.getElementById('statPlaylists').textContent = data.countPlaylists || 0;
    document.getElementById('statSingers').textContent = data.countSingers || 0;
    
    // Top nghệ sĩ
    var singersUl = document.getElementById('topSingersList');
    singersUl.innerHTML = '';
    if (data.topSingers && data.topSingers.length > 0) {
      data.topSingers.forEach(function(s, idx) {
        var div = document.createElement('div');
        div.className = 'top-list-item';
        div.innerHTML = '<span class="rank">' + (idx + 1) + '</span><span class="name">' + s.name + '</span>';
        singersUl.appendChild(div);
      });
    } else {
      singersUl.innerHTML = '<div class="text-muted small">Chưa có dữ liệu</div>';
    }
    
    // Top playlist
    var playlistsUl = document.getElementById('topPlaylistsList');
    playlistsUl.innerHTML = '';
    if (data.topPlaylists && data.topPlaylists.length > 0) {
      data.topPlaylists.forEach(function(p, idx) {
        var div = document.createElement('div');
        div.className = 'top-list-item';
        div.innerHTML = '<span class="rank">' + (idx + 1) + '</span><span class="name">' + p.name + '</span><span class="value">' + p.songCount + ' bài</span>';
        playlistsUl.appendChild(div);
      });
    } else {
      playlistsUl.innerHTML = '<div class="text-muted small">Chưa có dữ liệu</div>';
    }
    })
    .catch(function(e) {
      console.error('Error loading basic stats:', e);
    });
}

// Load dữ liệu động theo bộ lọc
function loadDynamicStats() {
  var period = currentPeriod;
  var year = document.getElementById('yearSelect').value;
  var url = ctxPath + '/admin/api/stats/dynamic?period=' + period + '&year=' + year;
  
  return fetch(url)
    .then(function(res) { return res.json(); })
    .then(function(data) {
    
    // Cập nhật thống kê
    document.getElementById('statViewsInRange').textContent = formatNumber(data.viewsInRange || 0);
    document.getElementById('statSongsInRange').textContent = data.songsInRange || 0;
    document.getElementById('statNewUsers').textContent = data.newUsers || 0;
    
    // Top bài hát trong khoảng thời gian
    var songsUl = document.getElementById('topSongsList');
    songsUl.innerHTML = '';
    if (data.topSongsInRange && data.topSongsInRange.length > 0) {
      data.topSongsInRange.forEach(function(s, idx) {
        var div = document.createElement('div');
        div.className = 'top-list-item';
        div.innerHTML = '<span class="rank">' + (idx + 1) + '</span><span class="name">' + s.title + '</span><span class="value">' + formatNumber(s.views) + ' lượt</span>';
        songsUl.appendChild(div);
      });
    } else {
      songsUl.innerHTML = '<div class="text-muted small">Chưa có dữ liệu trong khoảng thời gian này</div>';
    }
    
    // Top user có nhiều playlist
    var usersUl = document.getElementById('topUsersList');
    usersUl.innerHTML = '';
    if (data.topUsers && data.topUsers.length > 0) {
      data.topUsers.forEach(function(u, idx) {
        var div = document.createElement('div');
        div.className = 'top-list-item';
        div.innerHTML = '<span class="rank">' + (idx + 1) + '</span><span class="name">' + u.username + '</span><span class="value">' + u.playlistCount + ' playlist</span>';
        usersUl.appendChild(div);
      });
    } else {
      usersUl.innerHTML = '<div class="text-muted small">Chưa có dữ liệu</div>';
    }
    
    // Biểu đồ lượt nghe theo tháng
    updateMonthlyChart(data.viewsByMonth || []);
    })
    .catch(function(e) {
      console.error('Error loading dynamic stats:', e);
    });
}

// Cập nhật biểu đồ theo tháng
function updateMonthlyChart(data) {
  var canvas = document.getElementById('monthlyChart');
  
  // Properly destroy existing chart using Chart.js API
  var existingChart = Chart.getChart(canvas);
  if (existingChart) {
    existingChart.destroy();
  }
  
  var ctx = canvas.getContext('2d');
  
  var monthNames = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'];
  var labels = [];
  var views = [];
  
  // Tạo mảng đầy đủ 12 tháng
  for (var i = 1; i <= 12; i++) {
    labels.push(monthNames[i - 1]);
    var monthData = data.find(function(d) { return d.month === i; });
    views.push(monthData ? monthData.views : 0);
  }
  
  monthlyChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: labels,
      datasets: [{
        label: 'Lượt nghe',
        data: views,
        borderColor: '#7a5cff',
        backgroundColor: 'rgba(122, 92, 255, 0.1)',
        fill: true,
        tension: 0.4,
        pointBackgroundColor: '#00c2ff',
        pointBorderColor: '#fff',
        pointBorderWidth: 2,
        pointRadius: 5
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: true,
      plugins: {
        legend: {
          display: false
        }
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
    }
  });
}

// Format số
function formatNumber(num) {
  return new Intl.NumberFormat('vi-VN').format(num);
}

// Xử lý bộ lọc
document.querySelectorAll('.filter-btn').forEach(function(btn) {
  btn.addEventListener('click', function() {
    document.querySelectorAll('.filter-btn').forEach(function(b) { b.classList.remove('active'); });
    this.classList.add('active');
    currentPeriod = this.dataset.period;
    loadDynamicStats();
  });
});

// Xử lý thay đổi năm
document.getElementById('yearSelect').addEventListener('change', function() {
  loadDynamicStats();
});

// Khởi tạo Admin Dashboard
AdminDashboard.init(ctxPath);

// Set period and update UI
function setPeriod(period) {
  document.querySelectorAll('.filter-btn').forEach(function(b) { b.classList.remove('active'); });
  var periodBtn = document.querySelector('[data-period="' + period + '"]');
  if (periodBtn) periodBtn.classList.add('active');
  currentPeriod = period;
  
  if (period === 'custom') {
    document.getElementById('startDate').style.display = 'block';
    document.getElementById('endDate').style.display = 'block';
  } else {
    document.getElementById('startDate').style.display = 'none';
    document.getElementById('endDate').style.display = 'none';
    // Set default dates based on period
    var today = new Date();
    var startDateInput = document.getElementById('startDate');
    var endDateInput = document.getElementById('endDate');
    
    if (period === 'day') {
      startDateInput.value = endDateInput.value = today.toISOString().split('T')[0];
    } else if (period === 'week') {
      var weekStart = new Date(today);
      weekStart.setDate(today.getDate() - today.getDay());
      startDateInput.value = weekStart.toISOString().split('T')[0];
      endDateInput.value = today.toISOString().split('T')[0];
    } else if (period === 'month') {
      startDateInput.value = new Date(today.getFullYear(), today.getMonth(), 1).toISOString().split('T')[0];
      endDateInput.value = today.toISOString().split('T')[0];
    }
  }
  
  updateChartFilters();
}

function updateDateRange() {
  if (currentPeriod === 'custom') {
    updateChartFilters();
  }
}

// Chart controls
function changeChartType(type) {
  currentChartType = type;
  updateChartFilters();
  document.querySelectorAll('.chart-type-btn').forEach(function(btn) {
    btn.classList.toggle('active', btn.dataset.type === type);
  });
  
  // Show/hide filters based on chart type
  const statType = document.getElementById('chartStatType').value;
  toggleFilterGroups(statType);
}

function toggleFilterGroups(statType) {
  var singerGroup = document.getElementById('singerFilterGroup');
  var categoryGroup = document.getElementById('categoryFilterGroup');
  
  // Show/hide based on stat type
  if (statType === 'viewsBySinger' || statType === 'singerComparison') {
    singerGroup.style.display = 'none';
    categoryGroup.style.display = 'none';
  } else if (statType === 'viewsByCategory' || statType === 'categoryDistribution') {
    singerGroup.style.display = 'none';
    categoryGroup.style.display = 'none';
  } else {
    singerGroup.style.display = 'block';
    categoryGroup.style.display = 'block';
  }
}

function toggleChartSeries() {
  // Toggle chart series visibility
  if (AdminDashboard.charts.monthlyChart) {
    var chart = AdminDashboard.charts.monthlyChart;
    chart.data.datasets.forEach(function(dataset) {
      dataset.hidden = !dataset.hidden;
    });
    chart.update();
  }
}

function updateChartFilters() {
  var chartStatTypeEl = document.getElementById('chartStatType');
  var statType = chartStatTypeEl ? chartStatTypeEl.value : 'views';
  var period = currentPeriod;
  var yearSelectEl = document.getElementById('yearSelect');
  var year = yearSelectEl ? yearSelectEl.value : new Date().getFullYear();
  var startDateEl = document.getElementById('startDate');
  var startDate = startDateEl ? startDateEl.value : '';
  var endDateEl = document.getElementById('endDate');
  var endDate = endDateEl ? endDateEl.value : '';
  var singerFilterEl = document.getElementById('chartSingerFilter');
  var singer = singerFilterEl ? singerFilterEl.value : 'all';
  var categoryFilterEl = document.getElementById('chartCategoryFilter');
  var category = categoryFilterEl ? categoryFilterEl.value : 'all';
  
  toggleFilterGroups(statType);
  
  var url = ctxPath + '/admin/api/stats/dynamic?period=' + period + '&year=' + year + '&statType=' + statType;
  if (period === 'custom' && startDate && endDate) {
    url += '&startDate=' + startDate + '&endDate=' + endDate;
  }
  if (singer !== 'all') url += '&singer=' + singer;
  if (category !== 'all') url += '&category=' + category;
  
  return fetch(url)
    .then(function(res) { return res.json(); })
    .then(function(data) {
    
    // Update chart based on stat type
    if (statType === 'viewsBySinger' || statType === 'singerComparison') {
      AdminDashboard.updateChartBySingers('monthlyChart', data.singersData || [], currentChartType);
    } else if (statType === 'viewsByCategory' || statType === 'categoryDistribution') {
      AdminDashboard.updateChartByCategories('monthlyChart', data.categoriesData || [], currentChartType);
    } else if (statType === 'monthComparison') {
      AdminDashboard.updateChartComparison('monthlyChart', data.comparisonData || [], currentChartType);
    } else {
      AdminDashboard.updateChart('monthlyChart', data.viewsByMonth || [], currentChartType);
    }
    
    // Also update stats
    if (data.viewsInRange !== undefined) {
      AdminDashboard.updateStatCard('statViewsInRange', data.viewsInRange || 0);
    }
    if (data.songsInRange !== undefined) {
      AdminDashboard.updateStatCard('statSongsInRange', data.songsInRange || 0);
    }
    })
    .catch(function(e) {
      console.error('Error updating chart filters:', e);
    });
}

// Load singers and categories for filters
function loadChartFilters() {
  return fetch(ctxPath + '/admin/api/stats')
    .then(function(res) { return res.json(); })
    .then(function(data) {
      var singerSelect = document.getElementById('chartSingerFilter');
      var categorySelect = document.getElementById('chartCategoryFilter');
      
      // Populate singers (simplified - in production use dedicated API)
      if (data.topSingers) {
        data.topSingers.forEach(function(s) {
          var option = document.createElement('option');
          option.value = s.id || 'all';
          option.textContent = s.name;
          singerSelect.appendChild(option);
        });
      }
      
      // For categories, we'd need a separate API call or include in stats
      // For now, keep "Tất cả" option
    })
    .catch(function(e) {
      console.error('Error loading chart filters:', e);
    });
}

// Initialize date inputs
var today = new Date();
document.getElementById('startDate').value = today.toISOString().split('T')[0];
document.getElementById('endDate').value = today.toISOString().split('T')[0];
document.getElementById('startDate').style.display = 'none';
document.getElementById('endDate').style.display = 'none';

// Initial load
AdminDashboard.loadBasicStats();
setPeriod('day');
loadChartFilters();
</script>
<jsp:include page="../fragments/footer.jsp" />
