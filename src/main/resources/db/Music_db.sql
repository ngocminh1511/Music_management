-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: music_db
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thumbnail` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (4,'V-POP Hits','/assets/thumbs/vpop.png'),(5,'US-UK Chart','/assets/thumbs/usuk.png'),(6,'EDM Night','/assets/thumbs/edm.png'),(7,'Lo-fi Chill','/assets/thumbs/lofi.png'),(8,'Rap Việt','/assets/thumbs/rap.png'),(9,'Indie Acoustic','/assets/thumbs/indie.png'),(10,'Rock','/assets/thumbs/rock.png'),(11,'Dance','/assets/thumbs/dance.png'),(12,'Ballad','/assets/thumbs/ballad.png'),(13,'R&B','/assets/thumbs/r&b.png'),(14,'Flamenco','/assets/thumbs/flamenco.png');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlist_song`
--

DROP TABLE IF EXISTS `playlist_song`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlist_song` (
  `playlist_id` int NOT NULL,
  `song_id` int NOT NULL,
  `added_date` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'When song was added to playlist',
  PRIMARY KEY (`playlist_id`,`song_id`),
  KEY `song_id` (`song_id`),
  KEY `idx_playlist_song_added` (`playlist_id`,`added_date` DESC),
  CONSTRAINT `playlist_song_ibfk_1` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`id`) ON DELETE CASCADE,
  CONSTRAINT `playlist_song_ibfk_2` FOREIGN KEY (`song_id`) REFERENCES `songs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlist_song`
--

LOCK TABLES `playlist_song` WRITE;
/*!40000 ALTER TABLE `playlist_song` DISABLE KEYS */;
INSERT INTO `playlist_song` VALUES (3,4,'2025-11-30 13:32:04'),(4,3,'2025-11-30 13:32:04'),(6,3,'2025-11-30 13:32:04'),(8,3,'2025-11-30 13:32:04'),(8,4,'2025-11-30 13:32:04');
/*!40000 ALTER TABLE `playlist_song` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `playlists`
--

DROP TABLE IF EXISTS `playlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `playlists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `playlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `playlists`
--

