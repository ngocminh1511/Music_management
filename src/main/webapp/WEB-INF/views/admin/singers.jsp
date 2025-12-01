<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../fragments/header.jsp" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">

<div class="admin-page">
  <div class="container" style="max-width: 1400px; margin: 0 auto; padding: 2rem;">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="text-white mb-0"><i class='bx bx-microphone'></i> Quản lý Ca sĩ</h2>
      <button class="btn btn-primary" onclick="openCreateSingerModal()">
        <i class='bx bx-plus-circle'></i> Thêm ca sĩ
      </button>
    </div>

    <!-- Live Search & Filter -->
    <div class="live-search-container">
      <div class="live-search-icon"><i class='bx bx-search'></i></div>
      <input type="text" id="searchInput" class="live-search-input" placeholder="Tìm kiếm ca sĩ..." onkeyup="filterTable()">
    </div>

    <!-- Data Table -->
    <div class="data-table">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Ảnh</th>
            <th>Tên ca sĩ</th>
            <th>Mô tả</th>
            <th>Hành động</th>
          </tr>
        </thead>
        <tbody id="singerTableBody">
          <c:forEach var="s" items="${singers}">
            <tr data-id="${s.id}" data-name="${s.name}" data-description="${s.description || ''}">
              <td>${s.id}</td>
              <td>
                <img src="${pageContext.request.contextPath}${s.avatar}" 
                     style="width:60px;height:60px;object-fit:cover;border-radius:50%;border:2px solid rgba(122, 92, 255, 0.3);"
                     onerror="this.src='data:image/svg+xml,%3Csvg xmlns=\'http://www.w3.org/2000/svg\' width=\'60\' height=\'60\'%3E%3Crect fill=\'%237a5cff\' width=\'60\' height=\'60\'/%3E%3Ctext fill=\'white\' x=\'50%25\' y=\'50%25\' text-anchor=\'middle\' dy=\'.3em\' font-size=\'24\'%3E🎤%3C/text%3E%3C/svg%3E'">
              </td>
              <td class="singer-name">${s.name}</td>
              <td><small class="text-muted">${s.description || '-'}</small></td>
              <td>
                <button class="btn btn-secondary btn-sm" onclick="openEditSingerModal(this)" style="padding: 0.5rem 1rem; font-size: 0.85rem;">
                  <i class='bx bx-edit-alt'></i> Sửa
                </button>
                <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/singers/delete" onsubmit="return confirm('Xoá ca sĩ này?')">
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

<!-- Modal Create/Edit Singer -->
<div id="singerModal" class="modal-backdrop">
  <div class="modal-dialog">
    <div class="modal-header">
      <h5 id="singerModalTitle">Thêm ca sĩ mới</h5>
      <button class="btn-close" onclick="closeSingerModal()">×</button>
    </div>
    <form id="singerForm" method="post" enctype="multipart/form-data">
      <div class="modal-body">
        <input type="hidden" id="singerId" name="id">
        <div class="mb-3">
          <label class="text-white small mb-2 d-block">Tên ca sĩ *</label>
          <input type="text" id="singerName" name="name" class="form-control" required 
                 style="background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); color: #fff; padding: 0.75rem;">
        </div>
        <div class="mb-3">
          <label class="text-white small mb-2 d-block">Mô tả</label>
          <textarea id="singerDescription" name="description" class="form-control" rows="3"
                    style="background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); color: #fff; padding: 0.75rem;"></textarea>
        </div>
        <div class="mb-3">
          <label class="text-white small mb-2 d-block">Ảnh đại diện</label>
          <input type="file" id="singerAvatar" name="avatar" accept="image/*" class="form-control"
                 style="background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); color: #fff; padding: 0.75rem;">
          <small class="text-muted d-block mt-1" id="singerAvatarHint">Bắt buộc khi thêm mới</small>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="closeSingerModal()">Hủy</button>
        <button type="submit" class="btn btn-primary">Lưu</button>
      </div>
    </form>
  </div>
</div>

<script>
const ctxPath = '${pageContext.request.contextPath}';

function openCreateSingerModal() {
  document.getElementById('singerModalTitle').textContent = 'Thêm ca sĩ mới';
  document.getElementById('singerForm').action = ctxPath + '/admin/singers/create';
  document.getElementById('singerId').value = '';
  document.getElementById('singerName').value = '';
  document.getElementById('singerDescription').value = '';
  document.getElementById('singerAvatar').required = true;
  document.getElementById('singerAvatar').value = '';
  document.getElementById('singerAvatarHint').textContent = 'Bắt buộc khi thêm mới';
  document.getElementById('singerModal').classList.add('show');
}

function openEditSingerModal(btn) {
  var row = btn.closest('tr');
  document.getElementById('singerModalTitle').textContent = 'Sửa ca sĩ';
  document.getElementById('singerForm').action = ctxPath + '/admin/singers/update';
  document.getElementById('singerId').value = row.dataset.id;
  document.getElementById('singerName').value = row.dataset.name;
  document.getElementById('singerDescription').value = row.dataset.description || '';
  document.getElementById('singerAvatar').required = false;
  document.getElementById('singerAvatar').value = '';
  document.getElementById('singerAvatarHint').textContent = 'Để trống nếu không muốn thay đổi';
  document.getElementById('singerModal').classList.add('show');
}

function closeSingerModal() {
  document.getElementById('singerModal').classList.remove('show');
}

function filterTable() {
  var input = document.getElementById('searchInput');
  var filter = input.value.toLowerCase();
  var tbody = document.getElementById('singerTableBody');
  var rows = tbody.getElementsByTagName('tr');
  
  for (var i = 0; i < rows.length; i++) {
    var nameCell = rows[i].querySelector('.singer-name');
    if (nameCell) {
      var text = nameCell.textContent || nameCell.innerText;
      rows[i].style.display = text.toLowerCase().indexOf(filter) > -1 ? '' : 'none';
    }
  }
}

var singerModalEl = document.getElementById('singerModal');
if (singerModalEl) {
  var singerDialogEl = singerModalEl.querySelector('.modal-dialog');
  
  singerModalEl.addEventListener('click', function(e) {
    // Chỉ đóng khi click vào backdrop (không phải dialog)
    if (!singerDialogEl.contains(e.target)) {
      closeSingerModal();
    }
  });
}

// Auto refresh
setInterval(function() {
  // Simulate checking for new singers
}, 5000);
</script>
<jsp:include page="../fragments/footer.jsp" />
