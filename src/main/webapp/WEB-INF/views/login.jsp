<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="fragments/header.jsp">
    <jsp:param name="pageTitle" value="Đăng nhập - GenZ Beats" />
</jsp:include>

<style>
.auth-container {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    padding: 2rem;
}
.auth-card {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 20px;
    padding: 3rem;
    max-width: 450px;
    width: 100%;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
}
.auth-logo {
    text-align: center;
    margin-bottom: 2rem;
}
.auth-logo h1 {
    font-size: 2.5rem;
    font-weight: 700;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 0.5rem;
}
.auth-logo p {
    color: #666;
    font-size: 0.95rem;
}
.form-group {
    margin-bottom: 1.5rem;
}
.form-group label {
    display: block;
    margin-bottom: 0.5rem;
    color: #333;
    font-weight: 600;
    font-size: 0.9rem;
}
.form-control {
    width: 100%;
    padding: 0.9rem 1.2rem;
    border: 2px solid #e0e0e0;
    border-radius: 10px;
    font-size: 1rem;
    transition: all 0.3s;
    background: white;
}
.form-control:focus {
    outline: none;
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}
.btn-auth {
    width: 100%;
    padding: 1rem;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
    border-radius: 10px;
    font-size: 1.1rem;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.3s;
    margin-top: 1rem;
}
.btn-auth:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
}
.auth-footer {
    text-align: center;
    margin-top: 1.5rem;
    color: #666;
    font-size: 0.95rem;
}
.auth-footer a {
    color: #667eea;
    text-decoration: none;
    font-weight: 600;
}
.auth-footer a:hover {
    text-decoration: underline;
}
.error-message {
    background: #fee;
    color: #c33;
    padding: 0.8rem;
    border-radius: 8px;
    margin-bottom: 1rem;
    font-size: 0.9rem;
}
.social-login {
    display: flex;
    gap: 1rem;
    margin-top: 1.5rem;
}
.social-btn {
    flex: 1;
    padding: 0.8rem;
    border: 2px solid #e0e0e0;
    border-radius: 10px;
    background: white;
    cursor: pointer;
    transition: all 0.3s;
    font-size: 0.9rem;
    color: #333;
}
.social-btn:hover {
    border-color: #667eea;
    background: #f8f9ff;
}
</style>

<div class="auth-container">
    <div class="auth-card">
        <div class="auth-logo">
            <h1><i class='bx bxs-music'></i> GenZ Beats</h1>
            <p>Chào mừng bạn trở lại!</p>
        </div>
        
        <c:if test="${not empty error}">
            <div class="error-message">${error}</div>
        </c:if>
        
        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="form-group">
                <label for="username"><i class='bx bx-user'></i> Tên đăng nhập</label>
                <input type="text" id="username" name="username" class="form-control" placeholder="Nhập username" required autofocus>
            </div>
            
            <div class="form-group">
                <label for="password"><i class='bx bx-lock-alt'></i> Mật khẩu</label>
                <input type="password" id="password" name="password" class="form-control" placeholder="Nhập mật khẩu" required>
            </div>
            
            <button type="submit" class="btn-auth">Đăng nhập</button>
        </form>
        
        <div class="auth-footer">
            Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />