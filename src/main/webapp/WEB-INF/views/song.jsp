<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="fragments/header.jsp" />
<div class="container">
  <c:if test="${not empty song}">
    <div class="row g-4">
      <div class="col-md-4">
        <img src="${pageContext.request.contextPath}${song.thumbnail}" class="img-fluid rounded" alt="thumb" onerror="this.src='data:image/svg+xml;utf8,<svg xmlns=\'http://www.w3.org/2000/svg\' width=\'600\' height=\'600\'><rect width=\'100%\' height=\'100%\' fill=\'%231a1a1b\'/><text x=\'50%\' y=\'50%\' fill=\'%23aaa\' font-size=\'24\' text-anchor=\'middle\'>No Image</text></svg>'">
      </div>
      <div class="col-md-8">
        <h2>${song.title}</h2>
        <audio controls class="w-100 mt-3">
          <source src="${pageContext.request.contextPath}${song.filePath}" type="audio/mpeg">
          Trình duyệt không hỗ trợ audio.
        </audio>
        <p class="mt-2 text-muted">Lượt nghe: ${song.viewCount}</p>
        <c:if test="${not empty userPlaylists}">
          <form class="row g-2 mt-3" method="post" action="${pageContext.request.contextPath}/playlist/addSong">
            <input type="hidden" name="songId" value="${song.id}">
            <div class="col-md-6">
              <select class="form-select" name="playlistId" required>
                <c:forEach var="p" items="${userPlaylists}">
                  <option value="${p.id}">${p.name}</option>
                </c:forEach>
              </select>
            </div>
            <div class="col-md-3">
              <button class="btn btn-primary w-100">Thêm vào playlist</button>
            </div>
          </form>
        </c:if>
      </div>
    </div>
  </c:if>
  <c:if test="${empty song}">
    <p class="text-danger">Không tìm thấy bài hát.</p>
  </c:if>
</div>
<jsp:include page="fragments/footer.jsp" />