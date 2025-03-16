CREATE DATABASE  IF NOT EXISTS `moving_bazaar` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `moving_bazaar`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: moving_bazaar
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_users` (
  `auserid` int NOT NULL AUTO_INCREMENT,
  `ausername` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`auserid`),
  UNIQUE KEY `ausername` (`ausername`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_users`
--

LOCK TABLES `admin_users` WRITE;
/*!40000 ALTER TABLE `admin_users` DISABLE KEYS */;
INSERT INTO `admin_users` VALUES (1,'ranji','ranji123','2025-02-02 03:45:11');
/*!40000 ALTER TABLE `admin_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billing`
--

DROP TABLE IF EXISTS `billing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billing` (
  `billing_id` varchar(50) NOT NULL,
  `order_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `paid_by` int DEFAULT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `payment_status` enum('Pending','Paid','Failed','Refunded') DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `receipt_pdf` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`billing_id`),
  UNIQUE KEY `unique_order` (`order_id`),
  KEY `paid_by` (`paid_by`),
  KEY `billing_ibfk_2` (`user_id`),
  CONSTRAINT `billing_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `billing_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`employeeid`) ON DELETE SET NULL,
  CONSTRAINT `billing_ibfk_3` FOREIGN KEY (`paid_by`) REFERENCES `customer` (`customer_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing`
--

LOCK TABLES `billing` WRITE;
/*!40000 ALTER TABLE `billing` DISABLE KEYS */;
/*!40000 ALTER TABLE `billing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commodities_photos`
--

DROP TABLE IF EXISTS `commodities_photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commodities_photos` (
  `photo_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `photo_paths` json NOT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`photo_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `commodities_photos_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commodities_photos`
--

LOCK TABLES `commodities_photos` WRITE;
/*!40000 ALTER TABLE `commodities_photos` DISABLE KEYS */;
/*!40000 ALTER TABLE `commodities_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `commodity`
--

DROP TABLE IF EXISTS `commodity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `commodity` (
  `commodity_id` int NOT NULL AUTO_INCREMENT,
  `item_name` varchar(255) NOT NULL,
  `item_photo` varchar(255) DEFAULT NULL,
  `description` text COMMENT 'Detailed description of the commodity',
  `min_order_qty` int NOT NULL DEFAULT '1',
  `max_order_qty` int NOT NULL DEFAULT '10',
  `price` decimal(10,2) NOT NULL DEFAULT '30.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`commodity_id`),
  UNIQUE KEY `item_name_UNIQUE` (`item_name`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commodity`
--

LOCK TABLES `commodity` WRITE;
/*!40000 ALTER TABLE `commodity` DISABLE KEYS */;
INSERT INTO `commodity` VALUES (2,'Organic Apples','apple.jpg','Organic fresh apples',2,15,55.00,'2025-02-06 16:14:07'),(5,' Vegetables','veg_image.jpg',NULL,1,10,35.50,'2025-02-10 17:26:31'),(10,'Test Commodity','test.jpg',NULL,1,5,25.00,'2025-02-10 17:39:56'),(11,'Updated Commodi','updated.jpg',NULL,2,10,30.50,'2025-02-10 17:40:35'),(12,'Onion','onion.jpg',NULL,1,100,25.00,'2025-02-22 11:03:34'),(13,'Potato','potato.jpg',NULL,1,150,20.00,'2025-02-22 11:03:34'),(14,'Carrot','carrot.jpg',NULL,1,80,40.00,'2025-02-22 11:03:34'),(15,'Brinjal','brinjal.jpg',NULL,1,60,35.00,'2025-02-22 11:03:34'),(16,'Cabbage','cabbage.jpg',NULL,1,50,30.00,'2025-02-22 11:03:34'),(17,'Apple','apple.jpg',NULL,2,50,120.00,'2025-02-22 11:03:44'),(18,'Banana','banana.jpg',NULL,2,200,60.00,'2025-02-22 11:03:45'),(19,'Pomegranate','pomegranate.jpg',NULL,2,40,180.00,'2025-02-22 11:03:45'),(20,'Grapes','grapes.jpg',NULL,2,75,90.00,'2025-02-22 11:03:45'),(21,'Papaya','papaya.jpg',NULL,2,30,50.00,'2025-02-22 11:03:45'),(22,'Milk','milk.jpg',NULL,3,500,50.00,'2025-02-22 11:04:00'),(23,'Curd','curd.jpg',NULL,3,100,40.00,'2025-02-22 11:04:00'),(24,'Paneer','paneer.jpg',NULL,3,80,250.00,'2025-02-22 11:04:00'),(25,'Butter','butter.jpg',NULL,3,70,450.00,'2025-02-22 11:04:00'),(26,'Ghee','ghee.jpg',NULL,3,60,600.00,'2025-02-22 11:04:00'),(27,'Vegetables','veg_image.jpg','Fresh vegetables from local farms',1,10,35.50,'2025-03-16 08:26:08'),(28,'Vege','veg_image.jpg','Fresh organic vegetables',1,10,35.50,'2025-03-16 08:30:32'),(29,'Veg','veg_image.jpg','Fresh organic vegetables',1,10,35.50,'2025-03-16 08:31:36');
/*!40000 ALTER TABLE `commodity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `customer_id` int NOT NULL AUTO_INCREMENT,
  `store_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone_number` varchar(15) NOT NULL,
  `whatsapp_number` varchar(15) DEFAULT NULL,
  `address_line1` varchar(255) NOT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `outstanding_price` decimal(10,2) DEFAULT '0.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone_number` (`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (4,'New Store Name','new_email@example.com','050000002','050000002','456 New Street','Area B','Los Angeles',150.50,'2025-02-06 15:46:05'),(5,'vignesh Store','karthick@example.com','050000003',NULL,'123 Street','Area A','New York',0.00,'2025-02-07 00:03:17'),(10,'Kumar Supermarket','kumar.store@example.com','9876543210','9876543211','12, Mount Road','T. Nagar','Chennai',5000.00,'2025-02-22 11:00:49'),(12,'Gupta Wholesale','gupta.wholesale@example.com','9823456789','9823456790','45, Connaught Place','Central Delhi','Delhi',10000.50,'2025-02-22 11:01:28'),(13,'Ramesh Kirana','ramesh.kirana@example.com','9900123456',NULL,'8th Main Road','Indiranagar','Bangalore',1500.25,'2025-02-22 11:01:28'),(14,'Sai Fashion','sai.fashion@example.com','9000011223','9000011224','20, Banjara Hills','Jubilee Hills','Hyderabad',7500.00,'2025-02-22 11:01:28'),(30,'Spice Junction','spice.junction@example.com','9822004455',NULL,'21, Linking Road','Bandra','Mumbai',12000.75,'2025-03-15 18:37:58'),(31,'Spice Junction','spice.junction@exampljue.com','9822004451',NULL,'21, Linking Road','Bandra','Mumbai',12000.75,'2025-03-15 18:39:54');
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `commodity_id` int NOT NULL,
  `quantity` int NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_item_id`),
  KEY `commodity_id` (`commodity_id`),
  KEY `fk_order_items_order` (`order_id`),
  CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`commodity_id`) REFERENCES `commodity` (`commodity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (70,1068025,18,2,120.00,'2025-03-05 16:22:58'),(72,1068025,18,2,120.00,'2025-03-06 02:40:28'),(73,58430656,17,3,360.00,'2025-03-16 09:16:30'),(74,58430656,18,2,120.00,'2025-03-16 09:16:30'),(75,58430656,17,3,360.00,'2025-03-16 09:18:56'),(76,58430656,18,2,120.00,'2025-03-16 09:18:56'),(77,58430656,17,3,360.00,'2025-03-16 09:28:53'),(78,58430656,18,2,120.00,'2025-03-16 09:28:53');
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `sender_id` int NOT NULL,
  `receiver_id` int NOT NULL,
  `created_by` int NOT NULL,
  `order_status` enum('Retained','In Transit','Picked Up','Delivered') DEFAULT 'In Transit',
  `stage` enum('order','commodity','billing','Completed') DEFAULT 'order',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `sender_id` (`sender_id`),
  KEY `receiver_id` (`receiver_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`created_by`) REFERENCES `users` (`employeeid`)
) ENGINE=InnoDB AUTO_INCREMENT=59491925 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (1068025,13,14,10,'In Transit','order','2025-03-01 01:31:06','2025-03-01 01:31:06'),(1454275,13,14,10,'In Transit','order','2025-03-01 01:31:45','2025-03-01 01:31:45'),(3342978,13,14,10,'In Transit','order','2025-03-01 01:33:34','2025-03-01 01:33:34'),(5135981,13,14,10,'In Transit','order','2025-03-01 01:35:13','2025-03-01 01:35:13'),(16077556,12,13,10,'In Transit','order','2025-03-16 07:46:07','2025-03-16 07:46:07'),(17455902,12,13,10,'In Transit','order','2025-03-16 07:47:45','2025-03-16 07:47:45'),(19280588,12,13,10,'In Transit','order','2025-03-16 07:49:28','2025-03-16 07:49:28'),(55030183,12,13,10,'In Transit','order','2025-03-01 01:25:03','2025-03-01 01:25:03'),(55066636,12,13,10,'In Transit','order','2025-03-01 01:25:06','2025-03-01 01:25:06'),(56012634,12,13,10,'In Transit','order','2025-03-01 01:26:01','2025-03-01 01:26:01'),(58263727,13,14,10,'In Transit','order','2025-03-01 01:28:26','2025-03-01 01:28:26'),(58430656,13,14,10,'In Transit','order','2025-03-01 01:28:43','2025-03-01 01:28:43'),(59050656,13,14,10,'In Transit','order','2025-03-01 01:29:05','2025-03-01 01:29:05');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `employeeid` int NOT NULL AUTO_INCREMENT,
  `employee_full_name` varchar(255) NOT NULL,
  `employee_email` varchar(255) NOT NULL,
  `employee_phone_number` varchar(15) NOT NULL,
  `employee_password` varchar(255) NOT NULL,
  `employee_profile_photo` varchar(255) DEFAULT NULL,
  `employee_is_admin` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`employeeid`),
  UNIQUE KEY `employee_email` (`employee_email`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Ranjith','ranji@example.com','555-1234','hashed_password',NULL,0,'2025-01-21 18:04:23'),(10,'Ranjith','ranjith@example.com','555-1234','hashed_password',NULL,0,'2025-01-26 15:10:47'),(13,'John Do','john.doe@example.com','1234567890','new_hashed_password','image_url_or_data_here',0,'2025-02-10 15:04:51'),(14,'Ravi Kumar','ravi.kumar@example.com','9876543210','hashed_password_1','Software Engineer',0,'2025-02-22 10:58:42'),(16,'Priya Sharma','priya.sharma@example.com','9812345678','hashed_pwd_2',NULL,1,'2025-02-22 10:59:09'),(17,'Amit Verma','amit.verma@example.com','7890654321','hash_pswd_3','Data Scientist',0,'2025-02-22 10:59:09'),(18,'Arjun Reddy','arjun.reddy@example.com','9123456780','hashed_pswd_5','Product Manager',1,'2025-02-22 10:59:09');
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

-- Dump completed on 2025-03-16 15:06:52
