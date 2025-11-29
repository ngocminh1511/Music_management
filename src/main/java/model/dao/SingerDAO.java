package model.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.DBContext;
import model.bean.Singer;

public class SingerDAO {
    public List<Singer> findAll() throws SQLException {
        String sql = "SELECT * FROM singers ORDER BY name";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Singer> list = new ArrayList<>();
            while (rs.next()) list.add(map(rs));
            return list;
        }
    }

    public Singer getById(int id) throws SQLException {
        String sql = "SELECT * FROM singers WHERE id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
                return null;
            }
        }
    }

    public int create(Singer s) throws SQLException {
        String sql = "INSERT INTO singers(name, description, avatar) VALUES(?,?,?)";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getDescription());
            ps.setString(3, s.getAvatar());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
            return 0;
        }
    }

    public void update(Singer s) throws SQLException {
        String sql = "UPDATE singers SET name=?, description=?, avatar=? WHERE id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getDescription());
            ps.setString(3, s.getAvatar());
            ps.setInt(4, s.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM singers WHERE id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM singers";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    public List<Singer> getTopSingers(int limit) throws SQLException {
        String sql = "SELECT s.*, COALESCE(SUM(sg.view_count), 0) as total_views " +
                     "FROM singers s LEFT JOIN songs sg ON s.id = sg.singer_id " +
                     "GROUP BY s.id ORDER BY total_views DESC LIMIT ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                List<Singer> list = new ArrayList<>();
                while (rs.next()) list.add(map(rs));
                return list;
            }
        }
    }

    private Singer map(ResultSet rs) throws SQLException {
        Singer s = new Singer();
        s.setId(rs.getInt("id"));
        s.setName(rs.getString("name"));
        s.setDescription(rs.getString("description"));
        s.setAvatar(rs.getString("avatar"));
        return s;
    }
}