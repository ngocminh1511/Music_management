package model.bo;

import java.sql.SQLException;
import java.util.List;

import model.bean.Playlist;
import model.bean.PlaylistStat;
import model.bean.Song;
import model.dao.PlaylistDAO;

public class PlaylistBO {
    private final PlaylistDAO dao = new PlaylistDAO();

    public List<Playlist> byUser(int userId) throws SQLException { return dao.findByUser(userId); }
    public int create(int userId, String name) throws SQLException { return dao.create(userId, name); }
    public boolean rename(int id, String newName, int userId) throws SQLException { return dao.rename(id, newName, userId); }
    public void delete(int id, int userId) throws SQLException { dao.delete(id, userId); }
    public void addSong(int playlistId, int songId, int userId) throws SQLException { dao.addSong(playlistId, songId, userId); }
    public void removeSong(int playlistId, int songId, int userId) throws SQLException { dao.removeSong(playlistId, songId, userId); }
    public List<Song> songs(int playlistId, int userId) throws SQLException { return dao.songs(playlistId, userId); }

    // Dashboard helpers
    public int count() throws SQLException { return dao.count(); }
    public List<PlaylistStat> topBySongCount(int limit) throws SQLException { return dao.topBySongCount(limit); }
}