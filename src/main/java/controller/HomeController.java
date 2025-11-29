package controller;

import model.bo.SongBO;
import model.bo.CategoryBO;
import model.bo.SingerBO;
import model.bean.Song;
import model.bean.Category;
import model.bean.Singer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class HomeController extends HttpServlet {
    private final SongBO songBO = new SongBO();
    private final CategoryBO categoryBO = new CategoryBO();
    private final SingerBO singerBO = new SingerBO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String q = req.getParameter("q");
            String categoryIdParam = req.getParameter("category");
            String singerIdParam = req.getParameter("singer");
            String modeParam = req.getParameter("mode");
            
            List<Song> songs;
            
            // Lọc theo category hoặc singer nếu có
            if (categoryIdParam != null && !categoryIdParam.isEmpty()) {
                int categoryId = Integer.parseInt(categoryIdParam);
                songs = songBO.getByCategory(categoryId, 50);
            } else if (singerIdParam != null && !singerIdParam.isEmpty()) {
                int singerId = Integer.parseInt(singerIdParam);
                songs = songBO.getBySinger(singerId, 50);
            } else if (q != null && !q.isEmpty()) {
                songs = songBO.search(q);
            } else {
                songs = songBO.latest(12);
            }
            
            // Load categories, top songs, top singers
            List<Category> categories = categoryBO.all();
            List<Song> topSongs = songBO.getTopByViews(10);
            List<Singer> topSingers = singerBO.getTopSingers(10);
            
            // Load all singers as Map for easy lookup
            List<Singer> allSingers = singerBO.all();
            java.util.Map<Integer, String> singerMap = new java.util.HashMap<>();
            for (Singer singer : allSingers) {
                singerMap.put(singer.getId(), singer.getName());
            }
            
            req.setAttribute("songs", songs);
            req.setAttribute("categories", categories);
            req.setAttribute("topSongs", topSongs);
            req.setAttribute("topSingers", topSingers);
            req.setAttribute("singerMap", singerMap);
            req.setAttribute("currentMode", modeParam != null ? modeParam : "1");
            
            req.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}