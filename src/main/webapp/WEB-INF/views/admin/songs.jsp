<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../fragments/header.jsp" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">

<div class="admin-page">
  <div class="container" style="max-width: 1400px; margin: 0 auto; padding: 2rem;">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="text-white mb-0"><i class='bx bx-music'></i> Quản lý Bài hát</h2>
      <button class="btn btn-primary" onclick="openCreateSongModal()">
        <i class='bx bx-plus-circle'></i> Thêm bài hát
      </button>
    </div>

    <!-- Live Search & Filter -->
    <div class="filter-bar">
      <div class="live-search-container" style="flex: 1;">
        <div class="live-search-icon"><i class='bx bx-search'></i></div>
        <input type="text" id="searchInput" class="live-search-input" placeholder="Tìm kiếm bài hát..." onkeyup="filterTable()">
      </div>
      <div class="filter-group">
        <label>Lọc theo Ca sĩ</label>
        <select id="singerFilter" onchange="filterTable()" style="padding: 0.5rem 0.75rem; background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); border-radius: 8px; color: #fff;">
          <option value="all">Tất cả</option>
          <c:forEach var="sg" items="${singers}">
            <option value="${sg.id}">${sg.name}</option>
          </c:forEach>
        </select>
      </div>
      <div class="filter-group">
        <label>Lọc theo Thể loại</label>
        <select id="categoryFilter" onchange="filterTable()" style="padding: 0.5rem 0.75rem; background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); border-radius: 8px; color: #fff;">
          <option value="all">Tất cả</option>
          <c:forEach var="c" items="${categories}">
            <option value="${c.id}">${c.name}</option>
          </c:forEach>
        </select>
      </div>
    </div>

    <!-- Data Table -->
    <div class="data-table">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Ảnh</th>
            <th>Tên bài hát</th>
            <th>Ca sĩ</th>
            <th>Thể loại</th>
            <th>Lượt nghe</th>
            <th>File</th>
            <th>Hành động</th>
          </tr>
        </thead>
        <tbody id="songTableBody">
          <c:forEach var="s" items="${songs}">
            <tr data-id="${s.id}" 
                data-title="${s.title}" 
                data-singer-id="${s.singerId != null ? s.singerId : ''}" 
                data-category-id="${s.categoryId != null ? s.categoryId : ''}">
              <td>${s.id}</td>
              <td>
                <img src="${pageContext.request.contextPath}${s.thumbnail}" 
                     alt="thumb" 
                     style="width:60px;height:60px;object-fit:cover;border-radius:8px;border:2px solid rgba(122, 92, 255, 0.3);"
                     onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'60\' height=\'60\'%3E%3Crect fill=\'%237a5cff\' width=\'60\' height=\'60\'/%3E%3Ctext fill=\'white\' x=\'50%25\' y=\'50%25\' text-anchor=\'middle\' dy=\'.3em\' font-size=\'24\'%3E🎵%3C/text%3E%3C/svg%3E'">
              </td>
              <td class="song-title">${s.title}</td>
              <td class="song-singer">
                <c:forEach var="sg" items="${singers}">
                  <c:if test="${sg.id == s.singerId}">${sg.name}</c:if>
                </c:forEach>
                <c:if test="${s.singerId == null}"><span class="text-muted">-</span></c:if>
              </td>
              <td class="song-category">
                <c:forEach var="c" items="${categories}">
                  <c:if test="${c.id == s.categoryId}">${c.name}</c:if>
                </c:forEach>
                <c:if test="${s.categoryId == null}"><span class="text-muted">-</span></c:if>
              </td>
              <td><span class="text-white">${s.viewCount}</span></td>
              <td>
                <a href="${pageContext.request.contextPath}${s.filePath}" target="_blank" class="btn btn-secondary btn-sm" style="padding: 0.4rem 0.8rem; font-size: 0.85rem;">
                  ▶️ Nghe
                </a>
              </td>
              <td>
                <button class="btn btn-secondary btn-sm" onclick="openEditSongModal(this)" style="padding: 0.5rem 1rem; font-size: 0.85rem;">
                  <i class='bx bx-edit-alt'></i> Sửa
                </button>
                <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/songs/delete" onsubmit="return confirm('Xoá bài hát này?')">
                  <input type="hidden" name="id" value="${s.id}">
                  <button type="submit" class="btn btn-danger btn-sm" style="padding: 0.5rem 1rem; font-size: 0.85rem;">
                    <i class='bx bx-trash'></i> Xoá
                  </button>
                </form>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

