<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../fragments/header.jsp" />
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">

<div class="admin-page">
  <div class="container" style="max-width: 1400px; margin: 0 auto; padding: 2rem;">
    <div class="d-flex justify-content-between align-items-center mb-4">
      <h2 class="text-white mb-0">📁 Quản lý Danh mục</h2>
      <button class="btn btn-primary" onclick="openCreateCategoryModal()">
        ➕ Thêm danh mục
      </button>
    </div>

    <!-- Live Search & Filter -->
    <div class="live-search-container">
      <div class="live-search-icon">🔍</div>
      <input type="text" id="searchInput" class="live-search-input" placeholder="Tìm kiếm danh mục..." onkeyup="filterTable()">
    </div>

    <!-- Data Table -->
    <div class="data-table">
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Tên danh mục</th>
            <th>Thumbnail</th>
            <th>Hành động</th>
          </tr>
        </thead>
        <tbody id="categoryTableBody">
          <c:forEach var="c" items="${categories}">
            <tr data-id="${c.id}" data-name="${c.name}">
              <td>${c.id}</td>
              <td class="category-name">${c.name}</td>
              <td>
                <c:if test="${not empty c.thumbnail}">
                  <img src="${pageContext.request.contextPath}${c.thumbnail}" alt="thumb" style="width:50px;height:50px;object-fit:cover;border-radius:8px;">
                </c:if>
                <c:if test="${empty c.thumbnail}">
                  <span class="text-muted">-</span>
                </c:if>
              </td>
              <td>
                <button class="btn btn-secondary btn-sm" onclick="openEditCategoryModal(this)" style="padding: 0.5rem 1rem; font-size: 0.85rem;">
                  ✏️ Sửa
                </button>
                <form class="d-inline" method="post" action="${pageContext.request.contextPath}/admin/categories/delete" onsubmit="return confirm('Xoá danh mục này?')">
                  <input type="hidden" name="id" value="${c.id}">
                  <button type="submit" class="btn btn-danger btn-sm" style="padding: 0.5rem 1rem; font-size: 0.85rem;">
                    🗑️ Xoá
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

<!-- Modal Create/Edit Category -->
<div id="categoryModal" class="modal-backdrop">
  <div class="modal-dialog">
    <div class="modal-header">
      <h5 id="categoryModalTitle">Thêm danh mục mới</h5>
      <button class="btn-close" onclick="closeCategoryModal()">×</button>
    </div>
    <form id="categoryForm" method="post" enctype="multipart/form-data">
      <div class="modal-body">
        <input type="hidden" id="categoryId" name="id">
        <div class="mb-3">
          <label class="text-white small mb-2 d-block">Tên danh mục *</label>
          <input type="text" id="categoryName" name="name" class="form-control" required 
                 style="background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); color: #fff; padding: 0.75rem;">
        </div>
        <div class="mb-3">
          <label class="text-white small mb-2 d-block">Thumbnail (tùy chọn)</label>
          <input type="file" id="categoryThumbnail" name="thumbnail" accept="image/*" class="form-control"
                 style="background: rgba(10, 10, 11, 0.8); border: 1px solid rgba(122, 92, 255, 0.2); color: #fff; padding: 0.75rem;">
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="closeCategoryModal()">Hủy</button>
        <button type="submit" class="btn btn-primary">Lưu</button>
      </div>
    </form>
  </div>
</div>

<script>
var ctxPath = '${pageContext.request.contextPath}';
var refreshInterval = null;

function openCreateCategoryModal() {
  document.getElementById('categoryModalTitle').textContent = 'Thêm danh mục mới';
  document.getElementById('categoryForm').action = ctxPath + '/admin/categories/create';
  document.getElementById('categoryId').value = '';
  document.getElementById('categoryName').value = '';
  document.getElementById('categoryThumbnail').value = '';
  document.getElementById('categoryModal').classList.add('show');
}

function openEditCategoryModal(btn) {
  var row = btn.closest('tr');
  var id = row.dataset.id;
  var name = row.dataset.name;
  
  document.getElementById('categoryModalTitle').textContent = 'Sửa danh mục';
  document.getElementById('categoryForm').action = ctxPath + '/admin/categories/update';
  document.getElementById('categoryId').value = id;
  document.getElementById('categoryName').value = name;
  document.getElementById('categoryThumbnail').value = '';
  document.getElementById('categoryModal').classList.add('show');
}

function closeCategoryModal() {
  document.getElementById('categoryModal').classList.remove('show');
}

function filterTable() {
  var input = document.getElementById('searchInput');
  var filter = input.value.toLowerCase();
  var tbody = document.getElementById('categoryTableBody');
  var rows = tbody.getElementsByTagName('tr');
  
  for (var i = 0; i < rows.length; i++) {
    var nameCell = rows[i].querySelector('.category-name');
    if (nameCell) {
      var text = nameCell.textContent || nameCell.innerText;
      rows[i].style.display = text.toLowerCase().indexOf(filter) > -1 ? '' : 'none';
    }
  }
}

// Auto refresh every 5 seconds
function startAutoRefresh() {
  refreshInterval = setInterval(function() {
    fetch(ctxPath + '/admin/categories')
      .then(function(res) { return res.text(); })
      .then(function(html) {
        var parser = new DOMParser();
        var doc = parser.parseFromString(html, 'text/html');
        var newBody = doc.getElementById('categoryTableBody');
        if (newBody) {
          var currentBody = document.getElementById('categoryTableBody');
          var newRows = Array.from(newBody.querySelectorAll('tr'));
          var currentRows = Array.from(currentBody.querySelectorAll('tr'));
          
          // Check for new rows
          newRows.forEach(function(newRow) {
            var newId = newRow.dataset.id;
            var existing = currentRows.find(function(r) { return r.dataset.id === newId; });
            if (!existing) {
              newRow.classList.add('new-row');
              currentBody.appendChild(newRow);
            }
          });
        }
      })
      .catch(function(err) { console.error('Auto refresh error:', err); });
  }, 5000);
}

// Close modal when clicking outside
var categoryModalEl = document.getElementById('categoryModal');
if (categoryModalEl) {
  var categoryDialogEl = categoryModalEl.querySelector('.modal-dialog');
  
  categoryModalEl.addEventListener('click', function(e) {
    // Chỉ đóng khi click vào backdrop (không phải dialog)
    if (!categoryDialogEl.contains(e.target)) {
      closeCategoryModal();
    }
  });
}

// Start auto refresh
startAutoRefresh();
</script>
<jsp:include page="../fragments/footer.jsp" />
