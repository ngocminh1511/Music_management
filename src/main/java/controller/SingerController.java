package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.bean.Singer;
import model.bean.Song;
import model.bo.SingerBO;
import model.bo.SongBO;

@WebServlet("/singer/view")
public class SingerController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String singerIdParam = request.getParameter("id");
        
        if (singerIdParam == null || singerIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Singer ID is required");
            return;
        }
        
        try {
            int singerId = Integer.parseInt(singerIdParam);
            
            SingerBO singerBO = new SingerBO();
            Singer singer = singerBO.get(singerId);
            
            if (singer == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Singer not found");
                return;
            }
            
            // Get all songs by this singer (limit 100)
            SongBO songBO = new SongBO();
            List<Song> songs = songBO.getBySinger(singerId, 100);
            
            request.setAttribute("singer", singer);
            request.setAttribute("songs", songs);
            
            request.getRequestDispatcher("/WEB-INF/views/components/singer-view.jsp")
                   .forward(request, response);
                   
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid singer ID format");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Database error: " + e.getMessage());
        }
    }
}
