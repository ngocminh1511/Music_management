package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.DBContext;
import model.bean.Song;

public class SongDAO {
    public List<Song> getLatest(int limit) throws SQLException {
        String sql = "SELECT * FROM songs ORDER BY upload_date DESC LIMIT ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                List<Song> list = new ArrayList<>();
                while (rs.next()) {
					list.add(map(rs));
				}
                return list;
            }
        }
    }

    public Song getById(int id) throws SQLException {
        String sql = "SELECT * FROM songs WHERE id=?";
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

    public List<Song> search(String keyword) throws SQLException {
        String sql = "SELECT * FROM songs WHERE title LIKE ? ORDER BY upload_date DESC";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                List<Song> list = new ArrayList<>();
                while (rs.next()) {
					list.add(map(rs));
				}
                return list;
            }
        }
    }

    public void increaseView(int id) throws SQLException {
        String sql = "UPDATE songs SET view_count = view_count + 1 WHERE id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public List<Song> findAll() throws SQLException {
        String sql = "SELECT * FROM songs ORDER BY upload_date DESC";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Song> list = new ArrayList<>();
            while (rs.next()) {
				list.add(map(rs));
			}
            return list;
        }
    }

    public int create(Song s) throws SQLException {
        String sql = "INSERT INTO songs(title, singer_id, category_id, file_path, thumbnail) VALUES(?,?,?,?,?)";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, s.getTitle());
            if (s.getSingerId() == null) {
				ps.setNull(2, Types.INTEGER);
			} else {
				ps.setInt(2, s.getSingerId());
			}
            if (s.getCategoryId() == null) {
				ps.setNull(3, Types.INTEGER);
			} else {
				ps.setInt(3, s.getCategoryId());
			}
            ps.setString(4, s.getFilePath());
            ps.setString(5, s.getThumbnail());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
					return keys.getInt(1);
				}
            }
            return 0;
        }
    }

    public void update(Song s) throws SQLException {
        String sql = "UPDATE songs SET title=?, singer_id=?, category_id=?, file_path=?, thumbnail=? WHERE id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, s.getTitle());
            if (s.getSingerId() == null) {
				ps.setNull(2, Types.INTEGER);
			} else {
				ps.setInt(2, s.getSingerId());
			}
            if (s.getCategoryId() == null) {
				ps.setNull(3, Types.INTEGER);
			} else {
				ps.setInt(3, s.getCategoryId());
			}
            ps.setString(4, s.getFilePath());
            ps.setString(5, s.getThumbnail());
            ps.setInt(6, s.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM songs WHERE id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM songs";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    public long sumViews() throws SQLException {
        String sql = "SELECT COALESCE(SUM(view_count),0) FROM songs";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getLong(1);
        }
    }

    public List<Song> getByCategoryOrderByViews(int categoryId, int limit) throws SQLException {
        String sql = "SELECT * FROM songs WHERE category_id=? ORDER BY view_count DESC LIMIT ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                List<Song> list = new ArrayList<>();
                while (rs.next()) {
					list.add(map(rs));
				}
                return list;
            }
        }
    }

    public List<Song> getTopByViews(int limit) throws SQLException {
        String sql = "SELECT * FROM songs ORDER BY view_count DESC LIMIT ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                List<Song> list = new ArrayList<>();
                while (rs.next()) {
					list.add(map(rs));
				}
                return list;
            }
        }
    }

    public List<Song> getBySingerOrderByViews(int singerId, int limit) throws SQLException {
        String sql = "SELECT * FROM songs WHERE singer_id=? ORDER BY view_count DESC LIMIT ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, singerId);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                List<Song> list = new ArrayList<>();
                while (rs.next()) {
					list.add(map(rs));
				}
                return list;
            }
        }
    }

    // Thống kê theo thời gian
    public long sumViewsByDateRange(String startDate, String endDate) throws SQLException {
        String sql = "SELECT COALESCE(SUM(view_count),0) FROM songs WHERE upload_date >= ? AND upload_date <= ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
					return rs.getLong(1);
				}
                return 0;
            }
        }
    }

    public int countByDateRange(String startDate, String endDate) throws SQLException {
        String sql = "SELECT COUNT(*) FROM songs WHERE upload_date >= ? AND upload_date <= ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
					return rs.getInt(1);
				}
                return 0;
            }
        }
    }

    // Lấy dữ liệu theo tháng để vẽ biểu đồ
    public List<java.util.Map<String, Object>> getViewsByMonth(int year) throws SQLException {
        String sql = "SELECT MONTH(upload_date) as month, SUM(view_count) as total_views " +
                     "FROM songs WHERE YEAR(upload_date) = ? GROUP BY MONTH(upload_date) ORDER BY month";
        List<java.util.Map<String, Object>> result = new ArrayList<>();
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, year);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    java.util.Map<String, Object> map = new java.util.HashMap<>();
                    map.put("month", rs.getInt("month"));
                    map.put("views", rs.getLong("total_views"));
                    result.add(map);
                }
            }
        }
        return result;
    }

    // Top bài hát theo lượt nghe trong khoảng thời gian
    public List<Song> getTopByViewsInRange(String startDate, String endDate, int limit) throws SQLException {
        String sql = "SELECT * FROM songs WHERE upload_date >= ? AND upload_date <= ? ORDER BY view_count DESC LIMIT ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                List<Song> list = new ArrayList<>();
                while (rs.next()) {
					list.add(map(rs));
				}
                return list;
            }
        }
    }

    private Song map(ResultSet rs) throws SQLException {
        Song s = new Song();
        s.setId(rs.getInt("id"));
        s.setTitle(rs.getString("title"));
        s.setSingerId((Integer) rs.getObject("singer_id"));
        s.setCategoryId((Integer) rs.getObject("category_id"));
        s.setFilePath(rs.getString("file_path"));
        s.setThumbnail(rs.getString("thumbnail"));
        s.setLyrics(rs.getString("lyrics"));
        s.setViewCount(rs.getInt("view_count"));
        s.setUploadDate(rs.getTimestamp("upload_date"));
        return s;
    }
}