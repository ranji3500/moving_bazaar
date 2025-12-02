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
  `payment_status` enum('Pending','Paid') DEFAULT 'Pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `receipt_pdf` varchar(255) DEFAULT NULL,
  `delivery_date` date DEFAULT NULL,
  PRIMARY KEY (`billing_id`),
  UNIQUE KEY `order_id_UNIQUE` (`order_id`),
  KEY `billing_ibfk_2` (`employee_id`),
  KEY `billing_ibfk_3` (`paid_by`),
  CONSTRAINT `billing_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  CONSTRAINT `billing_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `users` (`employeeid`),
  CONSTRAINT `billing_ibfk_3` FOREIGN KEY (`paid_by`) REFERENCES `customer` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing`
--

LOCK TABLES `billing` WRITE;
/*!40000 ALTER TABLE `billing` DISABLE KEYS */;
INSERT INTO `billing` VALUES (23,42465129,1,5,41960.00,41960.00,41960.00,41960.00,0.00,'[]','Paid','2025-06-01 14:33:45',NULL,'2025-06-01'),(24,4140411,1,5,3996.00,3996.00,3996.00,3996.00,0.00,'[]','Paid','2025-06-16 15:16:06',NULL,'2025-06-16'),(25,50093252,1,5,10200.00,10200.00,10200.00,10200.00,0.00,'[]','Paid','2025-06-29 15:02:52',NULL,'2025-06-29'),(30,177730,1,5,10200.00,10200.00,10200.00,10200.00,0.00,'[]','Paid','2025-06-30 15:31:39',NULL,'2025-06-30'),(32,48123420,10,31,5240.00,5240.00,5240.00,5240.00,0.00,'[]','Paid','2025-07-20 02:27:15',NULL,'2025-07-20'),(33,8304319,10,5,180.00,180.00,180.00,180.00,0.00,'[]','Pending','2025-07-20 12:42:51',NULL,'2025-07-21'),(34,56223511,10,5,8700.00,8700.00,8700.00,8700.00,0.00,'[]','Paid','2025-07-25 16:30:20',NULL,'2025-07-30'),(35,22309698,10,33,90.00,90.00,90.00,90.00,0.00,'[]','Paid','2025-08-16 06:52:57',NULL,'2025-08-16'),(36,7256551,10,38,90.00,90.00,90.00,90.00,0.00,'[]','Paid','2025-08-24 14:41:38',NULL,'2025-08-24');
/*!40000 ALTER TABLE `billing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `city`
--

