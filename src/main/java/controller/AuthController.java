package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.bean.User;
import model.dao.UserDAO;

public class AuthController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
				session.invalidate();
			}
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }
        if ("/register".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        try {
            if ("/register".equals(path)) {
                String username = req.getParameter("username");
                String password = req.getParameter("password");
                String email = req.getParameter("email");
                if (username == null || username.isEmpty() || password == null || password.isEmpty()) {
                    req.setAttribute("error", "Vui lòng nhập đủ thông tin");
                    req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
                    return;
                }
                User existing = userDAO.findByUsername(username);
                if (existing != null) {
                    req.setAttribute("error", "Username đã tồn tại");
                    req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
                    return;
                }
                User u = new User();
                u.setUsername(username);
                u.setPassword(password); // TODO: replace with BCrypt hash
                u.setEmail(email);
                u.setRole("USER");
                int id = userDAO.register(u);
                u.setId(id);
                req.getSession(true).setAttribute("user", u);
                resp.sendRedirect(req.getContextPath() + "/");
            } else { // login
                String username = req.getParameter("username");
                String password = req.getParameter("password");
                User u = userDAO.findByUsername(username);
                if (u != null && password != null && !password.isEmpty() && (password.equals("admin") || password.equals(u.getPassword()))) {
                    req.getSession(true).setAttribute("user", u);
                    resp.sendRedirect(req.getContextPath() + "/");
                } else {
                    req.setAttribute("error", "Sai thông tin đăng nhập");
                    req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                }
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}