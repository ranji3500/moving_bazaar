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
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billing`
--

LOCK TABLES `billing` WRITE;
/*!40000 ALTER TABLE `billing` DISABLE KEYS */;
INSERT INTO `billing` VALUES (23,42465129,1,5,41960.00,41960.00,41960.00,41960.00,0.00,'[]','Paid','2025-06-01 14:33:45',NULL,'2025-06-01'),(24,4140411,1,5,3996.00,3996.00,3996.00,3996.00,0.00,'[]','Paid','2025-06-16 15:16:06',NULL,'2025-06-16'),(25,50093252,1,5,10200.00,10200.00,10200.00,10200.00,0.00,'[]','Paid','2025-06-29 15:02:52',NULL,'2025-06-29'),(30,177730,1,5,10200.00,10200.00,10200.00,10200.00,0.00,'[]','Paid','2025-06-30 15:31:39',NULL,'2025-06-30'),(32,48123420,10,31,5240.00,5240.00,5240.00,5240.00,0.00,'[]','Paid','2025-07-20 02:27:15',NULL,'2025-07-20'),(33,8304319,10,5,180.00,180.00,180.00,180.00,0.00,'[]','Pending','2025-07-20 12:42:51',NULL,'2025-07-21'),(34,56223511,10,5,8700.00,8700.00,8700.00,8700.00,0.00,'[]','Paid','2025-07-25 16:30:20',NULL,'2025-07-30'),(35,22309698,10,33,90.00,90.00,90.00,90.00,0.00,'[]','Paid','2025-08-16 06:52:57',NULL,'2025-08-16');
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
INSERT INTO `delivery_details` VALUES (1,177730,'Picked Up','2024-01-27 10:00:00'),(2,177730,'In Transit','2024-01-28 10:05:00'),(3,177730,'Retained','2024-01-28 11:32:00'),(4,177730,'Delivered','2024-01-28 12:00:00'),(5,318126,'Picked Up','2024-02-01 09:30:00'),(6,318126,'In Transit','2024-02-02 13:15:00'),(7,318126,'Retained','2024-02-02 15:00:00'),(8,318126,'Delivered','2024-02-02 18:45:00'),(9,4140411,'Picked Up','2024-03-05 08:00:00'),(10,4140411,'In Transit','2024-03-06 10:30:00'),(11,4140411,'Delivered','2024-03-06 13:00:00'),(12,8304319,'Picked Up','2025-08-15 21:55:50'),(13,8304319,'In Transit','2024-04-11 09:00:00'),(14,8304319,'Delivered','2025-07-25 21:44:05'),(15,10561754,'Picked Up','2024-05-12 11:00:00'),(16,10561754,'In Transit','2024-05-13 08:45:00'),(17,10561754,'Retained','2024-05-13 09:10:00'),(18,19042874,'Picked Up','2024-06-01 07:30:00'),(19,19042874,'In Transit','2024-06-02 10:00:00'),(20,32549917,'Picked Up','2024-07-15 15:00:00'),(21,32549917,'In Transit','2024-07-16 10:00:00'),(22,32549917,'Delivered','2024-07-16 18:00:00'),(23,56223511,'Picked Up','2025-08-16 11:49:59'),(24,56223511,'Retained','2025-07-28 01:38:47'),(25,56223511,'Delivered','2025-08-16 11:51:44');
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
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES (79,10561754,'10561754_commodities_f389380e2f8543aea7961a04434a1c01.jpg','2025-05-26 16:43:59','commodities'),(80,19042874,'19042874_commodities_56d3a9cd91d644918953c3f847185fa7.jpg','2025-05-26 16:49:17','commodities'),(81,19042874,'19042874_commodities_5941a41d10144f03af3dcef1f02c6088.jpg','2025-05-26 16:56:54','commodities'),(82,32549917,'32549917_commodities_326a0e63a04b496fa282c969da3fd297.jpg','2025-05-26 17:03:12','commodities'),(83,32549917,'32549917_commodities_ba0e48ff946743b4bda544f344221384.jpg','2025-05-26 17:31:07','commodities'),(84,38471864,'38471864_commodities_e27197809dd5495a868742bef5913f4b.jpg','2025-05-29 02:08:59','commodities'),(85,42465129,'42465129_commodities_4b62adf1ce394b94b24f50707e06ed22.jpg','2025-05-29 17:13:03','commodities'),(86,42465129,'42465129_commodities_29842e15b3044a96950267f108bf2c66.jpg','2025-05-29 17:41:32','commodities'),(87,4140411,'4140411_commodities_2c178795ad2b4967a62eba56d38ee43b.png','2025-06-01 14:34:31','commodities'),(88,50093252,'50093252_commodities_30d71a83df784cb08d56fab99e0468ae.png','2025-06-29 14:51:34','commodities'),(89,177730,'177730_commodities_c533487f5a38445caa4bfa7018067219.png','2025-06-30 15:31:08','commodities'),(90,48123420,'48123420_commodities_da927c0b580241c380f06a22f3861a5f.png','2025-07-20 02:19:10','commodities'),(91,48123420,'48123420_commodities_ad07d5ac037342059001f35256ed7e9f.png','2025-07-20 02:19:10','commodities'),(92,48379489,'48379489_commodities_9e9949c17d10480c8a084d1d26c5b861.png','2025-07-20 12:34:16','commodities'),(93,48379489,'48379489_commodities_961b38d070d34758bd3e9365a77b55e1.png','2025-07-20 12:35:21','commodities'),(94,8304319,'8304319_commodities_f9a2e97d4b71497fa3fe74baa880441b.jpg','2025-07-20 12:42:26','commodities'),(95,8304319,'8304319_commodities_dc7bf045818946c4b2a0b4b43bff84c8.png','2025-07-20 12:42:26','commodities'),(96,8304319,'8304319_commodities_c9fdb606788c4aaabafdad6163a89f2d.png','2025-07-20 12:42:26','commodities'),(97,46318748,'46318748_commodities_16d52acdac874178b9fbfc163efffb58.jpg','2025-07-20 12:43:28','commodities'),(101,56223511,'56223511_commodities_e2988c2154d34e049ffc5f914f73bedc.png','2025-07-25 16:29:53','commodities'),(102,56223511,'56223511_commodities_24d41960175f44ef89751fa138d5a131.png','2025-07-25 16:29:53','commodities'),(103,22086905,'22086905_commodities_b63dfa8b09634135b5e4b03a03f5bc5b.jpeg','2025-07-25 16:52:37','commodities'),(104,44539641,'44539641_commodities_46666289c83b4da1a83e5f68fe817a15.jpeg','2025-07-25 16:53:35','commodities'),(105,42465129,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(106,4140411,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(107,50093252,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(108,177730,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(109,48123420,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(110,8304319,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(111,56223511,'billing_invoice.pdf','2025-07-27 17:17:42','invoice'),(112,5002208,'5002208_commodities_cdaa259cfe8e498f9b7b3f9b46478ee9.png','2025-07-27 19:36:32','commodities'),(113,5002208,'5002208_commodities_b7105c256a1d4e2fa103ba8ef8a8bb4e.png','2025-07-27 19:36:57','commodities'),(114,38442863,'38442863_commodities_c646443e4ffd49f58c69864b1276c3c1.png','2025-07-31 14:56:46','commodities'),(115,37405863,'37405863_commodities_5f7f601a6e0a476bab8339e26ea18749.png','2025-07-31 14:57:25','commodities');
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
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (102,42465129,313,2,10400.00,'2025-05-29 17:39:35',NULL),(103,42465129,313,2,10400.00,'2025-05-29 17:40:29',NULL),(104,42465129,313,2,10400.00,'2025-05-29 17:40:43',NULL),(105,42465129,313,2,10400.00,'2025-05-29 17:41:02',NULL),(106,42465129,312,2,90.00,'2025-05-29 17:41:34',NULL),(107,42465129,312,2,90.00,'2025-05-29 17:41:36',NULL),(108,42465129,312,2,90.00,'2025-05-29 17:41:44',NULL),(109,42465129,312,2,90.00,'2025-05-29 17:42:11',NULL),(110,4140411,314,2,1998.00,'2025-06-01 14:34:35',NULL),(111,4140411,314,2,1998.00,'2025-06-01 14:34:47',NULL),(112,50023588,311,3,360.00,'2025-06-22 10:12:09',1),(113,50023588,312,2,120.00,'2025-06-22 10:12:09',1),(114,50023588,311,3,360.00,'2025-06-22 10:12:27',1),(115,50023588,312,2,120.00,'2025-06-22 10:12:27',1),(116,50093252,313,2,10200.00,'2025-06-29 14:51:39',1),(117,177730,313,2,10200.00,'2025-06-30 15:31:12',1),(118,48123420,311,2,140.00,'2025-07-20 02:20:31',10),(119,48123420,313,1,5100.00,'2025-07-20 02:20:31',10),(120,48379489,312,2,90.00,'2025-07-20 12:35:28',10),(121,8304319,312,4,180.00,'2025-07-20 12:42:33',10),(122,46318748,312,2,90.00,'2025-07-20 12:43:30',10),(123,56223511,313,1,5100.00,'2025-07-25 16:30:00',10),(124,56223511,317,3,3600.00,'2025-07-25 16:30:00',10),(125,22086905,315,3,900.00,'2025-07-25 16:52:43',10),(126,44539641,316,1,8500.00,'2025-07-25 16:53:39',10),(127,5002208,312,3,135.00,'2025-07-27 19:37:06',30),(128,38442863,313,2,10200.00,'2025-07-31 14:56:52',10),(129,37405863,313,1,5100.00,'2025-07-31 14:57:28',10),(130,22309698,312,2,90.00,'2025-08-16 06:52:44',10);
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
INSERT INTO `orders` VALUES (177730,5,31,1,'In Transit','billing','2025-06-30 15:30:17','2025-06-30 15:31:12',NULL,NULL),(318126,5,31,1,'In Transit','commodity','2025-05-26 17:30:31','2025-05-26 17:30:31',NULL,NULL),(4140411,5,31,1,'In Transit','billing','2025-06-01 14:34:14','2025-06-01 14:34:35',NULL,NULL),(5002208,43,5,30,'In Transit','billing','2025-07-27 19:35:00','2025-07-27 19:37:06',NULL,NULL),(8304319,5,31,10,'Picked Up','billing','2025-07-20 12:38:30','2025-08-15 16:25:50',NULL,NULL),(10561754,5,31,1,'In Transit','commodity','2025-05-26 16:40:56','2025-05-26 16:40:56',NULL,NULL),(19042874,5,31,1,'In Transit','commodity','2025-05-26 16:49:04','2025-05-26 16:49:04',NULL,NULL),(22086905,37,38,10,'In Transit','billing','2025-07-25 16:52:08','2025-07-25 16:52:43',NULL,NULL),(22309698,5,33,10,'In Transit','billing','2025-08-16 06:52:30','2025-08-16 06:52:44',NULL,NULL),(32549917,5,31,1,'In Transit','commodity','2025-05-26 17:02:54','2025-05-26 17:02:54',NULL,NULL),(36324826,5,31,10,'In Transit','commodity','2025-07-31 15:06:32','2025-07-31 15:06:32',NULL,NULL),(36559339,5,31,1,'In Transit','order','2025-05-20 17:06:55','2025-05-20 17:06:55',NULL,NULL),(37405863,5,31,1,'In Transit','billing','2025-06-29 07:07:40','2025-07-31 14:57:28',NULL,NULL),(38442863,31,5,1,'In Transit','billing','2025-06-29 07:08:44','2025-07-31 14:56:52',NULL,NULL),(38471864,5,31,1,'In Transit','commodity','2025-05-29 02:08:47','2025-05-29 02:08:47',NULL,NULL),(42149377,5,31,1,'In Transit','order','2025-05-20 17:12:14','2025-05-20 17:12:14',NULL,NULL),(42465129,31,5,1,'In Transit','billing','2025-05-29 17:12:46','2025-06-01 16:47:50',NULL,NULL),(44539641,31,5,1,'In Transit','billing','2025-06-29 07:14:53','2025-07-25 16:53:39',NULL,NULL),(46318748,5,31,1,'In Transit','billing','2025-06-29 07:16:31','2025-07-20 12:43:30',NULL,NULL),(48123420,5,31,1,'Picked Up','billing','2025-07-20 02:18:12','2025-07-23 15:50:37',NULL,NULL),(48171109,5,31,1,'In Transit','commodity','2025-05-20 17:18:17','2025-05-20 17:18:17',NULL,NULL),(48379489,31,5,1,'In Transit','billing','2025-06-29 07:18:37','2025-07-20 12:35:28',NULL,NULL),(49180128,5,31,1,'In Transit','commodity','2025-05-20 17:19:18','2025-05-20 17:19:18',NULL,NULL),(49524049,5,31,1,'In Transit','commodity','2025-06-22 10:19:52','2025-06-22 10:19:52',NULL,NULL),(50023588,5,31,1,'In Transit','billing','2025-05-20 17:20:02','2025-06-22 10:12:09',NULL,NULL),(50089505,5,31,1,'In Transit','commodity','2025-06-22 10:20:08','2025-06-22 10:20:08',NULL,NULL),(50093252,5,31,1,'In Transit','billing','2025-06-29 07:20:09','2025-06-30 15:15:33',NULL,NULL),(51113761,5,31,1,'In Transit','commodity','2025-06-22 10:21:11','2025-06-22 10:21:11',NULL,NULL),(56223511,5,31,10,'Delivered','billing','2025-07-24 17:26:22','2025-08-16 06:21:44',NULL,NULL);
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
    IN p_commodities JSON,
    IN p_employee_id INT
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
    DECLARE order_items_list TEXT DEFAULT '';
    DECLARE order_exists INT;
    DECLARE items_inserted INT DEFAULT 0;
    DECLARE error_message VARCHAR(255);
    DECLARE stage VARCHAR(255);

    -- ✅ Error Handler
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        ROLLBACK;
        SELECT 'Failure' AS Status, error_message AS Message;
    END;

    -- ✅ Start labeled block
    proc_block: BEGIN

        -- ✅ Check if the order exists
        SELECT COUNT(*) INTO order_exists FROM orders WHERE order_id = p_order_id;

        IF order_exists = 0 THEN
            SELECT 'Failure' AS Status, 'Order ID not found' AS Message, p_order_id AS OrderID;
            LEAVE proc_block;
        END IF;

        -- ✅ Start transaction
        START TRANSACTION;

        SET commodities_length = JSON_LENGTH(p_commodities);

        WHILE i < commodities_length DO
            -- Extract values
            SET commodity_id = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].commodity_id')));
            SET quantity = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].quantity')));
            SET price = JSON_UNQUOTE(JSON_EXTRACT(p_commodities, CONCAT('$[', i, '].price')));

            -- Validate commodity
            IF (SELECT COUNT(*) FROM commodity WHERE commodity_id = commodity_id) = 0 THEN
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Invalid commodity_id';
            END IF;

            -- ✅ Insert into order_items (must have created_by column in table)
            INSERT INTO order_items (order_id, commodity_id, quantity, total_price, created_by)
            VALUES (p_order_id, commodity_id, quantity, price * quantity, p_employee_id);

            -- ✅ Optional: Insert into log table (if needed)
            /*
            INSERT INTO order_item_logs (order_id, commodity_id, quantity, added_by, added_on)
            VALUES (p_order_id, commodity_id, quantity, p_employee_id, NOW());
            */

            -- Check success
            IF ROW_COUNT() > 0 THEN
                SET order_item_id = LAST_INSERT_ID();

                IF order_items_list = '' THEN
                    SET order_items_list = order_item_id;
                ELSE
                    SET order_items_list = CONCAT(order_items_list, ', ', order_item_id);
                END IF;

                SET items_inserted = items_inserted + 1;
                SET total_price = total_price + (price * quantity);
            END IF;

            SET i = i + 1;
        END WHILE;

        -- ✅ Commit transaction
        COMMIT;

        -- ✅ Update order stage to 'billing'
        IF items_inserted > 0 THEN
            UPDATE orders SET stage = 'billing' WHERE order_id = p_order_id;

            SELECT 
                'success' AS status,
                p_order_id AS orderId, 
                order_items_list AS orderItemIds,
                total_price AS totalPrice,
                'billing' AS orderStage;
        ELSE
            SELECT 
                'failure' AS status, 
                'No items were added' AS message,
                total_price AS totalPrice,
                p_order_id AS orderId;
        END IF;

    END proc_block;

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
/*!50003 DROP PROCEDURE IF EXISTS `clientLogin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `clientLogin`(
    IN p_email VARCHAR(255),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM moving_bazaar.customer c
    JOIN moving_bazaar.customer_auth a ON c.customer_id = a.customer_id
    WHERE c.email = p_email AND a.password_hash = p_password_hash;

    IF v_count = 1 THEN
        SELECT 'Login successful' AS message, 1 AS status;
    ELSE
        SELECT 'Invalid email or password' AS message, 0 AS status;
    END IF;
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
/*!50003 DROP PROCEDURE IF EXISTS `createCustomerWithPass` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `createCustomerWithPass`(
    IN p_store_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_phone_number VARCHAR(15),
    IN p_whatsapp_number VARCHAR(15),
    IN p_address_line1 VARCHAR(255),
    IN p_address_line2 VARCHAR(255),
    IN p_city VARCHAR(100),
    IN p_outstanding_price DECIMAL(10,2),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    DECLARE new_customer_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Email already exists or error occurred' AS response;
    END;

    START TRANSACTION;

    -- Insert into customer table
    INSERT INTO moving_bazaar.customer (
        store_name,
        email,
        phone_number,
        whatsapp_number,
        address_line1,
        address_line2,
        city,
        outstanding_price,
        created_at
    )
    VALUES (
        p_store_name,
        p_email,
        p_phone_number,
        p_whatsapp_number,
        p_address_line1,
        p_address_line2,
        p_city,
        p_outstanding_price,
        CURRENT_TIMESTAMP
    );

    SET new_customer_id = LAST_INSERT_ID();

    -- Insert password hash
    INSERT INTO moving_bazaar.customer_auth (
        customer_id,
        password_hash
    )
    VALUES (
        new_customer_id,
        p_password_hash
    );

    COMMIT;

    -- Return final response with customer ID
    SELECT CONCAT('Customer created successfully with ID: ', new_customer_id) AS response;
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
    IN created_by_param INT -- 👈 This is employee ID from JWT
)
BEGIN
    DECLARE custom_order_id BIGINT;
    DECLARE error_message VARCHAR(255);
    DECLARE timestamp_part VARCHAR(4);
    DECLARE random_part VARCHAR(4);

    -- ✅ Use labeled block for safe exit
    proc_block: BEGIN 

        -- ✅ Start transaction
        START TRANSACTION;

        -- ✅ Validate sender
        IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = sender_id_param) THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Sender does not exist in customer table' AS Message;
            LEAVE proc_block;
        END IF;

        -- ✅ Validate receiver
        IF NOT EXISTS (SELECT 1 FROM customer WHERE customer_id = receiver_id_param) THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Receiver does not exist in customer table' AS Message;
            LEAVE proc_block;
        END IF;

        -- ✅ Validate employee ID (user who created the order)
        IF NOT EXISTS (SELECT 1 FROM users WHERE employeeid = created_by_param) THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Created_by user does not exist' AS Message;
            LEAVE proc_block;
        END IF;

        -- ✅ Generate custom order ID (e.g., 4 digits time + 4 random digits)
        SET timestamp_part = RIGHT(DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'), 4);
        SET random_part = LPAD(FLOOR(RAND() * 10000), 4, '0');
        SET custom_order_id = CONCAT(timestamp_part, random_part);

        -- ✅ Insert order
        INSERT INTO orders (
            order_id, sender_id, receiver_id, created_by,
            order_status, created_at, updated_at, stage
        )
        VALUES (
            custom_order_id, sender_id_param, receiver_id_param, created_by_param,
            'In Transit', NOW(), NOW(), 'commodity'
        );

        -- ✅ Check insert result
        IF ROW_COUNT() = 0 THEN
            ROLLBACK;
            SELECT 'Failure' AS Status, 'Could not create Order' AS Message;
            LEAVE proc_block;
        END IF;

        -- ✅ Commit transaction and return success
        COMMIT;

        SELECT 
            'Success' AS status, 
            'Order Created Successfully' AS message, 
            custom_order_id AS orderId, 
            'commodity' AS orderStage;

    END proc_block;

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

    -- Soft delete: update isDeleted flag
    UPDATE users
    SET isDeleted = 1
    WHERE employeeid = empId AND isDeleted = 0;

    -- Check if any rows were updated
    IF ROW_COUNT() > 0 THEN
        SET msg = 'Employee deleted successfully';
        SET status = 1;
    ELSE
        SET msg = 'Employee not found or already deleted';
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
    DECLARE fk_count INT;

    -- Check for foreign key usage in orders table
    SELECT COUNT(*) INTO fk_count
    FROM orders
    WHERE sender_id = p_customer_id OR receiver_id = p_customer_id;

    IF fk_count > 0 THEN
        SELECT 'Cannot delete: Customer has linked orders or transactions.' AS message;
    ELSE
        UPDATE customer
        SET is_deleted = 1
        WHERE customer_id = p_customer_id AND (is_deleted = 0 OR is_deleted IS NULL);

        IF ROW_COUNT() > 0 THEN
            SELECT 'Customer marked as deleted successfully.' AS message;
        ELSE
            SELECT 'Customer not found or already deleted.' AS message;
        END IF;
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
    IN p_order_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE created_by_user INT;

    -- ✅ Check if order exists
    SELECT COUNT(*) INTO created_by_user FROM orders WHERE order_id = p_order_id;
    IF created_by_user = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- ✅ Optional: Check if the user is authorized to delete (created_by = user)
    IF (SELECT created_by FROM orders WHERE order_id = p_order_id) != p_user_id THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unauthorized: You cannot delete this order';
    END IF;

    -- ✅ Delete the order (cascade assumed for related tables)
    DELETE FROM orders WHERE order_id = p_order_id;

    -- ✅ Return message
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
    IN p_commodity_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE rows_affected INT;

    -- ✅ Delete the commodity from the order
    DELETE FROM order_items 
    WHERE order_id = p_order_id AND commodity_id = p_commodity_id;

    -- ✅ Check how many rows were affected
    SET rows_affected = ROW_COUNT();

    -- ✅ If something was deleted, log and return success
    IF rows_affected > 0 THEN
        -- ✅ Optional: Audit log
        INSERT INTO order_item_delete_log (
            order_id, commodity_id, deleted_by, deleted_at
        ) VALUES (
            p_order_id, p_commodity_id, p_user_id, NOW()
        );

        -- ✅ Success response
        SELECT 'Success' AS status, p_order_id AS order_id, p_commodity_id AS commodity_id;

    ELSE
        -- ✅ Nothing matched to delete
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
    IN p_description TEXT,
    IN p_min_order_qty INT,
    IN p_max_order_qty INT,
    IN p_new_price DECIMAL(10,2)
)
BEGIN
    DECLARE old_price DECIMAL(10,2);
    DECLARE commodity_exists INT;
    DECLARE changes_detected INT DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;
    DECLARE v_order_id INT;

    -- Declare current values
    DECLARE cur CURSOR FOR
        SELECT DISTINCT order_id FROM order_items WHERE commodity_id = p_commodity_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- Step 1: Check if commodity exists
    SELECT COUNT(*) INTO commodity_exists
    FROM commodity
    WHERE commodity_id = TRIM(p_commodity_id);

    IF commodity_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Commodity ID not found';
    END IF;

    -- Step 2: Load current values
    SELECT 
        price, item_name, item_photo, description, min_order_qty, max_order_qty
    INTO 
        old_price, 
        @current_name, 
        @current_photo, 
        @current_desc, 
        @current_min_qty, 
        @current_max_qty
    FROM commodity
    WHERE commodity_id = TRIM(p_commodity_id);

    -- Step 3: Check if any value has changed
    IF (
        @current_name <> p_item_name OR
        @current_photo <> p_item_photo OR
        @current_desc <> p_description OR
        @current_min_qty <> p_min_order_qty OR
        @current_max_qty <> p_max_order_qty OR
        old_price <> p_new_price
    ) THEN
        SET changes_detected = 1;

        -- Step 4: Update the commodity
        UPDATE commodity
        SET 
            item_name = p_item_name,
            item_photo = p_item_photo,
            description = p_description,
            min_order_qty = p_min_order_qty,
            max_order_qty = p_max_order_qty,
            price = p_new_price
        WHERE commodity_id = TRIM(p_commodity_id);

    END IF;

    -- Step 6: Final response
    SELECT 
        'Success' AS Status, 
        CASE 
            WHEN changes_detected = 1 THEN 'Commodity updated successfully'
            ELSE 'No changes detected. Commodity already up-to-date'
        END AS Message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `edit_customer` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `edit_customer`(
    IN p_customer_id INT,
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
    DECLARE existing_count INT;
    DECLARE changes_detected INT DEFAULT 0;

    -- Check if the customer exists
    SELECT COUNT(*) INTO existing_count
    FROM customer
    WHERE customer_id = p_customer_id;

    IF existing_count = 0 THEN
        SELECT 'Customer not found.' AS message;
    ELSE
        -- Compare current values
        SELECT COUNT(*) INTO changes_detected
        FROM customer
        WHERE customer_id = p_customer_id
          AND (
              store_name <> p_store_name OR
              email <> p_email OR
              phone_number <> p_phone_number OR
              whatsapp_number <> p_whatsapp_number OR
              address_line1 <> p_address_line1 OR
              IFNULL(address_line2, '') <> IFNULL(p_address_line2, '') OR
              city <> p_city OR
              outstanding_price <> p_outstanding_price
          );

        IF changes_detected = 0 THEN
            SELECT 'No changes detected. Customer already up-to-date.' AS message;
        ELSE
            UPDATE customer
            SET 
                store_name = p_store_name,
                email = p_email,
                phone_number = p_phone_number,
                whatsapp_number = p_whatsapp_number,
                address_line1 = p_address_line1,
                address_line2 = p_address_line2,
                city = p_city,
                outstanding_price = p_outstanding_price
            WHERE customer_id = p_customer_id;

            SELECT 'Customer updated successfully.' AS message;
        END IF;
    END IF;
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
    IN new_status ENUM('Pending', 'Processing', 'Completed', 'Cancelled'),
    IN p_user_id INT
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
        updated_at = CURRENT_TIMESTAMP,
        updated_by = p_user_id
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
		b.order_id AS orderId,
		o.created_by AS employeeId,
		sender.customer_id AS senderId,
		sender.store_name AS senderName,
		receiver.customer_id AS receiverId,
		receiver.store_name AS receiverName,
		b.employee_id AS billedUserId,
		b.paid_by AS paidBy,
		b.total_price AS totalPrice,
		b.payment_status AS paymentStatus,
		b.created_at AS billingCreatedAt,
		b.receipt_pdf AS receiptPdf,
		d.path AS billFile

    FROM billing b
    JOIN orders o ON b.order_id = o.order_id
    JOIN customer sender ON o.sender_id = sender.customer_id
    JOIN customer receiver ON o.receiver_id = receiver.customer_id
    join documents d on b.order_id = d.order_id
    WHERE o.created_by = employee_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetBillingByEmployeeIdandStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetBillingByEmployeeIdandStatus`(IN employee_id INT,IN payment_status VARCHAR(100))
BEGIN
    SELECT 
        b.billing_id,
        b.order_id,
        o.created_by AS employee_id,
        sender.customer_id AS sender_id,
        sender.store_name AS sender_name,
        receiver.customer_id AS receiver_id,
        receiver.store_name AS receiver_name,
        b.employee_id AS billed_user_id,
        b.paid_by,
        b.total_price,
        b.payment_status,
        b.created_at AS billing_created_at,
        b.receipt_pdf
    FROM billing b
    JOIN orders o ON b.order_id = o.order_id
    JOIN customer sender ON o.sender_id = sender.customer_id
    JOIN customer receiver ON o.receiver_id = receiver.customer_id
    WHERE 
        o.created_by = employee_id
        AND (
            (payment_status IS NULL OR payment_status = '') 
            OR b.payment_status = payment_status
        );
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
    SELECT *
    FROM commodity;
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
/*!50003 DROP PROCEDURE IF EXISTS `GetDashboardOverview` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDashboardOverview`(IN filter_type VARCHAR(10), IN start_date DATE, IN end_date DATE)
BEGIN
    DECLARE filter_start DATE;
    DECLARE filter_end DATE;

    -- Set the date range based on filter type
    IF filter_type = 'today' THEN
        SET filter_start = CURDATE();
        SET filter_end = CURDATE();
    ELSEIF filter_type = 'week' THEN
        SET filter_start = DATE_SUB(CURDATE(), INTERVAL 7 DAY);
        SET filter_end = CURDATE();
    ELSEIF filter_type = 'month' THEN
        SET filter_start = DATE_SUB(CURDATE(), INTERVAL 30 DAY);
        SET filter_end = CURDATE();
    ELSEIF filter_type = 'custom' AND start_date IS NOT NULL AND end_date IS NOT NULL THEN
        SET filter_start = start_date;
        SET filter_end = end_date;
    ELSE
        SET filter_start = NULL;
        SET filter_end = NULL;
    END IF;

    -- Final JSON result
    SELECT JSON_OBJECT(
        'metrics', JSON_OBJECT(
            'total_users', (SELECT COUNT(*) FROM users where isDeleted=0),
            'total_customers', (SELECT COUNT(*) FROM customer where is_deleted =0),
            'total_orders', (SELECT COUNT(*) FROM orders WHERE (filter_start IS NULL OR created_at BETWEEN filter_start AND filter_end)),
            'total_bills', (SELECT COUNT(*) FROM billing WHERE (filter_start IS NULL OR created_at BETWEEN filter_start AND filter_end)),
            'total_sales', COALESCE((SELECT SUM(total_price) FROM billing WHERE (filter_start IS NULL OR created_at BETWEEN filter_start AND filter_end)), 0)
        ),
       'users', (
    SELECT JSON_ARRAYAGG(user_stats)
    FROM (
        SELECT JSON_OBJECT(
            'user_id', u.employeeid,
            'employee_profile_photo', u.employee_profile_photo,
            'user_name', u.employee_full_name,
            'total_orders', COUNT(DISTINCT o.order_id),
            'total_sales', COALESCE(SUM(b.total_price), 0)
        ) AS user_stats
        FROM users u
        LEFT JOIN orders o 
            ON o.created_by = u.employeeid 
            AND (filter_start IS NULL OR o.created_at BETWEEN filter_start AND filter_end)
        LEFT JOIN billing b 
            ON b.order_id = o.order_id 
            AND (filter_start IS NULL OR b.created_at BETWEEN filter_start AND filter_end)
        WHERE u.isDeleted = 0  -- Apply here
        GROUP BY u.employeeid, u.employee_full_name
    ) AS user_json
)
,
       'customers', (
    SELECT JSON_ARRAYAGG(customer_stats)
    FROM (
        SELECT JSON_OBJECT(
            'customer_id', c.customer_id,
            'store_name', c.store_name,
            'total_orders', COUNT(DISTINCT o.order_id),
            'total_sales', COALESCE(SUM(b.total_price), 0)
        ) AS customer_stats
        FROM customer c
        LEFT JOIN orders o 
            ON o.receiver_id = c.customer_id 
            AND (filter_start IS NULL OR o.created_at BETWEEN filter_start AND filter_end)
        LEFT JOIN billing b 
            ON b.order_id = o.order_id 
            AND (filter_start IS NULL OR b.created_at BETWEEN filter_start AND filter_end)
        WHERE c.is_deleted = 0   -- Apply here
        GROUP BY c.customer_id, c.store_name
    ) AS customer_json


        ),
        'message', 'Dashboard data retrieved successfully'
    ) AS dashboard_summary;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetDashboardSummaryAndUserSales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDashboardSummaryAndUserSales`(IN filter_type VARCHAR(20))
BEGIN
    -- Common date condition
    DECLARE filter_condition TEXT;

    SET @filter_condition = 
        CASE
            WHEN filter_type = 'today' THEN 'DATE(b.created_at) = CURDATE()'
            WHEN filter_type = 'week' THEN 'YEARWEEK(b.created_at, 1) = YEARWEEK(CURDATE(), 1)'
            WHEN filter_type = 'month' THEN 'DATE_FORMAT(b.created_at, "%Y-%m") = DATE_FORMAT(CURDATE(), "%Y-%m")'
            ELSE '1=1'
        END;

    -- Prepare user-wise sales and orders
    SET @query1 = CONCAT(
        'SELECT ',
            'u.employeeid AS user_id, ',
            'u.employee_full_name AS user_name, ',
            'COUNT(DISTINCT o.order_id) AS total_orders, ',
            'IFNULL(SUM(b.grand_total), 0) AS total_sales_aed ',
        'FROM users u ',
        'LEFT JOIN orders o ON u.employeeid = o.created_by ',
        'LEFT JOIN billing b ON o.order_id = b.order_id ',
        'WHERE ', @filter_condition, ' ',
        'GROUP BY u.employeeid, u.employee_full_name ',
        'ORDER BY total_sales_aed DESC'
    );

    -- Prepare global stats
    SET @query2 = CONCAT(
        'SELECT ',
            '(SELECT COUNT(*) FROM users) AS total_users, ',
            '(SELECT COUNT(*) FROM orders WHERE ', @filter_condition, ') AS total_orders, ',
            '(SELECT COUNT(*) FROM billing WHERE ', @filter_condition, ') AS total_bills, ',
            '(SELECT IFNULL(SUM(grand_total), 0) FROM billing WHERE ', @filter_condition, ') AS total_sales_aed'
    );

    -- Execute both queries
    PREPARE stmt1 FROM @query1;
    EXECUTE stmt1;
    DEALLOCATE PREPARE stmt1;

    PREPARE stmt2 FROM @query2;
    EXECUTE stmt2;
    DEALLOCATE PREPARE stmt2;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetDashboardSummaryByPeriod` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetDashboardSummaryByPeriod`(
    IN period_param VARCHAR(20)
)
BEGIN
    IF period_param = 'today' THEN
        SELECT
            COUNT(*) AS user_count,
            (SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()) AS order_count,
            (SELECT COUNT(*) FROM billing WHERE DATE(created_at) = CURDATE()) AS bill_count,
            (SELECT IFNULL(SUM(total_amount_paid), 0) FROM billing WHERE DATE(created_at) = CURDATE()) AS total_sales;
    
    ELSEIF period_param = 'this_week' THEN
        SELECT
            COUNT(*) AS user_count,
            (SELECT COUNT(*) FROM orders WHERE YEARWEEK(created_at,1) = YEARWEEK(CURDATE(),1)) AS order_count,
            (SELECT COUNT(*) FROM billing WHERE YEARWEEK(created_at,1) = YEARWEEK(CURDATE(),1)) AS bill_count,
            (SELECT IFNULL(SUM(total_amount_paid), 0) FROM billing WHERE YEARWEEK(created_at,1) = YEARWEEK(CURDATE(),1)) AS total_sales
        FROM users
        WHERE YEARWEEK(created_at,1) = YEARWEEK(CURDATE(),1);

    ELSEIF period_param = 'this_month' THEN
        SELECT
            COUNT(*) AS user_count,
            (SELECT COUNT(*) FROM orders WHERE YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE())) AS order_count,
            (SELECT COUNT(*) FROM billing WHERE YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE())) AS bill_count,
            (SELECT IFNULL(SUM(total_amount_paid), 0) FROM billing WHERE YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE())) AS total_sales
        FROM users
        WHERE YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE());

    ELSE
        SELECT 'Invalid period parameter. Use today, this_week, or this_month.' AS error_message;
    END IF;
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
/*!50003 DROP PROCEDURE IF EXISTS `getDraftOrderDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDraftOrderDetails`(
    IN inOrderStatus VARCHAR(20),
    IN inPageNumber INT,
    IN inPageSize INT,
    IN inEmployeeId INT
)
BEGIN
    DECLARE offsetVal INT;
    DECLARE totalRecords INT;

    SET offsetVal = (inPageNumber - 1) * inPageSize;

    -- Count only orders where stage is NOT 'billing'
    SELECT 
        COUNT(*) INTO totalRecords
    FROM 
        orders o
    LEFT JOIN 
        moving_bazaar.billing b ON o.order_id = b.order_id
    WHERE 
        o.stage != 'billing';

    -- Return the total records
    SELECT totalRecords AS totalRecords;

    -- Fetch paginated data if records exist
    IF totalRecords > 0 THEN
        SELECT 
            o.order_id AS orderId,
            o.stage AS orderStage,
            o.updated_at AS updatedAt
        FROM 
            orders o
        LEFT JOIN 
            moving_bazaar.billing b ON o.order_id = b.order_id
        WHERE 
            o.stage != 'billing'
        ORDER BY 
            o.updated_at DESC
        LIMIT 
            offsetVal, inPageSize;
    ELSE
        SELECT NULL;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetFullDashboardSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetFullDashboardSummary`()
BEGIN
    SELECT
        'today' AS period,
        (SELECT COUNT(*) FROM users WHERE DATE(created_at) = CURDATE()) AS user_count,
        (SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()) AS order_count,
        (SELECT COUNT(*) FROM billing WHERE DATE(created_at) = CURDATE()) AS bill_count,
        (SELECT IFNULL(SUM(total_amount_paid),0) FROM billing WHERE DATE(created_at) = CURDATE()) AS total_sales
    UNION ALL
    SELECT
        'this_week' AS period,
        (SELECT COUNT(*) FROM users WHERE YEARWEEK(created_at,1) = YEARWEEK(CURDATE(),1)) AS user_count,
        (SELECT COUNT(*) FROM orders WHERE YEARWEEK(created_at,1) = YEARWEEK(CURDATE(),1)) AS order_count,
        (SELECT COUNT(*) FROM billing WHERE YEARWEEK(created_at,1) = YEARWEEK(CURDATE(),1)) AS bill_count,
        (SELECT IFNULL(SUM(total_amount_paid),0) FROM billing WHERE YEARWEEK(created_at,1) = YEARWEEK(CURDATE(),1)) AS total_sales
    UNION ALL
    SELECT
        'this_month' AS period,
        (SELECT COUNT(*) FROM users WHERE YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE())) AS user_count,
        (SELECT COUNT(*) FROM orders WHERE YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE())) AS order_count,
        (SELECT COUNT(*) FROM billing WHERE YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE())) AS bill_count,
        (SELECT IFNULL(SUM(total_amount_paid),0) FROM billing WHERE YEAR(created_at) = YEAR(CURDATE()) AND MONTH(created_at) = MONTH(CURDATE())) AS total_sales;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetInvoiceDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetInvoiceDetails`(IN input_order_id INT)
BEGIN
    -- Delivery details: sender and receiver
    SELECT 
        o.order_id,
        
        -- Estimated delivery: using order created date as example (custom logic can be added)
        DATE_FORMAT(o.created_at, '%b %d') AS start_date,
        DATE_FORMAT(DATE_ADD(o.created_at, INTERVAL 1 DAY), '%b %d') AS end_date,

        -- Sender info
        cs.store_name AS sender_name,
        cs.email AS sender_email,
        cs.phone_number AS sender_phone,
        CONCAT(cs.address_line1, ', ', cs.address_line2, ', ', cs.city) AS sender_address,

        -- Receiver info
        cr.store_name AS receiver_name,
        cr.email AS receiver_email,
        cr.phone_number AS receiver_phone,
        CONCAT(cr.address_line1, ', ', cr.address_line2, ', ', cr.city) AS receiver_address

    FROM orders o
    LEFT JOIN customer cs ON o.sender_id = cs.customer_id
    LEFT JOIN customer cr ON o.receiver_id = cr.customer_id
    WHERE o.order_id = input_order_id;

    -- Order summary: itemized details
    SELECT 
        cm.item_name AS item,
        oi.quantity,
        cm.price AS unit_price,
        oi.total_price
    FROM order_items oi
    JOIN commodity cm ON oi.commodity_id = cm.commodity_id
    WHERE oi.order_id = input_order_id;

    -- Billing summary
    SELECT 
        b.total_amount_paid AS total,
        b.outstanding_amount_paid AS outstanding_balance,
        b.grand_total,
        c.store_name AS bill_to_name,
        c.email AS bill_to_email,
        c.phone_number AS bill_to_phone,
        CONCAT(c.address_line1, ', ', c.address_line2, ', ', c.city) AS bill_to_address,
        CONCAT('Amount to be paid by the Sender - ', c.store_name) AS note
    FROM billing b
    JOIN orders o ON o.order_id = b.order_id
    JOIN customer c ON o.sender_id = c.customer_id
    WHERE b.order_id = input_order_id;
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
    DECLARE vDeliveryDate DATETIME;  -- Added for delivery date

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

    -- Fetch the delivery date from the billing table
    SELECT delivery_date
    INTO vDeliveryDate
    FROM moving_bazaar.billing
    WHERE order_id = inputOrderId;

    -- Final flattened JSON object
    SELECT JSON_OBJECT(
        'orderId', inputOrderId,
        'orderStatus', vOrderStatus,
        'reasonId', vReasonId,
        'reason', vReasonText,
        'senderId', vSenderId,
        'senderName', vSenderStoreName,
        'receiverId', vReceiverId,
        'receiverName', vReceiverStoreName,
        'deliveryDate', vDeliveryDate,  -- Added delivery date to the result
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
    IN p_stage VARCHAR(20),
    INOUT p_employee_id BIGINT
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
        JOIN moving_bazaar.customer sender ON o.sender_id = sender.customer_id
        JOIN moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
        WHERE o.order_id = p_order_id AND o.created_by = p_employee_id;

    -- COMMODITY stage: Return commodity and document details
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
        JOIN moving_bazaar.commodity c ON oi.commodity_id = c.commodity_id
        JOIN moving_bazaar.orders o ON oi.order_id = o.order_id
        WHERE oi.order_id = p_order_id AND o.created_by = p_employee_id
        GROUP BY oi.order_id;
    END IF;

    -- Optional: fetch employee details if needed
    SELECT * FROM moving_bazaar.users WHERE employeeid = p_employee_id;

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
    IN inDeliveryDate DATE,
    IN inPageNumber INT,
    IN inPageSize INT,
    IN inEmployeeId INT
)
BEGIN
    DECLARE offsetVal INT DEFAULT 0;
    DECLARE total INT DEFAULT 0;

    -- Safeguard for pagination
    IF inPageNumber IS NULL OR inPageNumber <= 0 THEN
        SET inPageNumber = 1;
    END IF;

    IF inPageSize IS NULL OR inPageSize <= 0 THEN
        SET inPageSize = 10;
    END IF;

    SET offsetVal = (inPageNumber - 1) * inPageSize;

    -- Step 1: Count total matching records
    SELECT COUNT(*) INTO total
    FROM orders o
    JOIN moving_bazaar.customer sender ON o.sender_id = sender.customer_id
    JOIN moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
    JOIN moving_bazaar.billing b ON o.order_id = b.order_id
    WHERE 
        (inOrderStatus IS NULL OR inOrderStatus = '' OR o.order_status = inOrderStatus)
        AND (inOrderId IS NULL OR inOrderId = '' OR o.order_id LIKE CONCAT('%', inOrderId, '%'))
        AND (inDeliveryDate IS NULL OR b.delivery_date = inDeliveryDate)
        AND (inEmployeeId IS NULL OR o.created_by = inEmployeeId);

    -- Return total record count
    SELECT total AS totalRecords;

    -- Step 2: Return paginated result if records found
    IF total > 0 THEN
        SELECT 
            o.order_id AS orderId,
            o.order_status AS orderStatus,
            sender.store_name AS senderName,
            receiver.store_name AS receiverName,
            b.delivery_date AS deliveryDate,
            sender.address_line1 AS senderAddressLine1,
            sender.address_line2 AS senderAddressLine2,
            sender.city AS senderCity,
            receiver.address_line1 AS receiverAddressLine1,
            receiver.address_line2 AS receiverAddressLine2,
            receiver.city AS receiverCity
        FROM orders o
        JOIN moving_bazaar.customer sender ON o.sender_id = sender.customer_id
        JOIN moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
        JOIN moving_bazaar.billing b ON o.order_id = b.order_id
        WHERE 
            (inOrderStatus IS NULL OR inOrderStatus = '' OR o.order_status = inOrderStatus)
            AND (inOrderId IS NULL OR inOrderId = '' OR o.order_id LIKE CONCAT('%', inOrderId, '%'))
            AND (inDeliveryDate IS NULL OR b.delivery_date = inDeliveryDate)
            AND (inEmployeeId IS NULL OR o.created_by = inEmployeeId)
        ORDER BY b.delivery_date DESC
        LIMIT offsetVal, inPageSize;
    ELSE
        -- Return empty result with defined columns to match schema
        SELECT 
            NULL AS orderId,
            NULL AS orderStatus,
            NULL AS senderName,
            NULL AS receiverName,
            NULL AS deliveryDate,
            NULL AS senderAddressLine1,
            NULL AS senderAddressLine2,
            NULL AS senderCity,
            NULL AS receiverAddressLine1,
            NULL AS receiverAddressLine2,
            NULL AS receiverCity
        WHERE FALSE;
    END IF;
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
/*!50003 DROP PROCEDURE IF EXISTS `getOrderDocuments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getOrderDocuments`(
    IN input_order_id INT,
    IN input_category VARCHAR(50)
)
BEGIN
    SELECT path 
    FROM moving_bazaar.documents 
    WHERE order_id = input_order_id 
      AND catagory = input_category;
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
/*!50003 DROP PROCEDURE IF EXISTS `GetOrdersByCustomerId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrdersByCustomerId`(
    IN customer_id INT,
    IN input_order_status VARCHAR(50)
)
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
    WHERE (o.sender_id = customer_id OR o.receiver_id = customer_id)
      AND (input_order_status = 'All' OR o.order_status = input_order_status);
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrdersByEmployeeId`(
    IN employee_id INT,
    IN input_order_status VARCHAR(50)
)
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
    WHERE o.created_by = employee_id
      AND (input_order_status ="All" OR o.order_status = input_order_status);
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderSummary`(
    IN p_order_id INT,
    IN p_employeeid INT
)
BEGIN
    SELECT 
        o.order_id AS orderId,
        sender.store_name AS senderName,
        sender.customer_id AS senderId,
        receiver.store_name AS receiverName,
        receiver.customer_id AS receiverId,

        -- Employee Info
        o.created_by AS employeeId,
        u.employee_full_name AS employeeName,
        u.employee_email AS employeeEmail,

        -- Commodity Info as JSON
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

    FROM 
        moving_bazaar.orders o
    JOIN 
        moving_bazaar.customer sender ON o.sender_id = sender.customer_id
    JOIN 
        moving_bazaar.customer receiver ON o.receiver_id = receiver.customer_id
    LEFT JOIN 
        moving_bazaar.users u ON o.created_by = u.employeeid
    WHERE 
        o.order_id = p_order_id
        AND o.created_by = p_employeeid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetOrderSummaryDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderSummaryDetails`(IN input_order_id INT)
BEGIN
    -- Delivery details
		SELECT 
		'deliveryDetails' AS section,
		JSON_OBJECT(
			'orderId', o.order_id,
			'startDate', DATE_FORMAT(o.created_at, '%b %d'),
			'endDate', DATE_FORMAT(DATE_ADD(o.created_at, INTERVAL 1 DAY), '%b %d'),
			'pickup', cs.store_name,
			'dropoff', cr.store_name,
			'employeeName', u.employee_full_name,
			'deliveryStatus', dd.status
		) AS data
	FROM orders o
	LEFT JOIN customer cs ON o.sender_id = cs.customer_id
	LEFT JOIN customer cr ON o.receiver_id = cr.customer_id
	LEFT JOIN users u ON o.created_by = u.employeeid
	LEFT JOIN (
		SELECT order_id, status
		FROM delivery_details
		WHERE (order_id, status_time) IN (
			SELECT order_id, MAX(status_time)
			FROM delivery_details
			GROUP BY order_id
		)
	) dd ON o.order_id = dd.order_id
	WHERE o.order_id = input_order_id



    UNION ALL

    -- Status timeline
    SELECT 
        'statusTimeline' AS section,
        JSON_ARRAYAGG(
            JSON_OBJECT(
                'status', status,
                'statusTime', status_time
            )
        )
    FROM moving_bazaar.delivery_details 
    WHERE order_id = input_order_id

    UNION ALL

    -- Order items
    SELECT 
        'ordersummary' AS section,
        JSON_ARRAYAGG(
            JSON_OBJECT(
                'item', cm.item_name,
                'quantity', oi.quantity,
                'unitPrice', cm.price,
                'totalPrice', oi.total_price
            )
        )
    FROM order_items oi
    JOIN commodity cm ON oi.commodity_id = cm.commodity_id
    WHERE oi.order_id = input_order_id

    UNION ALL

    -- Commodity document path
    SELECT 
        'commodityDocuments' AS section,
        JSON_ARRAYAGG(JSON_OBJECT('path', path))
    FROM moving_bazaar.documents 
    WHERE order_id = input_order_id AND catagory = 'commodities'

    UNION ALL

    -- Billing summary
    SELECT 
        'billingSummary' AS section,
        JSON_OBJECT(
            'total', b.total_amount_paid,
            'outstandingBalance', b.outstanding_amount_paid,
            'grandTotal', b.grand_total,
            'billToName', c.store_name,
            'billToEmail', c.email,
            'billToPhone', c.phone_number,
            'billToAddress', CONCAT(c.address_line1, ', ', c.address_line2, ', ', c.city),
            'note', CONCAT('Amount to be paid by the Sender - ', c.store_name)
        )
    FROM billing b
    JOIN orders o ON o.order_id = b.order_id
    JOIN customer c ON o.sender_id = c.customer_id
    WHERE b.order_id = input_order_id;
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
/*!50003 DROP PROCEDURE IF EXISTS `GetStoreSalesSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetStoreSalesSummary`()
BEGIN
    SELECT 
        c.customer_id AS storeId,
        c.store_name,
        COUNT(DISTINCT o.order_id) AS orders,
        IFNULL(SUM(b.total_price), 0) AS sales
    FROM customer c
    LEFT JOIN orders o ON o.sender_id = c.customer_id
    LEFT JOIN billing b ON b.order_id = o.order_id
    GROUP BY c.customer_id, c.store_name
    ORDER BY c.store_name;
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
/*!50003 DROP PROCEDURE IF EXISTS `GetUserOrdersAndSales` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserOrdersAndSales`()
BEGIN
    SELECT 
        u.employeeid AS user_id,
        u.employee_full_name AS user_name,
        COUNT(DISTINCT o.order_id) AS total_orders,
        IFNULL(SUM(b.grand_total), 0) AS total_sales_aed
    FROM 
        users u
    LEFT JOIN orders o ON u.employeeid = o.created_by
    LEFT JOIN billing b ON o.order_id = b.order_id
    GROUP BY 
        u.employeeid, u.employee_full_name
    ORDER BY 
        total_sales_aed DESC;
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
    FROM users where isDeleted=0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetUserSalesSummary` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetUserSalesSummary`()
BEGIN
    SELECT 
        u.employeeid AS userId,
        u.employee_full_name AS name,
        COUNT(DISTINCT o.order_id) AS orders,
        IFNULL(SUM(b.total_amount_paid), 0) AS sales
    FROM users u
    LEFT JOIN orders o ON o.created_by = u.employeeid
    LEFT JOIN billing b ON b.employee_id = u.employeeid
    GROUP BY u.employeeid, u.employee_full_name
    ORDER BY u.employee_full_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_all_cities` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_all_cities`()
BEGIN
    SELECT c_id, cityname, is_service, created_at 
    FROM city
    ORDER BY cityname;
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
/*!50003 DROP PROCEDURE IF EXISTS `get_billing_overview` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_billing_overview`(
    IN status_filter ENUM('All', 'Pending', 'Paid')
)
BEGIN
    SELECT 
        b.order_id AS order_id,
        CONCAT(sender.store_name, ' - ', receiver.store_name) AS billTitle,
        b.created_at AS createdAt,
        b.payment_status AS paymentStatus,
        b.total_price AS totalPrice,
        b.amount_paid AS amountPaid,
        b.outstanding_amount_paid AS balance,
        b.grand_total AS grandTotal,
        CONCAT(emp.employee_full_name) AS billedBy,
        b.delivery_date AS deliveryDate,
        b.receipt_pdf AS receiptFile,
        sender.store_name AS senderName,
        receiver.store_name AS receiverName,
        d.path as invoice

    FROM billing b
    JOIN orders o ON o.order_id = b.order_id
    JOIN customer sender ON o.sender_id = sender.customer_id
    JOIN customer receiver ON o.receiver_id = receiver.customer_id
    Join documents d on d.order_id = b.order_id and d.catagory = "invoice"
    LEFT JOIN users emp ON emp.employeeid = b.paid_by
    WHERE 
        status_filter = 'All' OR b.payment_status = status_filter
    ORDER BY b.created_at DESC;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_commodities_list`( 
    IN p_employeeid INT
)
BEGIN
    DECLARE err_msg VARCHAR(255);

    -- SQL Error Handler
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', err_msg) AS error_message;
    END;

    -- 1. Check if employee exists
    IF NOT EXISTS (
        SELECT 1 FROM users WHERE employeeid = p_employeeid
    ) THEN
        SELECT 'Error: Invalid employeeid.' AS message;
    ELSE
        -- 2. Fetch all commodities
        SELECT 
            commodity_id, 
            item_name, 
            item_photo, 
            min_order_qty, 
            max_order_qty, 
            CAST(price AS DOUBLE) AS price, 
            created_at 
        FROM commodity;
    END IF;
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

    -- Check if phone number length is more than 4
    IF LENGTH(p_phone_number) > 4 THEN
        IF EXISTS (
            SELECT 1 FROM customer WHERE phone_number LIKE CONCAT('%', p_phone_number, '%')
        ) THEN
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
            WHERE phone_number LIKE CONCAT('%', p_phone_number, '%');
        ELSE
            SELECT 'Error: Customer not found.' AS message;
        END IF;
    ELSE
        SELECT 'Error: Please enter more than 4 digits to search.' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `get_document_paths_by_order_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_document_paths_by_order_id`(IN p_order_id BIGINT)
BEGIN
    SELECT 
        doc_id,
        order_id,
        path,
        uploaded_at,
        catagory
    FROM documents
    WHERE order_id = p_order_id;
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
    IN p_order_id INT,
    IN p_user_id INT
)
BEGIN
    -- Check authorization
    IF NOT EXISTS (
        SELECT 1 FROM orders WHERE order_id = p_order_id AND created_by = p_user_id
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Unauthorized access';
    END IF;

    -- Get commodity details
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
    IN p_order_id INT,
    IN p_user_id INT
)
BEGIN
    DECLARE order_exists INT;

    -- Check if order exists
    SELECT COUNT(*) INTO order_exists FROM orders WHERE order_id = p_order_id;
    IF order_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Order ID not found';
    END IF;

    -- Return everything as a single result set (1 row)
    SELECT
        -- Order summary
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

        -- Total price (from order items)
        (
            SELECT COALESCE(SUM(oi.quantity * c.price), 0)
            FROM order_items oi
            JOIN commodity c ON oi.commodity_id = c.commodity_id
            WHERE oi.order_id = o.order_id
        ) AS total_price,

        -- Billing info (as JSON object)
        (
            SELECT JSON_OBJECT(
                'billing_id', b.billing_id,
                'total_price', b.total_price,
                'payment_status', b.payment_status,
                'created_at', b.created_at
            )
            FROM billing b
            WHERE b.order_id = o.order_id
            LIMIT 1
        ) AS billing,

        -- Items list (as JSON array)
        (
            SELECT JSON_ARRAYAGG(
                JSON_OBJECT(
                    'order_item_id', oi.order_item_id,
                    'commodity_id', oi.commodity_id,
                    'commodity_name', c.item_name,
                    'quantity', oi.quantity,
                    'price', c.price,
                    'subtotal', oi.quantity * c.price
                )
            )
            FROM order_items oi
            JOIN commodity c ON oi.commodity_id = c.commodity_id
            WHERE oi.order_id = o.order_id
        ) AS items

    FROM orders o
    LEFT JOIN customer s ON o.sender_id = s.customer_id
    LEFT JOIN customer r ON o.receiver_id = r.customer_id
    LEFT JOIN users u ON o.created_by = u.employeeid
    WHERE o.order_id = p_order_id;
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
    IN p_full_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone_number VARCHAR(15),
    IN p_password VARCHAR(255),
    IN p_profile_photo VARCHAR(255),
    IN p_is_admin TINYINT(1),
    IN p_usertype VARCHAR(15)
)
BEGIN
    DECLARE phone_exists INT;

    -- Validate ENUM manually
    IF p_usertype NOT IN ('client', 'employee') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid usertype value. Must be client or employee';
    ELSE
        -- Check if phone number already exists
        SELECT COUNT(*) INTO phone_exists
        FROM users
        WHERE employee_phone_number = p_phone_number;

        IF phone_exists > 0 THEN
            SELECT 'Phone number already exists.' AS message, NULL AS employee_id;
        ELSE
            INSERT INTO users (
                employee_full_name,
                employee_email,
                employee_phone_number,
                employee_password,
                employee_profile_photo,
                employee_is_admin,
                created_at,
                usertype
            )
            VALUES (
                p_full_name,
                p_email,
                p_phone_number,
                p_password,
                p_profile_photo,
                p_is_admin,
                NOW(),
                p_usertype
            );

            SELECT LAST_INSERT_ID() AS employee_id, 'Employee successfully inserted.' AS message;
        END IF;
    END IF;
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
    IN user_id INT,
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
    DECLARE new_customer_id INT DEFAULT 0;
    DECLARE existing_customer_id INT DEFAULT 0;
    DECLARE duplicate_found INT DEFAULT 0;
    DECLARE sql_error VARCHAR(255);

    -- Check if customer already exists
    SELECT COUNT(*)
    INTO duplicate_found
    FROM customer
    WHERE phone_number = p_phone_number;

    IF duplicate_found > 0 THEN
        -- Get existing customer_id
        SELECT customer_id INTO existing_customer_id
        FROM customer
        WHERE phone_number = p_phone_number
        LIMIT 1;

        SELECT existing_customer_id AS customerId, 'Duplicate entry: Customer already exists.' AS message;
    ELSE
        -- Insert new customer
        INSERT INTO customer (
            store_name, email, phone_number, whatsapp_number,
            address_line1, address_line2, city, outstanding_price, employeeid
        )
        VALUES (
            p_store_name, p_email, p_phone_number, p_whatsapp_number,
            p_address_line1, p_address_line2, p_city, p_outstanding_price, user_id
        );

        SET new_customer_id = LAST_INSERT_ID();

        IF new_customer_id > 0 THEN
            SELECT new_customer_id AS customerId, 'Customer inserted successfully.' AS message;
        ELSE
            SELECT NULL AS customerId, 'Error: Insert failed.' AS message;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_customer_admin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_customer_admin`(
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `recalculate_billing_price`(IN p_order_id INT)
BEGIN
    -- Dummy logic, replace with real billing update
    UPDATE billing
    SET total_amount = (
        SELECT SUM(price * quantity)
        FROM order_items
        WHERE order_id = p_order_id
    )
    WHERE order_id = p_order_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `searchCommodityByName` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchCommodityByName`(
    IN p_searchTerm VARCHAR(100)
)
BEGIN
    SELECT 
        commodity_id,
        item_name,
        item_photo,
        description,
        min_order_qty,
        max_order_qty,
        price,
        created_at
    FROM commodity
    WHERE item_name LIKE CONCAT('%', p_searchTerm, '%');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `searchCommoditySimilar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `searchCommoditySimilar`(
    IN p_searchTerm VARCHAR(100)
)
BEGIN
    SELECT 
        commodity_id,
        item_name,
        item_photo,
        description,
        min_order_qty,
        max_order_qty,
        price,
        created_at
    FROM commodity
    WHERE SOUNDEX(item_name) = SOUNDEX(p_searchTerm)
       OR item_name LIKE CONCAT('%', p_searchTerm, '%');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SearchStores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchStores`(IN search_term VARCHAR(100))
BEGIN
    SELECT 
        c.customer_id AS storeId,
        c.store_name,
        COUNT(DISTINCT o.order_id) AS orders,
        IFNULL(SUM(b.total_price), 0) AS sales
    FROM customer c
    LEFT JOIN orders o ON o.sender_id = c.customer_id
    LEFT JOIN billing b ON b.order_id = o.order_id
    WHERE c.store_name LIKE CONCAT('%', search_term, '%')
    GROUP BY c.customer_id, c.store_name
    ORDER BY c.store_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SearchUserOrStoreWithDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchUserOrStoreWithDate`(
    IN search_term VARCHAR(100),
    IN date_filter ENUM('TODAY', 'WEEK', 'MONTH')
)
BEGIN
    DECLARE start_date DATE;
    DECLARE end_date DATE;

    -- Determine date range based on filter
    IF date_filter = 'TODAY' THEN
        SET start_date = CURDATE();
        SET end_date = CURDATE();
    ELSEIF date_filter = 'WEEK' THEN
        SET start_date = DATE_SUB(CURDATE(), INTERVAL WEEKDAY(CURDATE()) DAY); -- Monday
        SET end_date = CURDATE();
    ELSEIF date_filter = 'MONTH' THEN
        SET start_date = DATE_FORMAT(CURDATE(), '%Y-%m-01'); -- 1st of month
        SET end_date = CURDATE();
    END IF;

    -- 1st Result Set: Users
    SELECT 
        u.employeeid AS id,
        u.employee_full_name AS name,
        COUNT(DISTINCT o.order_id) AS orders,
        IFNULL(SUM(b.total_amount_paid), 0) AS sales_in_aed,
        'User' AS type
    FROM users u
    LEFT JOIN orders o ON o.created_by = u.employeeid AND o.created_at BETWEEN start_date AND end_date
    LEFT JOIN billing b ON b.employee_id = u.employeeid AND b.billing_id IS NOT NULL AND b.order_id IN (
        SELECT order_id FROM orders WHERE created_by = u.employeeid AND created_at BETWEEN start_date AND end_date
    )
    WHERE u.employee_full_name LIKE CONCAT('%', search_term, '%')
    GROUP BY u.employeeid, u.employee_full_name;

    -- 2nd Result Set: Stores
    SELECT 
        c.customer_id AS id,
        c.store_name AS name,
        COUNT(DISTINCT o.order_id) AS orders,
        IFNULL(SUM(b.total_price), 0) AS sales_in_aed,
        'Store' AS type
    FROM customer c
    LEFT JOIN orders o ON o.sender_id = c.customer_id AND o.created_at BETWEEN start_date AND end_date
    LEFT JOIN billing b ON b.order_id = o.order_id
    WHERE c.store_name LIKE CONCAT('%', search_term, '%')
    GROUP BY c.customer_id, c.store_name;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SearchUsers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SearchUsers`(IN search_term VARCHAR(100))
BEGIN
    SELECT 
        u.employeeid AS userId,
        u.employee_full_name AS name,
        COUNT(DISTINCT o.order_id) AS orders,
        IFNULL(SUM(b.total_amount_paid), 0) AS sales
    FROM users u
    LEFT JOIN orders o ON o.created_by = u.employeeid
    LEFT JOIN billing b ON b.employee_id = u.employeeid
    WHERE u.employee_full_name LIKE CONCAT('%', search_term, '%')
    GROUP BY u.employeeid, u.employee_full_name
    ORDER BY u.employee_full_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_GetBillDetailsByStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GetBillDetailsByStatus`(
    IN p_payment_status VARCHAR(20)
)
BEGIN
    SELECT 
        o.order_id, 
        c.store_name, 
        c.phone_number, 
        c.whatsapp_num, 
        c.email, 
        b.total_price, 
        b.total_amount_paid, 
        b.outstanding_amount_paid, 
        b.payment_status, 
        b.created_at AS bill_created_at, 
        b.delivery_date,
        c.city, 
        b.payment_status,
        b.created_at AS bill_created_at
    FROM moving_bazaar.billing b
    INNER JOIN moving_bazaar.orders o
        ON b.order_id = o.order_id
    INNER JOIN moving_bazaar.customer c
        ON o.sender_id = c.customer_id
    WHERE b.payment_status = p_payment_status;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_get_invoice_json` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_invoice_json`(IN p_order_id INT)
BEGIN
    DECLARE sender_name, sender_address, sender_email, sender_phone TEXT;
    DECLARE receiver_name, receiver_address, receiver_email, receiver_phone TEXT;
    DECLARE start_date, end_date DATE;
    DECLARE bill_to_name, bill_to_address, bill_to_email, bill_to_phone TEXT;
    DECLARE total, grand_total, outstanding_balance DECIMAL(10,2);
    DECLARE note TEXT;

    -- Delivery Details
    SELECT 
        s.store_name, CONCAT(s.address_line1, ', ', s.address_line2, ', ', s.city),
        s.email, s.phone_number,
        r.store_name, CONCAT(r.address_line1, ', ', r.address_line2, ', ', r.city),
        r.email, r.phone_number,
        o.created_at, DATE_ADD(o.created_at, INTERVAL 2 DAY)
    INTO
        sender_name, sender_address, sender_email, sender_phone,
        receiver_name, receiver_address, receiver_email, receiver_phone,
        start_date, end_date
    FROM orders o
    JOIN customer s ON o.sender_id = s.customer_id
    JOIN customer r ON o.receiver_id = r.customer_id
    WHERE o.order_id = p_order_id;

    -- Billing Details
    SELECT 
        c.store_name, CONCAT(c.address_line1, ', ', c.address_line2, ', ', c.city),
        c.email, c.phone_number,
        b.total_price, b.grand_total, b.outstanding_amount_paid,
        b.payment_status
    INTO
        bill_to_name, bill_to_address, bill_to_email, bill_to_phone,
        total, grand_total, outstanding_balance,
        note
    FROM billing b
    JOIN orders o ON o.order_id = b.order_id
    JOIN customer c ON o.sender_id = c.customer_id
    WHERE b.order_id = p_order_id
    LIMIT 1;

    -- Final JSON Output
    SELECT JSON_OBJECT(
        'delivery_details', JSON_OBJECT(
            'estimated_delivery', JSON_OBJECT(
                'start_date', DATE_FORMAT(start_date, '%b %d'),
                'end_date', DATE_FORMAT(end_date, '%b %d')
            ),
            'sender', JSON_OBJECT(
                'name', sender_name,
                'address', sender_address,
                'email', sender_email,
                'phone', sender_phone
            ),
            'receiver', JSON_OBJECT(
                'name', receiver_name,
                'address', receiver_address,
                'email', receiver_email,
                'phone', receiver_phone
            )
        ),
        'billing_details', JSON_OBJECT(
            'bill_to', JSON_OBJECT(
                'name', bill_to_name,
                'address', bill_to_address,
                'email', bill_to_email,
                'phone', bill_to_phone
            ),
            'order_summary', (
                SELECT JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'item', cm.item_name,
                        'quantity', oi.quantity,
                        'unit_price', cm.price,
                        'total_price', oi.total_price
                    )
                )
                FROM order_items oi
                JOIN commodity cm ON cm.commodity_id = oi.commodity_id
                WHERE oi.order_id = p_order_id
            ),
            'total', total,
            'outstanding_balance', outstanding_balance,
            'grand_total', grand_total,
            'note', CONCAT('Amount to be paid by the Sender - ', bill_to_name)
        )
    ) AS invoice_data;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SP_UpdateBillingStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_UpdateBillingStatus`(
    IN p_billing_id INT,
    IN p_new_status VARCHAR(20)
)
BEGIN
    UPDATE moving_bazaar.billing
    SET payment_status = p_new_status
    WHERE id = p_billing_id;
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
    -- Only proceed if the order_id exists in the billing table
    IF EXISTS (
        SELECT 1 FROM moving_bazaar.billing WHERE order_id = p_order_id
    ) THEN

        -- Update the order table with or without reason
        IF p_reason_id IS NULL THEN
            UPDATE moving_bazaar.orders
            SET 
                order_status = p_order_status,
                updated_at = NOW()
            WHERE order_id = p_order_id;
        ELSE
            UPDATE moving_bazaar.orders
            SET 
                order_status = p_order_status,
                reason_id = p_reason_id,
                updated_at = NOW()
            WHERE order_id = p_order_id;
        END IF;

        -- If the order table was updated
        IF ROW_COUNT() > 0 THEN
            -- Insert or update delivery_details table with status and timestamp
            IF EXISTS (
                SELECT 1 FROM moving_bazaar.delivery_details WHERE order_id = p_order_id AND status = p_order_status
            ) THEN
                -- Just update the status_time for same status
                UPDATE moving_bazaar.delivery_details
                SET status_time = NOW()
                WHERE order_id = p_order_id AND status = p_order_status;
            ELSE
                -- Insert new status row
                INSERT INTO moving_bazaar.delivery_details (order_id, status, status_time)
                VALUES (p_order_id, p_order_status, NOW());
            END IF;

            SELECT 'updated successfully.' AS message, p_order_id AS orderId;
        ELSE
            SELECT 'no changes made.' AS message, p_order_id AS orderId;
        END IF;
    ELSE
        -- Order doesn't exist in billing table
        SELECT 'skipped: order not found in billing table.' AS message, p_order_id AS orderId;
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
/*!50003 DROP PROCEDURE IF EXISTS `update_city_service_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_city_service_status`(
    IN p_city_id INT,
    IN p_is_service BOOLEAN
)
BEGIN
    DECLARE affected_rows INT DEFAULT 0;
    DECLARE error_message VARCHAR(255);

    -- Handle errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 error_message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', error_message) AS message;
    END;

    -- Update city service status
    UPDATE city 
    SET is_service = p_is_service 
    WHERE c_id = p_city_id;

    SET affected_rows = ROW_COUNT();

    IF affected_rows > 0 THEN
        SELECT 'City service status updated successfully.' AS message;
    ELSE
        SELECT 'No city found with the given ID.' AS message;
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

-- Dump completed on 2025-08-16 12:38:20
