package model.bo;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.bean.User;
import model.dao.UserDAO;

public class UserBO {
    private final UserDAO dao = new UserDAO();

    public User getByUsername(String username) throws SQLException { return dao.findByUsername(username); }
    public int register(User u) throws SQLException { return dao.register(u); }
    public User get(int id) throws SQLException { return dao.getById(id); }

    // Admin helpers (implemented here to avoid changing UserDAO signature too much)
    public List<User> listAll(java.sql.Connection externalCon) throws SQLException {
        List<User> list = new ArrayList<>();
        try (java.sql.Statement st = externalCon.createStatement();
             java.sql.ResultSet rs = st.executeQuery("SELECT * FROM users ORDER BY id DESC")) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                list.add(u);
            }
        }
        return list;
    }

    public void updateRole(int id, String role, java.sql.Connection externalCon) throws SQLException {
        try (java.sql.PreparedStatement ps = externalCon.prepareStatement("UPDATE users SET role=? WHERE id=?")) {
            ps.setString(1, role);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public void delete(int id, java.sql.Connection externalCon) throws SQLException {
        try (java.sql.PreparedStatement ps = externalCon.prepareStatement("DELETE FROM users WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public int countNewUsers() throws SQLException {
        return dao.countNewUsers();
    }

    public java.util.List<java.util.Map<String, Object>> getTopUsersByPlaylistCount(int limit) throws SQLException {
        return dao.getTopUsersByPlaylistCount(limit);
    }

    public boolean updateProfile(int userId, String username, String email, String bio, String avatarPath) throws SQLException {
        return dao.updateProfile(userId, username, email, bio, avatarPath);
    }
}