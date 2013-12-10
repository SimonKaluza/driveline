-- MySQL dump 10.13  Distrib 5.6.13, for osx10.8 (x86_64)
--
-- Host: localhost    Database: driveline
-- ------------------------------------------------------
-- Server version	5.6.13

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `group`
--

DROP TABLE IF EXISTS `group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `group` (
  `groupId` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(200) DEFAULT NULL,
  `deleted` char(1) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  `admin_email` varchar(100) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `zip_code` char(5) DEFAULT NULL,
  PRIMARY KEY (`groupId`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group`
--

LOCK TABLES `group` WRITE;
/*!40000 ALTER TABLE `group` DISABLE KEYS */;
INSERT INTO `group` VALUES (1,'A local safe rides for East Haven, run out of a local residence.','0','37 1st Ave, East Haven, CT','kaluza.simon@gmail.com','East Haven Safe Rides',NULL,NULL,NULL),(6,'A Safe Rides group for University of New Haven','0','West Haven, CT','kaluza.simon@gmail.com','UNH Safe Rides',NULL,NULL,NULL),(7,'Providing transport and carpooling services for employees of 3M','0','100 Barnes Rd, Wallingford, CT','spkaluza@mmm.com','3M Safe Rides',NULL,NULL,NULL),(8,'Some random new SafeRide group!','0','94 Some Random Rd., Some Town, CT 06443','uberl33tadmin@driveline.com','New SafeRide Group',NULL,NULL,NULL),(62,'The first group to be created through the Driveline App','0','100 Barnes Rd.','kaluza.simon@gmail.com','iOS-Created Group!',NULL,NULL,NULL),(63,'','0','','kaluza.simon@gmail.com','Blah group!',NULL,NULL,NULL),(64,'','0','','kaluza.simon@gmail.com','DOH!',NULL,NULL,NULL),(68,'asdf','0','','kaluza.simon@gmail.com','sadf',NULL,NULL,NULL),(69,'','0','','kaluza.simon@gmail.com','dsfas',NULL,NULL,NULL),(70,'A carpool for commercial Linux users!','0','Somewhere in Africa','mark.shuttleworth@ubuntu.com','Ubuntu Car Pool',NULL,NULL,NULL),(71,'Some random new SafeRide group!','0','94 Some Random Rd., Some Town, CT 06443','uberl33tadmin@driveline.com','New SafeRide Group',NULL,NULL,NULL),(73,'Some random new SafeRide group!','0','94 Some Random Rd., Some Town, CT 06443','uberl33tadmin@driveline.com','New SafeRide Group',NULL,NULL,NULL);
/*!40000 ALTER TABLE `group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `email` varchar(100) NOT NULL,
  `firstname` varchar(45) DEFAULT NULL,
  `lastname` varchar(45) DEFAULT NULL,
  `phone` char(10) DEFAULT NULL,
  `password` varchar(45) DEFAULT NULL,
  `deleted` int(1) DEFAULT NULL,
  `seats` int(1) DEFAULT NULL,
  `lastLatitude` decimal(12,9) DEFAULT NULL,
  `lastLongitude` decimal(12,9) DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('','','','','',0,0,NULL,NULL),('admin@depthfirstdesign.com','Master','Admin','7777777777','inn0vat3',0,0,NULL,NULL),('alice@we2skate.net','Alice','Fischer','2036666666','elizanewhaven',0,4,NULL,NULL),('blah','string','string','string','string',0,4,NULL,NULL),('bobooo','string','string','string','string',0,4,NULL,NULL),('jeanvaljean@lesmis.com','Jean','Valjean','2035456789','whoami',0,1,NULL,NULL),('kaluza.simon@gmail.com','Simon','Kaluza','2034153846','dude',0,0,37.333828000,-122.072360000),('madden@nfl.com','John','Madden','2035553453','football',0,0,NULL,NULL),('mark.shuttleworth@ubuntu.com','Mark','Shuttleworth','5555555555','ubuntu',0,0,NULL,NULL),('mfunaro@gmail.com','Michael','Funaro','2035555555','haloforever',0,4,NULL,NULL),('ndimucci84@gmail.com','Nicholas','DiMucci','2034444444','monkeyisland',0,4,NULL,NULL),('steve.jobs@apple.com','Steve','Jobs','5555555555','blah',0,0,NULL,NULL),('Steven@gmail.com','Steven','Jackson','2035555555','superpass',0,4,NULL,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_group`
--

DROP TABLE IF EXISTS `user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user_group` (
  `groupId` bigint(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `status` int(1) DEFAULT NULL,
  `admin` int(1) DEFAULT NULL,
  PRIMARY KEY (`groupId`,`email`),
  KEY `to_user` (`email`),
  KEY `to_group` (`groupId`),
  CONSTRAINT `to_group` FOREIGN KEY (`groupId`) REFERENCES `group` (`groupId`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `to_user` FOREIGN KEY (`email`) REFERENCES `user` (`email`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_group`
--

LOCK TABLES `user_group` WRITE;
/*!40000 ALTER TABLE `user_group` DISABLE KEYS */;
INSERT INTO `user_group` VALUES (1,'kaluza.simon@gmail.com',0,1),(1,'mark.shuttleworth@ubuntu.com',1,0),(1,'mfunaro@gmail.com',1,0),(6,'kaluza.simon@gmail.com',0,0),(6,'mark.shuttleworth@ubuntu.com',0,0),(6,'ndimucci84@gmail.com',1,0),(7,'kaluza.simon@gmail.com',0,0),(7,'mfunaro@gmail.com',0,0),(7,'ndimucci84@gmail.com',1,0),(62,'kaluza.simon@gmail.com',0,0),(63,'kaluza.simon@gmail.com',0,-1),(70,'mark.shuttleworth@ubuntu.com',0,1),(70,'steve.jobs@apple.com',1,0);
/*!40000 ALTER TABLE `user_group` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-10  0:06:18
