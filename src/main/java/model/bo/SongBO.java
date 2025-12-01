package model.bo;

import java.sql.SQLException;
import java.util.List;

import model.bean.Song;
import model.dao.SongDAO;

public class SongBO {
    private final SongDAO songDAO = new SongDAO();

    public List<Song> latest(int limit) throws SQLException {
        return songDAO.getLatest(limit);
    }

    public Song get(int id) throws SQLException {
        return songDAO.getById(id);
    }

    public List<Song> search(String q) throws SQLException {
        return songDAO.search(q);
    }

    public void increaseView(int id) throws SQLException {
        songDAO.increaseView(id);
    }

    public List<Song> getByCategory(int categoryId, int limit) throws SQLException {
        return songDAO.getByCategoryOrderByViews(categoryId, limit);
    }

    public List<Song> getTopByViews(int limit) throws SQLException {
        return songDAO.getTopByViews(limit);
    }

    public List<Song> getBySinger(int singerId, int limit) throws SQLException {
        return songDAO.getBySingerOrderByViews(singerId, limit);
    }

    // Admin operations
    public java.util.List<Song> all() throws SQLException { return songDAO.findAll(); }
    public int create(Song s) throws SQLException { return songDAO.create(s); }
    public void update(Song s) throws SQLException { songDAO.update(s); }
    public void delete(int id) throws SQLException { songDAO.delete(id); }
    public int count() throws SQLException { return songDAO.count(); }
    public long sumViews() throws SQLException { return songDAO.sumViews(); }

    // Thống kê theo thời gian
    public long sumViewsByDateRange(String startDate, String endDate) throws SQLException {
        return songDAO.sumViewsByDateRange(startDate, endDate);
    }
    public int countByDateRange(String startDate, String endDate) throws SQLException {
        return songDAO.countByDateRange(startDate, endDate);
    }
    public java.util.List<java.util.Map<String, Object>> getViewsByMonth(int year) throws SQLException {
        return songDAO.getViewsByMonth(year);
    }
    public java.util.List<Song> getTopByViewsInRange(String startDate, String endDate, int limit) throws SQLException {
        return songDAO.getTopByViewsInRange(startDate, endDate, limit);
    }
}