<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="lyrics-panel">
    <h3 style="color: var(--accent-purple); margin-bottom: 1rem; font-size: 1rem;">
        <i class='bx bx-book-content'></i> Lời bài hát
    </h3>
    <div class="lyrics-content" id="lyricsContent">
        <div class="no-lyrics">
            <i class='bx bx-info-circle'></i>
            <p>Chưa có lời bài hát</p>
        </div>
    </div>
</div>

<style>
.lyrics-panel {
    background: linear-gradient(135deg, rgba(26, 26, 27, 0.95) 0%, rgba(10, 10, 11, 0.95) 100%);
    border-radius: 12px;
    padding: 1.5rem;
    max-height: 500px;
    overflow-y: auto;
    border: 1px solid rgba(122, 92, 255, 0.2);
}

.lyrics-panel::-webkit-scrollbar {
    width: 6px;
}

.lyrics-panel::-webkit-scrollbar-track {
    background: rgba(122, 92, 255, 0.1);
    border-radius: 10px;
}

.lyrics-panel::-webkit-scrollbar-thumb {
    background: var(--accent-purple);
    border-radius: 10px;
}

.lyrics-content {
    min-height: 200px;
}

.lyrics-content .lyric-line {
    padding: 0.5rem 0;
    transition: all 0.3s;
    color: var(--text-secondary);
    font-size: 0.95rem;
    line-height: 1.8;
}

.lyrics-content .lyric-line.active {
    color: var(--accent-purple);
    font-weight: 600;
    font-size: 1.1rem;
    transform: translateX(10px);
    text-shadow: 0 0 10px rgba(122, 92, 255, 0.5);
}

.no-lyrics {
    text-align: center;
    padding: 3rem 1rem;
    color: var(--text-secondary);
}

.no-lyrics i {
    font-size: 3rem;
    display: block;
    margin-bottom: 1rem;
    opacity: 0.5;
}
</style>
