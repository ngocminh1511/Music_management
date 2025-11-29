package controller;

import model.bo.PlaylistBO;
import model.bo.SingerBO;
import model.bo.SongBO;
import model.bean.Playlist;
import model.bean.Singer;
import model.bean.Song;
import model.bean.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PlaylistController extends HttpServlet {
    private final PlaylistBO playlistBO = new PlaylistBO();
    private final SongBO songBO = new SongBO();
    private final SingerBO singerBO = new SingerBO();

    private User requireUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User u = (User) req.getSession().getAttribute("user");
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
        return u;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        User user = requireUser(req, resp);
        if (user == null) return;
        try {
            // API endpoint for AJAX
            if ("/api/list".equals(path)) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                List<Playlist> lists = playlistBO.byUser(user.getId());
                
                StringBuilder json = new StringBuilder("[");
                for (int i = 0; i < lists.size(); i++) {
                    Playlist p = lists.get(i);
                    if (i > 0) json.append(",");
                    json.append("{\"id\":").append(p.getId())
                        .append(",\"name\":\"").append(p.getName().replace("\"", "\\\"")).append("\"}");
                }
                json.append("]");
                
                resp.getWriter().write(json.toString());
                return;
            }
            
            if (path == null || "/".equals(path)) {
                List<Playlist> lists = playlistBO.byUser(user.getId());
                req.setAttribute("playlists", lists);
                req.getRequestDispatcher("/WEB-INF/views/playlist/index.jsp").forward(req, resp);
            } else if ("/view".equals(path)) {
                int id = Integer.parseInt(req.getParameter("id"));
                List<Song> songs = playlistBO.songs(id, user.getId());
                
                // Get playlist name - simplified approach
                List<Playlist> userPlaylists = playlistBO.byUser(user.getId());
                Playlist currentPlaylist = null;
                for (Playlist p : userPlaylists) {
                    if (p.getId() == id) {
                        currentPlaylist = p;
                        break;
                    }
                }
                
                // Build singer map
                List<Singer> allSingers = singerBO.all();
                Map<Integer, String> singerMap = new HashMap<>();
                for (Singer singer : allSingers) {
                    singerMap.put(singer.getId(), singer.getName());
                }
                
                // Search functionality
                String q = req.getParameter("q");
                List<Song> searchResults = null;
                if (q != null && !q.isEmpty()) {
                    searchResults = songBO.search(q);
                }
                
                req.setAttribute("playlist", currentPlaylist);
                req.setAttribute("songs", songs);
                req.setAttribute("singerMap", singerMap);
                req.setAttribute("playlistId", id);
                req.setAttribute("searchQuery", q);
                req.setAttribute("searchResults", searchResults);
                req.getRequestDispatcher("/WEB-INF/views/playlist_detail.jsp").forward(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        User user = requireUser(req, resp);
        if (user == null) return;
        try {
            // Rename playlist API
            if ("/rename".equals(path)) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                
                int id = Integer.parseInt(req.getParameter("id"));
                String name = req.getParameter("name");
                
                if (name == null || name.trim().isEmpty()) {
                    resp.getWriter().write("{\"success\":false,\"message\":\"Tên không được để trống\"}");
                    return;
                }
                
                boolean success = playlistBO.rename(id, name.trim(), user.getId());
                if (success) {
                    resp.getWriter().write("{\"success\":true}");
                } else {
                    resp.getWriter().write("{\"success\":false,\"message\":\"Không có quyền hoặc playlist không tồn tại\"}");
                }
                return;
            }
            
            switch (path) {
                case "/create": {
                    String name = req.getParameter("name");
                    playlistBO.create(user.getId(), name);
                    resp.sendRedirect(req.getContextPath() + "/");
                    break;
                }
                case "/delete": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    playlistBO.delete(id, user.getId());
                    resp.sendRedirect(req.getContextPath() + "/");
                    break;
                }
                case "/addSong": {
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    
                    int playlistId = Integer.parseInt(req.getParameter("playlistId"));
                    int songId = Integer.parseInt(req.getParameter("songId"));
                    playlistBO.addSong(playlistId, songId, user.getId());
                    resp.getWriter().write("{\"success\":true}");
                    break;
                }
                case "/removeSong": {
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    
                    int playlistId = Integer.parseInt(req.getParameter("playlistId"));
                    int songId = Integer.parseInt(req.getParameter("songId"));
                    playlistBO.removeSong(playlistId, songId, user.getId());
                    resp.getWriter().write("{\"success\":true}");
                    break;
                }
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}