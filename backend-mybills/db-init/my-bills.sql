-- MySQL dump 10.13  Distrib 8.0.44, for Linux (x86_64)
--
-- Host: localhost    Database: my_bills
-- ------------------------------------------------------
-- Server version	8.0.44-0ubuntu0.24.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `charge_types`
--

DROP TABLE IF EXISTS `charge_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `charge_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `charge_types`
--

LOCK TABLES `charge_types` WRITE;
/*!40000 ALTER TABLE `charge_types` DISABLE KEYS */;
INSERT INTO `charge_types` VALUES (7,'Call Charges International'),(3,'Call Charges National'),(4,'Call Charges Roaming'),(6,'Discount Summary'),(2,'New Installments'),(8,'One Time Charge'),(1,'Recurring Charge'),(5,'Subscription Total');
/*!40000 ALTER TABLE `charge_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `charges`
--

DROP TABLE IF EXISTS `charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `charges` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `invoice_id` bigint NOT NULL,
  `subscription_id` bigint DEFAULT NULL,
  `charge_type_id` int NOT NULL,
  `row_type_id` int DEFAULT NULL,
  `jurisdiction_id` int DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `installments` varchar(50) DEFAULT NULL,
  `charge_from_date` date DEFAULT NULL,
  `charge_to_date` date DEFAULT NULL,
  `display_units` varchar(50) DEFAULT NULL,
  `call_counter` int DEFAULT NULL,
  `charged_amount` decimal(12,2) NOT NULL,
  `discount` decimal(12,2) DEFAULT NULL,
  `full_amount` decimal(12,2) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_chg_invoice` (`invoice_id`),
  KEY `fk_chg_subscription` (`subscription_id`),
  KEY `fk_chg_type` (`charge_type_id`),
  KEY `fk_chg_row_type` (`row_type_id`),
  KEY `fk_chg_juris` (`jurisdiction_id`),
  CONSTRAINT `fk_chg_invoice` FOREIGN KEY (`invoice_id`) REFERENCES `invoices` (`id`),
  CONSTRAINT `fk_chg_juris` FOREIGN KEY (`jurisdiction_id`) REFERENCES `jurisdictions` (`id`),
  CONSTRAINT `fk_chg_row_type` FOREIGN KEY (`row_type_id`) REFERENCES `row_types` (`id`),
  CONSTRAINT `fk_chg_subscription` FOREIGN KEY (`subscription_id`) REFERENCES `subscriptions` (`id`),
  CONSTRAINT `fk_chg_type` FOREIGN KEY (`charge_type_id`) REFERENCES `charge_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=256 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `charges`
--

LOCK TABLES `charges` WRITE;
/*!40000 ALTER TABLE `charges` DISABLE KEYS */;
INSERT INTO `charges` VALUES (1,1,1,1,1,NULL,'Freedom europe & US','','2025-11-01','2025-11-30','',0,29.00,108.40,137.40,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(2,1,1,1,1,NULL,'Apple Music','','2025-11-01','2025-11-30','',0,13.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(3,1,1,1,1,NULL,'surf protect','','2025-11-01','2025-11-30','',0,2.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(4,1,1,1,1,NULL,'Flex Upgrade incl. AppleCare Services (Insurance premium)','','2025-11-01','2025-11-30','',0,15.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(5,1,1,2,1,NULL,'Apple iPhone 16 Plus 256GB Black Black','3 of 24',NULL,NULL,'',0,43.70,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(6,1,1,3,1,1,'','',NULL,NULL,'0:00:22',6,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(7,1,1,4,1,2,'','',NULL,NULL,'1:00:48',21,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(8,1,1,4,1,3,'','',NULL,NULL,'0:05:06',6,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(9,1,1,4,1,4,'','',NULL,NULL,'27850 MB',59,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(10,1,1,4,1,5,'','',NULL,NULL,'',1,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(11,1,1,5,2,NULL,'','',NULL,NULL,'',0,104.50,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(12,1,1,6,3,NULL,'Employee discount partner company - Basic monthly charge - 78.8937%','','2025-11-01','2025-11-30','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(13,2,1,1,1,NULL,'Freedom europe & US','','2025-10-01','2025-10-31','',0,29.00,108.40,137.40,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(14,2,1,1,1,NULL,'Apple Music','','2025-10-01','2025-10-31','',0,13.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(15,2,1,1,1,NULL,'surf protect','','2025-10-01','2025-10-31','',0,2.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(16,2,1,1,1,NULL,'Flex Upgrade incl. AppleCare Services (Insurance premium)','','2025-10-01','2025-10-31','',0,15.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(17,2,1,2,1,NULL,'Apple iPhone 16 Plus 256GB Black Black','2 of 24',NULL,NULL,'',0,43.70,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(18,2,1,3,1,4,'','',NULL,NULL,'578 MB',1,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(19,2,1,4,1,2,'','',NULL,NULL,'0:06:42',2,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(20,2,1,4,1,3,'','',NULL,NULL,'0:01:18',2,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(21,2,1,4,1,4,'','',NULL,NULL,'21277 MB',41,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(22,2,1,5,2,NULL,'','',NULL,NULL,'',0,104.50,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(23,2,1,6,3,NULL,'Employee discount partner company - Basic monthly charge - 78.8937%','','2025-09-19','2025-10-31','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(24,3,1,1,1,NULL,'Freedom europe & US','','2025-09-01','2025-09-30','',0,29.00,108.40,137.40,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(25,3,1,1,1,NULL,'Flex Upgrade incl. AppleCare Services (Insurance premium)','','2025-08-26','2025-08-31','',0,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(26,3,1,1,1,NULL,'Apple Music','','2025-09-01','2025-09-30','',0,13.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(27,3,1,1,1,NULL,'surf protect','','2025-09-01','2025-09-30','',0,2.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(28,3,1,1,1,NULL,'Flex Upgrade incl. AppleCare Services (Insurance premium)','','2025-09-01','2025-09-30','',0,15.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(29,3,1,2,1,NULL,'Apple iPhone 16 Plus 256GB Black Black','1 of 24',NULL,NULL,'',0,43.70,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(30,3,1,2,1,NULL,'PanzerGlass UW Fit iP 16+','1 of 24',NULL,NULL,'',0,1.85,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(31,3,1,2,1,NULL,'Apple iP 16+ Clear Case MagSafe','1 of 24',NULL,NULL,'',0,2.05,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(32,3,1,2,1,NULL,'Apple iPhone 16 Plus 256GB Black Black','',NULL,NULL,'',0,1.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(33,3,1,2,1,NULL,'PanzerGlass UW Fit iP 16+','',NULL,NULL,'',0,1.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(34,3,1,2,1,NULL,'Apple iP 16+ Clear Case MagSafe','',NULL,NULL,'',0,1.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(35,3,1,3,1,6,'','',NULL,NULL,'0:00:42',1,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(36,3,1,3,1,4,'','',NULL,NULL,'16665 MB',24,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(37,3,1,7,1,3,'','',NULL,NULL,'0:24:53',2,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(38,3,1,4,1,2,'','',NULL,NULL,'0:00:37',1,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(39,3,1,4,1,3,'','',NULL,NULL,'0:00:30',1,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(40,3,1,4,1,4,'','',NULL,NULL,'32507 MB',28,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(41,3,1,8,1,NULL,'Exchange fee eSIM - O110022890','','2025-08-29','2025-08-29','',0,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(42,3,1,5,2,NULL,'','',NULL,NULL,'',0,111.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(43,3,1,6,3,NULL,'Employee discount partner company - Basic monthly charge - 78.8937%','','2025-09-01','2025-09-30','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(44,4,1,1,1,NULL,'Freedom europe & US','','2025-08-01','2025-08-31','',0,29.00,108.40,137.40,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(45,4,1,1,1,NULL,'Apple Music','','2025-08-01','2025-08-31','',0,13.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(46,4,1,1,1,NULL,'surf protect','','2025-08-01','2025-08-31','',0,2.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(47,4,1,1,1,NULL,'Flex Upgrade incl. AppleCare Services (Insurance premium)','','2025-08-01','2025-08-31','',0,10.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(48,4,1,2,1,NULL,'Apple iPhone 14 128GB Noir','24 of 24',NULL,NULL,'',0,33.25,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(49,4,1,3,1,4,'','',NULL,NULL,'9078 MB',11,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(50,4,1,7,1,3,'','',NULL,NULL,'1:02:43',7,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(51,4,1,4,1,2,'','',NULL,NULL,'0:16:28',14,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(52,4,1,4,1,3,'','',NULL,NULL,'0:01:16',3,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(53,4,1,4,1,4,'','',NULL,NULL,'16490 MB',51,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(54,4,1,5,2,NULL,'','',NULL,NULL,'',0,89.05,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(55,4,1,6,3,NULL,'Employee discount partner company - Basic monthly charge - 78.8937%','','2025-08-01','2025-08-31','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(56,5,1,1,1,NULL,'Freedom europe & US','','2025-07-01','2025-07-31','',0,29.00,108.40,137.40,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(57,5,1,1,1,NULL,'Apple Music','','2025-07-01','2025-07-31','',0,13.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(58,5,1,1,1,NULL,'surf protect','','2025-07-01','2025-07-31','',0,2.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(59,5,1,1,1,NULL,'Sunrise TV neo max','','2025-07-01','2025-07-31','',0,25.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(60,5,1,3,1,4,'','',NULL,NULL,'8000 MB',10,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(61,5,1,4,1,2,'','',NULL,NULL,'0:10:15',3,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(62,5,1,4,1,3,'','',NULL,NULL,'0:03:45',2,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(63,5,1,4,1,4,'','',NULL,NULL,'15000 MB',25,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(64,5,1,5,2,NULL,'','',NULL,NULL,'',0,150.20,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(65,5,1,6,3,NULL,'','','2025-07-01','2025-07-31','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(66,6,1,1,1,NULL,'Freedom europe & US','','2025-06-01','2025-06-30','',0,29.00,108.40,137.40,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(67,6,1,1,1,NULL,'Apple Music','','2025-06-01','2025-06-30','',0,13.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(68,6,1,1,1,NULL,'surf protect','','2025-06-01','2025-06-30','',0,2.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(69,6,1,1,1,NULL,'Sunrise TV neo max','','2025-06-01','2025-06-30','',0,25.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(70,6,1,2,1,NULL,'Apple iPhone 14 128GB Noir','22 of 24',NULL,NULL,'',0,33.25,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(71,6,1,3,1,4,'','',NULL,NULL,'9500 MB',11,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(72,6,1,4,1,2,'','',NULL,NULL,'0:10:15',3,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(73,6,1,4,1,3,'','',NULL,NULL,'0:03:45',2,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(74,6,1,4,1,4,'','',NULL,NULL,'17000 MB',26,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(75,6,1,5,2,NULL,'','',NULL,NULL,'',0,183.45,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(76,6,1,6,3,NULL,'','','2025-06-01','2025-06-30','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(77,7,1,1,1,NULL,'Freedom europe & US','','2025-05-01','2025-05-31','',0,29.00,108.40,137.40,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(78,7,1,1,1,NULL,'Apple Music','','2025-05-01','2025-05-31','',0,13.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(79,7,1,1,1,NULL,'surf protect','','2025-05-01','2025-05-31','',0,2.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(80,7,1,1,1,NULL,'Netflix option','','2025-05-01','2025-05-31','',0,19.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(81,7,1,2,1,NULL,'Apple iPhone 14 128GB Noir','21 of 24',NULL,NULL,'',0,33.25,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(82,7,1,3,1,4,'','',NULL,NULL,'11000 MB',12,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(83,7,1,4,1,2,'','',NULL,NULL,'0:10:15',3,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(84,7,1,4,1,3,'','',NULL,NULL,'0:03:45',2,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(85,7,1,4,1,4,'','',NULL,NULL,'19000 MB',27,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(86,7,1,5,2,NULL,'','',NULL,NULL,'',0,178.35,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(87,7,1,6,3,NULL,'','','2025-05-01','2025-05-31','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(88,8,1,1,1,NULL,'Freedom europe & US','','2025-04-01','2025-04-30','',0,29.00,108.40,137.40,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(89,8,1,1,1,NULL,'Spotify Premium','','2025-04-01','2025-04-30','',0,13.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(90,8,1,1,1,NULL,'surf protect','','2025-04-01','2025-04-30','',0,2.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(91,8,1,1,1,NULL,'Netflix option','','2025-04-01','2025-04-30','',0,19.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(92,8,1,2,1,NULL,'Apple iPhone 14 128GB Noir','20 of 24',NULL,NULL,'',0,33.25,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(93,8,1,3,1,4,'','',NULL,NULL,'12500 MB',13,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(94,8,1,4,1,2,'','',NULL,NULL,'0:10:15',3,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(95,8,1,4,1,3,'','',NULL,NULL,'0:03:45',2,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(96,8,1,4,1,4,'','',NULL,NULL,'21000 MB',28,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(97,8,1,5,2,NULL,'','',NULL,NULL,'',0,178.35,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(98,8,1,6,3,NULL,'','','2025-04-01','2025-04-30','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(99,9,1,1,1,NULL,'Freedom europe & US','','2025-03-01','2025-03-31','',0,29.00,108.40,137.40,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(100,9,1,1,1,NULL,'Spotify Premium','','2025-03-01','2025-03-31','',0,13.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(101,9,1,1,1,NULL,'surf protect','','2025-03-01','2025-03-31','',0,2.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(102,9,1,1,1,NULL,'Extra data 5GB add-on','','2025-03-01','2025-03-31','',0,10.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(103,9,1,3,1,4,'','',NULL,NULL,'14000 MB',14,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(104,9,1,4,1,2,'','',NULL,NULL,'0:10:15',3,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(105,9,1,4,1,3,'','',NULL,NULL,'0:03:45',2,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(106,9,1,4,1,4,'','',NULL,NULL,'23000 MB',29,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(107,9,1,5,2,NULL,'','',NULL,NULL,'',0,135.20,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(108,9,1,6,3,NULL,'','','2025-03-01','2025-03-31','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(109,10,1,1,1,NULL,'Freedom europe & US','','2025-02-01','2025-02-28','',0,29.00,108.40,137.40,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(110,10,1,1,1,NULL,'Spotify Premium','','2025-02-01','2025-02-28','',0,13.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(111,10,1,1,1,NULL,'surf protect','','2025-02-01','2025-02-28','',0,2.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(112,10,1,1,1,NULL,'Extra data 5GB add-on','','2025-02-01','2025-02-28','',0,10.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(113,10,1,3,1,4,'','',NULL,NULL,'15500 MB',15,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(114,10,1,4,1,2,'','',NULL,NULL,'0:10:15',3,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(115,10,1,4,1,3,'','',NULL,NULL,'0:03:45',2,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(116,10,1,4,1,4,'','',NULL,NULL,'25000 MB',30,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(117,10,1,5,2,NULL,'','',NULL,NULL,'',0,135.20,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(118,10,1,6,3,NULL,'','','2025-02-01','2025-02-28','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(119,11,1,1,1,NULL,'Freedom europe & US','','2025-01-01','2025-01-31','',0,29.00,108.40,137.40,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(120,11,1,1,1,NULL,'Spotify Premium','','2025-01-01','2025-01-31','',0,13.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(121,11,1,2,1,NULL,'Apple iPhone 14 128GB Noir','20 of 24',NULL,NULL,'',0,33.25,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(122,11,1,3,1,4,'','',NULL,NULL,'11500 MB',13,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(123,11,1,8,1,NULL,'Admin fee','','2024-12-15','2024-12-15','',0,10.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(124,11,1,5,2,NULL,'','',NULL,NULL,'',0,165.55,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(125,11,1,6,3,NULL,'','','2025-01-01','2025-01-31','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(126,12,1,1,1,NULL,'Freedom europe & US','','2024-12-01','2024-12-31','',0,29.00,108.40,137.40,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(127,12,1,1,1,NULL,'surf protect','','2024-12-01','2024-12-31','',0,2.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(128,12,1,1,1,NULL,'Netflix Option','','2024-12-01','2024-12-31','',0,19.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(129,12,1,2,1,NULL,'Apple iPhone 14 128GB Noir','19 of 24',NULL,NULL,'',0,33.25,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(130,12,1,3,1,4,'','',NULL,NULL,'9500 MB',10,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(131,12,1,3,1,3,'','',NULL,NULL,'0:12:52',4,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(132,12,1,5,2,NULL,'','',NULL,NULL,'',0,164.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(133,12,1,6,3,NULL,'','','2024-12-01','2024-12-31','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(134,13,1,1,1,NULL,'surf protect','','2024-11-01','2024-11-30','',0,2.90,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(135,13,1,2,1,NULL,'Apple iPhone 14 128GB Noir','18 of 24',NULL,NULL,'',0,33.25,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(136,13,1,3,1,4,'','',NULL,NULL,'10500 MB',12,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(137,13,1,4,1,2,'','',NULL,NULL,'0:04:22',2,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(138,13,1,4,1,3,'','',NULL,NULL,'0:01:15',1,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(139,13,1,4,1,4,'','',NULL,NULL,'8000 MB',15,0.00,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(140,13,1,5,2,NULL,'','',NULL,NULL,'',0,158.45,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02'),(141,13,1,6,3,NULL,'','','2024-11-01','2024-11-30','',0,-108.40,0.00,0.00,'2025-12-08 10:46:02','2025-12-08 10:46:02');
/*!40000 ALTER TABLE `charges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_number` bigint NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_number` (`customer_number`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
INSERT INTO `customers` VALUES (1,5556609618,'Lisa Simpson','2025-12-08 10:34:03','2025-12-08 10:34:03');
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoices`
--

DROP TABLE IF EXISTS `invoices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoices` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `invoice_number` bigint NOT NULL,
  `customer_id` bigint NOT NULL,
  `bill_to_date` date NOT NULL,
  `amount_due` decimal(12,2) DEFAULT NULL,
  `currency` char(3) DEFAULT 'CHF',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `invoice_number` (`invoice_number`),
  KEY `fk_inv_customer` (`customer_id`),
  CONSTRAINT `fk_inv_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoices`
--

LOCK TABLES `invoices` WRITE;
/*!40000 ALTER TABLE `invoices` DISABLE KEYS */;
INSERT INTO `invoices` VALUES (1,1107740232,1,'2025-10-31',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00'),(2,1103713534,1,'2025-09-30',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00'),(3,1099668357,1,'2025-08-31',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00'),(4,1095632148,1,'2025-07-31',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00'),(5,1091600001,1,'2025-06-30',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00'),(6,1087560002,1,'2025-05-31',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00'),(7,1083520003,1,'2025-04-30',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00'),(8,1079480004,1,'2025-03-31',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00'),(9,1075440005,1,'2025-02-28',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00'),(10,1071400006,1,'2025-01-31',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00'),(11,1059220003,1,'2024-12-31',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00'),(12,1063260002,1,'2024-11-30',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00'),(13,1067300001,1,'2024-10-31',NULL,'CHF','2025-12-08 10:37:00','2025-12-08 10:37:00');
/*!40000 ALTER TABLE `invoices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jurisdictions`
--

DROP TABLE IF EXISTS `jurisdictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jurisdictions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jurisdictions`
--

LOCK TABLES `jurisdictions` WRITE;
/*!40000 ALTER TABLE `jurisdictions` DISABLE KEYS */;
INSERT INTO `jurisdictions` VALUES (1,'Calls to mailbox'),(2,'Incoming calls'),(4,'Mobile Internet'),(3,'Outgoing calls'),(5,'SMS'),(6,'Swiss landline network');
/*!40000 ALTER TABLE `jurisdictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_lines`
--

DROP TABLE IF EXISTS `product_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_lines` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_lines`
--

LOCK TABLES `product_lines` WRITE;
/*!40000 ALTER TABLE `product_lines` DISABLE KEYS */;
INSERT INTO `product_lines` VALUES (1,'Sunrise Mobile Service');
/*!40000 ALTER TABLE `product_lines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `row_types`
--

DROP TABLE IF EXISTS `row_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `row_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `row_types`
--

LOCK TABLES `row_types` WRITE;
/*!40000 ALTER TABLE `row_types` DISABLE KEYS */;
INSERT INTO `row_types` VALUES (1,'Charge\r'),(3,'DiscountSummary\r'),(2,'SubscriptionTotal\r');
/*!40000 ALTER TABLE `row_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staging_billing`
--

DROP TABLE IF EXISTS `staging_billing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staging_billing` (
  `CUSTOMER_NUMBER` bigint DEFAULT NULL,
  `INVOICE_NUMBER` bigint DEFAULT NULL,
  `BILL_TO_DATE` varchar(20) DEFAULT NULL,
  `CHARGE_TYPE` varchar(100) DEFAULT NULL,
  `JURISDICTION_NAME` varchar(255) DEFAULT NULL,
  `PRODUCT_LINE_NAME` varchar(255) DEFAULT NULL,
  `EXTERNAL_ID` varchar(50) DEFAULT NULL,
  `EXTERNAL_ID_DESC` varchar(255) DEFAULT NULL,
  `DESCRIPTION` varchar(255) DEFAULT NULL,
  `INSTALLMENTS` varchar(50) DEFAULT NULL,
  `CHARGE_FROM_DATE` varchar(20) DEFAULT NULL,
  `CHARGE_TO_DATE` varchar(20) DEFAULT NULL,
  `DISPLAY_UNITS` varchar(50) DEFAULT NULL,
  `CALL_COUNTER` int DEFAULT NULL,
  `CHARGED_AMOUNT` decimal(12,2) DEFAULT NULL,
  `DISCOUNT` decimal(12,2) DEFAULT NULL,
  `FULL_AMOUNT` decimal(12,2) DEFAULT NULL,
  `SUBSCRIPTION_STATE` varchar(50) DEFAULT NULL,
  `ROW_TYPE` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staging_billing`
--

LOCK TABLES `staging_billing` WRITE;
/*!40000 ALTER TABLE `staging_billing` DISABLE KEYS */;
INSERT INTO `staging_billing` VALUES (5556609618,1107740232,'31-Oct-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Freedom europe & US','','1-Nov-25','30-Nov-25','',0,29.00,108.40,137.40,'','Charge\r'),(5556609618,1107740232,'31-Oct-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple Music','','1-Nov-25','30-Nov-25','',0,13.90,0.00,0.00,'','Charge\r'),(5556609618,1107740232,'31-Oct-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','surf protect','','1-Nov-25','30-Nov-25','',0,2.90,0.00,0.00,'','Charge\r'),(5556609618,1107740232,'31-Oct-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Flex Upgrade incl. AppleCare Services (Insurance premium)','','1-Nov-25','30-Nov-25','',0,15.00,0.00,0.00,'','Charge\r'),(5556609618,1107740232,'31-Oct-25','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iPhone 16 Plus 256GB Black Black','3 of 24','','','',0,43.70,0.00,0.00,'','Charge\r'),(5556609618,1107740232,'31-Oct-25','Call Charges National','Calls to mailbox','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:00:22',6,0.00,0.00,0.00,'','Charge\r'),(5556609618,1107740232,'31-Oct-25','Call Charges Roaming','Incoming calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','1:00:48',21,0.00,0.00,0.00,'','Charge\r'),(5556609618,1107740232,'31-Oct-25','Call Charges Roaming','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:05:06',6,0.00,0.00,0.00,'','Charge\r'),(5556609618,1107740232,'31-Oct-25','Call Charges Roaming','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','27850 MB',59,0.00,0.00,0.00,'','Charge\r'),(5556609618,1107740232,'31-Oct-25','Call Charges Roaming','SMS','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','',1,0.00,0.00,0.00,'','Charge\r'),(5556609618,1107740232,'31-Oct-25','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,104.50,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1107740232,'31-Oct-25','Discount Summary','','','021 292 70 96','Lisa Simpson','Employee discount partner company - Basic monthly charge - 78.8937%','','1-Nov-25','30-Nov-25','',0,-108.40,0.00,0.00,'','DiscountSummary\r'),(5556609618,1103713534,'30-Sep-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Freedom europe & US','','1-Oct-25','31-Oct-25','',0,29.00,108.40,137.40,'','Charge\r'),(5556609618,1103713534,'30-Sep-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple Music','','1-Oct-25','31-Oct-25','',0,13.90,0.00,0.00,'','Charge\r'),(5556609618,1103713534,'30-Sep-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','surf protect','','1-Oct-25','31-Oct-25','',0,2.90,0.00,0.00,'','Charge\r'),(5556609618,1103713534,'30-Sep-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Flex Upgrade incl. AppleCare Services (Insurance premium)','','1-Oct-25','31-Oct-25','',0,15.00,0.00,0.00,'','Charge\r'),(5556609618,1103713534,'30-Sep-25','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iPhone 16 Plus 256GB Black Black','2 of 24','','','',0,43.70,0.00,0.00,'','Charge\r'),(5556609618,1103713534,'30-Sep-25','Call Charges National','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','578 MB',1,0.00,0.00,0.00,'','Charge\r'),(5556609618,1103713534,'30-Sep-25','Call Charges Roaming','Incoming calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:06:42',2,0.00,0.00,0.00,'','Charge\r'),(5556609618,1103713534,'30-Sep-25','Call Charges Roaming','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:01:18',2,0.00,0.00,0.00,'','Charge\r'),(5556609618,1103713534,'30-Sep-25','Call Charges Roaming','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','21277 MB',41,0.00,0.00,0.00,'','Charge\r'),(5556609618,1103713534,'30-Sep-25','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,104.50,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1103713534,'30-Sep-25','Discount Summary','','','021 292 70 96','Lisa Simpson','Employee discount partner company - Basic monthly charge - 78.8937%','','19-Sep-25','31-Oct-25','',0,-108.40,0.00,0.00,'','DiscountSummary\r'),(5556609618,1099668357,'31-Aug-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Freedom europe & US','','1-Sep-25','30-Sep-25','',0,29.00,108.40,137.40,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Flex Upgrade incl. AppleCare Services (Insurance premium)','','26-Aug-25','31-Aug-25','',0,0.00,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple Music','','1-Sep-25','30-Sep-25','',0,13.90,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','surf protect','','1-Sep-25','30-Sep-25','',0,2.90,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Flex Upgrade incl. AppleCare Services (Insurance premium)','','1-Sep-25','30-Sep-25','',0,15.00,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iPhone 16 Plus 256GB Black Black','1 of 24','','','',0,43.70,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','PanzerGlass UW Fit iP 16+','1 of 24','','','',0,1.85,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iP 16+ Clear Case MagSafe','1 of 24','','','',0,2.05,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iPhone 16 Plus 256GB Black Black','','','','',0,1.00,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','PanzerGlass UW Fit iP 16+','','','','',0,1.00,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iP 16+ Clear Case MagSafe','','','','',0,1.00,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','Call Charges National','Swiss landline network','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:00:42',1,0.00,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','Call Charges National','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','16665 MB',24,0.00,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','Call Charges International','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:24:53',2,0.00,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','Call Charges Roaming','Incoming calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:00:37',1,0.00,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','Call Charges Roaming','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:00:30',1,0.00,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','Call Charges Roaming','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','32507 MB',28,0.00,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','One Time Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Exchange fee eSIM - O110022890','','29-Aug-25','29-Aug-25','',0,0.00,0.00,0.00,'','Charge\r'),(5556609618,1099668357,'31-Aug-25','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,111.40,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1099668357,'31-Aug-25','Discount Summary','','','021 292 70 96','Lisa Simpson','Employee discount partner company - Basic monthly charge - 78.8937%','','1-Sep-25','30-Sep-25','',0,-108.40,0.00,0.00,'','DiscountSummary\r'),(5556609618,1095632148,'31-Jul-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Freedom europe & US','','1-Aug-25','31-Aug-25','',0,29.00,108.40,137.40,'','Charge\r'),(5556609618,1095632148,'31-Jul-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple Music','','1-Aug-25','31-Aug-25','',0,13.90,0.00,0.00,'','Charge\r'),(5556609618,1095632148,'31-Jul-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','surf protect','','1-Aug-25','31-Aug-25','',0,2.90,0.00,0.00,'','Charge\r'),(5556609618,1095632148,'31-Jul-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Flex Upgrade incl. AppleCare Services (Insurance premium)','','1-Aug-25','31-Aug-25','',0,10.00,0.00,0.00,'','Charge\r'),(5556609618,1095632148,'31-Jul-25','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iPhone 14 128GB Noir','24 of 24','','','',0,33.25,0.00,0.00,'','Charge\r'),(5556609618,1095632148,'31-Jul-25','Call Charges National','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','9078 MB',11,0.00,0.00,0.00,'','Charge\r'),(5556609618,1095632148,'31-Jul-25','Call Charges International','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','1:02:43',7,0.00,0.00,0.00,'','Charge\r'),(5556609618,1095632148,'31-Jul-25','Call Charges Roaming','Incoming calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:16:28',14,0.00,0.00,0.00,'','Charge\r'),(5556609618,1095632148,'31-Jul-25','Call Charges Roaming','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:01:16',3,0.00,0.00,0.00,'','Charge\r'),(5556609618,1095632148,'31-Jul-25','Call Charges Roaming','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','16490 MB',51,0.00,0.00,0.00,'','Charge\r'),(5556609618,1095632148,'31-Jul-25','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,89.05,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1095632148,'31-Jul-25','Discount Summary','','','021 292 70 96','Lisa Simpson','Employee discount partner company - Basic monthly charge - 78.8937%','','1-Aug-25','31-Aug-25','',0,-108.40,0.00,0.00,'','DiscountSummary\r'),(5556609618,1091600001,'30-Jun-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Freedom europe & US','','1-Jul-25','31-Jul-25','',0,29.00,108.40,137.40,'','Charge\r'),(5556609618,1091600001,'30-Jun-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple Music','','1-Jul-25','31-Jul-25','',0,13.90,0.00,0.00,'','Charge\r'),(5556609618,1091600001,'30-Jun-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','surf protect','','1-Jul-25','31-Jul-25','',0,2.90,0.00,0.00,'','Charge\r'),(5556609618,1091600001,'30-Jun-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Sunrise TV neo max','','1-Jul-25','31-Jul-25','',0,25.00,0.00,0.00,'','Charge\r'),(5556609618,1091600001,'30-Jun-25','Call Charges National','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','8000 MB',10,0.00,0.00,0.00,'','Charge\r'),(5556609618,1091600001,'30-Jun-25','Call Charges Roaming','Incoming calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:10:15',3,0.00,0.00,0.00,'','Charge\r'),(5556609618,1091600001,'30-Jun-25','Call Charges Roaming','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:03:45',2,0.00,0.00,0.00,'','Charge\r'),(5556609618,1091600001,'30-Jun-25','Call Charges Roaming','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','15000 MB',25,0.00,0.00,0.00,'','Charge\r'),(5556609618,1091600001,'30-Jun-25','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,150.20,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1091600001,'30-Jun-25','Discount Summary','','','021 292 70 96','Lisa Simpson','','','1-Jul-25','31-Jul-25','',0,-108.40,0.00,0.00,'','DiscountSummary\r'),(5556609618,1087560002,'31-May-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Freedom europe & US','','1-Jun-25','30-Jun-25','',0,29.00,108.40,137.40,'','Charge\r'),(5556609618,1087560002,'31-May-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple Music','','1-Jun-25','30-Jun-25','',0,13.90,0.00,0.00,'','Charge\r'),(5556609618,1087560002,'31-May-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','surf protect','','1-Jun-25','30-Jun-25','',0,2.90,0.00,0.00,'','Charge\r'),(5556609618,1087560002,'31-May-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Sunrise TV neo max','','1-Jun-25','30-Jun-25','',0,25.00,0.00,0.00,'','Charge\r'),(5556609618,1087560002,'31-May-25','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iPhone 14 128GB Noir','22 of 24','','','',0,33.25,0.00,0.00,'','Charge\r'),(5556609618,1087560002,'31-May-25','Call Charges National','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','9500 MB',11,0.00,0.00,0.00,'','Charge\r'),(5556609618,1087560002,'31-May-25','Call Charges Roaming','Incoming calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:10:15',3,0.00,0.00,0.00,'','Charge\r'),(5556609618,1087560002,'31-May-25','Call Charges Roaming','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:03:45',2,0.00,0.00,0.00,'','Charge\r'),(5556609618,1087560002,'31-May-25','Call Charges Roaming','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','17000 MB',26,0.00,0.00,0.00,'','Charge\r'),(5556609618,1087560002,'31-May-25','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,183.45,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1087560002,'31-May-25','Discount Summary','','','021 292 70 96','Lisa Simpson','','','1-Jun-25','30-Jun-25','',0,-108.40,0.00,0.00,'','DiscountSummary\r'),(5556609618,1083520003,'30-Apr-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Freedom europe & US','','1-May-25','31-May-25','',0,29.00,108.40,137.40,'','Charge\r'),(5556609618,1083520003,'30-Apr-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple Music','','1-May-25','31-May-25','',0,13.90,0.00,0.00,'','Charge\r'),(5556609618,1083520003,'30-Apr-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','surf protect','','1-May-25','31-May-25','',0,2.90,0.00,0.00,'','Charge\r'),(5556609618,1083520003,'30-Apr-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Netflix option','','1-May-25','31-May-25','',0,19.90,0.00,0.00,'','Charge\r'),(5556609618,1083520003,'30-Apr-25','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iPhone 14 128GB Noir','21 of 24','','','',0,33.25,0.00,0.00,'','Charge\r'),(5556609618,1083520003,'30-Apr-25','Call Charges National','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','11000 MB',12,0.00,0.00,0.00,'','Charge\r'),(5556609618,1083520003,'30-Apr-25','Call Charges Roaming','Incoming calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:10:15',3,0.00,0.00,0.00,'','Charge\r'),(5556609618,1083520003,'30-Apr-25','Call Charges Roaming','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:03:45',2,0.00,0.00,0.00,'','Charge\r'),(5556609618,1083520003,'30-Apr-25','Call Charges Roaming','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','19000 MB',27,0.00,0.00,0.00,'','Charge\r'),(5556609618,1083520003,'30-Apr-25','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,178.35,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1083520003,'30-Apr-25','Discount Summary','','','021 292 70 96','Lisa Simpson','','','1-May-25','31-May-25','',0,-108.40,0.00,0.00,'','DiscountSummary\r'),(5556609618,1079480004,'31-Mar-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Freedom europe & US','','1-Apr-25','30-Apr-25','',0,29.00,108.40,137.40,'','Charge\r'),(5556609618,1079480004,'31-Mar-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Spotify Premium','','1-Apr-25','30-Apr-25','',0,13.90,0.00,0.00,'','Charge\r'),(5556609618,1079480004,'31-Mar-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','surf protect','','1-Apr-25','30-Apr-25','',0,2.90,0.00,0.00,'','Charge\r'),(5556609618,1079480004,'31-Mar-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Netflix option','','1-Apr-25','30-Apr-25','',0,19.90,0.00,0.00,'','Charge\r'),(5556609618,1079480004,'31-Mar-25','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iPhone 14 128GB Noir','20 of 24','','','',0,33.25,0.00,0.00,'','Charge\r'),(5556609618,1079480004,'31-Mar-25','Call Charges National','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','12500 MB',13,0.00,0.00,0.00,'','Charge\r'),(5556609618,1079480004,'31-Mar-25','Call Charges Roaming','Incoming calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:10:15',3,0.00,0.00,0.00,'','Charge\r'),(5556609618,1079480004,'31-Mar-25','Call Charges Roaming','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:03:45',2,0.00,0.00,0.00,'','Charge\r'),(5556609618,1079480004,'31-Mar-25','Call Charges Roaming','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','21000 MB',28,0.00,0.00,0.00,'','Charge\r'),(5556609618,1079480004,'31-Mar-25','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,178.35,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1079480004,'31-Mar-25','Discount Summary','','','021 292 70 96','Lisa Simpson','','','1-Apr-25','30-Apr-25','',0,-108.40,0.00,0.00,'','DiscountSummary\r'),(5556609618,1075440005,'28-Feb-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Freedom europe & US','','1-Mar-25','31-Mar-25','',0,29.00,108.40,137.40,'','Charge\r'),(5556609618,1075440005,'28-Feb-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Spotify Premium','','1-Mar-25','31-Mar-25','',0,13.90,0.00,0.00,'','Charge\r'),(5556609618,1075440005,'28-Feb-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','surf protect','','1-Mar-25','31-Mar-25','',0,2.90,0.00,0.00,'','Charge\r'),(5556609618,1075440005,'28-Feb-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Extra data 5GB add-on','','1-Mar-25','31-Mar-25','',0,10.00,0.00,0.00,'','Charge\r'),(5556609618,1075440005,'28-Feb-25','Call Charges National','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','14000 MB',14,0.00,0.00,0.00,'','Charge\r'),(5556609618,1075440005,'28-Feb-25','Call Charges Roaming','Incoming calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:10:15',3,0.00,0.00,0.00,'','Charge\r'),(5556609618,1075440005,'28-Feb-25','Call Charges Roaming','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:03:45',2,0.00,0.00,0.00,'','Charge\r'),(5556609618,1075440005,'28-Feb-25','Call Charges Roaming','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','23000 MB',29,0.00,0.00,0.00,'','Charge\r'),(5556609618,1075440005,'28-Feb-25','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,135.20,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1075440005,'28-Feb-25','Discount Summary','','','021 292 70 96','Lisa Simpson','','','1-Mar-25','31-Mar-25','',0,-108.40,0.00,0.00,'','DiscountSummary\r'),(5556609618,1071400006,'31-Jan-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Freedom europe & US','','1-Feb-25','28-Feb-25','',0,29.00,108.40,137.40,'','Charge\r'),(5556609618,1071400006,'31-Jan-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Spotify Premium','','1-Feb-25','28-Feb-25','',0,13.90,0.00,0.00,'','Charge\r'),(5556609618,1071400006,'31-Jan-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','surf protect','','1-Feb-25','28-Feb-25','',0,2.90,0.00,0.00,'','Charge\r'),(5556609618,1071400006,'31-Jan-25','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Extra data 5GB add-on','','1-Feb-25','28-Feb-25','',0,10.00,0.00,0.00,'','Charge\r'),(5556609618,1071400006,'31-Jan-25','Call Charges National','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','15500 MB',15,0.00,0.00,0.00,'','Charge\r'),(5556609618,1071400006,'31-Jan-25','Call Charges Roaming','Incoming calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:10:15',3,0.00,0.00,0.00,'','Charge\r'),(5556609618,1071400006,'31-Jan-25','Call Charges Roaming','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:03:45',2,0.00,0.00,0.00,'','Charge\r'),(5556609618,1071400006,'31-Jan-25','Call Charges Roaming','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','25000 MB',30,0.00,0.00,0.00,'','Charge\r'),(5556609618,1071400006,'31-Jan-25','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,135.20,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1071400006,'31-Jan-25','Discount Summary','','','021 292 70 96','Lisa Simpson','','','1-Feb-25','28-Feb-25','',0,-108.40,0.00,0.00,'','DiscountSummary\r'),(5556609618,1059220003,'31-Dec-24','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Freedom europe & US','','1-Jan-25','31-Jan-25','',0,29.00,108.40,137.40,'','Charge\r'),(5556609618,1059220003,'31-Dec-24','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Spotify Premium','','1-Jan-25','31-Jan-25','',0,13.90,0.00,0.00,'','Charge\r'),(5556609618,1059220003,'31-Dec-24','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iPhone 14 128GB Noir','20 of 24','','','',0,33.25,0.00,0.00,'','Charge\r'),(5556609618,1059220003,'31-Dec-24','Call Charges National','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','11500 MB',13,0.00,0.00,0.00,'','Charge\r'),(5556609618,1059220003,'31-Dec-24','One Time Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Admin fee','','15-Dec-24','15-Dec-24','',0,10.00,0.00,0.00,'','Charge\r'),(5556609618,1059220003,'31-Dec-24','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,165.55,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1059220003,'31-Dec-24','Discount Summary','','','021 292 70 96','Lisa Simpson','','','1-Jan-25','31-Jan-25','',0,-108.40,0.00,0.00,'','DiscountSummary\r'),(5556609618,1063260002,'30-Nov-24','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Freedom europe & US','','1-Dec-24','31-Dec-24','',0,29.00,108.40,137.40,'','Charge\r'),(5556609618,1063260002,'30-Nov-24','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','surf protect','','1-Dec-24','31-Dec-24','',0,2.90,0.00,0.00,'','Charge\r'),(5556609618,1063260002,'30-Nov-24','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Netflix Option','','1-Dec-24','31-Dec-24','',0,19.90,0.00,0.00,'','Charge\r'),(5556609618,1063260002,'30-Nov-24','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iPhone 14 128GB Noir','19 of 24','','','',0,33.25,0.00,0.00,'','Charge\r'),(5556609618,1063260002,'30-Nov-24','Call Charges National','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','9500 MB',10,0.00,0.00,0.00,'','Charge\r'),(5556609618,1063260002,'30-Nov-24','Call Charges National','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:12:52',4,0.00,0.00,0.00,'','Charge\r'),(5556609618,1063260002,'30-Nov-24','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,164.40,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1063260002,'30-Nov-24','Discount Summary','','','021 292 70 96','Lisa Simpson','','','1-Dec-24','31-Dec-24','',0,-108.40,0.00,0.00,'','DiscountSummary\r'),(5556609618,1067300001,'31-Oct-24','Recurring Charge','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','surf protect','','1-Nov-24','30-Nov-24','',0,2.90,0.00,0.00,'','Charge\r'),(5556609618,1067300001,'31-Oct-24','New Installments','','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','Apple iPhone 14 128GB Noir','18 of 24','','','',0,33.25,0.00,0.00,'','Charge\r'),(5556609618,1067300001,'31-Oct-24','Call Charges National','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','10500 MB',12,0.00,0.00,0.00,'','Charge\r'),(5556609618,1067300001,'31-Oct-24','Call Charges Roaming','Incoming calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:04:22',2,0.00,0.00,0.00,'','Charge\r'),(5556609618,1067300001,'31-Oct-24','Call Charges Roaming','Outgoing calls','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','0:01:15',1,0.00,0.00,0.00,'','Charge\r'),(5556609618,1067300001,'31-Oct-24','Call Charges Roaming','Mobile Internet','Sunrise Mobile Service','021 292 70 96','Lisa Simpson','','','','','8000 MB',15,0.00,0.00,0.00,'','Charge\r'),(5556609618,1067300001,'31-Oct-24','Subscription Total','','','021 292 70 96','Lisa Simpson','','','','','',0,158.45,0.00,0.00,'','SubscriptionTotal\r'),(5556609618,1067300001,'31-Oct-24','Discount Summary','','','021 292 70 96','Lisa Simpson','','','1-Nov-24','30-Nov-24','',0,-108.40,0.00,0.00,'','DiscountSummary\r');
/*!40000 ALTER TABLE `staging_billing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subscriptions`
--

DROP TABLE IF EXISTS `subscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `subscriptions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `customer_id` bigint NOT NULL,
  `product_line_id` int DEFAULT NULL,
  `external_id` varchar(50) NOT NULL,
  `external_desc` varchar(255) DEFAULT NULL,
  `subscription_state` varchar(50) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_id` (`customer_id`,`external_id`),
  KEY `fk_sub_product_line` (`product_line_id`),
  CONSTRAINT `fk_sub_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`),
  CONSTRAINT `fk_sub_product_line` FOREIGN KEY (`product_line_id`) REFERENCES `product_lines` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subscriptions`
--

LOCK TABLES `subscriptions` WRITE;
/*!40000 ALTER TABLE `subscriptions` DISABLE KEYS */;
INSERT INTO `subscriptions` VALUES (1,1,1,'021 292 70 96','Lisa Simpson','',NULL,NULL,'2025-12-08 10:45:52','2025-12-08 10:45:52');
/*!40000 ALTER TABLE `subscriptions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-08 11:14:16
