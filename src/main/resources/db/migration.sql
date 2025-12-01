-- Migration script for enhanced features
-- Run this after init.sql

USE music_db;

-- Add lyrics column to songs table
ALTER TABLE songs 
ADD COLUMN  lyrics TEXT COMMENT 'Song lyrics in plain text or LRC format';

-- Add added_date to playlist_song for sorting
ALTER TABLE playlist_song 
ADD COLUMN  added_date DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'When song was added to playlist';

-- Add user profile columns to users table
ALTER TABLE users
ADD COLUMN  avatar VARCHAR(255) DEFAULT '/assets/avatars/default-user.png',
ADD COLUMN  bio TEXT,
ADD COLUMN  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Create index for performance
CREATE INDEX  idx_playlist_song_added ON playlist_song(playlist_id, added_date DESC);
CREATE INDEX  idx_song_upload ON songs(upload_date DESC);

-- Sample lyrics data (LRC format - time-synced)
UPDATE songs SET lyrics = '[00:00.00] Waiting For You - Mono
[00:15.50] I''ve been waiting for you
[00:20.30] Through the night and day
[00:25.10] Even when the stars fade away
[00:30.00] I''ll be here to stay
[00:35.50] 
[00:40.00] Every moment feels so long
[00:45.20] Without you by my side
[00:50.00] But I know that you belong
[00:55.30] Right here in my life'
WHERE title = 'Waiting For You';

UPDATE songs SET lyrics = '[00:00.00] Có Chắc Yêu Là Đây - Sơn Tùng M-TP
[00:12.00] Có chắc yêu là đây
[00:16.50] Khi ta bên nhau mỗi ngày
[00:21.00] Có chắc yêu là đây
[00:25.50] Khi em luôn là điều anh nghĩ tới
[00:30.00] 
[00:35.00] Dù có xa cách bao lâu
[00:40.00] Em vẫn mãi trong tim anh
[00:45.00] Tình yêu này mãi không phai
[00:50.00] Vì anh yêu em thật lòng'
WHERE title = 'Có Chắc Yêu Là Đây';

-- Update admin user with avatar
UPDATE users SET avatar = '/assets/avatars/admin-avatar.png', bio = 'System Administrator' WHERE username = 'admin';

COMMIT;
