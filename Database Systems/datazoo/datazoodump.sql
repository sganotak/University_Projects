-- MySQL dump 10.13  Distrib 8.0.12, for Win64 (x86_64)
--
-- Host: localhost    Database: datazoo
-- ------------------------------------------------------
-- Server version	8.0.12

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `animal`
--

DROP TABLE IF EXISTS `animal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `animal` (
  `AnimalID` char(8) NOT NULL,
  `Birth_Date` date NOT NULL,
  `Arrival_Date` date DEFAULT NULL,
  `Color` varchar(25) NOT NULL,
  `Gender` varchar(25) NOT NULL,
  `AnSpecies` varchar(50) NOT NULL,
  `AnPlace` int(11) NOT NULL,
  `ConceptionDay` date DEFAULT NULL,
  `MatingPeriod` varchar(25) DEFAULT NULL,
  `GesDuration` varchar(45) DEFAULT NULL,
  `MotherID` char(8) DEFAULT NULL,
  PRIMARY KEY (`AnimalID`),
  KEY `AnSpecies_idx` (`AnSpecies`),
  KEY `AnPlace_idx` (`AnPlace`),
  KEY `MotherID_idx` (`MotherID`),
  CONSTRAINT `AnPlace` FOREIGN KEY (`AnPlace`) REFERENCES `place` (`placeid`),
  CONSTRAINT `AnSpecies` FOREIGN KEY (`AnSpecies`) REFERENCES `taxonomy` (`subspecies`),
  CONSTRAINT `MotherID` FOREIGN KEY (`MotherID`) REFERENCES `animal` (`animalid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `animal`
--