DROP TABLE IF EXISTS `city`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `city` (
  `c_id` int NOT NULL AUTO_INCREMENT,
  `cityname` varchar(145) DEFAULT NULL,
  `is_service` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`c_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `city`
--

LOCK TABLES `city` WRITE;
/*!40000 ALTER TABLE `city` DISABLE KEYS */;
INSERT INTO `city` VALUES (1,'Abu Dhabi',1,'2025-06-29 09:37:31'),(2,'Dubai',0,'2025-06-29 09:37:31'),(3,'Sharjah',1,'2025-06-29 09:37:31'),(4,'Al Ain',0,'2025-06-29 09:37:31'),(5,'Ajman',0,'2025-06-29 09:37:31'),(6,'Fujairah',0,'2025-06-29 09:37:31'),(7,'Ras Al Khaimah',0,'2025-06-29 09:37:31'),(8,'Umm Al Quwain',0,'2025-06-29 09:37:31');
/*!40000 ALTER TABLE `city` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=343 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commodity`
--

LOCK TABLES `commodity` WRITE;
/*!40000 ALTER TABLE `commodity` DISABLE KEYS */;
INSERT INTO `commodity` VALUES (311,'Fruits','commodity_ee65bfa73dfa44b3a253e48d5db2fe1b.png','',1,50,70.00,'2025-05-10 06:30:00'),(312,'Vegetables','commodity_5d84aa44879649b797a42f4e7b6cc96a.png','',1,50,45.00,'2025-05-10 06:31:00'),(313,'Kids Bicycle','kids_bicycle_v2.jpg','Updated kids bicycle',1,5,5100.00,'2025-05-10 06:32:00'),(314,'Electric Kettle','electric_kettle.jpg','Convenient appliance for boiling water quickly',1,20,999.00,'2025-05-10 06:33:00'),(315,'Notebooks Pack','notebooks.jpg','Set of ruled notebooks for school or office use',1,100,300.00,'2025-05-10 06:34:00'),(316,'Dining Table','dining_table.jpg','Sturdy wooden dining table ideal for families',1,3,8500.00,'2025-05-10 06:35:00'),(317,'Curtains Set','curtains.jpg','Decorative curtains set for home interiors',1,25,1200.00,'2025-05-10 06:36:00'),(318,'Toiletries Pack','toiletries.jpg','Daily essentials including soap, shampoo, and toothpaste',1,100,500.00,'2025-05-10 06:37:00'),(319,'Mixer Grinder','commodity_902387454c574e8e9f0e3a08c3f1661e.png','',1,15,2800.00,'2025-05-10 06:38:00'),(320,'Fitness Dumbbells','dumbbells.jpg','Adjustable dumbbells suitable for home workouts',1,20,1500.00,'2025-05-10 06:39:00'),(321,'Mattress','mattress.jpg','Comfortable foam mattress for quality sleep',1,10,5200.00,'2025-05-10 06:40:00'),(322,'Ceiling Fan','ceiling_fan.jpg','Energy-efficient ceiling fan with modern design',1,20,1800.00,'2025-05-10 06:41:00'),(323,'LED Bulb Set','led_bulbs.jpg','Pack of long-lasting energy-saving LED bulbs',1,100,800.00,'2025-05-10 06:42:00'),(324,'Water Bottle','bottle.jpg','Reusable plastic water bottle for daily hydration',1,200,120.00,'2025-05-10 06:43:00'),(325,'Laptop Stand','laptop_stand.jpg','Ergonomic stand to elevate laptop for comfortable viewing',1,50,750.00,'2025-05-10 06:44:00'),(326,'Cooking Oil','cooking_oil.jpg','Refined cooking oil suitable for everyday use',1,100,150.00,'2025-05-10 06:45:00'),(327,'Washing Powder','washing_powder.jpg','Effective detergent powder for all fabrics',1,75,350.00,'2025-05-10 06:46:00'),(328,'Garden Tools Kit','garden_tools.jpg','Set of tools for basic home gardening tasks',1,20,1400.00,'2025-05-10 06:47:00'),(329,'Pillows','pillows.jpg','Soft cotton pillows suitable for all bed types',1,60,250.00,'2025-05-10 06:48:00'),(331,'Home Decor Lights','decor_lights.jpg','String lights for decoration during events or festivals',1,80,950.00,'2025-05-10 06:50:00'),(332,'Kids Bicyced','kids_bicycle_v2.jpg','Updated description for kids bicycle',1,5,508.00,'2025-05-10 06:51:00'),(333,'Plastic Storage Box','storage_box.jpg','Multipurpose storage container with lid',1,75,180.00,'2025-05-10 06:52:00'),(334,'Hand Sanitizer','sanitizer.jpg','Alcohol-based hand sanitizer for hygiene',1,200,110.00,'2025-05-10 06:53:00'),(335,'Extension Cord','extension_cord.jpg','5-socket extension board with surge protection',1,40,450.00,'2025-05-10 06:54:00'),(336,'USB Flash Drive','usb.jpg','32GB USB flash drive for portable storage',1,100,420.00,'2025-05-10 06:55:00'),(337,'Wall Paint','wall_paint.jpg','Interior wall paint with smooth finish',1,30,2200.00,'2025-05-10 06:56:00'),(338,'Rechargeable Torch','torch.jpg','Long-lasting LED torch with rechargeable battery',1,50,850.00,'2025-05-10 06:57:00'),(339,'Yoga Mat','yoga_mat.jpg','Non-slip yoga mat for home workouts and stretching',1,60,750.00,'2025-05-10 06:58:00'),(340,'Mobile Charger','mobile_charger.jpg','Fast-charging adapter compatible with all smartphones',1,100,399.00,'2025-05-10 06:59:00'),(341,'Premium Basmati Rice','basmati.jpg','Long-grain aged rice for premium customers',10,100,120.00,'2025-06-29 03:47:14'),(342,'Premium Basmati Rice21',NULL,'Long-grain aged rice for premium customers',10,100,120.00,'2025-07-22 23:36:38');
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
  `is_deleted` tinyint(1) DEFAULT '0',
  `employeeid` int DEFAULT NULL,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone_number` (`phone_number`),
  KEY `fk_employee` (`employeeid`),
  CONSTRAINT `fk_employee` FOREIGN KEY (`employeeid`) REFERENCES `users` (`employeeid`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (5,'Vignesh Store','vignesh@example.com','12345678','12345678','123 Street','Area A','New York',1000.50,'2025-02-07 00:03:17',0,1),(31,'Spice Junction','spice.junction@exampljue.com','87654321','87654321','21, Linking Road','Bandra','Mumbai',12000.75,'2025-03-15 18:39:54',0,1),(33,'Vision Hardware','vision@example.com','9876543210','9876543210','No.12, Main Street','Near Bus Stop','Chennai',0.00,'2025-06-29 15:25:28',0,1),(37,'ranjith','ranji3500@gmail.com','123655478','','3kjghggfdgdfdffd','fgtdsdf','Downtown Dubai',10.10,'2025-07-25 16:46:33',0,10),(38,'nelllai sweets','nellai@gmail.com','123455677','','qwerdfdfgddg','chennaui','Mirdif',10.10,'2025-07-25 16:49:26',0,10),(39,'Green Ma','greeat@example.com','99887966','99887796','12 Park Street','Near Metro','Chennai',5000.75,'2025-07-27 14:55:34',0,NULL),(40,'Green efgMa','greeadgt@example.com','90887966','99387796','12 Park Street','Near Metro','Chennai',0.00,'2025-07-27 14:59:27',1,1),(41,'Kannan Store','kannan@example.com','98768943210','9876540210','Street 1','Area 2','Chennai',500.00,'2025-07-27 15:15:54',0,1),(43,'ar store','ranjii@gmail.com','1987456321','','cvbnm,','dfgh','Dubai Marina',10.10,'2025-07-27 19:33:15',0,30);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer_auth`
--

DROP TABLE IF EXISTS `customer_auth`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer_auth` (
  `auth_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`auth_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `customer_auth_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer_auth`
--

LOCK TABLES `customer_auth` WRITE;
/*!40000 ALTER TABLE `customer_auth` DISABLE KEYS */;
INSERT INTO `customer_auth` VALUES (1,33,'$2b$12$examplehashedpasswordhere','2025-06-29 20:55:28');
/*!40000 ALTER TABLE `customer_auth` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `delivery_details`
--

DROP TABLE IF EXISTS `delivery_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `delivery_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `status` enum('Picked Up','In Transit','Retained','Delivered') NOT NULL,
  `status_time` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_delivery_order_id` (`order_id`),
  CONSTRAINT `fk_delivery_order_id` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `delivery_details`
--

LOCK TABLES `delivery_details` WRITE;
/*!40000 ALTER TABLE `delivery_details` DISABLE KEYS */;
INSERT INTO `delivery_details` VALUES (1,177730,'Picked Up','2024-01-27 10:00:00'),(2,177730,'In Transit','2024-01-28 10:05:00'),(3,177730,'Retained','2024-01-28 11:32:00'),(4,177730,'Delivered','2024-01-28 12:00:00'),(5,318126,'Picked Up','2024-02-01 09:30:00'),(6,318126,'In Transit','2024-02-02 13:15:00'),(7,318126,'Retained','2024-02-02 15:00:00'),(8,318126,'Delivered','2024-02-02 18:45:00'),(9,4140411,'Picked Up','2024-03-05 08:00:00'),(10,4140411,'In Transit','2024-03-06 10:30:00'),(11,4140411,'Delivered','2024-03-06 13:00:00'),(12,8304319,'Picked Up','2025-08-15 21:55:50'),(13,8304319,'In Transit','2024-04-11 09:00:00'),(14,8304319,'Delivered','2025-08-17 15:28:22'),(15,10561754,'Picked Up','2024-05-12 11:00:00'),(16,10561754,'In Transit','2024-05-13 08:45:00'),(17,10561754,'Retained','2024-05-13 09:10:00'),(18,19042874,'Picked Up','2024-06-01 07:30:00'),(19,19042874,'In Transit','2024-06-02 10:00:00'),(20,32549917,'Picked Up','2024-07-15 15:00:00'),(21,32549917,'In Transit','2024-07-16 10:00:00'),(22,32549917,'Delivered','2024-07-16 18:00:00'),(23,56223511,'Picked Up','2025-08-16 11:49:59'),(24,56223511,'Retained','2025-07-28 01:38:47'),(25,56223511,'Delivered','2025-08-16 11:51:44');
/*!40000 ALTER TABLE `delivery_details` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=118 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES (79,10561754,'10561754_commodities_f389380e2f8543aea7961a04434a1c01.jpg','2025-05-26 16:43:59','commodities'),(80,19042874,'19042874_commodities_56d3a9cd91d644918953c3f847185fa7.jpg','2025-05-26 16:49:17','commodities'),(81,19042874,'19042874_commodities_5941a41d10144f03af3dcef1f02c6088.jpg','2025-05-26 16:56:54','commodities'),(82,32549917,'32549917_commodities_326a0e63a04b496fa282c969da3fd297.jpg','2025-05-26 17:03:12','commodities'),(83,32549917,'32549917_commodities_ba0e48ff946743b4bda544f344221384.jpg','2025-05-26 17:31:07','commodities'),(84,38471864,'38471864_commodities_e27197809dd5495a868742bef5913f4b.jpg','2025-05-29 02:08:59','commodities'),(85,42465129,'42465129_commodities_4b62adf1ce394b94b24f50707e06ed22.jpg','2025-05-29 17:13:03','commodities'),(86,42465129,'42465129_commodities_29842e15b3044a96950267f108bf2c66.jpg','2025-05-29 17:41:32','commodities'),(87,4140411,'4140411_commodities_2c178795ad2b4967a62eba56d38ee43b.png','2025-06-01 14:34:31','commodities'),(88,50093252,'50093252_commodities_30d71a83df784cb08d56fab99e0468ae.png','2025-06-29 14:51:34','commodities'),(89,177730,'177730_commodities_c533487f5a38445caa4bfa7018067219.png','2025-06-30 15:31:08','commodities'),(90,48123420,'48123420_commodities_da927c0b580241c380f06a22f3861a5f.png','2025-07-20 02:19:10','commodities'),(91,48123420,'48123420_commodities_ad07d5ac037342059001f35256ed7e9f.png','2025-07-20 02:19:10','commodities'),(92,48379489,'48379489_commodities_9e9949c17d10480c8a084d1d26c5b861.png','2025-07-20 12:34:16','commodities'),(93,48379489,'48379489_commodities_961b38d070d34758bd3e9365a77b55e1.png','2025-07-20 12:35:21','commodities'),(94,8304319,'8304319_commodities_f9a2e97d4b71497fa3fe74baa880441b.jpg','2025-07-20 12:42:26','commodities'),(95,8304319,'8304319_commodities_dc7bf045818946c4b2a0b4b43bff84c8.png','2025-07-20 12:42:26','commodities'),(96,8304319,'8304319_commodities_c9fdb606788c4aaabafdad6163a89f2d.png','2025-07-20 12:42:26','commodities'),(97,46318748,'46318748_commodities_16d52acdac874178b9fbfc163efffb58.jpg','2025-07-20 12:43:28','commodities'),(101,56223511,'56223511_commodities_e2988c2154d34e049ffc5f914f73bedc.png','2025-07-25 16:29:53','commodities'),(102,56223511,'56223511_commodities_24d41960175f44ef89751fa138d5a131.png','2025-07-25 16:29:53','commodities'),(103,22086905,'22086905_commodities_b63dfa8b09634135b5e4b03a03f5bc5b.jpeg','2025-07-25 16:52:37','commodities'),(104,44539641,'44539641_commodities_46666289c83b4da1a83e5f68fe817a15.jpeg','2025-07-25 16:53:35','commodities'),(105,42465129,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(106,4140411,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(107,50093252,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(108,177730,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(109,48123420,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(110,8304319,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(111,56223511,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(112,5002208,'5002208_commodities_cdaa259cfe8e498f9b7b3f9b46478ee9.png','2025-07-27 19:36:32','commodities'),(113,5002208,'5002208_commodities_b7105c256a1d4e2fa103ba8ef8a8bb4e.png','2025-07-27 19:36:57','commodities'),(114,38442863,'38442863_commodities_c646443e4ffd49f58c69864b1276c3c1.png','2025-07-31 14:56:46','commodities'),(115,37405863,'37405863_commodities_5f7f601a6e0a476bab8339e26ea18749.png','2025-07-31 14:57:25','commodities'),(116,7256551,'7256551_commodities_975cae8ee4eb4c018539191e3bf8f30c.png','2025-08-24 14:38:30','commodities'),(117,7256551,'7256551_commodities_ce323a64812643edb53ae61233eb7f1a.png','2025-08-24 14:39:03','commodities');
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item_delete_log`
--

DROP TABLE IF EXISTS `order_item_delete_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_delete_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `commodity_id` int DEFAULT NULL,
  `deleted_by` int DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL,
  PRIMARY KEY (`log_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item_delete_log`
--

LOCK TABLES `order_item_delete_log` WRITE;
/*!40000 ALTER TABLE `order_item_delete_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_item_delete_log` ENABLE KEYS */;
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
  `created_by` int DEFAULT NULL,
  PRIMARY KEY (`order_item_id`),
  KEY `commodity_id` (`commodity_id`),
  KEY `fk_order_items_order` (`order_id`),
  CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`commodity_id`) REFERENCES `commodity` (`commodity_id`)
) ENGINE=InnoDB AUTO_INCREMENT=132 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (102,42465129,313,2,10400.00,'2025-05-29 17:39:35',NULL),(103,42465129,313,2,10400.00,'2025-05-29 17:40:29',NULL),(104,42465129,313,2,10400.00,'2025-05-29 17:40:43',NULL),(105,42465129,313,2,10400.00,'2025-05-29 17:41:02',NULL),(106,42465129,312,2,90.00,'2025-05-29 17:41:34',NULL),(107,42465129,312,2,90.00,'2025-05-29 17:41:36',NULL),(108,42465129,312,2,90.00,'2025-05-29 17:41:44',NULL),(109,42465129,312,2,90.00,'2025-05-29 17:42:11',NULL),(110,4140411,314,2,1998.00,'2025-06-01 14:34:35',NULL),(111,4140411,314,2,1998.00,'2025-06-01 14:34:47',NULL),(112,50023588,311,3,360.00,'2025-06-22 10:12:09',1),(113,50023588,312,2,120.00,'2025-06-22 10:12:09',1),(114,50023588,311,3,360.00,'2025-06-22 10:12:27',1),(115,50023588,312,2,120.00,'2025-06-22 10:12:27',1),(116,50093252,313,2,10200.00,'2025-06-29 14:51:39',1),(117,177730,313,2,10200.00,'2025-06-30 15:31:12',1),(118,48123420,311,2,140.00,'2025-07-20 02:20:31',10),(119,48123420,313,1,5100.00,'2025-07-20 02:20:31',10),(120,48379489,312,2,90.00,'2025-07-20 12:35:28',10),(121,8304319,312,4,180.00,'2025-07-20 12:42:33',10),(122,46318748,312,2,90.00,'2025-07-20 12:43:30',10),(123,56223511,313,1,5100.00,'2025-07-25 16:30:00',10),(124,56223511,317,3,3600.00,'2025-07-25 16:30:00',10),(125,22086905,315,3,900.00,'2025-07-25 16:52:43',10),(126,44539641,316,1,8500.00,'2025-07-25 16:53:39',10),(127,5002208,312,3,135.00,'2025-07-27 19:37:06',30),(128,38442863,313,2,10200.00,'2025-07-31 14:56:52',10),(129,37405863,313,1,5100.00,'2025-07-31 14:57:28',10),(130,22309698,312,2,90.00,'2025-08-16 06:52:44',10),(131,7256551,312,2,90.00,'2025-08-24 14:39:56',10);
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
INSERT INTO `orders` VALUES (177730,5,31,1,'In Transit','billing','2025-06-30 15:30:17','2025-06-30 15:31:12',NULL,NULL),(318126,5,31,1,'In Transit','commodity','2025-05-26 17:30:31','2025-05-26 17:30:31',NULL,NULL),(4140411,5,31,1,'In Transit','billing','2025-06-01 14:34:14','2025-06-01 14:34:35',NULL,NULL),(5002208,43,5,30,'In Transit','billing','2025-07-27 19:35:00','2025-07-27 19:37:06',NULL,NULL),(7256551,38,43,10,'In Transit','billing','2025-08-24 14:37:25','2025-08-24 14:39:56',NULL,NULL),(8304319,5,31,10,'Delivered','billing','2025-07-20 12:38:30','2025-08-17 09:58:22',NULL,NULL),(10561754,5,31,1,'In Transit','commodity','2025-05-26 16:40:56','2025-05-26 16:40:56',NULL,NULL),(19042874,5,31,1,'In Transit','commodity','2025-05-26 16:49:04','2025-05-26 16:49:04',NULL,NULL),(22086905,37,38,10,'In Transit','billing','2025-07-25 16:52:08','2025-07-25 16:52:43',NULL,NULL),(22309698,5,33,10,'In Transit','billing','2025-08-16 06:52:30','2025-08-16 06:52:44',NULL,NULL),(32549917,5,31,1,'In Transit','commodity','2025-05-26 17:02:54','2025-05-26 17:02:54',NULL,NULL),(36324826,5,31,10,'In Transit','commodity','2025-07-31 15:06:32','2025-07-31 15:06:32',NULL,NULL),(36559339,5,31,1,'In Transit','order','2025-05-20 17:06:55','2025-05-20 17:06:55',NULL,NULL),(37405863,5,31,1,'In Transit','billing','2025-06-29 07:07:40','2025-07-31 14:57:28',NULL,NULL),(38442863,31,5,1,'In Transit','billing','2025-06-29 07:08:44','2025-07-31 14:56:52',NULL,NULL),(38471864,5,31,1,'In Transit','commodity','2025-05-29 02:08:47','2025-05-29 02:08:47',NULL,NULL),(42149377,5,31,1,'In Transit','order','2025-05-20 17:12:14','2025-05-20 17:12:14',NULL,NULL),(42465129,31,5,1,'In Transit','billing','2025-05-29 17:12:46','2025-06-01 16:47:50',NULL,NULL),(44539641,31,5,1,'In Transit','billing','2025-06-29 07:14:53','2025-07-25 16:53:39',NULL,NULL),(46318748,5,31,1,'In Transit','billing','2025-06-29 07:16:31','2025-07-20 12:43:30',NULL,NULL),(48123420,5,31,1,'Picked Up','billing','2025-07-20 02:18:12','2025-07-23 15:50:37',NULL,NULL),(48171109,5,31,1,'In Transit','commodity','2025-05-20 17:18:17','2025-05-20 17:18:17',NULL,NULL),(48379489,31,5,1,'In Transit','billing','2025-06-29 07:18:37','2025-07-20 12:35:28',NULL,NULL),(49180128,5,31,1,'In Transit','commodity','2025-05-20 17:19:18','2025-05-20 17:19:18',NULL,NULL),(49524049,5,31,1,'In Transit','commodity','2025-06-22 10:19:52','2025-06-22 10:19:52',NULL,NULL),(50023588,5,31,1,'In Transit','billing','2025-05-20 17:20:02','2025-06-22 10:12:09',NULL,NULL),(50089505,5,31,1,'In Transit','commodity','2025-06-22 10:20:08','2025-06-22 10:20:08',NULL,NULL),(50093252,5,31,1,'In Transit','billing','2025-06-29 07:20:09','2025-06-30 15:15:33',NULL,NULL),(51113761,5,31,1,'In Transit','commodity','2025-06-22 10:21:11','2025-06-22 10:21:11',NULL,NULL),(56223511,5,31,10,'Delivered','billing','2025-07-24 17:26:22','2025-08-16 06:21:44',NULL,NULL);
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
  `usertype` enum('client','employee') DEFAULT 'employee',
  `isDeleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`employeeid`),
  UNIQUE KEY `employee_email` (`employee_email`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Ranjith','ranji@example.com','83005809','Welcome123','img.png',0,'2025-01-21 18:04:23',NULL,0),(10,'Karthick','Karthick@example.com','59876543','Welcome123','img.png',0,'2025-01-26 15:10:47',NULL,0),(23,'Karthick3','karthic2@example.com','59376543','Welcome123','img.png',0,'2025-06-29 03:27:19',NULL,1),(24,'Karthick3','karthic12@example.com','59376545','Welcome123','img.png',0,'2025-07-22 17:53:02',NULL,1),(25,'Karthick3','karthic172@example.com','59376525','Welcome123','img.png',0,'2025-07-22 17:53:39',NULL,1),(27,'Karthick3','karthifc172@example.com','59376523','Welcome123','img.png',1,'2025-07-22 17:56:35',NULL,1),(28,'Karthick3','karthifca172@example.com','59376521','Welcome123','img.png',1,'2025-07-23 01:03:09',NULL,1),(30,' jaleel','jaleelma71@gmail.com','568085801','admin@123','img.png',1,'2025-07-27 19:01:36','client',0);
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

-- Dump completed on 2025-08-30 20:58:59