LOCK TABLES `playlists` WRITE;
/*!40000 ALTER TABLE `playlists` DISABLE KEYS */;
INSERT INTO `playlists` VALUES (2,1,'hi'),(3,1,'lalaa'),(4,2,'hihi'),(5,2,'hihi'),(6,2,'hihi'),(7,1,'lalaa'),(8,1,'hii');
/*!40000 ALTER TABLE `playlists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `singers`
--

DROP TABLE IF EXISTS `singers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `singers` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `singers`
--

LOCK TABLES `singers` WRITE;
/*!40000 ALTER TABLE `singers` DISABLE KEYS */;
INSERT INTO `singers` VALUES (1,'Mono','Gen Z vibe','/assets/avatars/mono.png'),(2,'Sơn Tùng M-TP','Vietnamese pop star','/assets/avatars/m-tp.png'),(3,'Minh-ND','Best Singer 2025','/assets/avatars/MinhND.png'),(4,'Hà Anh Tuấn','Nơi những tinh hoa hội tụ','/assets/avatars/haanhtuan.png'),(5,'Adele','Nơi những tinh hoa hội tụ','/assets/avatars/adele.png'),(6,'Beyonce','Nơi những tinh hoa hội tụ','/assets/avatars/beyonce.png'),(7,'Đen Vâu','Nơi những tinh hoa hội tụ','/assets/avatars/denvau.png'),(8,'Đông Nhi','Nơi những tinh hoa hội tụ','/assets/avatars/dongnhi.png'),(9,'Hiếu Thứ Hai','Nơi những tinh hoa hội tụ','/assets/avatars/hieuthuhai.png'),(10,'Hoàng Dũng','Nơi những tinh hoa hội tụ','/assets/avatars/hoangdung.png'),(11,'Justatee','Nơi những tinh hoa hội tụ','/assets/avatars/justatee.png'),(12,'Karik','Nơi những tinh hoa hội tụ','/assets/avatars/karik.png'),(13,'Phan Mạnh Quỳnh','Nơi những tinh hoa hội tụ','/assets/avatars/phanmanhquynh.png'),(14,'Suboi','Nơi những tinh hoa hội tụ','/assets/avatars/suboi.png'),(15,'Taylor','Nơi những tinh hoa hội tụ','/assets/avatars/taylor.png'),(16,'Wowy','Rapper sá» 1 Viá»t Nam','/assets/avatars/wowy.png');
/*!40000 ALTER TABLE `singers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `songs`
--

DROP TABLE IF EXISTS `songs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `songs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `singer_id` int DEFAULT NULL,
  `category_id` int DEFAULT NULL,
  `file_path` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `thumbnail` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `view_count` int DEFAULT '0',
  `upload_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `lyrics` text COLLATE utf8mb4_unicode_ci COMMENT 'Song lyrics in plain text or LRC format',
  PRIMARY KEY (`id`),
  KEY `idx_title` (`title`),
  KEY `singer_id` (`singer_id`),
  KEY `category_id` (`category_id`),
  KEY `idx_song_upload` (`upload_date` DESC),
  CONSTRAINT `songs_ibfk_1` FOREIGN KEY (`singer_id`) REFERENCES `singers` (`id`) ON DELETE SET NULL,
  CONSTRAINT `songs_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `songs`
--

LOCK TABLES `songs` WRITE;
/*!40000 ALTER TABLE `songs` DISABLE KEYS */;
INSERT INTO `songs` VALUES (1,'Waiting For You',1,6,'/assets/music/waiting_for_you.mp3','/assets/thumbs/waiting_for_you.png',19,'2025-11-26 22:05:55','[00:00.00] Waiting For You - Mono\n[00:15.50] I\'ve been waiting for you\n[00:20.30] Through the night and day\n[00:25.10] Even when the stars fade away\n[00:30.00] I\'ll be here to stay\n[00:35.50] \n[00:40.00] Every moment feels so long\n[00:45.20] Without you by my side\n[00:50.00] But I know that you belong\n[00:55.30] Right here in my life'),(2,'Có Chắc Yêu Là Đây',2,5,'/assets/music/co_chac_yeu_la_day.mp3','/assets/thumbs/co_chac.png',10,'2025-11-26 22:05:55','[00:00.00] Có chắc yê là đây - Sơn Tùng MTP\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(3,'Đà Nẵng - Trái tim phía mặt trời',3,6,'/assets/music/DaNang_TraiTimPhiaMatTroi.mp3','/assets/thumbs/danang.png',30,'2025-11-27 13:50:10','[00:00.00] Đà Nẵng Trái tim phía mặt trời - MinhND\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(4,'Tháng 4 là lời nói dối của em',4,6,'/assets/music/Thang4_LaLoiNoiDoiCuaEm.mp3','/assets/thumbs/thang4.png',59,'2025-11-27 14:59:44','[00:00.00] Tháng 4 là lời nói dối của em - Hà Anh Tuấn\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(5,'Nhà tôi có treo một lá cờ',4,6,'/assets/music/Thang4_LaLoiNoiDoiCuaEm.mp3','/assets/thumbs/nhatoicotreomotlaco.png',27,'2025-11-27 22:36:38','[00:00.00] Tháng 4 là lời nói dối của em - Hà Anh Tuấn\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(6,'Dear, Memory',4,6,'/assets/music/Thang4_LaLoiNoiDoiCuaEm.mp3','/assets/thumbs/dear_memory.png',20,'2025-11-27 22:36:38','[00:00.00] Tháng 4 là lời nói dối của em - Hà Anh Tuấn\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(7,'Hoa Hồng',4,6,'/assets/music/Thang4_LaLoiNoiDoiCuaEm.mp3','/assets/thumbs/hoahong.png',11,'2025-11-27 22:36:38','[00:00.00] Tháng 4 là lời nói dối của em - Hà Anh Tuấn\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(8,'Tháng mấy em nhớ anh?',4,6,'/assets/music/Thang4_LaLoiNoiDoiCuaEm.mp3','/assets/thumbs/thangmayemnhoanh.png',15,'2025-11-27 22:36:38','[00:00.00] Tháng 4 là lời nói dối của em - Hà Anh Tuấn\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(9,'Xuân thì',4,6,'/assets/music/Thang4_LaLoiNoiDoiCuaEm.mp3','/assets/thumbs/xuanthi.png',4,'2025-11-27 22:36:38','[00:00.00] Tháng 4 là lời nói dối của em - Hà Anh Tuấn\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(10,'Mình yêu nhau bình yên thôi',4,6,'/assets/music/Thang4_LaLoiNoiDoiCuaEm.mp3','/assets/thumbs/minhyeunhaubinhyen.png',2,'2025-11-27 22:36:38','[00:00.00] Tháng 4 là lời nói dối của em - Hà Anh Tuấn\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(11,'Âm thầm bên em',2,6,'/assets/music/Thang4_LaLoiNoiDoiCuaEm.mp3','/assets/thumbs/amthambenem.png',12,'2025-11-27 22:36:38','[00:00.00] Tháng 4 là lời nói dối của em - Hà Anh Tuấn\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(12,'Hãy trao cho anh',2,6,'/assets/music/Thang4_LaLoiNoiDoiCuaEm.mp3','/assets/thumbs/haytraochoanh.png',6,'2025-11-27 22:36:38','[00:00.00] Tháng 4 là lời nói dối của em - Hà Anh Tuấn\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(13,'Nắng ấm xa dần',2,6,'/assets/music/Thang4_LaLoiNoiDoiCuaEm.mp3','/assets/thumbs/nangamxadan.png',6,'2025-11-27 22:36:38','[00:00.00] Tháng 4 là lời nói dối của em - Hà Anh Tuấn\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(14,'Lạc trôi',2,6,'/assets/music/Thang4_LaLoiNoiDoiCuaEm.mp3','/assets/thumbs/lactroi.png',8,'2025-11-27 22:36:38','[00:00.00] Tháng 4 là lời nói dối của em - Hà Anh Tuấn\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng'),(15,'Tiến lên Việt Nam ơi',2,6,'/assets/music/Thang4_LaLoiNoiDoiCuaEm.mp3','/assets/thumbs/tienlenvietnamoi.png',12,'2025-11-27 22:36:38','[00:00.00] Tháng 4 là lời nói dối của em - Hà Anh Tuấn\n [00:12.00] Có chắc yêu là đây\n [00:16.50] Khi ta bên nhau mỗi ngày\n [00:21.00] Có chắc yêu là đây\n [00:25.50] Khi em luôn là điều anh nghĩ tới\n [00:30.00] \n [00:35.00] Dù có xa cách bao lâu\n [00:40.00] Em vẫn mãi trong tim anh\n [00:45.00] Tình yêu này mãi không phai\n [00:50.00] Vì anh yêu em thật lòng');
/*!40000 ALTER TABLE `songs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'USER',
  `avatar` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '/assets/avatars/default-user.png',
  `bio` text COLLATE utf8mb4_unicode_ci,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','123456','admin@example.com','ADMIN','/assets/avatars/admin-avatar.png','System Administrator','2025-11-30 13:32:23','2025-11-30 13:33:32'),(2,'minhdoan','minhdoan123','minhdoan@gmail.com','USER','/assets/avatars/denvau.png','','2025-11-30 13:32:23','2025-12-01 13:55:53'),(3,'hiephc','hiep123','hiephc@gmail.com','USER','/assets/avatars/user-avatar.png',NULL,'2025-11-30 13:32:23','2025-11-30 13:35:48');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-03  0:18:46