LOCK TABLES `animal` WRITE;
/*!40000 ALTER TABLE `animal` DISABLE KEYS */;
INSERT INTO `animal` VALUES ('Chpf002','2018-04-05','2018-09-04','Grey','Female','Chinese paddlefish',32,NULL,NULL,NULL,NULL),('Lion2572','2010-12-16','2013-08-02','Wheat','Female','Panthera Leo Leo',25,NULL,'All Year','110',NULL),('Lion2573','2009-09-14','2011-09-01','Wheat','Female','Panthera Leo Leo',25,NULL,'All Year','110',NULL),('Lion2574','2011-02-14','2015-03-11','Fawn','Female','Panthera Leo Leo',25,NULL,'All Year','110',NULL),('Lion2576','2010-08-10','2013-01-07','Wheat','Male','Panthera Leo Leo',25,NULL,'All Year',NULL,NULL),('Lion2580','2018-12-01',NULL,'Fawn','Female','Panthera Leo Leo',25,'2018-08-01','All Year','110','Lion2574'),('Lion2581','2018-12-01',NULL,'Fawn','Male','Panthera Leo Leo',25,'2018-08-01','All Year',NULL,'Lion2574'),('Lion2582','2018-12-01',NULL,'Tawny','Male','Panthera Leo Leo',25,'2018-08-01','All Year',NULL,'Lion2574'),('Lion2674','2010-02-14','2015-03-11','Gold','Female','Panthera Leo Leo',25,NULL,'All Year','110',NULL),('Lion2680','2018-11-04',NULL,'Gold','Female','Panthera Leo Leo',25,'2018-07-01','All Year','110','Lion2674'),('Sh0020','2018-01-02','2018-05-04','Brown/Grey','Male','Ganges Shark',32,NULL,NULL,NULL,NULL),('St0001','2018-05-05','2018-09-03','Brown/Grey','Male','Russian Sturgeon',32,NULL,NULL,NULL,NULL),('Tig0010','2009-04-23','2011-04-25','Orange w/ Black Stripes','Male','Bengal Tiger',26,NULL,'November to April',NULL,NULL),('Tig0011','2009-05-15','2011-04-25','Orange w/ Black Stripes','Female','Bengal Tiger',26,NULL,'November to April','112',NULL),('Tig0012','2007-03-23','2012-04-25','Orange w/ Black Stripes','Male','Malayan Tiger',26,NULL,'November to April',NULL,NULL),('Tig0013','2008-11-12','2012-06-25','White w/ Black Stripes','Female','Siberian Tiger',26,NULL,'November to April','112',NULL),('Tig0014','2011-04-23','2013-07-10','Orange w/ Black Stripes','Male','South China Tiger',26,NULL,'November to April',NULL,NULL),('Trtl0040','2005-03-04','2010-03-05','Yellow','Female','Caretta caretta',32,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `animal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `animal_checkups`
--

DROP TABLE IF EXISTS `animal_checkups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `animal_checkups` (
  `CheckupNo` int(11) NOT NULL,
  `Ex_AnimalID` char(8) NOT NULL,
  `RecHeight` double NOT NULL,
  `RecWeight` double NOT NULL,
  `GeneralHealth` varchar(25) NOT NULL,
  `CheckupDetails` varchar(200) NOT NULL,
  `CheckupDate` varchar(25) NOT NULL,
  `CheckupType` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`CheckupNo`,`Ex_AnimalID`),
  KEY `ExAnimalID_idx` (`Ex_AnimalID`),
  CONSTRAINT `ExAnimalID` FOREIGN KEY (`Ex_AnimalID`) REFERENCES `animal` (`animalid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `animal_checkups`
--

LOCK TABLES `animal_checkups` WRITE;
/*!40000 ALTER TABLE `animal_checkups` DISABLE KEYS */;
INSERT INTO `animal_checkups` VALUES (1234,'Lion2574',150,120,'Healthy','Routine Checkup','2018-07-30','Routine'),(1235,'Lion2574',150,150,'Healthy','Routine Checkup during gestation','2018-0911','Routine'),(1236,'Lion2574',150,180,'Healthy','Routine Checkup before during gestation','2018-11-29','Routine'),(1237,'Lion2574',150,120,'Healthy','Routine Checkup after labor','2018-12-02','Routine'),(1238,'Lion2580',40,1.4,'Healthy','Routine Checkup after birth','2018-12-04','Routine'),(1239,'Lion2580',50,1.6,'Healthy','Routine Checkup after birth','2018-12-07','Routine'),(1240,'Lion2581',39,1.3,'Healthy','Routine Checkup after labor','2018-12-04','Routine'),(1241,'Lion2581',50,1.5,'Healthy','Routine Checkup after labor','2018-12-07','Routine'),(1242,'Lion2582',55,1.3,'Slightly Sick','Medication and Vaccination','2018-12-10','Vaccination');
/*!40000 ALTER TABLE `animal_checkups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `aninfo`
--

DROP TABLE IF EXISTS `aninfo`;
/*!50001 DROP VIEW IF EXISTS `aninfo`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `aninfo` AS SELECT 
 1 AS `AnimalID`,
 1 AS `Gender`,
 1 AS `Species`,
 1 AS `Country`,
 1 AS `Range`,
 1 AS `Status`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `careinfo`
--

DROP TABLE IF EXISTS `careinfo`;
/*!50001 DROP VIEW IF EXISTS `careinfo`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `careinfo` AS SELECT 
 1 AS `AnimalID`,
 1 AS `Location`,
 1 AS `EmployeeID`,
 1 AS `FirstName`,
 1 AS `LastName`,
 1 AS `Occupation`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `cares_for`
--

DROP TABLE IF EXISTS `cares_for`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `cares_for` (
  `AnimalID` char(8) NOT NULL,
  `EmployeeID` char(5) NOT NULL,
  PRIMARY KEY (`AnimalID`,`EmployeeID`),
  KEY `EmployeeID_idx` (`EmployeeID`),
  CONSTRAINT `AnimalID` FOREIGN KEY (`AnimalID`) REFERENCES `animal` (`animalid`),
  CONSTRAINT `EmployeeID` FOREIGN KEY (`EmployeeID`) REFERENCES `employee` (`employeeid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cares_for`
--

LOCK TABLES `cares_for` WRITE;
/*!40000 ALTER TABLE `cares_for` DISABLE KEYS */;
INSERT INTO `cares_for` VALUES ('Lion2580','LK050'),('Lion2582','LK050'),('Lion2674','LK050'),('Lion2574','VE010'),('Lion2580','VE010'),('Lion2581','VE010'),('Lion2582','VE015');
/*!40000 ALTER TABLE `cares_for` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `climate`
--

DROP TABLE IF EXISTS `climate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `climate` (
  `Name` varchar(25) NOT NULL,
  `Humidity` varchar(25) NOT NULL,
  `AtmosphericPressure` double NOT NULL,
  PRIMARY KEY (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `climate`
--

LOCK TABLES `climate` WRITE;
/*!40000 ALTER TABLE `climate` DISABLE KEYS */;
INSERT INTO `climate` VALUES ('Arctic','Low',1.5),('Equatorial','Very High',1),('Humid Continental','High',1.2),('Humid Subtropical','Very High',1.024),('Mediterranean','Moderate',1.008),('Mild Temperate','Moderate',1.05),('Subarctic','Low',1.1),('Tropical','Moderate',1.01),('Tropical Wet','High',1.008);
/*!40000 ALTER TABLE `climate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `diet`
--

DROP TABLE IF EXISTS `diet`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `diet` (
  `DietDay` date NOT NULL,
  `AnID` char(8) NOT NULL,
  `FoodName` varchar(25) NOT NULL,
  `FoodFreq` int(11) NOT NULL,
  `FoodPerDose` varchar(25) NOT NULL,
  `WaterFreq` int(11) DEFAULT NULL,
  `WaterPerDose` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`DietDay`,`AnID`),
  KEY `AnID_idx` (`AnID`),
  CONSTRAINT `AnID` FOREIGN KEY (`AnID`) REFERENCES `animal` (`animalid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `diet`
--

LOCK TABLES `diet` WRITE;
/*!40000 ALTER TABLE `diet` DISABLE KEYS */;
INSERT INTO `diet` VALUES ('2018-11-24','Lion2574','Beef',3,'300.3',5,'500'),('2018-11-24','Lion2674','Chicken',4,'300.3',5,'500'),('2018-11-25','Lion2574','Horse Meat',3,'300.3',5,'500'),('2018-11-25','Lion2674','Beef',3,'350',5,'500');
/*!40000 ALTER TABLE `diet` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `dietinfo`
--

DROP TABLE IF EXISTS `dietinfo`;
/*!50001 DROP VIEW IF EXISTS `dietinfo`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `dietinfo` AS SELECT 
 1 AS `AnimalID`,
 1 AS `Species`,
 1 AS `Order`,
 1 AS `DietDay`,
 1 AS `AnID`,
 1 AS `FoodName`,
 1 AS `FoodFreq`,
 1 AS `FoodPerDose`,
 1 AS `WaterFreq`,
 1 AS `WaterPerDose`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `employee` (
  `EmployeeID` char(5) NOT NULL,
  `FirstName` varchar(25) NOT NULL,
  `LastName` varchar(25) NOT NULL,
  `Occupation` varchar(25) DEFAULT NULL,
  `ShiftBegin` varchar(45) DEFAULT NULL,
  `ShiftEnd` varchar(45) DEFAULT NULL,
  `Salary` double NOT NULL,
  PRIMARY KEY (`EmployeeID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee`
--

LOCK TABLES `employee` WRITE;
/*!40000 ALTER TABLE `employee` DISABLE KEYS */;
INSERT INTO `employee` VALUES ('BK025','Jack','Sparrow','Bird Keeper','8:00:00','16:00:00',1000),('FM030','Anna','Ford','Finance Manager','9:00:00','17:00:00',2000),('LK050','Kevin','Lee','Lion Keeper','9:00:00','17:00:00',1300),('MD002','Nikolaos','Oikonomou','Marketing Director','9:00:00','17:00:00',1500),('RC010','Helen','Williams','Reptile Curator','8:00:00','15:00:00',800),('RE100','Mary','Jackson','Registrar','9:00:00','17:00:00',1000),('SA012','David','Jones','Head Aquarist','8:00:00','16:00:00',2000),('TK010','William','Adams','Tiger Keeper','10:00:00','19:00:00',1200),('VE010','John','Dolittle','Veterinarian','9:00:00','17:00:00',2000),('VE015','Jane','Williams','Veterinarian','9:00:00','17:00:00',2000);
/*!40000 ALTER TABLE `employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `habitat`
--

DROP TABLE IF EXISTS `habitat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `habitat` (
  `HabitatID` int(11) NOT NULL,
  `Country` varchar(25) NOT NULL,
  `Continent` varchar(25) NOT NULL,
  `AvgTemperature` double NOT NULL,
  `ClimateName` varchar(25) NOT NULL,
  PRIMARY KEY (`HabitatID`),
  KEY `ClimateName_idx` (`ClimateName`),
  CONSTRAINT `ClimateName` FOREIGN KEY (`ClimateName`) REFERENCES `climate` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `habitat`
--

LOCK TABLES `habitat` WRITE;
/*!40000 ALTER TABLE `habitat` DISABLE KEYS */;
INSERT INTO `habitat` VALUES (1,'United States of America','North America',13.3,'Humid Continental'),(2,'Australia','Australia',18,'Tropical'),(5,'China','Asia',17,'Tropical'),(10,'India','Asia',36,'Tropical Wet'),(12,'Tanzania','Africa',28,'Tropical'),(14,'Malaysia','Asia',28,'Equatorial'),(16,'Nepal','Asia ',15.4,'Mild Temperate'),(20,'Zimbabwe','Africa',35.4,'Humid Subtropical'),(21,'Russia','Europe',10.4,'Subarctic'),(22,'Kazakhstan','Asia',10.4,'Humid Continental'),(23,'Bulgaria','Europe',22,'Mild Temperate'),(30,'Bangladesh','Asia',25,'Humid Subtropical'),(49,'Greece','Europe',29,'Mediterranean'),(67,'Ecuador','South America',25.4,'Humid Subtropical'),(87,'Zambia','Africa',24,'Tropical'),(88,'Ethiopa','Africa',27,'Tropical'),(90,'Niger','Africa',31,'Tropical'),(100,'Madagascar','Africa',18,'Humid Subtropical'),(101,'Pakistan','Asia',25.4,'Mild Temperate'),(102,'South Shetland Islands','Antarctica',-3,'Arctic'),(103,'Spain','Europe',17,'Mediterranean');
/*!40000 ALTER TABLE `habitat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inhabits`
--

DROP TABLE IF EXISTS `inhabits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `inhabits` (
  `Subspecies` varchar(25) NOT NULL,
  `HabitatID` int(11) NOT NULL,
  `Range` varchar(200) NOT NULL,
  `Status` varchar(25) NOT NULL,
  PRIMARY KEY (`Subspecies`,`HabitatID`),
  KEY `HabitatID_idx` (`HabitatID`),
  CONSTRAINT `HabitatID` FOREIGN KEY (`HabitatID`) REFERENCES `habitat` (`habitatid`),
  CONSTRAINT `SubSpecies` FOREIGN KEY (`Subspecies`) REFERENCES `taxonomy` (`subspecies`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inhabits`
--

LOCK TABLES `inhabits` WRITE;
/*!40000 ALTER TABLE `inhabits` DISABLE KEYS */;
INSERT INTO `inhabits` VALUES ('Addax nasomaculatus',90,'Air Mountains','Critically Endangered'),('Ateles fusciceps',67,'Northwest Andes, Esmeralda Province','Critically Endangered'),('Bengal Tiger',10,'Indian Subcontinent','Endangered'),('Bengal Tiger',16,'Bardia, Banke and Suklaphanta regions','Endangered'),('Canis simensis',88,'Ethiopian Highlands','Critically Endangered'),('Caretta caretta',49,'Mediterranean Sea ','Vulnerable'),('Chinese paddlefish',5,'Yangtze River','Critically Endangered'),('Diceros bicornis',87,'Nature Reserve','Critically Endangered'),('Diceros bicornis',88,'Ethiopian Highlands','Extinct'),('Ganges Shark',10,'Ganges River','Critically Endangered'),('Giant Otter',67,'Eastern Andes Mountains','Critically Endangered'),('Malayan Tiger',14,'Peninsular Malaysia','Critically Endangered'),('Panthera Leo Leo',12,'Selous lion area, Ruaha-Rungwa lion area,Serengeti-Mara lion area, Tsavo-Mkomazi lion area','Vulnerable'),('Russian Sturgeon',21,'Sea of Asgov','Critically Endangered'),('Russian Sturgeon',23,'Black Sea','Endangered'),('Siberian Tiger',21,'Siberian Peninsula','Endangered'),('Siberian Tiger',22,'Siberian Peninsula','Endangered'),('South China Tiger',5,'Fujian, Guangdong, Hunan and Jiangxi provinces','Critically Endangered'),('Wilson\'s storm petrel',1,'Virgin Islands','Least Concern'),('Wilson\'s storm petrel',2,'Heard Island','Least Concern'),('Wilson\'s storm petrel',67,'Countrywide','Least Concern'),('Wilson\'s storm petrel',100,'Malagasy Region','Least Concern'),('Wilson\'s storm petrel',101,'Countrywide','Least Concern'),('Wilson\'s storm petrel',102,'Countrywide','Least Concern'),('Wilson\'s storm petrel',103,'West of Sisarga Islands','Least Concern');
/*!40000 ALTER TABLE `inhabits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `place`
--

DROP TABLE IF EXISTS `place`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `place` (
  `PlaceId` int(11) NOT NULL,
  `PlaceName` varchar(25) NOT NULL,
  `AvgTemperature` double NOT NULL,
  PRIMARY KEY (`PlaceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `place`
--

LOCK TABLES `place` WRITE;
/*!40000 ALTER TABLE `place` DISABLE KEYS */;
INSERT INTO `place` VALUES (25,'Safari Park Sector C',30),(26,'Safari Park Sector D',25.4),(32,'Aquarium',20.4);
/*!40000 ALTER TABLE `place` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxonomy`
--

DROP TABLE IF EXISTS `taxonomy`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `taxonomy` (
  `SubSpecies` varchar(50) NOT NULL,
  `Species` varchar(50) NOT NULL,
  `Class` varchar(50) NOT NULL,
  `Phylum` varchar(50) NOT NULL,
  `Order` varchar(25) NOT NULL,
  `SubOrder` varchar(50) DEFAULT NULL,
  `Family` varchar(50) NOT NULL,
  `SubFamily` varchar(50) DEFAULT NULL,
  `Genus` varchar(50) NOT NULL,
  PRIMARY KEY (`SubSpecies`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxonomy`
--

LOCK TABLES `taxonomy` WRITE;
/*!40000 ALTER TABLE `taxonomy` DISABLE KEYS */;
INSERT INTO `taxonomy` VALUES ('Addax nasomaculatus','Antilope','Mammalia','Chordata','Artiodactyla',NULL,'Bovidae','Hippotraginae','Addax'),('Ateles fusciceps','Spider Monkey','Mammalia','Chordata','Primates','Haplorhini','Atelidae','Atelinae','Ateles'),('Bengal Tiger','Panthera Tigris','Mammalia','Chordata','Carnivora','Felifornia','Felidae','Pantherinae','Panthera'),('Canis simensis','Wolf','Mammalia','Chordata','Carnivora',NULL,'Canidae',NULL,'Canis'),('Carcharodon carcharias','Mackerel Shark','Chondrichthyes','Chordata','Lamniformes',NULL,'Lamnidae',NULL,'Carcharodon'),('Caretta caretta','Sea Turtle','Reptilia','Chordata','Testudines','Cryptodira','Cheloniidae','Carettinae','Caretta'),('Chinese paddlefish','Paddlefish','Actinopterygii','Chordata','Acipenseriformes',NULL,'Polyodontidae',NULL,'Psephurus'),('Diceros bicornis','Rhinoceros','Mammalia','Chordata','Perissodactyla',NULL,'Rhinocerotidae',NULL,'Diceros'),('Ganges shark','Requiem Shark','Chondrichthyes','Chordata','Carcharhiniformes',NULL,'Carcharhinidae',NULL,'Glyphis'),('Giant Otter','Otter','Mammalia','Chordata','Carnivora',NULL,'Mustelidae',NULL,'Pteronura'),('Heterodontus francisci','Bullhead Shark','Chondrichthyes','Chordata','Heterodontiformes',NULL,'Heterodontidae',NULL,'Heterodontus'),('Indochinese Tiger','Panthera Tigris','Mammalia','Chordata','Carnivora','Felifornia','Felidae','Pantherinae','Panthera'),('Malayan Tiger','Panthera Tigris','Mammalia','Chordata','Carnivora','Felifornia','Felidae','Pantherinae','Panthera'),('Maui\'s Dolphin','Dolphin','Mammalia','Chordata','Artiodactyla','Cetacea','Delphinoidea','Delphinidae','Delphinus'),('Panthera Leo Leo','Panthera Leo','Mammalia','Chordata','Carvivora','Felifornia','Felidae','Pantherinae','Panthera'),('Russian sturgeon ','Sturgeon','Actinopterygii','Chordata','Acipenseriformes',NULL,'Acipenseridae',NULL,'Acipenser'),('Siberian Tiger','Panthera Tigris','Mammalia','Chordata','Carnivora','Felifornia','Felidae','Pantherinae','Panthera'),('South China Tiger','Panthera Tigris','Mammalia','Chordata','Carnivora','Felifornia','Felidae','Pantherinae','Panthera'),('Sunda Island Tiger','Panthera Tigris','Mammalia','Chordata','Carnivora','Felifornia','Felidae','Pantherinae','Panthera'),('Wilson\'s storm petrel','Petrel','Aves','Chordata','Procellariiformes',NULL,'Oceanitidae',NULL,'Oceanites');
/*!40000 ALTER TABLE `taxonomy` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `aninfo`
--

/*!50001 DROP VIEW IF EXISTS `aninfo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `aninfo` AS select `animal`.`AnimalID` AS `AnimalID`,`animal`.`Gender` AS `Gender`,`taxonomy`.`Species` AS `Species`,`habitat`.`Country` AS `Country`,`inhabits`.`Range` AS `Range`,`inhabits`.`Status` AS `Status` from (((`animal` join `taxonomy` on((`animal`.`AnSpecies` = `taxonomy`.`SubSpecies`))) join `inhabits` on((`taxonomy`.`SubSpecies` = `inhabits`.`Subspecies`))) join `habitat` on((`habitat`.`HabitatID` = `inhabits`.`HabitatID`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `careinfo`
--

/*!50001 DROP VIEW IF EXISTS `careinfo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `careinfo` AS select `animal`.`AnimalID` AS `AnimalID`,`place`.`PlaceName` AS `Location`,`employee`.`EmployeeID` AS `EmployeeID`,`employee`.`FirstName` AS `FirstName`,`employee`.`LastName` AS `LastName`,`employee`.`Occupation` AS `Occupation` from (((`animal` join `place` on((`place`.`PlaceId` = `animal`.`AnPlace`))) join `cares_for` on((`cares_for`.`AnimalID` = `animal`.`AnimalID`))) join `employee` on((`cares_for`.`EmployeeID` = `employee`.`EmployeeID`))) order by `animal`.`AnimalID` asc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `dietinfo`
--

/*!50001 DROP VIEW IF EXISTS `dietinfo`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `dietinfo` AS select `animal`.`AnimalID` AS `AnimalID`,`taxonomy`.`Species` AS `Species`,`taxonomy`.`Order` AS `Order`,`diet`.`DietDay` AS `DietDay`,`diet`.`AnID` AS `AnID`,`diet`.`FoodName` AS `FoodName`,`diet`.`FoodFreq` AS `FoodFreq`,`diet`.`FoodPerDose` AS `FoodPerDose`,`diet`.`WaterFreq` AS `WaterFreq`,`diet`.`WaterPerDose` AS `WaterPerDose` from ((`animal` join `diet` on((`animal`.`AnimalID` = `diet`.`AnID`))) join `taxonomy` on((`animal`.`AnSpecies` = `taxonomy`.`SubSpecies`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-12-19 18:32:17
