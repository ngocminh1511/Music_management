<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../fragments/header.jsp" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">

<div class="admin-page">
  <div class="container" style="max-width: 1400px; margin: 0 auto; padding: 2rem;">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="text-white mb-0"><i class='bx bx-group'></i> Quản lý Người dùng</h2>
    </div>

    <!-- Live Search & Filter -->
    <div class="filter-bar">
      <div class="live-search-container" style="flex: 1;">
        <div class="live-search-icon"><i class='bx bx-search'></i></div>
        <input type="text" id="searchInput" class="live-search-input" placeholder="Tìm kiếm username, email..." onkeyup="filterTable()">
      </div>
      <div class="filter-group">
        <label>Lọc theo Role</label>
        <select id="roleFilter" onchange="filterTable()" style="padding: 0.5rem 0.75rem; background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); border-radius: 8px; color: #fff;">
          <option value="all">Tất cả</option>
          <option value="USER">USER</option>
          <option value="ADMIN">ADMIN</option>
        </select>
      </div>
      <div class="filter-group">
        <label>Trạng thái</label>
        <select id="statusFilter" onchange="filterTable()" style="padding: 0.5rem 0.75rem; background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); border-radius: 8px; color: #fff;">
          <option value="all">Tất cả</option>
          <option value="online">Online</option>
          <option value="offline">Offline</option>
        </select>
      </div>
    </div>

    <!-- Data Table -->
    <div class="data-table">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Email</th>
            <th>Role</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
          </tr>
        </thead>
        <tbody id="userTableBody">
          <c:forEach var="u" items="${users}">
            <tr data-username="${u.username}" data-email="${u.email || ''}" data-role="${u.role}">
              <td>${u.id}</td>
              <td>${u.username}</td>
              <td>${u.email || '-'}</td>
              <td>
                <form class="d-inline-flex align-items-center gap-2" method="post" action="${pageContext.request.contextPath}/admin/users/role" onsubmit="return updateRole(this)">
                  <input type="hidden" name="id" value="${u.id}">
                  <select name="role" class="form-select form-select-sm" 
                          style="background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); color: #fff; padding: 0.5rem;">
                    <option value="USER" ${u.role=='USER'?'selected':''}>USER</option>
                    <option value="ADMIN" ${u.role=='ADMIN'?'selected':''}>ADMIN</option>
                  </select>
                  <button type="submit" class="btn btn-primary btn-sm" style="padding: 0.5rem 1rem; font-size: 0.85rem;">Cập nhật</button>
                </form>
              </td>
              <td>
                <span class="status-badge ${Math.random() > 0.5 ? 'online' : 'offline'}" data-user-id="${u.id}">
                  ${Math.random() > 0.5 ? '🟢 Online' : '⚫ Offline'}
                </span>
              </td>
              <td>
                <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/users/delete" onsubmit="return confirm('Xoá tài khoản này?')">
                  <input type="hidden" name="id" value="${u.id}">
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

<script>
function filterTable() {
  const searchInput = document.getElementById('searchInput').value.toLowerCase();
  const roleFilter = document.getElementById('roleFilter').value;
  const statusFilter = document.getElementById('statusFilter').value;
  const tbody = document.getElementById('userTableBody');
  const rows = tbody.getElementsByTagName('tr');
  
  for (let i = 0; i < rows.length; i++) {
    const row = rows[i];
    const username = row.dataset.username.toLowerCase();
    const email = (row.dataset.email || '').toLowerCase();
    const role = row.dataset.role;
    const statusBadge = row.querySelector('.status-badge');
    const isOnline = statusBadge?.classList.contains('online');
    
    const matchSearch = !searchInput || username.includes(searchInput) || email.includes(searchInput);
    const matchRole = roleFilter === 'all' || role === roleFilter;
    const matchStatus = statusFilter === 'all' || 
                       (statusFilter === 'online' && isOnline) || 
                       (statusFilter === 'offline' && !isOnline);
    
    row.style.display = (matchSearch && matchRole && matchStatus) ? '' : 'none';
  }
}

function updateRole(form) {
  const formData = new FormData(form);
  fetch(form.action, {
    method: 'POST',
    body: formData
  })
  .then(() => {
    if (typeof AdminDashboard !== 'undefined') {
      AdminDashboard.showToast('Cập nhật role thành công!', 'success');
    }
    // Reload after a moment
    setTimeout(() => location.reload(), 500);
  })
  .catch(err => {
    console.error('Error updating role:', err);
    if (typeof AdminDashboard !== 'undefined') {
      AdminDashboard.showToast('Có lỗi xảy ra!', 'error');
    }
  });
  return false;
}

// Simulate status changes
setInterval(function() {
  var badges = document.querySelectorAll('.status-badge');
  badges.forEach(function(badge) {
    if (Math.random() > 0.9) { // 10% chance to change
      var isOnline = badge.classList.contains('online');
      badge.classList.toggle('online', !isOnline);
      badge.classList.toggle('offline', isOnline);
      badge.textContent = !isOnline ? '🟢 Online' : '⚫ Offline';
      badge.closest('tr').classList.add('new-row');
      setTimeout(function() { badge.closest('tr').classList.remove('new-row'); }, 500);
    }
  });
}, 5000);

// Auto refresh table
setInterval(function() {
  // Check for new users (simulated)
}, 5000);
</script>
<jsp:include page="../fragments/footer.jsp" />