<!-- Modal Create/Edit Song -->
<div id="songModal" class="modal-backdrop">
  <div class="modal-dialog" style="max-width: 700px;">
    <div class="modal-header">
      <h5 id="songModalTitle">Thêm bài hát mới</h5>
      <button class="btn-close" onclick="closeSongModal()">×</button>
    </div>
    <form id="songForm" method="post" enctype="multipart/form-data">
      <div class="modal-body">
        <input type="hidden" id="songId" name="id">
        <div class="mb-3">
          <label class="text-white small mb-2 d-block">Tên bài hát *</label>
          <input type="text" id="songTitle" name="title" class="form-control" required 
                 style="background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); color: #fff; padding: 0.75rem;">
        </div>
        <div class="row g-2">
          <div class="col-md-6 mb-3">
            <label class="text-white small mb-2 d-block">Ca sĩ</label>
            <select class="form-select" name="singerId" id="songSingerId" 
                    style="background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); color: #fff; padding: 0.75rem;">
              <option value="">-- Chọn ca sĩ --</option>
              <c:forEach var="sg" items="${singers}">
                <option value="${sg.id}">${sg.name}</option>
              </c:forEach>
            </select>
          </div>
          <div class="col-md-6 mb-3">
            <label class="text-white small mb-2 d-block">Thể loại</label>
            <select class="form-select" name="categoryId" id="songCategoryId"
                    style="background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); color: #fff; padding: 0.75rem;">
              <option value="">-- Chọn thể loại --</option>
              <c:forEach var="c" items="${categories}">
                <option value="${c.id}">${c.name}</option>
              </c:forEach>
            </select>
          </div>
        </div>
        <div class="mb-3">
          <label class="text-white small mb-2 d-block">File nhạc (mp3, wav...)</label>
          <input type="file" name="audio" id="songAudio" accept="audio/*" class="form-control"
                 style="background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); color: #fff; padding: 0.75rem;">
          <small class="text-muted d-block mt-1" id="songAudioHint">Bắt buộc khi thêm mới</small>
        </div>
        <div class="mb-3">
          <label class="text-white small mb-2 d-block">Ảnh bìa</label>
          <input type="file" name="thumb" id="songThumb" accept="image/*" class="form-control"
                 style="background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); color: #fff; padding: 0.75rem;">
          <small class="text-muted d-block mt-1" id="songThumbHint">Bắt buộc khi thêm mới</small>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="closeSongModal()">Hủy</button>
        <button type="submit" class="btn btn-primary">Lưu</button>
      </div>
    </form>
  </div>
</div>

<script>
var ctxPath = '${pageContext.request.contextPath}';

function openCreateSongModal() {
  document.getElementById('songModalTitle').textContent = 'Thêm bài hát mới';
  document.getElementById('songForm').action = ctxPath + '/admin/songs/create';
  document.getElementById('songId').value = '';
  document.getElementById('songTitle').value = '';
  document.getElementById('songSingerId').value = '';
  document.getElementById('songCategoryId').value = '';
  document.getElementById('songAudio').required = true;
  document.getElementById('songThumb').required = true;
  document.getElementById('songAudioHint').textContent = 'Bắt buộc khi thêm mới';
  document.getElementById('songThumbHint').textContent = 'Bắt buộc khi thêm mới';
  document.getElementById('songModal').classList.add('show');
}

function openEditSongModal(btn) {
  var row = btn.closest('tr');
  document.getElementById('songModalTitle').textContent = 'Sửa bài hát';
  document.getElementById('songForm').action = ctxPath + '/admin/songs/update';
  document.getElementById('songId').value = row.dataset.id;
  document.getElementById('songTitle').value = row.dataset.title;
  document.getElementById('songSingerId').value = row.dataset.singerId || '';
  document.getElementById('songCategoryId').value = row.dataset.categoryId || '';
  document.getElementById('songAudio').required = false;
  document.getElementById('songThumb').required = false;
  document.getElementById('songAudio').value = '';
  document.getElementById('songThumb').value = '';
  document.getElementById('songAudioHint').textContent = 'Để trống nếu không muốn thay đổi file nhạc';
  document.getElementById('songThumbHint').textContent = 'Để trống nếu không muốn thay đổi ảnh bìa';
  document.getElementById('songModal').classList.add('show');
}

function closeSongModal() {
  document.getElementById('songModal').classList.remove('show');
}

function filterTable() {
  var searchInput = document.getElementById('searchInput').value.toLowerCase();
  var singerFilter = document.getElementById('singerFilter').value;
  var categoryFilter = document.getElementById('categoryFilter').value;
  var tbody = document.getElementById('songTableBody');
  var rows = tbody.getElementsByTagName('tr');
  
  for (var i = 0; i < rows.length; i++) {
    var row = rows[i];
    var titleEl = row.querySelector('.song-title');
    var title = titleEl ? titleEl.textContent.toLowerCase() : '';
    var singerId = row.dataset.singerId || '';
    var categoryId = row.dataset.categoryId || '';
    
    var matchSearch = !searchInput || title.indexOf(searchInput) > -1;
    var matchSinger = singerFilter === 'all' || singerId === singerFilter;
    var matchCategory = categoryFilter === 'all' || categoryId === categoryFilter;
    
    row.style.display = (matchSearch && matchSinger && matchCategory) ? '' : 'none';
  }
}

var songModalEl = document.getElementById('songModal');
if (songModalEl) {
  var songDialogEl = songModalEl.querySelector('.modal-dialog');
  
  songModalEl.addEventListener('click', function(e) {
    // Chỉ đóng khi click vào backdrop (không phải dialog)
    if (!songDialogEl.contains(e.target)) {
      closeSongModal();
    }
  });
}

// Auto refresh
setInterval(function() {
  // Simulate checking for new songs
}, 5000);
</script>
<jsp:include page="../fragments/footer.jsp" />
