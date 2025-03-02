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
  `min_order_qty` int NOT NULL DEFAULT '1',
  `max_order_qty` int NOT NULL DEFAULT '10',
  `price` decimal(10,2) NOT NULL DEFAULT '30.00',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`commodity_id`),
  UNIQUE KEY `unique_commodity` (`item_name`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `commodity`
--

LOCK TABLES `commodity` WRITE;
/*!40000 ALTER TABLE `commodity` DISABLE KEYS */;
INSERT INTO `commodity` VALUES (2,'Premium Fresh Fruits','new_fruits.jpg',2,15,50.00,'2025-02-06 16:14:07'),(5,' Vegetables','veg_image.jpg',1,10,35.50,'2025-02-10 17:26:31'),(10,'Test Commodity','test.jpg',1,5,25.00,'2025-02-10 17:39:56'),(11,'Updated Commodi','updated.jpg',2,10,30.50,'2025-02-10 17:40:35'),(12,'Onion','onion.jpg',1,100,25.00,'2025-02-22 11:03:34'),(13,'Potato','potato.jpg',1,150,20.00,'2025-02-22 11:03:34'),(14,'Carrot','carrot.jpg',1,80,40.00,'2025-02-22 11:03:34'),(15,'Brinjal','brinjal.jpg',1,60,35.00,'2025-02-22 11:03:34'),(16,'Cabbage','cabbage.jpg',1,50,30.00,'2025-02-22 11:03:34'),(17,'Apple','apple.jpg',2,50,120.00,'2025-02-22 11:03:44'),(18,'Banana','banana.jpg',2,200,60.00,'2025-02-22 11:03:45'),(19,'Pomegranate','pomegranate.jpg',2,40,180.00,'2025-02-22 11:03:45'),(20,'Grapes','grapes.jpg',2,75,90.00,'2025-02-22 11:03:45'),(21,'Papaya','papaya.jpg',2,30,50.00,'2025-02-22 11:03:45'),(22,'Milk','milk.jpg',3,500,50.00,'2025-02-22 11:04:00'),(23,'Curd','curd.jpg',3,100,40.00,'2025-02-22 11:04:00'),(24,'Paneer','paneer.jpg',3,80,250.00,'2025-02-22 11:04:00'),(25,'Butter','butter.jpg',3,70,450.00,'2025-02-22 11:04:00'),(26,'Ghee','ghee.jpg',3,60,600.00,'2025-02-22 11:04:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (4,'New Store Name','new_email@example.com','050000002','050000002','456 New Street','Area B','Los Angeles',150.50,'2025-02-06 15:46:05'),(5,'vignesh Store','karthick@example.com','050000003',NULL,'123 Street','Area A','New York',0.00,'2025-02-07 00:03:17'),(10,'Kumar Supermarket','kumar.store@example.com','9876543210','9876543211','12, Mount Road','T. Nagar','Chennai',5000.00,'2025-02-22 11:00:49'),(12,'Gupta Wholesale','gupta.wholesale@example.com','9823456789','9823456790','45, Connaught Place','Central Delhi','Delhi',10000.50,'2025-02-22 11:01:28'),(13,'Ramesh Kirana','ramesh.kirana@example.com','9900123456',NULL,'8th Main Road','Indiranagar','Bangalore',1500.25,'2025-02-22 11:01:28'),(14,'Sai Fashion','sai.fashion@example.com','9000011223','9000011224','20, Banjara Hills','Jubilee Hills','Hyderabad',7500.00,'2025-02-22 11:01:28'),(15,'Spice Junction','spice.junction@example.com','9822004455',NULL,'21, Linking Road','Bandra','Mumbai',12000.75,'2025-02-22 11:01:28');
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
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (57,59491924,17,3,360.00,'2025-03-01 01:47:18'),(58,59491924,18,2,120.00,'2025-03-01 01:47:18'),(59,59491924,17,3,360.00,'2025-03-01 01:48:43'),(60,59491924,18,2,120.00,'2025-03-01 01:48:43');
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
INSERT INTO `orders` VALUES (1068025,13,14,10,'In Transit','order','2025-03-01 01:31:06','2025-03-01 01:31:06'),(1454275,13,14,10,'In Transit','order','2025-03-01 01:31:45','2025-03-01 01:31:45'),(3342978,13,14,10,'In Transit','order','2025-03-01 01:33:34','2025-03-01 01:33:34'),(5135981,13,14,10,'In Transit','order','2025-03-01 01:35:13','2025-03-01 01:35:13'),(55030183,12,13,10,'In Transit','order','2025-03-01 01:25:03','2025-03-01 01:25:03'),(55066636,12,13,10,'In Transit','order','2025-03-01 01:25:06','2025-03-01 01:25:06'),(56012634,12,13,10,'In Transit','order','2025-03-01 01:26:01','2025-03-01 01:26:01'),(58263727,13,14,10,'In Transit','order','2025-03-01 01:28:26','2025-03-01 01:28:26'),(58430656,13,14,10,'In Transit','order','2025-03-01 01:28:43','2025-03-01 01:28:43'),(59050656,13,14,10,'In Transit','order','2025-03-01 01:29:05','2025-03-01 01:29:05'),(59212413,13,14,10,'In Transit','order','2025-03-01 01:29:21','2025-03-01 01:29:21'),(59491924,13,14,10,'In Transit','order','2025-03-01 01:29:49','2025-03-01 01:29:49');
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
                'Success' AS Status, 
                'All Order Items Added Successfully' AS Message, 
                p_order_id AS OrderID, 
                order_items_list AS OrderItemIDs, 
                total_price AS TotalPrice;
        ELSE
            SELECT 
                'Failure' AS Status, 
                'No items were added' AS Message, 
                p_order_id AS OrderID;
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
    DECLARE custom_order_id VARCHAR(8);
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
            SELECT 'Success' AS Status, 'Order Created Successfully' AS Message, custom_order_id AS OrderID ,"order" as Ordersatge;
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

    -- Fetch all commodities
    SELECT commodity_id, item_name, item_photo, min_order_qty, max_order_qty, price, created_at 
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
/*!50003 DROP PROCEDURE IF EXISTS `get_customer_balance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_customer_balance`(
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

    -- Retrieve Balance
    IF EXISTS (SELECT 1 FROM customer_balance WHERE customer_id = p_customer_id) THEN
        SELECT customer_id, outstanding_balance, last_updated
        FROM customer_balance
        WHERE customer_id = p_customer_id;
    ELSE
        SELECT 'Error: Customer not found or no outstanding balance.' AS message;
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
        SELECT customer_id, store_name, email, phone_number, whatsapp_number, address_line1, address_line2, city, outstanding_price, created_at
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
        -- Insert New Commodity
        INSERT INTO commodity (item_name, item_photo, min_order_qty, max_order_qty, price)
        VALUES (p_item_name, p_item_photo, p_min_order_qty, p_max_order_qty, p_price);

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
    DECLARE message VARCHAR(255);

    -- Start Error Handling
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Insert Data
    INSERT INTO customer (store_name, email, phone_number, whatsapp_number, address_line1, address_line2, city, outstanding_price)
    VALUES (p_store_name, p_email, p_phone_number, p_whatsapp_number, p_address_line1, p_address_line2, p_city, p_outstanding_price);

    -- Success Message
    SELECT 'Customer inserted successfully.' AS message;
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
    DECLARE login_status INT;
    DECLARE login_message VARCHAR(255);

    -- Check if user exists with the given email and password
    SELECT employeeid, employee_email
    INTO emp_id, emp_email
    FROM users
    WHERE employee_email = input_email 
      AND employee_password = input_password
      COLLATE utf8mb4_general_ci -- Case-insensitive comparison
    LIMIT 1;

    -- If match found, return success
    IF emp_id IS NOT NULL THEN
        SET login_status = 1;
        SET login_message = 'Login successful';
    ELSE
        SET login_status = 0;
        SET emp_id = NULL;
        SET emp_email = NULL;
        SET login_message = 'Invalid email or password';
    END IF;

    -- Return the login result
    SELECT login_status AS result_status, emp_id AS employee_id, emp_email AS email, login_message AS message;
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
/*!50003 DROP PROCEDURE IF EXISTS `update_commodity` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_commodity`(
    IN p_commodity_id INT,
    IN p_item_name VARCHAR(255),
    IN p_item_photo VARCHAR(255),
    IN p_min_order_qty INT,
    IN p_max_order_qty INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    DECLARE message VARCHAR(255);
    DECLARE rows_affected INT DEFAULT 0;

    -- Handle SQL Errors
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN
        GET DIAGNOSTICS CONDITION 1 message = MESSAGE_TEXT;
        SELECT CONCAT('SQL Error: ', message) AS error_message;
    END;

    -- Check if the commodity exists
    IF EXISTS (SELECT 1 FROM commodity WHERE commodity_id = p_commodity_id) THEN
        -- Prevent duplicate item name
        IF EXISTS (SELECT 1 FROM commodity WHERE item_name = p_item_name AND commodity_id <> p_commodity_id) THEN
            SELECT 'Error: Another commodity with the same name exists.' AS message;
        ELSE
            -- Update the commodity record
            UPDATE commodity
            SET 
                item_name = COALESCE(p_item_name, item_name),
                item_photo = COALESCE(p_item_photo, item_photo),
                min_order_qty = COALESCE(p_min_order_qty, min_order_qty),
                max_order_qty = COALESCE(p_max_order_qty, max_order_qty),
                price = COALESCE(p_price, price)
            WHERE commodity_id = p_commodity_id;

            SET rows_affected = ROW_COUNT();

            IF rows_affected > 0 THEN
                SELECT 'Commodity updated successfully.' AS message;
            ELSE
                SELECT 'No changes were made.' AS message;
            END IF;
        END IF;
    ELSE
        SELECT 'Error: Commodity not found.' AS message;
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

-- Dump completed on 2025-03-02  8:37:51
