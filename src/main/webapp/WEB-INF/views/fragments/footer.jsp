<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
    </main>
    <!-- Footer -->
    <footer class="footer">
        <div class="footer-content">
            <div class="footer-brand">
                <div class="footer-logo">
                    <div class="logo-icon">
                        <div class="logo-prism">
                            <div class="prism-shape"></div>
                        </div>
                    </div>
                    <span class="logo-text">
                        <span class="prism">GENZ</span>
                        <span class="flux">BEATS</span>
                    </span>
                </div>
                <p class="footer-description">
                    Nền tảng âm nhạc GenZ Beats — nơi bạn khám phá, nghe và chia sẻ âm nhạc yêu thích mỗi ngày.
                </p>
                <div class="footer-social">
                    <a href="#" class="social-icon">f</a>
                    <a href="#" class="social-icon">t</a>
                    <a href="#" class="social-icon">in</a>
                    <a href="#" class="social-icon">ig</a>
                </div>
            </div>
            
            <div class="footer-section">
                <h4>Khám phá</h4>
                <div class="footer-links">
                    <a href="${ctx}/home">Bài hát mới</a>
                    <a href="${ctx}/home?q=trending">Trending</a>
                    <a href="${ctx}/playlist/">Playlist</a>
                    <a href="${ctx}/#singers">Ca sĩ</a>
                </div>
            </div>
            
            <div class="footer-section">
                <h4>Tài khoản</h4>
                <div class="footer-links">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="javascript:viewDiscover()">Trang chủ</a>
                            <a href="javascript:void(0)" onclick="if(window.playlistManager) playlistManager.loadPlaylists()">Playlist của tôi</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${ctx}/login">Đăng nhập</a>
                            <a href="${ctx}/register">Đăng ký</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div class="footer-section">
                <h4>Hỗ trợ</h4>
                <div class="footer-links">
                    <a href="#">Trợ giúp</a>
                    <a href="#">Điều khoản</a>
                    <a href="#">Quyền riêng tư</a>
                    <a href="#">Liên hệ</a>
                </div>
            </div>
        </div>
        
        <div class="footer-bottom">
            <div class="copyright">
                © 2025 GenZ Beats. All rights reserved.
            </div>
            <div class="footer-credits">
                Designed by <a href="https://templatemo.com" rel="nofollow" target="_blank">TemplateMo</a>
            </div>
        </div>
    </footer>
</body>
</html>