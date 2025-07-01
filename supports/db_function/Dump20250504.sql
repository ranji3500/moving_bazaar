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
  `billing_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `employee_id` int DEFAULT NULL,
  `paid_by` int DEFAULT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `grand_total` decimal(10,2) DEFAULT '0.00',
  `total_amount_paid` decimal(10,2) DEFAULT '0.00',
  `amount_paid` decimal(10,2) DEFAULT '0.00',
  `outstanding_amount_paid` decimal(10,2) DEFAULT '0.00',
  `closed_outstanding_order_ids` json DEFAULT NULL,
  `payment_status` enum('Pending','Paid','Partial') DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `receipt_pdf` varchar(255) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  PRIMARY KEY (`billing_id`),
  KEY `billing_ibfk_1` (`order_id`),
  KEY `billing_ibfk_2` (`employee_id`),
  KEY `billing_ibfk_3` (`paid_by`),
  CONSTRAINT `billing_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `billing_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `users` (`employeeid`),
  CONSTRAINT `billing_ibfk_3` FOREIGN KEY (`paid_by`) REFERENCES `customer` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing`
--

LOCK TABLES `billing` WRITE;
/*!40000 ALTER TABLE `billing` DISABLE KEYS */;
INSERT INTO `billing` VALUES (3,3342978,1,4,267.00,467.00,250.00,50.00,200.00,'[1068025]','Partial','2025-04-24 18:30:51',NULL,'2025-04-12'),(4,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-24 18:41:53',NULL,'2025-04-12'),(5,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-24 18:44:33',NULL,'2025-04-12'),(6,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-24 18:48:21',NULL,'2025-04-12'),(7,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-24 18:50:10',NULL,'2025-04-12'),(8,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-24 18:57:37',NULL,'2025-04-12'),(9,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-24 19:02:00',NULL,'2025-04-12'),(10,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-24 19:03:34',NULL,'2025-04-12'),(11,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-24 19:04:14',NULL,'2025-04-12'),(12,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-24 19:05:16',NULL,'2025-04-12'),(13,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-24 19:05:50',NULL,'2025-04-12'),(14,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-27 09:36:05',NULL,'2025-04-12'),(15,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-27 09:37:27',NULL,'2025-04-12'),(16,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-27 09:37:40',NULL,'2025-04-12'),(18,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-27 09:39:11',NULL,'2025-04-12'),(19,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-27 09:39:52',NULL,'2025-04-12'),(20,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-27 09:40:12',NULL,'2025-04-12'),(21,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-27 09:40:35',NULL,'2025-04-12'),(22,1068025,1,4,267.00,467.00,250.00,50.00,200.00,'[3342978]','Partial','2025-04-27 09:42:22',NULL,'2025-04-12');
/*!40000 ALTER TABLE `billing` ENABLE KEYS */;
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
-- Table structure for table `delivery_failure_reasons`
--

DROP TABLE IF EXISTS `delivery_failure_reasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_failure_reasons` (
  `reasonid` int NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`reasonid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_failure_reasons`
--

LOCK TABLES `delivery_failure_reasons` WRITE;
/*!40000 ALTER TABLE `delivery_failure_reasons` DISABLE KEYS */;
INSERT INTO `delivery_failure_reasons` VALUES (1,'Contact Issues (Wrong/Unreachable Number)'),(2,'Customer Not Available at Address'),(3,'Incorrect Delivery Address'),(4,'Customer Requested Reschedule'),(5,'Customer Refused to Accept'),(6,'Payment Not Ready (for COD orders)'),(7,'Security/Access Issues (Gated Community, No Entry)'),(8,'Weather Conditions Prevented Delivery'),(9,'Traffic or Road Blockage'),(10,'Vehicle Breakdown or Delivery Issue'),(11,'Package Damaged in Transit'),(12,'Customer Changed Mind'),(13,'COVID/Health Concerns at Delivery Location'),(14,'Suspicious or Unsafe Location'),(15,'Customer Already Received Item via Alternate Delivery');
/*!40000 ALTER TABLE `delivery_failure_reasons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documents` (
  `doc_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `path` varchar(145) DEFAULT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `catagory` enum('commodities','invoice') DEFAULT NULL,
  PRIMARY KEY (`doc_id`),
  KEY `fk_order_id` (`order_id`),
  CONSTRAINT `fk_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=79 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES (12,1068025,NULL,'2025-05-01 07:55:12','commodities'),(15,1068025,NULL,'2025-05-01 08:30:20','commodities'),(16,1068025,NULL,'2025-05-01 09:01:16','commodities'),(17,1068025,NULL,'2025-05-01 09:01:17','commodities'),(18,1068025,NULL,'2025-05-01 09:02:03','commodities'),(19,1068025,NULL,'2025-05-01 09:17:14','commodities'),(20,1068025,'/docs/invoice1.png','2025-05-01 09:33:50','invoice'),(22,1068025,'/docs/invoice3.png','2025-05-01 09:33:50','invoice'),(23,1068025,'/docs/invoice1.png','2025-05-01 09:34:56','invoice'),(24,1068025,'/docs/invoice2.png','2025-05-01 09:34:56','invoice'),(25,1068025,'/docs/invoice3.png','2025-05-01 09:34:56','invoice'),(26,1068025,'a44ffc3c7b1b469f9c5f7e436c71e302.png','2025-05-01 09:35:46','commodities'),(28,1068025,'path1.jpg','2025-05-01 15:44:13','commodities'),(29,1068025,'path2.jpg','2025-05-01 15:44:13','commodities'),(30,1068025,'856a322ace4142cc97c2134bde18816c.png','2025-05-01 15:45:04','commodities'),(31,1068025,'60c6a52995004a9db799aa36a52deee3.png','2025-05-01 15:45:04','commodities'),(32,1068025,'fdfbd57f78a0421698b5289175afe56e.png','2025-05-01 15:45:43','commodities'),(33,1068025,'de2265aa17514840bead158701ffd2bb.png','2025-05-01 15:45:43','commodities'),(34,1068025,'6b65e751a6b44a31a1316b017861a789.png','2025-05-01 15:47:03','commodities'),(35,1068025,'542e0b5d717e47b9b54793597d6efd23.png','2025-05-01 15:47:03','commodities'),(36,1068025,'41afe9e360494866b1bc26af7ed0c143.png','2025-05-01 15:48:23','commodities'),(37,1068025,'75cfa8b474994169aa9db81f36aaa88b.png','2025-05-01 15:48:23','commodities'),(40,1068025,'3e00744f929646afb356c590f6cabcdf.png','2025-05-01 15:50:12','commodities'),(41,1068025,'e6722ea8a6c843ee81d9b2a054916604.png','2025-05-01 15:50:12','commodities'),(42,1068025,'/docs/invoice1.png','2025-05-01 15:52:07','invoice'),(43,1068025,'/docs/invoice2.png','2025-05-01 15:52:07','invoice'),(44,1068025,'/docs/invoice3.png','2025-05-01 15:52:07','invoice'),(45,1068025,'20eacf300a9543fc8c56635ee9547907.png','2025-05-01 15:53:14','commodities'),(46,1068025,'54458bbf208340139894643d78c7b865.png','2025-05-01 15:53:14','commodities'),(47,1068025,'0123b17d721f417b809fa2bfd176039d.png','2025-05-01 15:54:04','commodities'),(48,1068025,'a76dcf8965dd416a91516e96d017f47d.png','2025-05-01 15:54:04','commodities'),(49,1068025,'7f025d6daf9d48de9554879d21c55908.png','2025-05-01 15:54:43','commodities'),(50,1068025,'cbbbc2788cae4ef7980486a1c2f88066.png','2025-05-01 15:54:43','commodities'),(51,1068025,'ef346dc57d9544faa1e0515e0bc15c9e.png','2025-05-01 15:54:51','commodities'),(52,1068025,'bbdac1e4848648ab930fecefe9b0071b.png','2025-05-01 15:54:51','commodities'),(53,1068025,'67a710cfe8ac4cea865845371eeea56e.png','2025-05-01 16:09:56','commodities'),(54,1068025,'4222ee25b9bf4f8d821d6336cdd1c439.png','2025-05-01 16:09:56','commodities'),(55,1068025,'ecec8334053c4e268698e3c5bb11124f.png','2025-05-01 16:42:26','commodities'),(56,1068025,'276fabf662f54373a8d27bbed3c9afb1.png','2025-05-01 16:42:26','commodities'),(57,1068025,'8c4a70af330949d09a9cff2d5a4bb981.png','2025-05-01 16:44:20','commodities'),(58,1068025,'6f862f7fc2e441d788e0c35ce0a462b0.png','2025-05-01 16:44:20','commodities'),(59,1068025,'c455e1b62b444087a11806ba7d2acaba.png','2025-05-01 16:46:43','commodities'),(60,1068025,'1fbb28f06564417aa917510924b296c4.png','2025-05-01 16:46:43','commodities'),(61,1068025,'c58e908882334d8198333295faa3d4b3.png','2025-05-01 16:47:34','commodities'),(62,1068025,'32b01e19e3584f7eaac3f6d27f33a137.png','2025-05-01 16:47:34','commodities'),(63,1068025,'1068025_commodities_aa0689b409e8464fbc197088b8c13d4c.png','2025-05-01 16:51:39','commodities'),(64,1068025,'1068025_commodities_2ba0325b6af045ffbb119f657a951bac.png','2025-05-01 16:51:39','commodities'),(65,1068025,'1068025_commodities_7fe5e2e9d56b4ab897ba2167edd53511.png','2025-05-01 16:53:03','commodities'),(66,1068025,'1068025_commodities_6448c29e56454e5bb7aa482e63b75ff5.png','2025-05-01 16:53:03','commodities'),(67,1068025,'1068025_commodities_4edb0ad4f6314360883875d3535c58af.png','2025-05-01 16:54:15','commodities'),(68,1068025,'1068025_commodities_305fa936978b4bbba236fb3c56a7cb91.png','2025-05-01 16:54:15','commodities'),(69,1068025,'1068025_commodities_c389cc9c3ac84d04943b478f05a85ee0.png','2025-05-01 17:21:26','commodities'),(70,1068025,'1068025_commodities_f1fa9861b2364ed1b6c7df1e133878e4.png','2025-05-01 17:21:26','commodities'),(71,1068025,'1068025_commodities_fe2c8776f8da45dcaa7122dc39fc2986.png','2025-05-01 18:11:36','commodities'),(72,1068025,'1068025_commodities_4058748fc68c4393bc86c1487d443e39.png','2025-05-01 18:11:36','commodities'),(73,1068025,'1068025_commodities_e0ce3bd0e40f47db930f8ecd22410cb6.png','2025-05-01 18:12:09','commodities'),(74,1068025,'1068025_commodities_dc18be988d6d49b5bf30fba2920c781c.png','2025-05-01 18:12:09','commodities'),(75,1068025,'1068025_commodities_f10ff86f4ce743f1a33165f36f1ba529.png','2025-05-01 18:12:36','commodities'),(76,1068025,'1068025_commodities_bffc63aaa90b4f2ca4e8ef7315bbab99.png','2025-05-01 18:12:36','commodities'),(77,1068025,'1068025_commodities_4b3db12f86bd4c2b9ce7bf7d0eab604f.png','2025-05-01 18:18:15','commodities'),(78,1068025,'1068025_commodities_f0f9a87f9f03463da63275ace325e867.png','2025-05-01 18:18:15','commodities');
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
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
INSERT INTO `order_items` VALUES (70,1068025,18,2,120.00,'2025-03-05 16:22:58'),(73,58430656,17,3,360.00,'2025-03-16 09:16:30'),(74,58430656,18,2,120.00,'2025-03-16 09:16:30'),(75,58430656,17,3,360.00,'2025-03-16 09:18:56'),(76,58430656,18,2,120.00,'2025-03-16 09:18:56'),(77,58430656,17,3,360.00,'2025-03-16 09:28:53'),(78,58430656,18,2,120.00,'2025-03-16 09:28:53');
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
  `reason_text_backup` varchar(150) DEFAULT NULL,
  `reason_id` int DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `sender_id` (`sender_id`),
  KEY `receiver_id` (`receiver_id`),
  KEY `created_by` (`created_by`),
  KEY `fk_reason_id` (`reason_id`),
  CONSTRAINT `fk_reason_id` FOREIGN KEY (`reason_id`) REFERENCES `delivery_failure_reasons` (`reasonid`),
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
INSERT INTO `orders` VALUES (1068025,13,14,10,'Delivered','order','2025-03-01 01:31:06','2025-05-03 18:21:14',NULL,2),(1454275,13,14,10,'In Transit','order','2025-03-01 01:31:45','2025-04-27 17:20:52',NULL,NULL),(3342978,13,14,10,'In Transit','order','2025-03-01 01:33:34','2025-04-27 17:20:52',NULL,NULL),(5135981,13,14,10,'In Transit','order','2025-03-01 01:35:13','2025-03-01 01:35:13','other',NULL),(16077556,12,13,10,'In Transit','order','2025-03-16 07:46:07','2025-03-16 07:46:07','other',NULL),(17455902,12,13,10,'In Transit','order','2025-03-16 07:47:45','2025-03-16 07:47:45','other',NULL),(19280588,12,13,10,'In Transit','order','2025-03-16 07:49:28','2025-03-16 07:49:28','other',NULL),(55030183,12,13,10,'In Transit','order','2025-03-01 01:25:03','2025-03-01 01:25:03','other',NULL),(55066636,12,13,10,'In Transit','order','2025-03-01 01:25:06','2025-03-01 01:25:06','other',NULL),(56012634,12,13,10,'Delivered','order','2025-03-01 01:26:01','2025-05-03 18:49:23','other',1),(58263727,13,14,10,'Delivered','order','2025-03-01 01:28:26','2025-05-03 14:06:55','Delivered to customer',NULL),(58430656,13,14,10,'In Transit','order','2025-03-01 01:28:43','2025-03-01 01:28:43','other',NULL),(59050656,13,14,10,'In Transit','order','2025-03-01 01:29:05','2025-03-01 01:29:05','other',NULL);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outstanding_balance`
--

DROP TABLE IF EXISTS `outstanding_balance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `outstanding_balance` (
  `outstanding_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `order_id` int NOT NULL,
  `outstanding_amount` decimal(10,2) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('open','close') DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`outstanding_id`),
  KEY `customer_id` (`customer_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `outstanding_balance_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`),
  CONSTRAINT `outstanding_balance_ibfk_2` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outstanding_balance`
--

LOCK TABLES `outstanding_balance` WRITE;
/*!40000 ALTER TABLE `outstanding_balance` DISABLE KEYS */;
INSERT INTO `outstanding_balance` VALUES (6,10,3342978,150.50,'2025-04-05 22:29:36','open','2025-04-27 15:12:22');
/*!40000 ALTER TABLE `outstanding_balance` ENABLE KEYS */;
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

--
-- Dumping events for database 'moving_bazaar'
--

--
-- Dumping routines for database 'moving_bazaar'
--
/*!50003 DROP PROCEDURE IF EXISTS `add_order_items` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_order_items`(
    IN p_order_id INT,
    IN p_commodities JSON
)
BEGIN
    -- ✅ Declare variables
    DECLARE total_price DECIMAL(10,2) DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE commodities_length INT;
    DECLARE commodity_id INT;
    DECLARE quantity INT;
    DECLARE price DECIMAL(10,2);
    DECLARE order_item_id INT;
    DECLARE order_items_list TEXT DEFAULT ''; -- To store all order item IDs
    DECLARE order_exists INT;
    DECLARE items_inserted INT DEFAULT 0;
    DECLARE error_message VARCHAR(255);
	DECLARE stage VARCHAR(255);
    

    -- ✅ Error Handler for SQL Exceptions
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        ROLLBACK;  -- Rollback on error
        SELECT 'Failure' AS Status, error_message AS Message;
    END;

    -- ✅ Start labeled block
    proc_block: BEGIN

        -- ✅ Check if the order exists BEFORE inserting items
        SELECT COUNT(*) INTO order_exists FROM orders WHERE order_id = p_order_id;

        -- ✅ If order does not exist, return an error message **IMMEDIATELY**
        IF order_exists = 0 THEN
            SELECT 'Failure' AS Status, 'Order ID not found' AS Message, p_order_id AS OrderID;
            LEAVE proc_block;  -- ✅ Exit procedure safely
        END IF;

        -- ✅ Start transaction
        START TRANSACTION;

        -- ✅ Get JSON array length
        SET commodities_length = JSON_LENGTH(p_commodities);

        -- ✅ Loop through JSON array
        WHILE i < commodities_length DO
            -- Extract values
            SET commodity_id = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].commodity_id')));
            SET quantity = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].quantity')));
            SET price = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].price')));

            -- ✅ Ensure commodity exists
            IF (SELECT COUNT(*) FROM commodity WHERE commodity_id = commodity_id) = 0 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Invalid commodity_id';
            END IF;

            -- ✅ Insert order item
            INSERT INTO order_items (order_id, commodity_id, quantity, total_price)
            VALUES (p_order_id, commodity_id, quantity, price * quantity);

            -- ✅ Check if insertion was successful
            IF ROW_COUNT() > 0 THEN
                -- Get last inserted order_item_id
                SET order_item_id = LAST_INSERT_ID();
                
                -- ✅ Add order_item_id to the list
                IF order_items_list = '' THEN
                    SET order_items_list = order_item_id;
                ELSE
                    SET order_items_list = CONCAT(order_items_list, ', ', order_item_id);
                END IF;
                
                -- ✅ Increase count of inserted items
                SET items_inserted = items_inserted + 1;

                -- ✅ Add to total price
                SET total_price = total_price + (price * quantity);
            END IF;

            -- Move to next item
            SET i = i + 1;
        END WHILE;

        -- ✅ Commit transaction
        COMMIT;

        -- ✅ Return final message **based on items inserted**
		IF items_inserted > 0 THEN
			SELECT 
				'success' AS status,
				p_order_id AS orderId, 
				order_items_list AS orderItemIds,
				total_price AS totalPrice,
                "billing" AS stage; 
		ELSE
			SELECT 
				'failure' AS status, 
				'No items were added' AS message,
                total_price AS totalPrice,
				p_order_id AS orderId;
		END IF;


    END proc_block;  -- ✅ End labeled block

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AdminLogin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AdminLogin`(
    IN p_username VARCHAR(255), 
    IN p_password VARCHAR(255)
)
BEGIN
    SELECT 
        CASE 
            WHEN COUNT(*) > 0 THEN 'login successful' 
            ELSE 'login failed' 
        END AS rmsg 
    FROM admin_users 
    WHERE ausername = p_username AND password = p_password;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CloseOutstandingBalanceByOrderId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `CloseOutstandingBalanceByOrderId`(
    IN p_order_id INT
)
BEGIN
    -- Check if the order_id exists in the outstanding_balance table
    IF EXISTS (
        SELECT 1 
        FROM moving_bazaar.outstanding_balance 
        WHERE order_id = p_order_id
    ) THEN

        -- Update status to 'close' and set updated_at timestamp
        UPDATE moving_bazaar.outstanding_balance
        SET 
            status = 'close',
            updated_at = NOW()
        WHERE order_id = p_order_id;

        -- Return success message
        SELECT CONCAT('Status updated to ''close'' for order_id: ', p_order_id) AS message;

    ELSE
        -- Return error message if order_id not found
        SELECT 'Error: Order ID not found in outstanding_balance.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ConfirmOrder` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ConfirmOrder`(
    IN p_order_id INT,
    IN p_user_id INT,
    IN p_paid_by_customer_id INT,
    IN p_amount_paid DECIMAL(10,2),
    IN p_delivery_date DATE
)
BEGIN
    DECLARE v_total_price DECIMAL(10,2);

    -- Check if order exists
    IF NOT EXISTS (SELECT 1 FROM moving_bazaar.orders WHERE order_id = p_order_id) THEN
        SELECT 'Error: Order ID does not exist.' AS message;
    ELSE
        -- Calculate total price
        SELECT SUM(oi.quantity * c.price)
        INTO v_total_price
        FROM moving_bazaar.order_items oi
        JOIN moving_bazaar.commodity c ON oi.commodity_id = c.commodity_id
        WHERE oi.order_id = p_order_id;

        -- Insert billing record
        INSERT INTO moving_bazaar.billing (
            order_id, user_id, paid_by, total_price, payment_status,
            created_at, amount_paid, delivery_date
        ) VALUES (
            p_order_id, p_user_id, p_paid_by_customer_id, v_total_price, 'paid',
            NOW(), p_amount_paid, p_delivery_date
        );

        -- Update order status
        UPDATE moving_bazaar.orders
        SET order_status = 'confirmed', delivery_date = p_delivery_date
        WHERE order_id = p_order_id;

        -- Update outstanding status
        UPDATE moving_bazaar.outstanding_balance
        SET status = 'close', updated_at = NOW()
        WHERE order_id = p_order_id;

        SELECT 'Success: Order confirmed and billing record inserted.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_order`(
    IN sender_id_param INT,
    IN receiver_id_param INT,
    IN created_by_param INT
)
BEGIN
    DECLARE custom_order_id int;
    DECLARE error_message VARCHAR(255);
    DECLARE timestamp_part VARCHAR(4);
    DECLARE random_part VARCHAR(4);

    -- ✅ Start a labeled block to use LEAVE properly
    proc_block: BEGIN 

        -- ✅ Start transaction
        START TRANSACTION;

        -- ✅ Check if sender exists
        IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = sender_id_param) THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Sender does not exist in customer table' AS Message;
            LEAVE proc_block;
        END IF;

        -- ✅ Check if receiver exists
        IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = receiver_id_param) THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Receiver does not exist in customer table' AS Message;
            LEAVE proc_block;
        END IF;

        -- ✅ Check if created_by user exists (assuming `users` table)
        IF NOT EXISTS (SELECT 1 FROM users WHERE employeeid = created_by_param) THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Created_by user does not exist' AS Message;
            LEAVE proc_block;
        END IF;

        -- ✅ Generate Custom Order ID
        SET timestamp_part = RIGHT(DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'), 4);
        SET random_part = LPAD(FLOOR(RAND() * 10000), 4, '0');
        SET custom_order_id = CONCAT(timestamp_part, random_part);

        -- ✅ Insert the new order with the generated order ID
        INSERT INTO orders (order_id, sender_id, receiver_id, created_by, order_status, created_at, updated_at)
        VALUES (custom_order_id, sender_id_param, receiver_id_param, created_by_param, 'In Transit', NOW(), NOW());

        -- ✅ If insertion failed, rollback
        IF ROW_COUNT() = 0 THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Could not create Order' AS Message;
            LEAVE proc_block;
        ELSE
            -- ✅ Commit transaction and return success
            COMMIT;
            SELECT 'Success' AS status, 
       'Order Created Successfully' AS message, 
       custom_order_id AS orderId, 
       'commodity' AS orderStage;

        END IF;

    END proc_block;  -- ✅ End of labeled block

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_order_and_billing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_order_and_billing`(
    IN sender_id INT,
    IN receiver_id INT,
    IN created_by INT,
    IN commodities JSON  -- JSON array of commodities (commodity_id, quantity, price)
)
BEGIN
    DECLARE order_id INT;
    DECLARE total_price DECIMAL(10,2) DEFAULT 0;
    DECLARE billing_id BIGINT;
    DECLARE i INT DEFAULT 0;
    DECLARE commodities_length INT;
    DECLARE commodity_id INT;
    DECLARE quantity INT;
    DECLARE price DECIMAL(10,2);
    DECLARE unique_seq INT;

    -- Step 1: Insert a new order
    INSERT INTO orders (sender_id, receiver_id, created_by, order_status)
    VALUES (sender_id, receiver_id, created_by, 'Pending');

    -- Get the generated order_id
    SET order_id = LAST_INSERT_ID();

    -- Step 2: Get the length of JSON array
    SET commodities_length = JSON_LENGTH(commodities);

    -- Step 3: Loop through the JSON array and insert each commodity
    WHILE i < commodities_length DO
        -- Extract commodity_id, quantity, and price from JSON
        SET commodity_id = JSON_UNQUOTE(JSON_EXTRACT(commodities, CONCAT('$[', i, '].commodity_id')));
        SET quantity = JSON_UNQUOTE(JSON_EXTRACT(commodities, CONCAT('$[', i, '].quantity')));
        SET price = JSON_UNQUOTE(JSON_EXTRACT(commodities, CONCAT('$[', i, '].price')));

        -- Insert order item
        INSERT INTO order_items (order_id, commodity_id, quantity, total_price)
        VALUES (order_id, commodity_id, quantity, price * quantity);

        -- Add to the total price
        SET total_price = total_price + (price * quantity);

        -- Move to the next item
        SET i = i + 1;
    END WHILE;

    -- Step 4: Generate a unique numeric billing ID
    -- We take the current date (YYYYMMDD) + a unique sequence number + order_id
    SET unique_seq = (SELECT COALESCE(MAX(CAST(SUBSTRING(billing_id, 9, 4) AS UNSIGNED)), 0) + 1 FROM billing WHERE SUBSTRING(billing_id, 1, 8) = DATE_FORMAT(NOW(), '%Y%m%d'));

    SET billing_id = CONCAT(DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(unique_seq, 4, '0'), order_id);

    -- Step 5: Insert into billing table
    INSERT INTO billing (billing_id, order_id, user_id, total_price, payment_status)
    VALUES (billing_id, order_id, created_by, total_price, 'Pending');

    -- Step 6: Return the order_id and billing_id
    SELECT order_id AS 'Order ID', billing_id AS 'Billing ID', total_price AS 'Total Price';

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deduct_customer_balance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deduct_customer_balance`(
    IN p_customer_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Deduct balance if sufficient funds
    IF EXISTS (SELECT 1 FROM customer_balance WHERE customer_id = p_customer_id) THEN
        UPDATE customer_balance
        SET outstanding_balance = GREATEST(outstanding_balance - p_amount, 0)
        WHERE customer_id = p_customer_id;

        SET message = 'Customer balance deducted successfully.';
    ELSE
        SET message = 'Error: No balance record found for customer.';
    END IF;

    -- Return Message
    SELECT message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteCommodity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCommodity`(
    IN p_commodityId INT
)
BEGIN
    DECLARE message VARCHAR(255);
    DECLARE rowsAffected INT DEFAULT 0;

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('sqlError: ', message) AS errorMessage;
    END;

    -- Check if the commodity exists
    DELETE FROM commodity WHERE commodity_id = p_commodityId;
    
    SET rowsAffected = ROW_COUNT();

    IF rowsAffected > 0 THEN
        SELECT 'Commodity Deleted Successfully' AS message;
    ELSE
        SELECT 'Commodity not found.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteDocumentById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDocumentById`(
    IN inDocId INT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM documents WHERE doc_id = inDocId
    ) THEN
        DELETE FROM documents WHERE doc_id = inDocId;
        
        SELECT 
            'Document deleted successfully' AS message,
            TRUE AS status,
            inDocId AS docId;
    ELSE
        SELECT 
            'Document not found' AS message,
            FALSE AS status,
            inDocId AS docId;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DeleteEmployee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteEmployee`(
    IN empId INT
)
BEGIN
    DECLARE msg VARCHAR(255);
    DECLARE status INT;

    -- Delete employee
    DELETE FROM users WHERE employeeid = empId;

    -- Check if any rows were deleted
    IF ROW_COUNT() > 0 THEN
        SET msg = 'Employee deleted successfully';
        SET status = 1;
    ELSE
        SET msg = 'Employee not found or delete failed';
        SET status = 0;
    END IF;

    -- Return the result
    SELECT status AS result_status, msg AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `DeleteUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteUser`(
    IN p_userid INT
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Attempt to delete the user with the given userid
    DELETE FROM userdetails
    WHERE userid = p_userid;

    -- Check if a row was deleted
    IF ROW_COUNT() > 0 THEN
        SET message = 'User deleted successfully';
    ELSE
        SET message = 'User ID not found';
    END IF;

    -- Return the message
    SELECT message AS result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_billing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_billing`(
    IN p_billing_id VARCHAR(50)
)
BEGIN
    -- Ensure billing exists
    IF (SELECT COUNT(*) FROM billing WHERE billing_id = p_billing_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Billing ID not found';
    END IF;

    -- Delete billing
    DELETE FROM billing WHERE billing_id = p_billing_id;

    SELECT 'Success' AS Status, 'Billing deleted successfully' AS Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_commodity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_commodity`(
    IN p_commodity_id INT
)
BEGIN
    -- Ensure commodity exists
    IF (SELECT COUNT(*) FROM commodity WHERE commodity_id = p_commodity_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Commodity ID not found';
    END IF;

    -- Delete commodity from orders before deleting
    DELETE FROM order_items WHERE commodity_id = p_commodity_id;
    
    -- Delete commodity
    DELETE FROM commodity WHERE commodity_id = p_commodity_id;

    -- Recalculate billing
    CALL recalculate_billing_price();

    SELECT 'Success' AS Status, 'Commodity deleted successfully' AS Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_customer`(
    IN p_customer_id INT
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the customer exists
    IF EXISTS (SELECT 1 FROM customer WHERE customer_id = p_customer_id) THEN
        DELETE FROM customer WHERE customer_id = p_customer_id;
        SELECT 'Customer deleted successfully.' AS message;
    ELSE
        SELECT 'Error: Customer not found.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_order`(
    IN p_order_id INT
)
BEGIN
    -- Ensure order exists
    IF (SELECT COUNT(*) FROM orders WHERE order_id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- Delete the order (Cascade delete will remove order_items and billing)
    DELETE FROM orders WHERE order_id = p_order_id;

    SELECT 'Success' AS Status, 'Order deleted successfully' AS Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_order_and_billing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_order_and_billing`(
    IN p_order_id INT
)
BEGIN
    -- Step 1: Ensure order_id exists before deleting
    IF (SELECT COUNT(*) FROM orders WHERE order_id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order ID not found';
    END IF;

    -- Step 2: Delete the billing record using PRIMARY KEY
    DELETE FROM billing WHERE order_id = p_order_id;

    -- Step 3: Delete the order (ON DELETE CASCADE will remove order_items)
    DELETE FROM orders WHERE order_id = p_order_id;

    -- Step 4: Return success message
    SELECT 'Order and Billing Deleted Successfully' AS Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_order_commodity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_order_commodity`(
    IN p_order_id INT,
    IN p_commodity_id INT
)
BEGIN
    DECLARE rows_affected INT;

    -- Delete the commodity from the order
    DELETE FROM order_items 
    WHERE order_id = p_order_id AND commodity_id = p_commodity_id;

    -- Get number of affected rows
    SET rows_affected = ROW_COUNT();

    -- Return success message and IDs
    IF rows_affected > 0 THEN
        SELECT 'Success' AS status, p_order_id AS order_id, p_commodity_id AS commodity_id;
    ELSE
        SELECT 'No matching record found' AS status, NULL AS order_id, NULL AS commodity_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `edit_billing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_billing`(
    IN p_billing_id VARCHAR(50),
    IN p_payment_status ENUM('Pending', 'Paid', 'Failed', 'Refunded'),
    IN p_total_price DECIMAL(10,2)
)
BEGIN
    -- Ensure billing exists
    IF (SELECT COUNT(*) FROM billing WHERE billing_id = p_billing_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Billing ID not found';
    END IF;

    -- Update billing details
    UPDATE billing
    SET payment_status = p_payment_status, total_price = p_total_price
    WHERE billing_id = p_billing_id;

    SELECT 'Success' AS Status, 'Billing updated successfully' AS Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `edit_commodity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_commodity`(
    IN p_commodity_id INT,
    IN p_item_name VARCHAR(255),
    IN p_item_photo VARCHAR(255),
    IN p_new_price DECIMAL(10,2)
)
BEGIN
    DECLARE old_price DECIMAL(10,2);
    DECLARE commodity_exists INT;

    -- ✅ Ensure the commodity exists before updating
    SELECT COUNT(*) INTO commodity_exists 
    FROM `commodity` 
    WHERE `commodity_id` = TRIM(p_commodity_id);  -- Ensure no hidden characters

    IF commodity_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Commodity ID not found';
    END IF;

    -- ✅ Get the old price before updating
    SELECT price INTO old_price FROM `commodity` WHERE `commodity_id` = TRIM(p_commodity_id);

    -- ✅ Safe Update: Using PRIMARY KEY (`commodity_id`) in WHERE clause
    UPDATE `commodity` 
    SET item_name = p_item_name, 
        item_photo = p_item_photo, 
        price = p_new_price
    WHERE `commodity_id` = TRIM(p_commodity_id);

    -- ✅ If the price has changed, update order items and billing
    IF old_price <> p_new_price THEN
        CALL update_order_items_price(p_commodity_id, p_new_price);
    END IF;

    -- ✅ Return success message
    SELECT 'Success' AS Status, 'Commodity updated successfully' AS Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `edit_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_order`(
    IN p_order_id INT,
    IN new_sender_id INT,
    IN new_receiver_id INT,
    IN new_status ENUM('Pending', 'Processing', 'Completed', 'Cancelled')
)
BEGIN
    DECLARE error_message VARCHAR(255) DEFAULT NULL;
    DECLARE order_exists INT;

    -- ✅ Error Handler
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        SELECT 'Failure' AS Status, error_message AS Message;
    END;

    -- ✅ Check if the order exists
    SELECT COUNT(*) INTO order_exists FROM orders WHERE order_id = p_order_id;
    
    IF order_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- ✅ Update the order
    UPDATE orders 
    SET sender_id = new_sender_id,
        receiver_id = new_receiver_id,
        order_status = new_status,
        updated_at = CURRENT_TIMESTAMP
    WHERE order_id = p_order_id;

    -- ✅ Return success message
    SELECT 'Success' AS Status, 'Order Updated Successfully' AS Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `edit_order_and_billing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_order_and_billing`(
    IN p_order_id INT,
    IN p_sender_id INT,
    IN p_receiver_id INT,
    IN p_created_by INT,
    IN p_commodities JSON  -- JSON array of commodities (commodity_id, quantity, price)
)
BEGIN
    DECLARE total_price DECIMAL(10,2) DEFAULT 0;
    DECLARE i INT DEFAULT 0;
    DECLARE commodities_length INT;
    DECLARE commodity_id INT;
    DECLARE quantity INT;
    DECLARE price DECIMAL(10,2);

    -- Step 1: Ensure order_id exists before updating
    IF (SELECT COUNT(*) FROM orders WHERE order_id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Order ID not found';
    END IF;

    -- Step 2: Update order details using the PRIMARY KEY
    UPDATE orders
    SET sender_id = p_sender_id, receiver_id = p_receiver_id, updated_at = CURRENT_TIMESTAMP
    WHERE order_id = p_order_id;

    -- Step 3: Remove existing order items for this order
    DELETE FROM order_items WHERE order_id = p_order_id;

    -- Step 4: Insert updated commodities
    SET commodities_length = JSON_LENGTH(p_commodities);
    WHILE i < commodities_length DO
        SET commodity_id = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].commodity_id')));
        SET quantity = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].quantity')));
        SET price = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].price')));

        INSERT INTO order_items (order_id, commodity_id, quantity, total_price)
        VALUES (p_order_id, commodity_id, quantity, price * quantity);

        SET total_price = total_price + (price * quantity);
        SET i = i + 1;
    END WHILE;

    -- Step 5: Update billing total price using PRIMARY KEY
    UPDATE billing 
    SET total_price = total_price 
    WHERE order_id = p_order_id;

    -- Step 6: Return success message
    SELECT 'Order and Billing Updated Successfully' AS Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `edit_order_commodity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_order_commodity`(
    IN p_order_id INT,
    IN p_commodity_id INT,
    IN p_new_quantity INT,
    IN p_new_price DECIMAL(10,2)
)
BEGIN
    DECLARE old_total_price DECIMAL(10,2);
    DECLARE new_total_price DECIMAL(10,2);
    DECLARE item_exists INT;

    -- ✅ Check if the order and commodity exist
    SELECT COUNT(*) INTO item_exists 
    FROM order_items 
    WHERE order_id = p_order_id AND commodity_id = p_commodity_id;

    IF item_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Commodity not found in this order';
    END IF;

    -- ✅ Get the old total price
    SELECT total_price INTO old_total_price
    FROM order_items 
    WHERE order_id = p_order_id AND commodity_id = p_commodity_id;

    -- ✅ Calculate the new total price
    SET new_total_price = p_new_quantity * p_new_price;

    -- ✅ Update the order_items table
    UPDATE order_items
    SET quantity = p_new_quantity, 
        total_price = new_total_price
    WHERE order_id = p_order_id AND commodity_id = p_commodity_id;

    -- ✅ Update the billing total
    CALL recalculate_billing_price(p_order_id);

    -- ✅ Return success message
    SELECT 'Success' AS Status, 'Order commodity updated successfully' AS Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ForgotPassword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `ForgotPassword`(
    IN email VARCHAR(255),
    IN newPassword VARCHAR(255)
)
BEGIN
    DECLARE msg VARCHAR(255);
    DECLARE status INT;

    -- Update the password for the specified email
    UPDATE users
    SET employee_password = newPassword
    WHERE employee_email = email;

    -- Check if any rows were updated
    IF ROW_COUNT() > 0 THEN
        SET msg = 'Password updated successfully';
        SET status = 1;
    ELSE
        SET msg = 'Email not found or update failed';
        SET status = 0;
    END IF;

    -- Return the result
    SELECT status AS result_status, msg AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `generate_billing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_billing`(
    IN p_order_id INT,
    IN p_created_by INT,
    IN p_paid_by INT,
    IN p_outstanding_amount DECIMAL(10,2)
)
BEGIN
    DECLARE total_price DECIMAL(10,2) DEFAULT 0;
    DECLARE final_total_price DECIMAL(10,2) DEFAULT 0;
    DECLARE outstanding_price DECIMAL(10,2) DEFAULT 0;
    DECLARE billing_id VARCHAR(50);
    DECLARE customer_id INT;
    DECLARE error_message VARCHAR(255);

    -- ✅ Capture Duplicate Entry Error (Error Code 1062)
    DECLARE CONTINUE HANDLER FOR 1062 
    BEGIN
        SELECT 'Failure' AS Status, 'Error: Billing already exists for this Order ID' AS Message;
    END;

    -- ✅ General Error Handling for Other SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        SELECT 'Failure' AS Status, error_message AS Message;
    END;

    -- ✅ Check if Billing Already Exists for the Order
    IF EXISTS (SELECT 1 FROM billing WHERE order_id = p_order_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Billing already exists for this Order ID';
    END IF;

    -- ✅ Ensure `p_created_by` exists in `users`
    IF (SELECT COUNT(*) FROM users WHERE employeeid = p_created_by) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Created By User (employeeid) not found in users table';
    END IF;

    -- ✅ Ensure `p_paid_by` exists in `users`
    IF (SELECT COUNT(*) FROM users WHERE employeeid = p_paid_by) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Paid By User (employeeid) not found in users table';
    END IF;

    -- ✅ Fetch Customer ID from Order
    SELECT sender_id INTO customer_id FROM orders WHERE order_id = p_order_id;
    IF customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No customer linked to this order';
    END IF;

    -- ✅ Fetch Outstanding Amount from `customer` Table If Needed
    IF p_outstanding_amount = 0 THEN
        SELECT outstanding_price INTO outstanding_price 
        FROM moving_bazaar.customer 
        WHERE customer_id = customer_id
        LIMIT 1;
    ELSE
        SET outstanding_price = p_outstanding_amount;
    END IF;

    -- ✅ Ensure `order_id` Exists in `orders`
    IF (SELECT COUNT(*) FROM orders WHERE order_id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- ✅ Ensure `order_id` has Items in `order_items`
    IF (SELECT COUNT(*) FROM order_items WHERE order_id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No items found for this order. Please add items before generating billing.';
    END IF;

    -- ✅ Calculate Total Price from Order Items
    SELECT COALESCE(SUM(oi.quantity * c.price), 0) 
    INTO total_price 
    FROM order_items oi
    JOIN commodity c ON oi.commodity_id = c.commodity_id
    WHERE oi.order_id = p_order_id;

    -- ✅ Compute Final Total Price (Including Outstanding Amount)
    SET final_total_price = total_price + COALESCE(outstanding_price, 0);

    -- ✅ Generate Unique Billing ID (YYYYMMDD-OrderID)
    SET billing_id = CONCAT(DATE_FORMAT(NOW(), '%Y%m%d'), '-', p_order_id);

    -- ✅ Insert into `billing` Table (Handles Duplicate Entry with `1062`)
    INSERT INTO billing (billing_id, order_id, user_id, paid_by, total_price, payment_status)
    VALUES (billing_id, p_order_id, p_created_by, p_paid_by, final_total_price, 'Pending');

    -- ✅ **Return Success Response Only If INSERT Was Successful**
    IF ROW_COUNT() > 0 THEN
        SELECT 
            'Success' AS Status, 
            billing_id AS 'Billing ID', 
            p_order_id AS 'Order ID',
            p_paid_by AS 'Paid By',
            total_price AS 'Item Total Price', 
            COALESCE(outstanding_price, 0) AS 'Outstanding Amount',
            final_total_price AS 'Final Total Price';
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getAllReasons` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllReasons`()
BEGIN
    SELECT reasonid, reason
    FROM delivery_failure_reasons;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetBillingByEmployeeId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBillingByEmployeeId`(IN employee_id INT)
BEGIN
    SELECT 
        b.billing_id,
        b.order_id,
        o.created_by AS employee_id,
        sender.customer_id AS sender_id,
        sender.store_name AS sender_name,
        receiver.customer_id AS receiver_id,
        receiver.store_name AS receiver_name,
        b.user_id AS billed_user_id,
        b.paid_by,
        b.total_price,
        b.payment_status,
        b.created_at AS billing_created_at,
        b.receipt_pdf
    FROM billing b
    JOIN orders o ON b.order_id = o.order_id
    JOIN customer sender ON o.sender_id = sender.customer_id
    JOIN customer receiver ON o.receiver_id = receiver.customer_id
    WHERE o.created_by = employee_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getCommodities` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCommodities`()
BEGIN
    SELECT productid, productname, productdescription, unit_price, image, created_at
    FROM commodities;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getCommoditiesList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCommoditiesList`()
BEGIN
    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SELECT 'sqlError: Error occurred while fetching commodities' AS errorMessage;
    END;

    -- Fetch all commodities
    SELECT commodity_id AS commodityId,
           item_name AS itemName,
           item_photo AS itemPhoto,
           description AS description,
           min_order_qty AS minOrderQty,
           max_order_qty AS maxOrderQty,
           price,
           created_at AS createdAt
    FROM commodity;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getCommodityById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCommodityById`(
    IN p_commodityId INT
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Error Handling
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('sqlError: ', message) AS errorMessage;
    END;

    -- Check if the commodity exists
    IF EXISTS (SELECT 1 FROM commodity WHERE commodity_id = p_commodityId) THEN
        SELECT commodity_id AS commodityId,
               item_name AS itemName,
               item_photo AS itemPhoto,
               description AS description,
               min_order_qty AS minOrderQty,
               max_order_qty AS maxOrderQty,
               price,
               created_at AS createdAt
        FROM commodity
        WHERE commodity_id = p_commodityId;
    ELSE
        SELECT 'error: Commodity not found.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getCommodityDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCommodityDetails`(
    IN p_productid INT
)
BEGIN
    SELECT productid, productname, productdescription, unit_price, image, created_at
    FROM commodities
    WHERE productid = p_productid;
    
    IF ROW_COUNT() = 0 THEN
        SELECT 'Commodity not found' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetCustomerBalance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerBalance`(IN p_customer_id INT)
BEGIN
    DECLARE v_outstanding_price DECIMAL(10,2) DEFAULT 0.00;
    DECLARE v_created_at TIMESTAMP;
    DECLARE v_message VARCHAR(255) DEFAULT '';

    -- Error Handling
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SET v_message = 'SQL Error occurred';
        SELECT v_message AS error_message;
    END;

    -- Check if customer exists
    IF EXISTS (SELECT 1 FROM moving_bazaar.customer WHERE customer_id = p_customer_id) THEN
        -- Retrieve balance and timestamp
        SELECT outstanding_price, created_at
        INTO v_outstanding_price, v_created_at
        FROM moving_bazaar.customer 
        WHERE customer_id = p_customer_id
        LIMIT 1;

        -- Return result
        SELECT 
            p_customer_id AS customer_id,
            v_outstanding_price AS outstanding_balance;
    ELSE
        SET v_message = 'Error: Customer not found or no outstanding balance.';
        SELECT v_message AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetCustomers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomers`()
BEGIN
    SELECT 
        customer_id, 
        store_name, 
        email, 
        phone_number, 
        address_line1, 
        address_line2, 
        city, 
        created_at
    FROM customer;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getDocumentById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDocumentById`(
    IN inDocId INT
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM documents WHERE doc_id = inDocId AND path IS NOT NULL
    ) THEN
        SELECT 
            doc_id,
            order_id,
            catagory,
            path
        FROM documents
        WHERE doc_id = inDocId AND path IS NOT NULL;
    ELSE
        SELECT 
            'No document found' AS message,
            FALSE AS status,
            inDocId AS docId;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetDocumentsByOrderId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDocumentsByOrderId`(IN inOrderId INT)
BEGIN
    -- Return all documents and paths for the given order ID
    SELECT 
        d.doc_id AS docId,
        d.catagory AS category,
        JSON_ARRAYAGG(dp.path) AS paths
    FROM 
        documents d
    JOIN 
        document_paths dp ON d.doc_id = dp.doc_id
    WHERE 
        d.order_id = inOrderId
    GROUP BY 
        d.doc_id, d.catagory;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getDocumentsByOrderIdAndCatagory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDocumentsByOrderIdAndCatagory`(
    IN inOrderId INT,
    IN inCatagory ENUM('commodities', 'invoice')
)
BEGIN
    IF EXISTS (
        SELECT 1 FROM documents 
        WHERE order_id = inOrderId 
          AND catagory = inCatagory 
          AND path IS NOT NULL
    ) THEN
        SELECT 
            doc_id AS documentId,
            path AS documentName,
            catagory AS documentCategory,
			CONCAT('/orders/getdocumentfile/documents/', path) AS requestPath

        FROM documents
        WHERE order_id = inOrderId 
          AND catagory = inCatagory 
          AND path IS NOT NULL;
     
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrderAndStores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderAndStores`(IN inputOrderId INT)
BEGIN
    DECLARE vSenderId INT;
    DECLARE vReceiverId INT;
    DECLARE vOrderStatus VARCHAR(50);
    DECLARE vSenderStoreName VARCHAR(255);
    DECLARE vReceiverStoreName VARCHAR(255);
    DECLARE vReasonId INT;
    DECLARE vReasonText VARCHAR(255);

    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT JSON_OBJECT('error', 'An error occurred while executing the procedure.') AS result;
    END;

    -- Fetch order data including reason ID
    SELECT 
        sender_id, 
        receiver_id, 
        order_status, 
        reason_id
    INTO 
        vSenderId, 
        vReceiverId, 
        vOrderStatus, 
        vReasonId
    FROM moving_bazaar.orders 
    WHERE order_id = inputOrderId;

    -- Sender store name
    SELECT store_name
    INTO vSenderStoreName
    FROM moving_bazaar.customer 
    WHERE customer_id = vSenderId;

    -- Receiver store name
    SELECT store_name
    INTO vReceiverStoreName
    FROM moving_bazaar.customer 
    WHERE customer_id = vReceiverId;

    -- Reason text
    SELECT reason
    INTO vReasonText
    FROM moving_bazaar.delivery_failure_reasons 
    WHERE reasonid = vReasonId;

    -- Final flattened JSON object
    SELECT JSON_OBJECT(
        'orderId', inputOrderId,
        'orderStatus', vOrderStatus,
        'reasonId', vReasonId,
        'reason', vReasonText,
        'senderId', vSenderId,
        'senderStoreName', vSenderStoreName,
        'receiverId', vReceiverId,
        'receiverStoreName', vReceiverStoreName,
        'documents', (
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'documentId', d.doc_id,
                    'documentName', d.path,
                    'requestPath', d.path,
                    'uploadedAt', d.uploaded_at,
                    'category', d.catagory
                )
            )
            FROM moving_bazaar.documents d
            WHERE d.order_id = inputOrderId
        )
    ) AS result;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrderById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderById`(
    IN input_order_id INT
)
BEGIN
    -- Check if the order exists
    IF EXISTS (SELECT 1 FROM orders WHERE order_id = input_order_id) THEN
        -- Retrieve the specific order
        SELECT * FROM orders WHERE order_id = input_order_id;
    ELSE
        -- Return a message if the order is not found
        SELECT 'No order found with the given order_id' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrdercustomerDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrdercustomerDetails`(
    IN p_order_id INT
)
BEGIN
    DECLARE order_exists INT;

    -- Check if order exists
    SELECT COUNT(*) INTO order_exists FROM orders WHERE order_id = p_order_id;

    IF order_exists > 0 THEN
        SELECT sender_id, receiver_id 
        FROM orders 
        WHERE order_id = p_order_id;
    ELSE
        SELECT 'Order not found' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrderdeliveryDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderdeliveryDetails`(IN in_order_id VARCHAR(20))
BEGIN
    IF EXISTS (
        SELECT 1 FROM orders WHERE order_id = in_order_id
    ) THEN
        SELECT 
            o.order_id,
            o.order_status,
            sender.store_name AS sender_store_name,
            receiver.store_name AS receiver_store_name,
            b.delivery_date
        FROM 
            orders o
        JOIN 
            moving_bazaar.customer sender ON o.sender_id = sender.customer_id
        JOIN 
            moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
        LEFT JOIN 
            moving_bazaar.billing b ON o.order_id = b.order_id
        WHERE 
            o.order_id = in_order_id;
    ELSE
        SELECT 'No record found' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrderDetailsbyStagewise` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderDetailsbyStagewise`(
    IN p_order_id BIGINT, 
    IN p_stage VARCHAR(20)
)
BEGIN
    -- ORDER stage: Return customer details in camelCase
    IF p_stage = 'order' THEN
        SELECT 
            o.order_id,

            JSON_OBJECT(
                'customerId', sender.customer_id,
                'storeName', sender.store_name,
                'email', sender.email,
                'phoneNumber', sender.phone_number,
                'whatsappNumber', sender.whatsapp_number,
                'addressLine1', sender.address_line1,
                'addressLine2', sender.address_line2,
                'city', sender.city,
                'outstandingPrice', sender.outstanding_price,
                'createdAt', sender.created_at
            ) AS sender,

            JSON_OBJECT(
                'customerId', receiver.customer_id,
                'storeName', receiver.store_name,
                'email', receiver.email,
                'phoneNumber', receiver.phone_number,
                'whatsappNumber', receiver.whatsapp_number,
                'addressLine1', receiver.address_line1,
                'addressLine2', receiver.address_line2,
                'city', receiver.city,
                'outstandingPrice', receiver.outstanding_price,
                'createdAt', receiver.created_at
            ) AS receiver

        FROM moving_bazaar.orders o
        JOIN moving_bazaar.customer sender  
            ON o.sender_id = sender.customer_id
        JOIN moving_bazaar.customer receiver  
            ON o.receiver_id = receiver.customer_id
        WHERE o.order_id = p_order_id;

    -- COMMODITY stage: Return full commodity details in camelCase
    ELSEIF p_stage = 'commodity' THEN
        SELECT 
    oi.order_id,
    JSON_ARRAYAGG(
        JSON_OBJECT(
            'commodityId', c.commodity_id,
            'itemName', c.item_name,
            'itemPhoto', c.item_photo,
            'description', c.description,
            'minOrderQty', c.min_order_qty,
            'maxOrderQty', c.max_order_qty,
            'price', CAST(c.price AS DECIMAL(10,2)),
            'createdAt', c.created_at,
            'quantity', oi.quantity,
            'totalPrice', CAST(oi.total_price AS DECIMAL(10,2))
        )
    ) AS commodities,
    (
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'documentId', d.doc_id,
                'documentName', d.path,
                'requestPath', d.path,
                'uploadedAt', d.uploaded_at,
                'category', d.catagory
            )
        )
        FROM moving_bazaar.documents d
        WHERE d.order_id = oi.order_id
    ) AS documents
FROM moving_bazaar.order_items oi
JOIN moving_bazaar.commodity c 
    ON oi.commodity_id = c.commodity_id
WHERE oi.order_id = p_order_id
GROUP BY oi.order_id;

    END IF;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getOrderDetailsByStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getOrderDetailsByStatus`(
    IN inOrderStatus VARCHAR(20),
    IN inOrderId VARCHAR(50),
    IN inPageNumber INT,
    IN inPageSize INT
)
BEGIN
    DECLARE offsetVal INT;

    -- Calculate offset for pagination
    SET offsetVal = (inPageNumber - 1) * inPageSize;

    -- First: return the total count of matching records
    SELECT 
        COUNT(*) AS totalRecords
    FROM 
        orders o
    JOIN 
        moving_bazaar.customer sender ON o.sender_id = sender.customer_id
    JOIN 
        moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
    LEFT JOIN 
        moving_bazaar.billing b ON o.order_id = b.order_id
    WHERE 
        (inOrderStatus IS NULL OR inOrderStatus = '' OR o.order_status = inOrderStatus)
        AND (inOrderId IS NULL OR inOrderId = '' OR o.order_id LIKE CONCAT('%', inOrderId, '%'));

    -- Second: return paginated results
    SELECT 
        o.order_id AS orderId,
        o.order_status AS orderStatus,
        sender.store_name AS senderName,
        receiver.store_name AS receiverName,
        b.delivery_date AS deliveryDate,
        sender.address_line1 As senderAddressLine1,
        sender.address_line2 As senderAddressLine2,
        sender.city As senderCity,
        receiver.address_line1 As receiverAddressLine1,
        receiver.address_line2 As receiverAddressLine2,
        receiver.city As receiverCity
        
    FROM 
        orders o
    JOIN 
        moving_bazaar.customer sender ON o.sender_id = sender.customer_id
    JOIN 
        moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
    LEFT JOIN 
        moving_bazaar.billing b ON o.order_id = b.order_id
    WHERE 
        (inOrderStatus IS NULL OR inOrderStatus = '' OR o.order_status = inOrderStatus)
        AND (inOrderId IS NULL OR inOrderId = '' OR o.order_id LIKE CONCAT('%', inOrderId, '%'))
    LIMIT offsetVal, inPageSize;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrderDetailsStage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderDetailsStage`(IN p_order_id BIGINT, IN p_stage VARCHAR(20))
BEGIN
    -- Order Stage
    IF p_stage = 'order' THEN
        SELECT sender_id, receiver_id 
        FROM moving_bazaar.orders 
        WHERE order_id = p_order_id;
    
    -- Commodity (Executive) Stage
    ELSEIF p_stage = 'commodity' THEN
        SELECT 
            commodity.item_name, 
            order_items.quantity, 
            order_items.total_price  
        FROM 
            moving_bazaar.order_items 
        INNER JOIN 
            moving_bazaar.commodity 
        ON 
            order_items.commodity_id = commodity.commodity_id 
        WHERE 
            order_items.order_id = p_order_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrders` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrders`()
BEGIN
    -- Check if there are any orders
    IF EXISTS (SELECT 1 FROM orders) THEN
        -- Retrieve all orders
        SELECT * FROM orders;
    ELSE
        -- Return a message if no orders exist
        SELECT 'No orders found' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrdersByCreator` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrdersByCreator`(IN creator_id INT)
BEGIN
    SELECT 
        o.order_id, 
        o.sender_id, 
        sender.store_name AS sender_name,
        o.receiver_id, 
        receiver.store_name AS receiver_name,
        o.created_by, 
        u.username AS created_by_user,
        o.order_status, 
        o.created_at, 
        o.updated_at
    FROM orders o
    JOIN customer sender ON o.sender_id = sender.customer_id
    JOIN customer receiver ON o.receiver_id = receiver.customer_id
    JOIN users u ON o.created_by = u.employeeid
    WHERE o.created_by = creator_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrdersByEmployeeId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrdersByEmployeeId`(IN employee_id INT)
BEGIN
    SELECT 
        o.order_id,
        sender.customer_id AS sender_id,
        sender.store_name AS sender_name,
        receiver.customer_id AS receiver_id,
        receiver.store_name AS receiver_name,
        o.order_status,
        o.stage,
        o.created_at,
        o.updated_at
    FROM orders o
    JOIN customer sender ON o.sender_id = sender.customer_id
    JOIN customer receiver ON o.receiver_id = receiver.customer_id
    WHERE o.created_by = employee_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrdersByStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrdersByStatus`(
    IN input_status ENUM('Not Delivered', 'In Transit', 'Picked Up', 'Delivered')
)
BEGIN
    -- Retrieve orders matching the specified status
    SELECT * FROM orders WHERE status = input_status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getOrdersByUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getOrdersByUser`(
    IN p_user_id INT
)
BEGIN
    SELECT * FROM orders WHERE created_by = p_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrderSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderSummary`(IN p_order_id INT)
BEGIN
    SELECT 
        o.order_id AS orderId,
        sender.store_name AS senderName,
        sender.customer_id AS senderId,
        receiver.store_name AS receiverName,
        receiver.customer_id AS receiverId,
        
        -- Commodity details as a JSON array
        (
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'itemName', c.item_name,
                    'quantity', oi.quantity,
                    'price', c.price,
                    'totalPrice', oi.quantity * c.price
                )
            )
            FROM moving_bazaar.order_items oi
            JOIN moving_bazaar.commodity c ON oi.commodity_id = c.commodity_id
            WHERE oi.order_id = p_order_id
        ) AS commodities

  
    FROM moving_bazaar.orders o
    JOIN moving_bazaar.customer sender ON o.sender_id = sender.customer_id
    JOIN moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
    WHERE o.order_id = p_order_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOutstandingBalanceByCustomer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOutstandingBalanceByCustomer`(IN p_customer_id INT)
BEGIN
    -- Check if the customer has any outstanding balance
    -- IF NOT EXISTS (SELECT 1 FROM moving_bazaar.outstanding_balance WHERE customer_id = p_customer_id and status = 'open') THEN
        -- Return a message if no outstanding balance is found
    --    SELECT 'No outstanding balance found for this customer.' AS message;
    -- ELSE
        -- Return the outstanding balance details
        SELECT 
            outstanding_id, 
            customer_id, 
            order_id, 
            outstanding_amount, 
            created_at ,
            status
        FROM moving_bazaar.outstanding_balance
        WHERE customer_id = p_customer_id;
    -- END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getReasonById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getReasonById`(IN input_id INT)
BEGIN
    SELECT reasonid as Reasonid, reason as Reason
    FROM delivery_failure_reasons
    WHERE reasonid = input_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetUserById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserById`(IN empId INT)
BEGIN
    SELECT 
        employeeid, 
        employee_full_name, 
        employee_email, 
        employee_phone_number, 
        employee_profile_photo, 
        employee_is_admin, 
        created_at 
    FROM users
    WHERE employeeid = empId;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getUserOrdersByStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserOrdersByStatus`(
    IN p_user_id INT, 
    IN p_order_status VARCHAR(50)
)
BEGIN
    SELECT * FROM orders 
    WHERE created_by = p_user_id 
      AND order_status = p_order_status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetUsers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUsers`()
BEGIN
    SELECT 
        employeeid, 
        employee_full_name, 
        employee_email, 
        employee_phone_number, 
        employee_profile_photo, 
        employee_is_admin, 
        created_at 
    FROM users;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_billing_by_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_billing_by_customer`(
    IN p_customer_id INT
)
BEGIN
    SELECT 
        b.billing_id, b.order_id, o.sender_id, o.receiver_id, b.total_price, b.payment_status, b.created_at
    FROM billing b
    JOIN orders o ON b.order_id = o.order_id
    WHERE o.sender_id = p_customer_id OR o.receiver_id = p_customer_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_billing_by_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_billing_by_order`(
    IN p_order_id INT
)
BEGIN
    SELECT 
        b.billing_id, b.order_id, b.user_id, b.total_price, b.payment_status, b.created_at
    FROM billing b
    WHERE b.order_id = p_order_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_commodities_by_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_commodities_by_customer`(
    IN p_customer_id INT
)
BEGIN
    SELECT 
        oi.commodity_id, c.item_name, c.item_photo, SUM(oi.quantity) AS total_quantity, SUM(oi.total_price) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN commodity c ON oi.commodity_id = c.commodity_id
    WHERE o.sender_id = p_customer_id OR o.receiver_id = p_customer_id
    GROUP BY oi.commodity_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_commodities_by_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_commodities_by_user`(
    IN p_user_id INT
)
BEGIN
    SELECT 
        oi.commodity_id, c.item_name, c.item_photo, SUM(oi.quantity) AS total_quantity, SUM(oi.total_price) AS total_spent
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN commodity c ON oi.commodity_id = c.commodity_id
    WHERE o.created_by = p_user_id
    GROUP BY oi.commodity_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_commodities_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_commodities_list`()
BEGIN
    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        SELECT 'SQL Error occurred while fetching commodities' AS message;
    END;

    -- Fetch all commodities with price as DOUBLE
    SELECT 
        commodity_id, 
        item_name, 
        item_photo, 
        min_order_qty, 
        max_order_qty, 
        CAST(price AS DOUBLE) AS price, 
        created_at 
    FROM commodity;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_commodity_by_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_commodity_by_id`(
    IN p_commodity_id INT
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Error Handling
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the commodity exists
    IF EXISTS (SELECT 1 FROM commodity WHERE commodity_id = p_commodity_id) THEN
        SELECT commodity_id, item_name, item_photo, min_order_qty, max_order_qty, price, created_at
        FROM commodity
        WHERE commodity_id = p_commodity_id;
    ELSE
        SELECT 'Error: Commodity not found.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_customer_by_phone` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_customer_by_phone`(
    IN p_phone_number VARCHAR(15)
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the customer exists
IF EXISTS (SELECT 1 FROM customer WHERE phone_number = p_phone_number) THEN
    SELECT 
        customer_id AS customerId,
        store_name AS storeName,
        email AS email,
        phone_number AS phoneNumber,
        whatsapp_number AS whatsappNumber,
        address_line1 AS addressLine1,
        address_line2 AS addressLine2,
        city AS city,
        outstanding_price AS outstandingPrice,
        created_at AS createdAt
    FROM customer
    WHERE phone_number = p_phone_number;
ELSE
    SELECT 'Error: Customer not found.' AS message;
END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_order`(
    IN p_order_id INT
)
BEGIN
    -- Ensure order exists
    IF (SELECT COUNT(*) FROM orders WHERE order_id = p_order_id) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- Retrieve order details
    SELECT 
        o.order_id, o.sender_id, o.receiver_id, o.created_by, o.order_status, o.created_at, o.updated_at,
        SUM(oi.total_price) AS total_price
    FROM orders o
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_id = p_order_id
    GROUP BY o.order_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_orders_by_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_orders_by_customer`(
    IN p_customer_id INT
)
BEGIN
    SELECT 
        order_id, sender_id, receiver_id, created_by, order_status, created_at, updated_at
    FROM orders
    WHERE sender_id = p_customer_id OR receiver_id = p_customer_id
    ORDER BY created_at DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_orders_by_date` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_orders_by_date`(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT 
        order_id, sender_id, receiver_id, created_by, order_status, created_at, updated_at
    FROM orders
    WHERE DATE(created_at) BETWEEN p_start_date AND p_end_date
    ORDER BY created_at DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_orders_by_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_orders_by_user`(
    IN p_user_id INT
)
BEGIN
    SELECT 
        order_id, sender_id, receiver_id, order_status, created_at, updated_at
    FROM orders
    WHERE created_by = p_user_id
    ORDER BY created_at DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_order_commodities` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_order_commodities`(
    IN p_order_id INT
)
BEGIN
    SELECT 
        oi.commodity_id, c.item_name, c.item_photo, oi.quantity, oi.total_price
    FROM order_items oi
    JOIN commodity c ON oi.commodity_id = c.commodity_id
    WHERE oi.order_id = p_order_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_order_details` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_order_details`(
    IN p_order_id INT
)
BEGIN
    DECLARE order_exists INT;

    -- ✅ Check if order exists
    SELECT COUNT(*) INTO order_exists FROM orders WHERE order_id = p_order_id;
    IF order_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- ✅ First Result Set: Order Details (Includes Sender & Receiver Info)
    SELECT 
        o.order_id,
        o.sender_id,
        s.store_name AS sender_name,
        o.receiver_id,
        r.store_name AS receiver_name,
        o.created_by,
        u.employee_full_name AS created_by_name,
        o.order_status,
        o.created_at,
        o.updated_at,
        COALESCE(SUM(oi.quantity * c.price), 0) AS total_price
    FROM orders o
    LEFT JOIN customer s ON o.sender_id = s.customer_id  -- ✅ Get sender info
    LEFT JOIN customer r ON o.receiver_id = r.customer_id  -- ✅ Get receiver info
    LEFT JOIN users u ON o.created_by = u.employeeid  -- ✅ Get created by user info
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
    LEFT JOIN commodity c ON oi.commodity_id = c.commodity_id
    WHERE o.order_id = p_order_id
    GROUP BY o.order_id;

    -- ✅ Second Result Set: Billing Details (If Exists)
    SELECT 
        b.billing_id,
        b.total_price AS billing_total_price,
        b.payment_status,
        b.created_at AS billing_created_at
    FROM billing b
    WHERE b.order_id = p_order_id;

    -- ✅ Third Result Set: Order Items
    SELECT 
        oi.order_item_id,
        oi.commodity_id,
        c.item_name AS commodity_name,
        oi.quantity,
        c.price AS price,
        oi.quantity * c.price AS subtotal
    FROM order_items oi
    JOIN commodity c ON oi.commodity_id = c.commodity_id
    WHERE oi.order_id = p_order_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertBillingDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertBillingDetails`(
    IN p_order_id INT,
    IN p_user_id INT,
    IN p_paid_by INT,
    IN p_total_price DECIMAL(10,2),
    IN p_payment_status VARCHAR(50),
    IN p_created_at DATETIME,
    IN p_receipt_pdf TEXT,
    IN p_amount_paid DECIMAL(10,2),
    IN p_delivery_date DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Error handler block
        ROLLBACK;
        SELECT 
            NULL AS billing_id,
            'Failure' AS Status,
            'An error occurred while inserting billing record' AS Message;
    END;

    -- Start transaction (optional but good practice)
    START TRANSACTION;

    -- Insert into billing table
    INSERT INTO billing (
        order_id,
        user_id,
        paid_by,
        total_price,
        payment_status,
        created_at,
        receipt_pdf,
        amount_paid,
        delivery_date
    )
    VALUES (
        p_order_id,
        p_user_id,
        p_paid_by,
        p_total_price,
        p_payment_status,
        p_created_at,
        p_receipt_pdf,
        p_amount_paid,
        p_delivery_date
    );

    -- Commit transaction
    COMMIT;

    -- Return success with billing_id
    SELECT 
        LAST_INSERT_ID() AS billing_id,
        'Success' AS Status,
        'Billing record inserted successfully' AS Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertCommodity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCommodity`(
    IN p_itemName VARCHAR(255),
    IN p_itemPhoto VARCHAR(255),
    IN p_description TEXT,
    IN p_minOrderQty INT,
    IN p_maxOrderQty INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    DECLARE newCommodityId INT;
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('sqlError: ', message) AS errorMessage;
    END;

    -- Check if the commodity already exists
    IF EXISTS (SELECT 1 FROM commodity WHERE item_name = p_itemName) THEN
        SELECT 'error: Commodity already exists with the same name.' AS message;
    ELSE
        -- Insert New Commodity and get inserted ID
        INSERT INTO commodity (item_name, item_photo, description, min_order_qty, max_order_qty, price)
        VALUES (p_itemName, p_itemPhoto, p_description, p_minOrderQty, p_maxOrderQty, p_price);

        -- Retrieve the last inserted commodity ID
        SET newCommodityId = LAST_INSERT_ID();

        -- Return commodityId along with success message
        SELECT newCommodityId AS commodityId, 'commodityInsertedSuccessfully' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insertDocument` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertDocument`(
    IN inOrderId INT,
    IN inPaths JSON,
    IN inCatagory ENUM('commodities', 'invoice')
)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE pathCount INT;
    DECLARE path VARCHAR(1024);
    DECLARE docId INT;

    CREATE TEMPORARY TABLE temp_doc_info (
        document_id INT,
        document_name VARCHAR(1024),
        document_category VARCHAR(50)
    );

    SET pathCount = JSON_LENGTH(inPaths);

    WHILE i < pathCount DO
        SET path = JSON_UNQUOTE(JSON_EXTRACT(inPaths, CONCAT('$[', i, ']')));

        INSERT INTO documents (order_id, catagory, path)
        VALUES (inOrderId, inCatagory, path);

        SET docId = LAST_INSERT_ID();

        INSERT INTO temp_doc_info (document_id, document_name, document_category)
        VALUES (docId, path, inCatagory);

        SET i = i + 1;
    END WHILE;

    -- Return one row per document
    SELECT 
        document_id AS documentId,
        document_name AS documentName,
        document_category AS documentCategory,
        CONCAT('/orders/getdocumentfile/documents/', document_name) AS requestPath
    FROM temp_doc_info;

    DROP TEMPORARY TABLE IF EXISTS temp_doc_info;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertEmployee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertEmployee`(
    IN fullName VARCHAR(255),
    IN email VARCHAR(255),
    IN phoneNumber VARCHAR(15),
    IN password VARCHAR(255),
    IN profilePhoto VARCHAR(255),
    IN isAdmin BOOLEAN
)
BEGIN
    DECLARE msg VARCHAR(255);
    DECLARE status INT;

    -- Error handler to catch exceptions
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET msg = 'Failed to insert employee due to a database error';
        SET status = 0;
        -- Exit the procedure early to avoid executing further statements
        SELECT status AS result_status, msg AS message;
    END;

    -- Try to insert employee
    INSERT INTO users (employee_full_name, employee_email, employee_phone_number, employee_password, employee_profile_photo, employee_is_admin)
    VALUES (fullName, email, phoneNumber, password, profilePhoto, isAdmin);

    -- If no error occurs
    SET msg = 'Employee inserted successfully';
    SET status = 1;

    -- Return the result
    SELECT status AS result_status, msg AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertOrderWithCommodities` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertOrderWithCommodities`(
    IN sender_id INT,
    IN receiver_id INT,
    IN commodities TEXT -- JSON string containing commodity_id, quantity, and price
)
BEGIN
    DECLARE total_order_amount DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE new_order_id INT;
    DECLARE current_commodity_id INT;
    DECLARE current_quantity INT;
    DECLARE current_price DECIMAL(10, 2);
    DECLARE current_total_price DECIMAL(10, 2);

    -- Insert into the orders table
    INSERT INTO orders (sender_customer_id, receiver_customer_id, total_amount)
    VALUES (sender_id, receiver_id, 0);

    -- Get the last inserted order ID
    SET new_order_id = LAST_INSERT_ID();

    -- Loop through the JSON string to extract and process each commodity
    WHILE LENGTH(commodities) > 0 DO
        -- Extract current commodity_id, quantity, and price using JSON functions
        SET current_commodity_id = CAST(JSON_EXTRACT(commodities, '$[0].commodity_id') AS UNSIGNED);
        SET current_quantity = CAST(JSON_EXTRACT(commodities, '$[0].quantity') AS UNSIGNED);
        SET current_price = CAST(JSON_EXTRACT(commodities, '$[0].price') AS DECIMAL(10, 2));

        -- Calculate total price for the current commodity
        SET current_total_price = current_quantity * current_price;

        -- Insert into order_commodities table
        INSERT INTO order_commodities (order_id, commodity_id, quantity, total_price)
        VALUES (new_order_id, current_commodity_id, current_quantity, current_total_price);

        -- Add to the total order amount
        SET total_order_amount = total_order_amount + current_total_price;

        -- Remove the first element from the JSON array
        SET commodities = JSON_REMOVE(commodities, '$[0]');
    END WHILE;

    -- Update total amount in orders table
    UPDATE orders
    SET total_amount = total_order_amount
    WHERE order_id = new_order_id;

    -- Return the new order ID
    SELECT new_order_id AS order_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertOrderWithProducts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertOrderWithProducts`(
    IN sender_id INT,
    IN receiver_id INT,
    IN products JSON,
    IN initial_status ENUM('Not Delivered', 'In Transit', 'Picked Up', 'Delivered')
)
BEGIN
    DECLARE total_order_amount DECIMAL(10, 2) DEFAULT 0.00;
    DECLARE new_order_id INT;
    DECLARE current_productid INT;
    DECLARE current_quantity INT;
    DECLARE current_price DECIMAL(10, 2);
    DECLARE current_total_price DECIMAL(10, 2);

    -- Insert into the orders table with the provided status
    INSERT INTO orders (sender_customer_id, receiver_customer_id, total_amount, status)
    VALUES (sender_id, receiver_id, 0, initial_status);

    -- Get the last inserted order ID
    SET new_order_id = LAST_INSERT_ID();

    -- Loop through the JSON string to extract and process each product
    WHILE JSON_LENGTH(products) > 0 DO
        SET current_productid = CAST(JSON_UNQUOTE(JSON_EXTRACT(products, '$[0].productid')) AS UNSIGNED);
        SET current_quantity = CAST(JSON_UNQUOTE(JSON_EXTRACT(products, '$[0].quantity')) AS UNSIGNED);
        SET current_price = CAST(JSON_UNQUOTE(JSON_EXTRACT(products, '$[0].price')) AS DECIMAL(10, 2));

        -- Calculate total price for the product
        SET current_total_price = current_quantity * current_price;

        -- Insert into order_commodities table
        INSERT INTO order_commodities (order_id, productid, quantity, total_price)
        VALUES (new_order_id, current_productid, current_quantity, current_total_price);

        -- Add to the total order amount
        SET total_order_amount = total_order_amount + current_total_price;

        -- Remove the first element from the JSON array
        SET products = JSON_REMOVE(products, '$[0]');
    END WHILE;

    -- Update the total amount in the orders table
    UPDATE orders
    SET total_amount = total_order_amount
    WHERE order_id = new_order_id;

    -- Return the new order ID
    SELECT new_order_id AS order_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertOutstandingBalance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertOutstandingBalance`(
    IN p_customer_id INT,
    IN p_order_id INT,
    IN p_outstanding_amount DECIMAL(10,2)
)
BEGIN
    DECLARE new_outstanding_id INT;

    -- Check if customer_id exists
    IF NOT EXISTS (SELECT 1 FROM moving_bazaar.customer WHERE customer_id = p_customer_id) THEN
        SELECT 'Error: Customer ID does not exist.' AS message, NULL AS outstanding_id;

    ELSEIF NOT EXISTS (SELECT 1 FROM moving_bazaar.orders WHERE order_id = p_order_id) THEN
        SELECT 'Error: Order ID does not exist.' AS message, NULL AS outstanding_id;

    ELSE
        -- Insert record with default status 'open'
        INSERT INTO moving_bazaar.outstanding_balance (
            customer_id, 
            order_id, 
            outstanding_amount, 
            status
        )
        VALUES (
            p_customer_id, 
            p_order_id, 
            p_outstanding_amount, 
            'open'
        );
        
        -- Get the last inserted outstanding_id
        SET new_outstanding_id = LAST_INSERT_ID();
        
        -- Return success message and new outstanding_id
        SELECT 'Success: Outstanding balance inserted.' AS message, new_outstanding_id AS outstanding_id;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `InsertUserDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertUserDetails`(
    IN p_username VARCHAR(100),
    IN p_phonenumber VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_photo VARCHAR(255)  -- Photo as a parameter
)
BEGIN
    DECLARE phone_exists INT;

    -- Check if the phone number already exists
    SELECT COUNT(*) INTO phone_exists
    FROM userdetails
    WHERE phonenumber = p_phonenumber;

    IF phone_exists > 0 THEN
        SELECT 'Phone number already exists.' AS message;
    ELSE
        -- Insert the new user record
        INSERT INTO userdetails (username, phonenumber, email, password, photo, created_at)
        VALUES (p_username, p_phonenumber, p_email, p_password, p_photo, NOW());

        SELECT 'User successfully inserted.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_billing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_billing`(
    IN p_order_id INT,
    IN p_employee_id INT,
    IN p_paid_by INT,
    IN p_grand_total DECIMAL(10,2),
    IN p_current_order_value DECIMAL(10,2),
    IN p_total_amount_paid DECIMAL(10,2),
    IN p_current_order_amount_paid DECIMAL(10,2),
    IN p_outstanding_amount_paid DECIMAL(10,2),
    IN p_closed_outstanding_order_ids JSON,
    IN p_delivery_date DATE
)
BEGIN
    DECLARE v_payment_status ENUM('Pending', 'Paid', 'Partial');
    DECLARE idx INT DEFAULT 0;
    DECLARE arr_length INT;
    DECLARE billing_id INT;

    -- 1. Determine payment status
    IF p_current_order_amount_paid >= p_current_order_value THEN
        SET v_payment_status = 'Paid';
    ELSEIF p_current_order_amount_paid = 0 THEN
        SET v_payment_status = 'Pending';
    ELSE
        SET v_payment_status = 'Partial';
    END IF;

    -- 2. Insert into billing table
    INSERT INTO billing (
        order_id,
        employee_id,
        paid_by,
        total_price,
        grand_total,
        total_amount_paid,
        amount_paid,
        outstanding_amount_paid,
        closed_outstanding_order_ids,
        payment_status,
        delivery_date
    )
    VALUES (
        p_order_id,
        p_employee_id,
        p_paid_by,
        p_current_order_value,
        p_grand_total,
        p_total_amount_paid,
        p_current_order_amount_paid,
        p_outstanding_amount_paid,
        p_closed_outstanding_order_ids,
        v_payment_status,
        p_delivery_date
    );

    -- Retrieve the billing_id of the last inserted row
    SET billing_id = LAST_INSERT_ID();

    -- 3. Close any order IDs from the JSON array
    SET arr_length = JSON_LENGTH(p_closed_outstanding_order_ids);
    WHILE idx < arr_length DO
        SET @order_to_close = JSON_UNQUOTE(JSON_EXTRACT(p_closed_outstanding_order_ids, CONCAT('$[', idx, ']')));

        -- Corrected value to 'close' (instead of 'closed')
        UPDATE moving_bazaar.outstanding_balance
        SET status = 'close', updated_at = NOW()
        WHERE order_id = @order_to_close;

        SET idx = idx + 1;
    END WHILE;

    -- 4. Optionally close the current order_id if amounts are non-zero
    IF p_current_order_value != 0 AND p_current_order_amount_paid != 0 THEN
        -- Corrected value to 'close' (instead of 'closed')
        UPDATE moving_bazaar.outstanding_balance
        SET status = 'close', updated_at = NOW()
        WHERE order_id = p_order_id;
    END IF;

    -- 5. Return success message, billing ID, and order ID
    SELECT 'Billing successfully inserted.' AS message, billing_id, p_order_id as order_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_commodity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_commodity`(
    IN p_item_name VARCHAR(255),
    IN p_item_photo VARCHAR(255),
    IN p_description TEXT,
    IN p_min_order_qty INT,
    IN p_max_order_qty INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the commodity already exists
    IF EXISTS (SELECT 1 FROM commodity WHERE item_name = p_item_name) THEN
        SELECT 'Error: Commodity already exists with the same name.' AS message;
    ELSE
        -- Insert New Commodity with description
        INSERT INTO commodity (item_name, item_photo, description, min_order_qty, max_order_qty, price)
        VALUES (p_item_name, p_item_photo, p_description, p_min_order_qty, p_max_order_qty, p_price);

        SELECT 'Commodity inserted successfully.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_commodity_photos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_commodity_photos`(
    IN p_order_id INT,
    IN p_photo_paths JSON  -- JSON array of photo paths
)
BEGIN
    DECLARE order_exists INT;
    DECLARE error_message VARCHAR(255) DEFAULT NULL;

    -- ✅ Error Handler for SQL Exceptions
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        SELECT 'Failure' AS Status, error_message AS Message;
    END;

    -- ✅ Step 1: Ensure `order_id` exists before inserting photos
    SELECT COUNT(*) INTO order_exists FROM orders WHERE order_id = p_order_id;
    IF order_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID does not exist';
    END IF;

    -- ✅ Step 2: Insert multiple photo paths as JSON
    INSERT INTO commodities_photos (order_id, photo_paths)
    VALUES (p_order_id, p_photo_paths);

    -- ✅ If SQL error occurred earlier, return failure response
    IF error_message IS NOT NULL THEN
        SELECT 'Failure' AS Status, error_message AS Message;
    ELSE
        -- ✅ Return success message
        SELECT 'Success' AS Status, 'Photos inserted successfully' AS Message, p_photo_paths AS 'Inserted Photos';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_customer`(
    IN p_store_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phone_number VARCHAR(15),
    IN p_whatsapp_number VARCHAR(15),
    IN p_address_line1 VARCHAR(255),
    IN p_address_line2 VARCHAR(255),
    IN p_city VARCHAR(100),
    IN p_outstanding_price DECIMAL(10,2)
)
BEGIN
    DECLARE new_customer_id INT;
    DECLARE existing_customer_id INT;
    DECLARE sql_error VARCHAR(255);

    -- Error Handling
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 sql_error = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', sql_error) AS errorMessage;
    END;

    -- ✅ Check if customer already exists
    SELECT customer_id INTO existing_customer_id 
    FROM customer 
    WHERE phone_number = p_phone_number 
    LIMIT 1;

    -- ✅ If customer exists, return duplicate message
    IF existing_customer_id IS NOT NULL THEN
        SELECT existing_customer_id AS customerId, 'Duplicate entry: Customer already exists.' AS message;
    ELSE
        -- ✅ Insert new customer
        INSERT INTO customer (store_name, email, phone_number, whatsapp_number, address_line1, address_line2, city, outstanding_price)
        VALUES (p_store_name, p_email, p_phone_number, p_whatsapp_number, p_address_line1, p_address_line2, p_city, p_outstanding_price);

        -- ✅ Retrieve the last inserted customer_id
        SET new_customer_id = LAST_INSERT_ID();

        -- ✅ Return success message
        SELECT new_customer_id AS customerId, 'Customer inserted successfully.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `LoginEmployee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `LoginEmployee`(
    IN input_email VARCHAR(255),
    IN input_password VARCHAR(255)
)
BEGIN
    DECLARE emp_id INT;
    DECLARE emp_email VARCHAR(255);
    DECLARE username VARCHAR(255);
    DECLARE login_status INT;
    DECLARE login_message VARCHAR(255);

    -- Check if user exists
    SELECT employeeid, employee_email, employee_full_name
    INTO emp_id, emp_email, username
    FROM users
    WHERE employee_email = input_email 
      AND BINARY employee_password = input_password -- Ensure case-sensitive comparison for passwords
    LIMIT 1;

    -- Verify if a match was found
    IF ROW_COUNT() > 0 THEN
        SET login_status = 1;
        SET login_message = 'Login successful';
    ELSE
        SET login_status = 0;
        SET emp_id = NULL;
        SET emp_email = NULL;
        SET username = NULL;
        SET login_message = 'Invalid email or password';
    END IF;

    -- Return the result
    SELECT login_status AS result_status, 
           emp_id AS employee_id, 
           emp_email AS email, 
           login_message AS message,
           username AS userName;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `recalculate_billing_price` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `recalculate_billing_price`(
    IN p_order_id INT
)
BEGIN
    DECLARE new_total DECIMAL(10,2);

    -- ✅ Calculate new total price
    SELECT COALESCE(SUM(total_price), 0)
    INTO new_total 
    FROM order_items 
    WHERE order_id = p_order_id;

    -- ✅ Update the billing total price
    UPDATE billing
    SET total_price = new_total
    WHERE order_id = p_order_id;

    SELECT 'Success' AS Status, 'Billing total updated successfully' AS Message, new_total AS NewTotalPrice;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateAdminPassword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateAdminPassword`(
    IN p_auserid INT,          -- Admin user ID
    IN p_new_password VARCHAR(255) -- New password
)
BEGIN
    -- Update the password and the updated_at timestamp
    UPDATE moving_bazaar.adminuser
    SET 
        password = p_new_password,
        created_at = NOW()
    WHERE auserid = p_auserid;

    -- Check if the row was updated
    IF ROW_COUNT() > 0 THEN
        SELECT 'Password updated successfully.' AS message;
    ELSE
        SELECT 'Admin user ID not found.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateCommodity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCommodity`(
    IN p_commodityId INT,
    IN p_itemName VARCHAR(255),
    IN p_itemPhoto VARCHAR(255),
    IN p_description TEXT,
    IN p_minOrderQty INT,
    IN p_maxOrderQty INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    DECLARE message VARCHAR(255);
    DECLARE rowsAffected INT DEFAULT 0;

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('sqlError: ', message) AS errorMessage;
    END;

    -- Check if the commodity exists
    IF EXISTS (SELECT 1 FROM commodity WHERE commodity_id = p_commodityId) THEN
        -- Prevent duplicate item name
        IF EXISTS (SELECT 1 FROM commodity WHERE item_name = p_itemName AND commodity_id <> p_commodityId) THEN
            SELECT 'error: Another commodity with the same name exists.' AS message;
        ELSE
            -- Update the commodity record
            UPDATE commodity
            SET 
                item_name = COALESCE(p_itemName, item_name),
                item_photo = COALESCE(p_itemPhoto, item_photo),
                description = COALESCE(p_description, description),
                min_order_qty = COALESCE(p_minOrderQty, min_order_qty),
                max_order_qty = COALESCE(p_maxOrderQty, max_order_qty),
                price = COALESCE(p_price, price)
            WHERE commodity_id = p_commodityId;

            SET rowsAffected = ROW_COUNT();

            IF rowsAffected > 0 THEN
                SELECT 'Commodity Updated Successfully' AS message ,p_commodityId As commodityId;
            ELSE
                SELECT 'No changes were made.' AS message;
            END IF;
        END IF;
    ELSE
        SELECT ' Commodity not found.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateEmployee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateEmployee`(
    IN empId INT,
    IN fullName VARCHAR(255),
    IN email VARCHAR(255),
    IN phoneNumber VARCHAR(15),
    IN password VARCHAR(255),
    IN profilePhoto VARCHAR(255),
    IN isAdmin BOOLEAN
)
BEGIN
    DECLARE msg VARCHAR(255);
    DECLARE status INT;

    -- Update employee details
    UPDATE users
    SET 
        employee_full_name = fullName,
        employee_email = email,
        employee_phone_number = phoneNumber,
        employee_password = password,
        employee_profile_photo = profilePhoto,
        employee_is_admin = isAdmin
    WHERE employeeid = empId;

    -- Check if any rows were updated
    IF ROW_COUNT() > 0 THEN
        SET msg = 'Employee updated successfully';
        SET status = 1;
    ELSE
        SET msg = 'Employee not found or update failed';
        SET status = 0;
    END IF;

    -- Return the result
    SELECT status AS result_status, msg AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateOrder` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateOrder`(
    IN input_order_id INT,
    IN sender_id INT,
    IN receiver_id INT,
    IN new_total_amount DECIMAL(10, 2),
    IN new_status ENUM('Not Delivered', 'In Transit', 'Picked Up', 'Delivered')
)
BEGIN
    -- Attempt to update the order
    UPDATE orders
    SET sender_customer_id = sender_id,
        receiver_customer_id = receiver_id,
        total_amount = new_total_amount,
        status = new_status -- Update the status column
    WHERE order_id = input_order_id; -- Use the input parameter in the WHERE clause

    -- Check if any rows were updated
    IF ROW_COUNT() > 0 THEN
        SELECT 'Order updated successfully' AS message;
    ELSE
        SELECT 'No order found with the given order_id' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateOrderDeliveryStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateOrderDeliveryStatus`(
    IN in_order_id BIGINT,
    IN in_new_status VARCHAR(50)
)
BEGIN
    DECLARE msg VARCHAR(255);

    IF EXISTS (SELECT 1 FROM orders WHERE order_id = in_order_id) THEN
        -- Perform the update
        UPDATE orders
        SET 
            order_status = in_new_status,
            updated_at = NOW()
        WHERE 
            order_id = in_order_id;

        SET msg = CONCAT('Order ID ', in_order_id, ' status updated to "', in_new_status, '"');
    ELSE
        SET msg = CONCAT('Order ID ', in_order_id, ' not found');
    END IF;

    -- Return the message
    SELECT msg AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateOrderStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateOrderStatus`(
    IN input_order_id INT,
    IN new_status ENUM('Not Delivered', 'In Transit', 'Picked Up', 'Delivered')
)
BEGIN
    -- Attempt to update the order status
    UPDATE orders
    SET status = new_status
    WHERE order_id = input_order_id;

    -- Check if the status was updated
    IF ROW_COUNT() > 0 THEN
        SELECT 'Order status updated successfully' AS message;
    ELSE
        SELECT 'No order found with the given order_id' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateOrderStatusAndReason` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateOrderStatusAndReason`(
    IN p_order_id BIGINT,
    IN p_order_status VARCHAR(255),
    IN p_reason_id INT
)
BEGIN
    UPDATE moving_bazaar.orders
    SET 
        order_status = p_order_status,
        reason_id = p_reason_id,
        updated_at = NOW()
    WHERE order_id = p_order_id;

    IF ROW_COUNT() > 0 THEN
        SELECT 'updated successfully.' AS message, p_order_id AS orderId;
    ELSE
        SELECT 'not found or no changes made.' AS message, p_order_id AS orderId;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateUserDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateUserDetails`(
    IN p_userid INT,
    IN p_username VARCHAR(100),
    IN p_phonenumber VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_photo VARCHAR(255) -- Add photo as a parameter
)
BEGIN
    DECLARE phone_exists INT;
    DECLARE changes_needed INT;

    -- Check if the phone number already exists for another user
    SELECT COUNT(*) INTO phone_exists
    FROM userdetails
    WHERE phonenumber = p_phonenumber AND userid != p_userid;

    IF phone_exists > 0 THEN
        SELECT 'Phone number already exists for another user.' AS message;
    ELSE
        -- Check if any changes are required by comparing input values with existing values
        SELECT 
            CASE 
                WHEN username = p_username AND 
                     phonenumber = p_phonenumber AND 
                     email = p_email AND 
                     password = p_password AND
                     photo = p_photo THEN 0
                ELSE 1
            END INTO changes_needed
        FROM userdetails
        WHERE userid = p_userid;

        IF changes_needed = 0 THEN
            SELECT 'No changes detected in user details.' AS message;
        ELSE
            -- Update the user details if changes are detected
            UPDATE userdetails
            SET 
                username = p_username,
                phonenumber = p_phonenumber,
                email = p_email,
                password = p_password,
                photo = p_photo, -- Update photo
                created_at = NOW()
            WHERE userid = p_userid;

            IF ROW_COUNT() > 0 THEN
                SELECT 'User details updated successfully.' AS message;
            ELSE
                SELECT 'Error updating user details.' AS message;
            END IF;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_billing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_billing`(
    IN p_billing_id VARCHAR(50),
    IN p_paid_by INT,
    IN p_total_price DECIMAL(10,2),
    IN p_payment_status ENUM('Pending', 'Paid', 'Failed', 'Refunded')
)
BEGIN
    DECLARE billing_exists INT;

    -- ✅ Check if Billing ID Exists
    SELECT COUNT(*) INTO billing_exists FROM billing WHERE billing_id = p_billing_id;
    
    IF billing_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Billing ID not found';
    END IF;

    -- ✅ Update Billing Record
    UPDATE billing 
    SET 
        paid_by = p_paid_by,
        total_price = p_total_price,
        payment_status = p_payment_status
    WHERE billing_id = p_billing_id;

    -- ✅ Return Success Message
    SELECT 
        'Success' AS Status, 
        p_billing_id AS 'Billing ID', 
        p_paid_by AS 'Paid By',
        p_total_price AS 'Updated Total Price', 
        p_payment_status AS 'Updated Payment Status';

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_billing_by_order` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_billing_by_order`(
    IN p_order_id INT,
    IN p_paid_by INT,
    IN p_total_price DECIMAL(10,2),
    IN p_payment_status ENUM('Pending', 'Paid', 'Failed', 'Refunded')
)
BEGIN
    DECLARE billing_exists INT;
    DECLARE billing_id VARCHAR(50);
    DECLARE error_message VARCHAR(255);

    -- ✅ Check if the Order ID has a Billing Record
    SELECT billing_id INTO billing_id FROM billing WHERE order_id = p_order_id LIMIT 1;

    IF billing_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No billing record found for this Order ID';
    END IF;

    -- ✅ Update Billing Details
    UPDATE billing 
    SET 
        paid_by = p_paid_by,
        total_price = p_total_price,
        payment_status = p_payment_status
    WHERE order_id = p_order_id;

    -- ✅ Confirm Update Success
    IF ROW_COUNT() > 0 THEN
        SELECT 
            'Success' AS Status, 
            billing_id AS 'Billing ID',
            p_order_id AS 'Order ID',
            p_paid_by AS 'Updated Paid By',
            p_total_price AS 'Updated Total Price',
            p_payment_status AS 'Updated Payment Status';
    ELSE
        SELECT 'Error' AS Status, 'Update Failed. No changes made.' AS Message;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_customer`(
    IN p_customer_id INT,
    IN p_store_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_whatsapp_number VARCHAR(15),
    IN p_address_line1 VARCHAR(255),
    IN p_address_line2 VARCHAR(255),
    IN p_city VARCHAR(100),
    IN p_outstanding_price DECIMAL(10,2)
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the customer exists
    IF EXISTS (SELECT 1 FROM customer WHERE customer_id = p_customer_id) THEN
        -- Update the customer record
        UPDATE customer
        SET 
            store_name = IFNULL(p_store_name, store_name),
            email = IFNULL(p_email, email),
            whatsapp_number = IFNULL(p_whatsapp_number, whatsapp_number),
            address_line1 = IFNULL(p_address_line1, address_line1),
            address_line2 = IFNULL(p_address_line2, address_line2),
            city = IFNULL(p_city, city),
            outstanding_price = IFNULL(p_outstanding_price, outstanding_price)
        WHERE customer_id = p_customer_id;

        SELECT 'Customer updated successfully.' AS message;
    ELSE
        SELECT 'Error: Customer not found.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_customer_balance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_customer_balance`(
    IN p_customer_id INT,
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if balance exists
    IF EXISTS (SELECT 1 FROM customer_balance WHERE customer_id = p_customer_id) THEN
        -- Update balance
        UPDATE customer_balance
        SET outstanding_balance = outstanding_balance + p_amount
        WHERE customer_id = p_customer_id;

        SET message = 'Customer balance updated successfully.';
    ELSE
        -- Insert new balance entry
        INSERT INTO customer_balance (customer_id, outstanding_balance)
        VALUES (p_customer_id, p_amount);

        SET message = 'New balance entry created successfully.';
    END IF;

    -- Return Message
    SELECT message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_order_items_price` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_order_items_price`(
    IN p_commodity_id INT,
    IN p_new_price DECIMAL(10,2)
)
BEGIN
    -- Update order_items with new total price
    UPDATE order_items
    SET total_price = quantity * p_new_price
    WHERE commodity_id = p_commodity_id;

    -- Recalculate billing for affected orders
    CALL recalculate_billing_price();

    SELECT 'Success' AS Status, 'Order items updated successfully' AS Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_order_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_order_status`(
    IN p_order_id INT,
    IN p_order_status ENUM('Pending', 'Confirmed', 'Shipped', 'Delivered', 'Cancelled')
)
BEGIN
    DECLARE message VARCHAR(255);

    -- Error Handling
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Update Order Status
    UPDATE orders
    SET order_status = p_order_status
    WHERE order_id = p_order_id;

    -- Success Message
    SELECT 'Order status updated successfully.' AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_receipt_pdf` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_receipt_pdf`(
    IN p_order_id INT,
    IN p_receipt_pdf VARCHAR(255)
)
BEGIN
    DECLARE billing_exists INT;

    -- ✅ Check if Billing Exists for Given Order ID
    SELECT COUNT(*) INTO billing_exists FROM billing WHERE order_id = p_order_id;
    
    IF billing_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: No billing record found for this Order ID';
    END IF;

    -- ✅ Update the Receipt PDF Path
    UPDATE billing 
    SET receipt_pdf = p_receipt_pdf
    WHERE order_id = p_order_id;

    -- ✅ Return Success Message
    SELECT 
        'Success' AS Status, 
        p_order_id AS 'Order ID',
        p_receipt_pdf AS 'Updated Receipt PDF Path';

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `VerifyUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `VerifyUser`(
    IN p_user_input VARCHAR(255), 
    IN p_password VARCHAR(255)
)
BEGIN
    SELECT * 
    FROM moving_bazaar.users 
    WHERE (employee_email = p_user_input AND employee_password = p_password) 
       OR (employee_phone_number = p_user_input AND employee_password = p_password) 
       OR (employee_full_name = p_user_input AND employee_password = p_password);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-04  0:21:39
