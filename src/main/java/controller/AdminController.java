package controller;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import model.DBContext;
import model.bean.Category;
import model.bean.Singer;
import model.bean.Song;
import model.bo.CategoryBO;
import model.bo.PlaylistBO;
import model.bo.SingerBO;
import model.bo.SongBO;
import model.bo.UserBO;
import model.util.FileUploadUtil;

@MultipartConfig(maxFileSize = 20 * 1024 * 1024)
public class AdminController extends HttpServlet {
    private final SongBO songBO = new SongBO();
    private final SingerBO singerBO = new SingerBO();
    private final CategoryBO categoryBO = new CategoryBO();
    private final UserBO userBO = new UserBO();
    private final PlaylistBO playlistBO = new PlaylistBO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || "/".equals(path)) {
            try {
                req.setAttribute("countSongs", songBO.count());
                req.setAttribute("countSingers", singerBO.count());
                req.setAttribute("countCategories", categoryBO.count());
                req.setAttribute("sumViews", songBO.sumViews());
                req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
            } catch (Exception e) {
                throw new ServletException(e);
            }
            return;
        }

        try {
            switch (path) {
                case "/api/stats": {
                    try {
                        resp.setContentType("application/json;charset=UTF-8");
                        int cSongs = songBO.count();
                        int cSingers = singerBO.count();
                        int cCategories = categoryBO.count();
                        long views = songBO.sumViews();
                        int cPlaylists = playlistBO.count();

                        // top bài hát theo lượt nghe
                        List<Song> topSongs = songBO.getTopByViews(7);

                        // top nghệ sĩ theo lượt nghe (đã có sẵn trong SingerBO)
                        List<model.bean.Singer> topSingers = singerBO.getTopSingers(5);

                        // top playlist theo số lượng bài hát
                        List<model.bean.PlaylistStat> topPlaylists = playlistBO.topBySongCount(5);

                    StringBuilder sb = new StringBuilder();
                    sb.append('{')
                            .append("\"countSongs\":").append(cSongs).append(',')
                            .append("\"countSingers\":").append(cSingers).append(',')
                            .append("\"countCategories\":").append(cCategories).append(',')
                            .append("\"countPlaylists\":").append(cPlaylists).append(',')
                            .append("\"sumViews\":").append(views).append(',');

                    // topSongs
                    sb.append("\"topSongs\":[");
                    for (int i = 0; i < topSongs.size(); i++) {
                        Song s = topSongs.get(i);
                        if (i > 0) {
							sb.append(',');
						}
                        sb.append('{')
                                .append("\"title\":\"").append(s.getTitle().replace("\"", "\\\"")).append("\",")
                                .append("\"views\":").append(s.getViewCount())
                                .append('}');
                    }
                    sb.append("],");

                    // topSingers
                    sb.append("\"topSingers\":[");
                    for (int i = 0; i < topSingers.size(); i++) {
                        model.bean.Singer s = topSingers.get(i);
                        if (i > 0) {
							sb.append(',');
						}
                        sb.append('{')
                                .append("\"name\":\"").append(s.getName().replace("\"", "\\\"")).append("\"")
                                .append('}');
                    }
                    sb.append("],");

                    // topPlaylists
                    sb.append("\"topPlaylists\":[");
                    for (int i = 0; i < topPlaylists.size(); i++) {
                        model.bean.PlaylistStat p = topPlaylists.get(i);
                        if (i > 0) {
							sb.append(',');
						}
                        sb.append('{')
                                .append("\"name\":\"").append(p.getName().replace("\"", "\\\"")).append("\",")
                                .append("\"songCount\":").append(p.getSongCount())
                                .append('}');
                    }
                    sb.append("]");

                    sb.append('}');
                    resp.getWriter().write(sb.toString());
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        resp.setContentType("application/json;charset=UTF-8");
                        resp.getWriter().write("{\"error\":\"Internal server error\"}");
                    }
                    break;
                }
                case "/api/stats/dynamic": {
                    resp.setContentType("application/json;charset=UTF-8");
                    String period = req.getParameter("period"); // day, week, month, quarter, year
                    String startDate = req.getParameter("startDate");
                    String endDate = req.getParameter("endDate");
                    int year = req.getParameter("year") != null ? Integer.parseInt(req.getParameter("year")) : java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);

                    // Tính toán startDate và endDate dựa trên period
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");

                    if (period != null) {
                        switch (period) {
                            case "day":
                                startDate = sdf.format(cal.getTime());
                                endDate = sdf.format(cal.getTime());
                                break;
                            case "week":
                                cal.set(java.util.Calendar.DAY_OF_WEEK, cal.getFirstDayOfWeek());
                                startDate = sdf.format(cal.getTime());
                                cal.add(java.util.Calendar.DAY_OF_WEEK, 6);
                                endDate = sdf.format(cal.getTime());
                                break;
                            case "month":
                                cal.set(java.util.Calendar.DAY_OF_MONTH, 1);
                                startDate = sdf.format(cal.getTime());
                                cal.set(java.util.Calendar.DAY_OF_MONTH, cal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH));
                                endDate = sdf.format(cal.getTime());
                                break;
                            case "quarter":
                                int quarter = (cal.get(java.util.Calendar.MONTH) / 3);
                                cal.set(java.util.Calendar.MONTH, quarter * 3);
                                cal.set(java.util.Calendar.DAY_OF_MONTH, 1);
                                startDate = sdf.format(cal.getTime());
                                cal.add(java.util.Calendar.MONTH, 3);
                                cal.add(java.util.Calendar.DAY_OF_MONTH, -1);
                                endDate = sdf.format(cal.getTime());
                                break;
                            case "year":
                                cal.set(java.util.Calendar.DAY_OF_YEAR, 1);
                                startDate = sdf.format(cal.getTime());
                                cal.set(java.util.Calendar.DAY_OF_YEAR, cal.getActualMaximum(java.util.Calendar.DAY_OF_YEAR));
                                endDate = sdf.format(cal.getTime());
                                break;
                        }
                    }

                    if (startDate == null) {
						startDate = sdf.format(new java.util.Date());
					}
                    if (endDate == null) {
						endDate = sdf.format(new java.util.Date());
					}

                    String statType = req.getParameter("statType");
                    if (statType == null) {
						statType = "views";
					}

                    // Lấy dữ liệu theo khoảng thời gian
                    long viewsInRange = songBO.sumViewsByDateRange(startDate + " 00:00:00", endDate + " 23:59:59");
                    int songsInRange = songBO.countByDateRange(startDate + " 00:00:00", endDate + " 23:59:59");
                    List<Song> topSongsInRange = songBO.getTopByViewsInRange(startDate + " 00:00:00", endDate + " 23:59:59", 10);
                    List<java.util.Map<String, Object>> viewsByMonth = songBO.getViewsByMonth(year);
                    List<java.util.Map<String, Object>> topUsers = userBO.getTopUsersByPlaylistCount(5);
                    int newUsers = userBO.countNewUsers();

                    // Dữ liệu theo ca sĩ
                    List<java.util.Map<String, Object>> singersData = new java.util.ArrayList<>();
                    if ("viewsBySinger".equals(statType) || "singerComparison".equals(statType)) {
                        List<model.bean.Singer> allSingers = singerBO.all();
                        for (model.bean.Singer singer : allSingers) {
                            java.util.Map<String, Object> map = new java.util.HashMap<>();
                            map.put("singerId", singer.getId());
                            map.put("name", singer.getName());
                            List<Song> singerSongs = songBO.getBySinger(singer.getId(), 1000);
                            long totalViews = singerSongs.stream().mapToLong(Song::getViewCount).sum();
                            map.put("views", totalViews);
                            map.put("totalViews", totalViews);
                            singersData.add(map);
                        }
                        singersData.sort((a, b) -> Long.compare((Long)b.get("views"), (Long)a.get("views")));
                        if (singersData.size() > 10) {
							singersData = singersData.subList(0, 10);
						}
                    }

                    // Dữ liệu theo thể loại
                    List<java.util.Map<String, Object>> categoriesData = new java.util.ArrayList<>();
                    if ("viewsByCategory".equals(statType) || "categoryDistribution".equals(statType)) {
                        List<Category> allCategories = categoryBO.all();
                        for (Category cat : allCategories) {
                            java.util.Map<String, Object> map = new java.util.HashMap<>();
                            map.put("categoryId", cat.getId());
                            map.put("name", cat.getName());
                            map.put("categoryName", cat.getName());
                            List<Song> catSongs = songBO.getByCategory(cat.getId(), 1000);
                            long totalViews = catSongs.stream().mapToLong(Song::getViewCount).sum();
                            map.put("views", totalViews);
                            map.put("totalViews", totalViews);
                            categoriesData.add(map);
                        }
                        categoriesData.sort((a, b) -> Long.compare((Long)b.get("views"), (Long)a.get("views")));
                    }

                    // Dữ liệu so sánh tháng
                    List<java.util.Map<String, Object>> comparisonData = new java.util.ArrayList<>();
                    if ("monthComparison".equals(statType)) {
                        java.util.Calendar calNow = java.util.Calendar.getInstance();
                        int currentMonth = calNow.get(java.util.Calendar.MONTH) + 1;
                        int currentYear = calNow.get(java.util.Calendar.YEAR);

                        calNow.set(java.util.Calendar.MONTH, currentMonth - 1);
                        calNow.set(java.util.Calendar.DAY_OF_MONTH, 1);
                        String thisMonthStart = sdf.format(calNow.getTime());
                        calNow.set(java.util.Calendar.DAY_OF_MONTH, calNow.getActualMaximum(java.util.Calendar.DAY_OF_MONTH));
                        String thisMonthEnd = sdf.format(calNow.getTime());

                        calNow.add(java.util.Calendar.MONTH, -1);
                        calNow.set(java.util.Calendar.DAY_OF_MONTH, 1);
                        String lastMonthStart = sdf.format(calNow.getTime());
                        calNow.set(java.util.Calendar.DAY_OF_MONTH, calNow.getActualMaximum(java.util.Calendar.DAY_OF_MONTH));
                        String lastMonthEnd = sdf.format(calNow.getTime());

                        long thisMonthViews = songBO.sumViewsByDateRange(thisMonthStart + " 00:00:00", thisMonthEnd + " 23:59:59");
                        long lastMonthViews = songBO.sumViewsByDateRange(lastMonthStart + " 00:00:00", lastMonthEnd + " 23:59:59");

                        java.util.Map<String, Object> comp = new java.util.HashMap<>();
                        comp.put("label", "Tháng " + currentMonth);
                        comp.put("current", thisMonthViews);
                        comp.put("thisMonth", thisMonthViews);
                        comp.put("previous", lastMonthViews);
                        comp.put("lastMonth", lastMonthViews);
                        comparisonData.add(comp);
                    }

                    StringBuilder sb = new StringBuilder();
                    sb.append('{')
                            .append("\"period\":\"").append(period != null ? period : "all").append("\",")
                            .append("\"startDate\":\"").append(startDate).append("\",")
                            .append("\"endDate\":\"").append(endDate).append("\",")
                            .append("\"viewsInRange\":").append(viewsInRange).append(',')
                            .append("\"songsInRange\":").append(songsInRange).append(',')
                            .append("\"newUsers\":").append(newUsers).append(',');

                    // Top bài hát trong khoảng thời gian
                    sb.append("\"topSongsInRange\":[");
                    for (int i = 0; i < topSongsInRange.size(); i++) {
                        Song s = topSongsInRange.get(i);
                        if (i > 0) {
							sb.append(',');
						}
                        sb.append('{')
                                .append("\"title\":\"").append(s.getTitle().replace("\"", "\\\"")).append("\",")
                                .append("\"views\":").append(s.getViewCount())
                                .append('}');
                    }
                    sb.append("],");

                    // Biểu đồ lượt nghe theo tháng
                    sb.append("\"viewsByMonth\":[");
                    for (int i = 0; i < viewsByMonth.size(); i++) {
                        java.util.Map<String, Object> m = viewsByMonth.get(i);
                        if (i > 0) {
							sb.append(',');
						}
                        sb.append('{')
                                .append("\"month\":").append(m.get("month")).append(',')
                                .append("\"views\":").append(m.get("views"))
                                .append('}');
                    }
                    sb.append("],");

                    // Top user có nhiều playlist
                    sb.append("\"topUsers\":[");
                    for (int i = 0; i < topUsers.size(); i++) {
                        java.util.Map<String, Object> u = topUsers.get(i);
                        if (i > 0) {
							sb.append(',');
						}
                        sb.append('{')
                                .append("\"username\":\"").append(u.get("username").toString().replace("\"", "\\\"")).append("\",")
                                .append("\"playlistCount\":").append(u.get("playlistCount"))
                                .append('}');
                    }
                    sb.append("],");

                    // Singers data
                    sb.append("\"singersData\":[");
                    for (int i = 0; i < singersData.size(); i++) {
                        java.util.Map<String, Object> s = singersData.get(i);
                        if (i > 0) {
							sb.append(',');
						}
                        sb.append('{')
                                .append("\"singerId\":").append(s.get("singerId")).append(',')
                                .append("\"name\":\"").append(s.get("name").toString().replace("\"", "\\\"")).append("\",")
                                .append("\"singerName\":\"").append(s.get("name").toString().replace("\"", "\\\"")).append("\",")
                                .append("\"views\":").append(s.get("views")).append(',')
                                .append("\"totalViews\":").append(s.get("totalViews"))
                                .append('}');
                    }
                    sb.append("],");

                    // Categories data
                    sb.append("\"categoriesData\":[");
                    for (int i = 0; i < categoriesData.size(); i++) {
                        java.util.Map<String, Object> c = categoriesData.get(i);
                        if (i > 0) {
							sb.append(',');
						}
                        sb.append('{')
                                .append("\"categoryId\":").append(c.get("categoryId")).append(',')
                                .append("\"name\":\"").append(c.get("name").toString().replace("\"", "\\\"")).append("\",")
                                .append("\"categoryName\":\"").append(c.get("name").toString().replace("\"", "\\\"")).append("\",")
                                .append("\"views\":").append(c.get("views")).append(',')
                                .append("\"totalViews\":").append(c.get("totalViews"))
                                .append('}');
                    }
                    sb.append("],");

                    // Comparison data
                    sb.append("\"comparisonData\":[");
                    for (int i = 0; i < comparisonData.size(); i++) {
                        java.util.Map<String, Object> comp = comparisonData.get(i);
                        if (i > 0) {
							sb.append(',');
						}
                        sb.append('{')
                                .append("\"label\":\"").append(comp.get("label").toString().replace("\"", "\\\"")).append("\",")
                                .append("\"current\":").append(comp.get("current")).append(',')
                                .append("\"thisMonth\":").append(comp.get("thisMonth")).append(',')
                                .append("\"previous\":").append(comp.get("previous")).append(',')
                                .append("\"lastMonth\":").append(comp.get("lastMonth"))
                                .append('}');
                    }
                    sb.append("]");

                    sb.append('}');
                    resp.getWriter().write(sb.toString());
                    break;
                }
                case "/songs": {
                    req.setAttribute("songs", songBO.all());
                    req.setAttribute("singers", singerBO.all());
                    req.setAttribute("categories", categoryBO.all());
                    req.getRequestDispatcher("/WEB-INF/views/admin/songs.jsp").forward(req, resp);
                    break;
                }
                case "/singers": {
                    req.setAttribute("singers", singerBO.all());
                    req.getRequestDispatcher("/WEB-INF/views/admin/singers.jsp").forward(req, resp);
                    break;
                }
                case "/categories": {
                    req.setAttribute("categories", categoryBO.all());
                    req.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(req, resp);
                    break;
                }
                case "/users": {
                    try (Connection con = DBContext.getConnection()) {
                        req.setAttribute("users", userBO.listAll(con));
                    }
                    req.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(req, resp);
                    break;
                }
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }
        try {
            switch (path) {
                case "/songs/create": {
                    String title = req.getParameter("title");
                    Integer singerId = parseInt(req.getParameter("singerId"));
                    Integer categoryId = parseInt(req.getParameter("categoryId"));
                    Part audio = req.getPart("audio");
                    Part thumb = req.getPart("thumb");
                    String filePath = FileUploadUtil.save(audio, "music", getServletContext());
                    String thumbnail = FileUploadUtil.save(thumb, "thumbs", getServletContext());
                    Song s = new Song();
                    s.setTitle(title);
                    s.setSingerId(singerId);
                    s.setCategoryId(categoryId);
                    s.setFilePath(filePath);
                    s.setThumbnail(thumbnail);
                    songBO.create(s);
                    resp.sendRedirect(req.getContextPath() + "/admin/songs");
                    break;
                }
                case "/songs/update": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Song cur = songBO.get(id);
                    if (cur == null) { resp.sendError(404); return; }
                    cur.setTitle(req.getParameter("title"));
                    cur.setSingerId(parseInt(req.getParameter("singerId")));
                    cur.setCategoryId(parseInt(req.getParameter("categoryId")));
                    Part audio = req.getPart("audio");
                    Part thumb = req.getPart("thumb");
                    String filePath = FileUploadUtil.save(audio, "music", getServletContext());
                    String thumbnail = FileUploadUtil.save(thumb, "thumbs", getServletContext());
                    if (filePath != null) {
						cur.setFilePath(filePath);
					}
                    if (thumbnail != null) {
						cur.setThumbnail(thumbnail);
					}
                    songBO.update(cur);
                    resp.sendRedirect(req.getContextPath() + "/admin/songs");
                    break;
                }
                case "/songs/delete": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    songBO.delete(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/songs");
                    break;
                }
                case "/singers/create": {
                    Singer s = new Singer();
                    s.setName(req.getParameter("name"));
                    s.setDescription(req.getParameter("description"));
                    String avatar = null;
                    Part av = req.getPart("avatar");
                    avatar = FileUploadUtil.save(av, "avatars", getServletContext());
                    s.setAvatar(avatar);
                    singerBO.create(s);
                    resp.sendRedirect(req.getContextPath() + "/admin/singers");
                    break;
                }
                case "/singers/update": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Singer s = singerBO.get(id);
                    if (s == null) { resp.sendError(404); return; }
                    s.setName(req.getParameter("name"));
                    s.setDescription(req.getParameter("description"));
                    Part av = req.getPart("avatar");
                    String avatar = FileUploadUtil.save(av, "avatars", getServletContext());
                    if (avatar != null) {
						s.setAvatar(avatar);
					}
                    singerBO.update(s);
                    resp.sendRedirect(req.getContextPath() + "/admin/singers");
                    break;
                }
                case "/singers/delete": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    singerBO.delete(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/singers");
                    break;
                }
                case "/categories/create": {
                    Category c = new Category();
                    c.setName(req.getParameter("name"));
                    categoryBO.create(c);
                    resp.sendRedirect(req.getContextPath() + "/admin/categories");
                    break;
                }
                case "/categories/update": {
                    Category c = new Category();
                    c.setId(Integer.parseInt(req.getParameter("id")));
                    c.setName(req.getParameter("name"));
                    categoryBO.update(c);
                    resp.sendRedirect(req.getContextPath() + "/admin/categories");
                    break;
                }
                case "/categories/delete": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    categoryBO.delete(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/categories");
                    break;
                }
                case "/users/role": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    String role = req.getParameter("role");
                    try (Connection con = DBContext.getConnection()) {
                        userBO.updateRole(id, role, con);
                    }
                    resp.sendRedirect(req.getContextPath() + "/admin/users");
                    break;
                }
                case "/users/delete": {
                    int id = Integer.parseInt(req.getParameter("id"));
                    try (Connection con = DBContext.getConnection()) {
                        userBO.delete(id, con);
                    }
                    resp.sendRedirect(req.getContextPath() + "/admin/users");
                    break;
                }
                default:
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private Integer parseInt(String s) {
        try {
            if (s == null || s.isEmpty()) {
				return null;
			}
            return Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}