package model.bean;

/**
 * Thống kê playlist dùng riêng cho dashboard admin.
 * Lưu số lượng bài hát trong mỗi playlist.
 */
public class PlaylistStat {
    private int id;
    private String name;
    private int songCount;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getSongCount() {
        return songCount;
    }

    public void setSongCount(int songCount) {
        this.songCount = songCount;
    }
}


