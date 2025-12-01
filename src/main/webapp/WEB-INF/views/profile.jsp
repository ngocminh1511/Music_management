<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - Music Management</title>
    <link rel="stylesheet" href="${ctx}/assets/css/common.css">
    <link rel="stylesheet" href="${ctx}/assets/css/profile.css">
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
</head>
<body>
    <!-- Include header -->
    <jsp:include page="/WEB-INF/views/fragments/header.jsp"/>

    <div class="profile-container">
        <div class="profile-card">
            <div class="profile-header">
                <h2><i class='bx bx-user-circle'></i> Hồ sơ cá nhân</h2>
            </div>

            <form id="profileForm" enctype="multipart/form-data">
                <div class="profile-avatar-section">
                    <div class="avatar-preview">
                        <c:choose>
                            <c:when test="${not empty profileUser.avatar}">
                                <img id="avatarPreview" src="${ctx}${profileUser.avatar}" alt="${profileUser.username}">
                            </c:when>
                            <c:otherwise>
                                <img id="avatarPreview" src="${ctx}/assets/avatars/default.png" alt="${profileUser.username}">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="avatar-upload">
                        <label for="avatarInput" class="btn-upload-avatar">
                            <i class='bx bx-camera'></i> Thay đổi ảnh đại diện
                        </label>
                        <input type="file" id="avatarInput" name="avatar" accept="image/*" style="display: none;">
                        <p class="upload-hint">JPG, PNG hoặc GIF (tối đa 10MB)</p>
                    </div>
                </div>

                <div class="profile-form-section">
                    <div class="form-group">
                        <label for="username">
                            <i class='bx bx-user'></i> Tên người dùng
                        </label>
                        <input type="text" id="username" name="username" 
                               value="${profileUser.username}" required>
                    </div>

                    <div class="form-group">
                        <label for="email">
                            <i class='bx bx-envelope'></i> Email
                        </label>
                        <input type="email" id="email" name="email" 
                               value="${profileUser.email}" required>
                    </div>

                    <div class="form-group">
                        <label for="role">
                            <i class='bx bx-shield'></i> Vai trò
                        </label>
                        <input type="text" id="role" name="role" 
                               value="${profileUser.role}" disabled>
                    </div>

                    <div class="form-group">
                        <label for="createdAt">
                            <i class='bx bx-calendar'></i> Ngày tham gia
                        </label>
                        <input type="text" id="createdAt" name="createdAt" 
                               value="<fmt:formatDate value='${profileUser.createdAt}' pattern='dd/MM/yyyy HH:mm'/>" 
                               disabled>
                    </div>

                    <div class="form-group">
                        <label for="bio">
                            <i class='bx bx-message-square-detail'></i> Giới thiệu
                        </label>
                        <textarea id="bio" name="bio" rows="4" 
                                  placeholder="Viết vài dòng về bạn...">${profileUser.bio}</textarea>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-save">
                            <i class='bx bx-save'></i> Lưu thay đổi
                        </button>
                        <a href="${ctx}/home" class="btn-cancel">
                            <i class='bx bx-x'></i> Hủy
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Include footer -->
    <jsp:include page="/WEB-INF/views/fragments/footer.jsp"/>

    <script>
        // Avatar preview
        document.getElementById('avatarInput').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('avatarPreview').src = e.target.result;
                };
                reader.readAsDataURL(file);
            }
        });

        // Form submit
        document.getElementById('profileForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            const submitBtn = this.querySelector('.btn-save');
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="bx bx-loader-alt bx-spin"></i> Đang lưu...';
            
            try {
                const response = await fetch('${ctx}/profile', {
                    method: 'POST',
                    body: formData
                });
                
                const result = await response.json();
                
                if (result.success) {
                    alert(result.message);
                    window.location.reload();
                } else {
                    alert(result.message);
                }
            } catch (error) {
                alert('Lỗi: ' + error.message);
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerHTML = '<i class="bx bx-save"></i> Lưu thay đổi';
            }
        });
    </script>
</body>
</html>
