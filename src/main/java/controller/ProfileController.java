package controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import model.bean.User;
import model.bo.UserBO;
import model.util.FileUploadUtil;

@WebServlet("/profile")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProfileController extends HttpServlet {
    private final UserBO userBO = new UserBO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Load fresh user data from DB
        try {
            User freshUser = userBO.get(user.getId());
            if (freshUser != null) {
                request.setAttribute("profileUser", freshUser);
            } else {
                request.setAttribute("profileUser", user);
            }
        } catch (Exception e) {
            request.setAttribute("profileUser", user);
        }

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Vui lòng đăng nhập\"}");
            return;
        }

        try {
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String bio = request.getParameter("bio");
            Part avatarPart = request.getPart("avatar");

            String avatarPath = user.getAvatar();

            // Handle avatar upload
            if (avatarPart != null && avatarPart.getSize() > 0) {
                String savedPath = FileUploadUtil.save(avatarPart, "avatars", getServletContext());
                if (savedPath != null) {
                    avatarPath = savedPath;
                }
            }

            // Update user in database
            boolean updated = userBO.updateProfile(user.getId(), username, email, bio, avatarPath);

            if (updated) {
                // Update session
                user.setUsername(username);
                user.setEmail(email);
                user.setAvatar(avatarPath);
                session.setAttribute("user", user);

                response.getWriter().write("{\"success\": true, \"message\": \"Cập nhật thông tin thành công!\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Cập nhật thất bại. Vui lòng thử lại.\"}");
            }

        } catch (Exception e) {
            System.err.println("Error updating profile: " + e.getMessage());
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi: " + e.getMessage() + "\"}");
        }
    }
}
