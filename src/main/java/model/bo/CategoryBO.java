package model.bo;

import java.sql.SQLException;
import java.util.List;
import model.bean.Category;
import model.dao.CategoryDAO;

public class CategoryBO {
    private final CategoryDAO dao = new CategoryDAO();

    public List<Category> all() throws SQLException { return dao.findAll(); }
    public Category get(int id) throws SQLException { return dao.getById(id); }
    public int create(Category c) throws SQLException { return dao.create(c); }
    public void update(Category c) throws SQLException { dao.update(c); }
    public void delete(int id) throws SQLException { dao.delete(id); }
    public int count() throws SQLException { return dao.count(); }
}