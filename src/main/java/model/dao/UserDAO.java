package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import model.DBContext;
import model.bean.User;

public class UserDAO {
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM users WHERE username=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
					return map(rs);
				}
                return null;
            }
        }
    }

    public User getById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
					return map(rs);
				}
                return null;
            }
        }
    }

    public int register(User u) throws SQLException {
        String sql = "INSERT INTO users(username,password,email,role) VALUES(?,?,?,?)";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getUsername());
            ps.setString(2, u.getPassword());
            ps.setString(3, u.getEmail());
            ps.setString(4, u.getRole() == null ? "USER" : u.getRole());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
					return keys.getInt(1);
				}
                return 0;
            }
        }
    }

    public int countByDateRange(String startDate, String endDate) throws SQLException {
        // Nếu có created_at thì dùng, không thì dùng id làm ước lượng
        String sql = "SELECT COUNT(*) FROM users WHERE id >= (SELECT MIN(id) FROM users)";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
				return rs.getInt(1);
			}
            return 0;
        }
    }

    public int countNewUsers() throws SQLException {
        // Đếm user mới trong 30 ngày gần nhất (nếu có created_at)
        // Hiện tại chỉ đếm tổng user
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
				return rs.getInt(1);
			}
            return 0;
        }
    }

    // Top user có nhiều playlist nhất
    public List<Map<String, Object>> getTopUsersByPlaylistCount(int limit) throws SQLException {
        String sql = "SELECT u.id, u.username, COUNT(p.id) as playlist_count " +
                     "FROM users u LEFT JOIN playlists p ON u.id = p.user_id " +
                     "GROUP BY u.id, u.username ORDER BY playlist_count DESC LIMIT ?";
        List<Map<String, Object>> result = new ArrayList<>();
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", rs.getInt("id"));
                    map.put("username", rs.getString("username"));
                    map.put("playlistCount", rs.getInt("playlist_count"));
                    result.add(map);
                }
            }
        }
        return result;
    }

    public boolean updateProfile(int userId, String username, String email, String bio, String avatarPath) throws SQLException {
        String sql = "UPDATE users SET username = ?, email = ?, bio = ?, avatar = ? WHERE id = ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, bio);
            ps.setString(4, avatarPath);
            ps.setInt(5, userId);

            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    private User map(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setEmail(rs.getString("email"));
        u.setRole(rs.getString("role"));
        u.setAvatar(rs.getString("avatar"));
        u.setBio(rs.getString("bio"));
        try {
            u.setCreatedAt(rs.getTimestamp("created_at"));
        } catch (SQLException e) {
            // Column might not exist in older schema
        }
        return u;
    }
}