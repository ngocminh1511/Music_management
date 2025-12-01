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
import model.bo.CategoryBO;
import model.bo.SingerBO;
import model.bo.SongBO;

public class CategoryController extends HttpServlet {
    private final CategoryBO categoryBO = new CategoryBO();
    private final SongBO songBO = new SongBO();
    private final SingerBO singerBO = new SingerBO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();

        try {
            // Route: /category/view?id=X - View category (AJAX)
            if ("/view".equals(path)) {
                handleCategoryView(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void handleCategoryView(HttpServletRequest req, HttpServletResponse resp) throws Exception {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int categoryId = Integer.parseInt(idStr);
        Category category = categoryBO.get(categoryId);
        List<Song> songs = songBO.getByCategory(categoryId, 100);

        if (category == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Load singer map for display
        List<Singer> allSingers = singerBO.all();
        java.util.Map<Integer, String> singerMap = new java.util.HashMap<>();
        for (Singer singer : allSingers) {
            singerMap.put(singer.getId(), singer.getName());
        }

        req.setAttribute("category", category);
        req.setAttribute("songs", songs);
        req.setAttribute("singerMap", singerMap);

        // Return JSP fragment for AJAX
        req.getRequestDispatcher("/WEB-INF/views/components/category-view.jsp").forward(req, resp);
    }
}
