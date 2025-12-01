package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.bean.Category;
import model.bean.Singer;
import model.bean.Song;
import model.bean.User;
import model.bo.CategoryBO;
import model.bo.PlaylistBO;
import model.bo.SingerBO;
import model.bo.SongBO;

public class SongController extends HttpServlet {
    private final SongBO songBO = new SongBO();
    private final PlaylistBO playlistBO = new PlaylistBO();
    private final CategoryBO categoryBO = new CategoryBO();
    private final SingerBO singerBO = new SingerBO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();

        try {
            // Route: /song/api/get?id=X - Get song JSON for player
            if ("/api/get".equals(path)) {
                handleApiGet(req, resp);
            }
            // Route: /song/view?id=X - View single song (AJAX)
            else if ("/view".equals(path)) {
                handleSongView(req, resp);
            }
            // Route: /song/category?id=X - Play category
            else if ("/category".equals(path)) {
                handleCategory(req, resp);
            }
            // Route: /song/singer?id=X - Play singer's songs
            else if ("/singer".equals(path)) {
                handleSinger(req, resp);
            }
            // Route: /song?id=X - Play single song (full page)
            else {
                handleSingleSong(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // API endpoint for player
    private void handleApiGet(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int id = Integer.parseInt(idStr);
        Song song = songBO.get(id);

        if (song != null) {
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");

            // Get singer name
            String singerName = "";
            if (song.getSingerId() != null) {
                Singer singer = singerBO.get(song.getSingerId());
                if (singer != null) {
					singerName = singer.getName();
				}
            }

            // Build JSON manually
            StringBuilder json = new StringBuilder("{");
            json.append("\"id\":").append(song.getId()).append(",");
            json.append("\"title\":\"").append(escapeJson(song.getTitle())).append("\",");
            json.append("\"artist\":\"").append(escapeJson(singerName)).append("\",");
            json.append("\"thumbnail\":\"").append(req.getContextPath()).append(escapeJson(song.getThumbnail())).append("\",");
            json.append("\"filePath\":\"").append(req.getContextPath()).append(escapeJson(song.getFilePath())).append("\",");
            json.append("\"lyrics\":\"").append(escapeJson(song.getLyrics() != null ? song.getLyrics() : "")).append("\"");
            json.append("}");

            resp.getWriter().write(json.toString());
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private String escapeJson(String str) {
        if (str == null) {
			return "";
		}
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }

    // AJAX view for mode switcher - detailed song view with suggestions
    private void handleSongView(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int id = Integer.parseInt(idStr);
        Song song = songBO.get(id);

        if (song != null) {
            songBO.increaseView(id);
            req.setAttribute("song", song);

            // Load singer info
            if (song.getSingerId() != null) {
                Singer singer = singerBO.get(song.getSingerId());
                req.setAttribute("singer", singer);
            }

            // Load category info
            if (song.getCategoryId() != null) {
                Category category = categoryBO.get(song.getCategoryId());
                req.setAttribute("category", category);
            }

            // Get suggestions from same category (max 8 songs, exclude current)
            if (song.getCategoryId() != null) {
                List<Song> allCategorySongs = songBO.getByCategory(song.getCategoryId(), 100);
                List<Song> suggestions = new java.util.ArrayList<>();
                for (Song s : allCategorySongs) {
                    if (s.getId() != id && suggestions.size() < 8) {
                        suggestions.add(s);
                    }
                }
                req.setAttribute("suggestions", suggestions);
            }

            User u = (User) req.getSession().getAttribute("user");
            if (u != null) {
                req.setAttribute("userPlaylists", playlistBO.byUser(u.getId()));
            }

            // Return detailed song view with suggestions
            req.getRequestDispatcher("/WEB-INF/views/components/song-detail-view.jsp").forward(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleSingleSong(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("id");
        int id = Integer.parseInt(idStr);
        Song s = songBO.get(id);
        if (s != null) {
            songBO.increaseView(id);
            req.setAttribute("song", s);
            User u = (User) req.getSession().getAttribute("user");
            if (u != null) {
                req.setAttribute("userPlaylists", playlistBO.byUser(u.getId()));
            }
            req.getRequestDispatcher("/WEB-INF/views/song.jsp").forward(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleCategory(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int categoryId = Integer.parseInt(req.getParameter("id"));
        Category category = categoryBO.get(categoryId);
        List<Song> songs = songBO.getByCategory(categoryId, 100);

        if (category == null || songs.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Load singer map for display
        List<Singer> allSingers = singerBO.all();
        java.util.Map<Integer, String> singerMap = new java.util.HashMap<>();
        for (Singer singer : allSingers) {
            singerMap.put(singer.getId(), singer.getName());
        }

        // First song to play
        Song currentSong = songs.get(0);
        songBO.increaseView(currentSong.getId());

        req.setAttribute("currentSong", currentSong);
        req.setAttribute("playlist", songs);
        req.setAttribute("playlistTitle", category.getName());
        req.setAttribute("playlistType", "category");
        req.setAttribute("singerMap", singerMap);

        User u = (User) req.getSession().getAttribute("user");
        if (u != null) {
            req.setAttribute("userPlaylists", playlistBO.byUser(u.getId()));
        }

        req.getRequestDispatcher("/WEB-INF/views/player.jsp").forward(req, resp);
    }

    private void handleSinger(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        int singerId = Integer.parseInt(req.getParameter("id"));
        Singer singer = singerBO.get(singerId);
        List<Song> songs = songBO.getBySinger(singerId, 100);

        if (singer == null || songs.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Load singer map
        List<Singer> allSingers = singerBO.all();
        java.util.Map<Integer, String> singerMap = new java.util.HashMap<>();
        for (Singer s : allSingers) {
            singerMap.put(s.getId(), s.getName());
        }

        // First song to play
        Song currentSong = songs.get(0);
        songBO.increaseView(currentSong.getId());

        req.setAttribute("currentSong", currentSong);
        req.setAttribute("playlist", songs);
        req.setAttribute("playlistTitle", singer.getName());
        req.setAttribute("playlistType", "singer");
        req.setAttribute("singerMap", singerMap);

        User u = (User) req.getSession().getAttribute("user");
        if (u != null) {
            req.setAttribute("userPlaylists", playlistBO.byUser(u.getId()));
        }

        req.getRequestDispatcher("/WEB-INF/views/player.jsp").forward(req, resp);
    }
}