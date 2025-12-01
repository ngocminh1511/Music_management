package model.bo;

import java.sql.SQLException;
import java.util.List;

import model.bean.Singer;
import model.dao.SingerDAO;

public class SingerBO {
    private final SingerDAO dao = new SingerDAO();

    public List<Singer> all() throws SQLException { return dao.findAll(); }
    public Singer get(int id) throws SQLException { return dao.getById(id); }
    public List<Singer> getTopSingers(int limit) throws SQLException { return dao.getTopSingers(limit); }
    public int create(Singer s) throws SQLException { return dao.create(s); }
    public void update(Singer s) throws SQLException { dao.update(s); }
    public void delete(int id) throws SQLException { dao.delete(id); }
    public int count() throws SQLException { return dao.count(); }
}