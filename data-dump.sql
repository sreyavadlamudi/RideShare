-- MySQL dump 10.13  Distrib 8.1.0, for macos12.6 (x86_64)
--
-- Host: localhost    Database: RideShare
-- ------------------------------------------------------
-- Server version	8.1.0

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
-- Table structure for table `Driver`
--

DROP TABLE IF EXISTS `Driver`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Driver` (
  `DriverID` int NOT NULL AUTO_INCREMENT,
  `UserID` int DEFAULT NULL,
  `DriverMode` tinyint NOT NULL DEFAULT '0',
  PRIMARY KEY (`DriverID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `driver_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Driver`
--

LOCK TABLES `Driver` WRITE;
/*!40000 ALTER TABLE `Driver` DISABLE KEYS */;
INSERT INTO `Driver` VALUES (1,1,1),(2,3,0),(3,7,1);
/*!40000 ALTER TABLE `Driver` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ride`
--

DROP TABLE IF EXISTS `Ride`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ride` (
  `RideID` int NOT NULL AUTO_INCREMENT,
  `DriverID` int DEFAULT NULL,
  `RiderID` int DEFAULT NULL,
  `PickUpLocation` varchar(255) DEFAULT NULL,
  `DropOffLocation` varchar(255) DEFAULT NULL,
  `Rating` decimal(3,2) DEFAULT NULL,
  PRIMARY KEY (`RideID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ride`
--

LOCK TABLES `Ride` WRITE;
/*!40000 ALTER TABLE `Ride` DISABLE KEYS */;
INSERT INTO `Ride` VALUES (1,1,2,'Location 1','Location 2',4.30),(2,3,4,'Location 3','Location 4',4.10),(3,1,4,'Location 5','Location 6',4.40),(4,3,2,'Location 2','Location 1',4.80),(5,1,6,'chapman university','lmu',NULL),(6,1,2,'chapman university','lmu',NULL),(7,1,5,'chapman university','lmu',NULL),(8,1,8,'los angeles','san diego',NULL);
/*!40000 ALTER TABLE `Ride` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Rider`
--

DROP TABLE IF EXISTS `Rider`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Rider` (
  `RiderID` int NOT NULL AUTO_INCREMENT,
  `UserID` int DEFAULT NULL,
  PRIMARY KEY (`RiderID`),
  KEY `UserID` (`UserID`),
  CONSTRAINT `rider_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `User` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Rider`
--

LOCK TABLES `Rider` WRITE;
/*!40000 ALTER TABLE `Rider` DISABLE KEYS */;
INSERT INTO `Rider` VALUES (2,2),(4,4),(5,5),(6,6),(7,8);
/*!40000 ALTER TABLE `Rider` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `UserType` enum('Driver','Rider') DEFAULT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `Rating` decimal(3,2) DEFAULT NULL,
  PRIMARY KEY (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (1,'Driver','Zakari Clark','zclark@gmail.com','password123',4.80),(2,'Rider','Sreya Vadlamudi','svadlamudi@gmail.com','password456',4.50),(3,'Driver','Brynn McGovern','bMcGovern@gmail.com','password789',4.30),(4,'Rider','Saniya Revankar','srevankar@gmail.com','password149',4.40),(5,'Rider','Austin','abutler@chapman.edu','yourmom',NULL),(6,'Rider','Timothee Chalamet','tchalamet@chapman.edu','password111',NULL),(7,'Driver','Zendaya Coleman','zcoleman@chapman.edu','password222',NULL),(8,'Rider','Florence Pugh','fpugh@chapman.edu','password333',NULL);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-02 19:31:59
