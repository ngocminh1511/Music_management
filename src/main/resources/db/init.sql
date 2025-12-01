CREATE DATABASE IF NOT EXISTS music_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE music_db;

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(200) NOT NULL,
  email VARCHAR(100),
  role VARCHAR(20) DEFAULT 'USER'
);

CREATE TABLE IF NOT EXISTS singers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150),
  description TEXT,
  avatar VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  thumbnail VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS songs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255),
  singer_id INT,
  category_id INT,
  file_path VARCHAR(255),
  thumbnail VARCHAR(255),
  lyrics TEXT COMMENT 'Song lyrics in plain text or LRC format',
  view_count INT DEFAULT 0,
  upload_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_title (title),
  FOREIGN KEY (singer_id) REFERENCES singers(id) ON DELETE SET NULL,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS playlists (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  name VARCHAR(150),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS playlist_song (
  playlist_id INT,
  song_id INT,
  PRIMARY KEY (playlist_id, song_id),
  FOREIGN KEY (playlist_id) REFERENCES playlists(id) ON DELETE CASCADE,
  FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE
);

INSERT IGNORE INTO users (username, password, email, role) VALUES ('admin', '123456', 'admin@example.com', 'ADMIN');
INSERT IGNORE INTO singers (name, description, avatar) VALUES 
('Mono', 'Gen Z vibe', '/assets/avatars/mono.png'),
('Sơn Tùng M-TP', 'Vietnamese pop star', '/assets/avatars/m-tp.png');
INSERT IGNORE INTO categories (name, thumbnail) VALUES 
('V-POP Hits', '/assets/thumbs/vpop.png'),
('US-UK Chart', '/assets/thumbs/usuk.png'),
('EDM Night', '/assets/thumbs/edm.png'),
('Lo-fi Chill', '/assets/thumbs/lofi.png'),
('Rap Việt', '/assets/thumbs/rap.png'),
('Indie Acoustic', '/assets/thumbs/indie.png');
INSERT IGNORE INTO songs (title, singer_id, category_id, file_path, thumbnail) VALUES
('Waiting For You',1,1,'/assets/music/waiting_for_you.mp3','/assets/thumbs/waiting_for_you.png'),
('Có Chắc Yêu Là Đây',2,1,'/assets/music/co_chac_yeu_la_day.mp3','/assets/thumbs/co_chac.png');