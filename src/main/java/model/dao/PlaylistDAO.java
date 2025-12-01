package model.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.DBContext;
import model.bean.Playlist;
import model.bean.PlaylistStat;
import model.bean.Song;

public class PlaylistDAO {
    public List<Playlist> findByUser(int userId) throws SQLException {
        String sql = "SELECT * FROM playlists WHERE user_id=? ORDER BY id DESC";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Playlist> list = new ArrayList<>();
                while (rs.next()) {
                    Playlist p = new Playlist();
                    p.setId(rs.getInt("id"));
                    p.setUserId(rs.getInt("user_id"));
                    p.setName(rs.getString("name"));
                    list.add(p);
                }
                return list;
            }
        }
    }

    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM playlists";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    /**
     * Lấy danh sách playlist có nhiều bài hát nhất (dùng cho dashboard).
     */
    public List<PlaylistStat> topBySongCount(int limit) throws SQLException {
        String sql = "SELECT p.id, p.name, COUNT(ps.song_id) AS song_count " +
                     "FROM playlists p LEFT JOIN playlist_song ps ON p.id = ps.playlist_id " +
                     "GROUP BY p.id, p.name " +
                     "ORDER BY song_count DESC " +
                     "LIMIT ?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                List<PlaylistStat> list = new ArrayList<>();
                while (rs.next()) {
                    PlaylistStat stat = new PlaylistStat();
                    stat.setId(rs.getInt("id"));
                    stat.setName(rs.getString("name"));
                    stat.setSongCount(rs.getInt("song_count"));
                    list.add(stat);
                }
                return list;
            }
        }
    }

    public int create(int userId, String name) throws SQLException {
        String sql = "INSERT INTO playlists(user_id, name) VALUES(?,?)";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setString(2, name);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
					return keys.getInt(1);
				}
            }
            return 0;
        }
    }

    public boolean rename(int id, String newName, int userId) throws SQLException {
        String sql = "UPDATE playlists SET name=? WHERE id=? AND user_id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newName);
            ps.setInt(2, id);
            ps.setInt(3, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        }
    }

    public void delete(int id, int userId) throws SQLException {
        String sql = "DELETE FROM playlists WHERE id=? AND user_id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    public void addSong(int playlistId, int songId, int userId) throws SQLException {
        // ensure owner
        String check = "SELECT 1 FROM playlists WHERE id=? AND user_id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement c = con.prepareStatement(check)) {
            c.setInt(1, playlistId);
            c.setInt(2, userId);
            try (ResultSet rs = c.executeQuery()) {
                if (!rs.next()) {
					return;
				}
            }
        }
        String sql = "INSERT IGNORE INTO playlist_song(playlist_id, song_id) VALUES(?,?)";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, playlistId);
            ps.setInt(2, songId);
            ps.executeUpdate();
        }
    }

    public void removeSong(int playlistId, int songId, int userId) throws SQLException {
        String sql = "DELETE ps FROM playlist_song ps JOIN playlists p ON ps.playlist_id=p.id WHERE ps.playlist_id=? AND ps.song_id=? AND p.user_id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, playlistId);
            ps.setInt(2, songId);
            ps.setInt(3, userId);
            ps.executeUpdate();
        }
    }

    public List<Song> songs(int playlistId, int userId) throws SQLException {
        String sql = "SELECT s.* FROM songs s JOIN playlist_song ps ON s.id=ps.song_id JOIN playlists p ON p.id=ps.playlist_id WHERE p.id=? AND p.user_id=? ORDER BY s.upload_date DESC";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, playlistId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Song> list = new ArrayList<>();
                while (rs.next()) {
                    Song s = new Song();
                    s.setId(rs.getInt("id"));
                    s.setTitle(rs.getString("title"));
                    s.setSingerId((Integer) rs.getObject("singer_id"));
                    s.setCategoryId((Integer) rs.getObject("category_id"));
                    s.setFilePath(rs.getString("file_path"));
                    s.setThumbnail(rs.getString("thumbnail"));
                    s.setViewCount(rs.getInt("view_count"));
                    s.setUploadDate(rs.getTimestamp("upload_date"));
                    list.add(s);
                }
                return list;
            }
        }
    }
}