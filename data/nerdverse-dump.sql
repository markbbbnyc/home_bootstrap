/*M!999999\- enable the sandbox mode */ 
-- MariaDB dump 10.19  Distrib 10.11.14-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: nerdverse
-- ------------------------------------------------------
-- Server version	10.11.14-MariaDB-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `nerdverse`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `nerdverse` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `nerdverse`;

--
-- Table structure for table `artifacts`
--

DROP TABLE IF EXISTS `artifacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `artifacts` (
  `artifact_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` enum('Weapon','Relic','Gadget','Snack','Pet','Meme') NOT NULL,
  `power_level` int(11) DEFAULT 10 CHECK (`power_level` between 1 and 999),
  `description` text DEFAULT NULL,
  `rarity` enum('Common','Rare','Epic','Legendary','Memetic') NOT NULL,
  `current_owner_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`artifact_id`),
  KEY `current_owner_id` (`current_owner_id`),
  CONSTRAINT `artifacts_ibfk_1` FOREIGN KEY (`current_owner_id`) REFERENCES `heroes` (`hero_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `artifacts`
--

LOCK TABLES `artifacts` WRITE;
/*!40000 ALTER TABLE `artifacts` DISABLE KEYS */;
INSERT INTO `artifacts` VALUES
(1,'Keyboard of Destiny','Weapon',420,'Legendary mechanical keyboard that types code by pure willpower','Legendary',1),
(2,'Infinite Dorito Bag','Snack',99,'Never empties. Grants +50 charisma but -10 wisdom','Epic',3),
(3,'Rubber Duck of Debugging','Pet',777,'Stares at you until the bug reveals itself','Legendary',5),
(4,'Otter Space Helmet','Gadget',300,'Allows breathing in the vacuum of bad takes','Epic',2),
(5,'Rickroll Crystal','Meme',666,'Plays Never Gonna Give You Up when shattered','Memetic',4);
/*!40000 ALTER TABLE `artifacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `battles`
--

DROP TABLE IF EXISTS `battles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `battles` (
  `battle_id` int(11) NOT NULL AUTO_INCREMENT,
  `hero_id` int(11) NOT NULL,
  `quest_id` int(11) NOT NULL,
  `enemy_name` varchar(100) NOT NULL,
  `enemy_level` int(11) DEFAULT 1,
  `hero_hp` int(11) DEFAULT 100,
  `enemy_hp` int(11) DEFAULT 50,
  `battle_status` enum('in_progress','won','lost','escaped') DEFAULT 'in_progress',
  `started_at` timestamp NULL DEFAULT current_timestamp(),
  `ended_at` timestamp NULL DEFAULT NULL,
  `damage_dealt` int(11) DEFAULT 0,
  `damage_taken` int(11) DEFAULT 0,
  `battle_result` enum('victory','defeat','escape','draw') DEFAULT NULL,
  `xp_gained` int(11) DEFAULT 0,
  `items_found` text DEFAULT NULL,
  `combat_time` int(11) DEFAULT 0,
  `hero_max_hp` int(11) DEFAULT 100,
  `enemy_max_hp` int(11) DEFAULT 50,
  `battle_difficulty` enum('Easy','Medium','Hard','Extreme') DEFAULT NULL,
  PRIMARY KEY (`battle_id`),
  KEY `hero_id` (`hero_id`),
  KEY `quest_id` (`quest_id`),
  CONSTRAINT `battles_ibfk_1` FOREIGN KEY (`hero_id`) REFERENCES `heroes` (`hero_id`) ON DELETE CASCADE,
  CONSTRAINT `battles_ibfk_2` FOREIGN KEY (`quest_id`) REFERENCES `quests` (`quest_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `battles`
--

LOCK TABLES `battles` WRITE;
/*!40000 ALTER TABLE `battles` DISABLE KEYS */;
INSERT INTO `battles` VALUES
(1,2,2,'SassyBot AI',3,100,50,'won','2026-05-10 05:03:37','2026-05-10 05:04:54',0,0,'victory',500,NULL,120,100,50,'Medium');
/*!40000 ALTER TABLE `battles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `companions`
--

DROP TABLE IF EXISTS `companions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `companions` (
  `companion_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `type` enum('Chaos Dragon','SassBot AI','Sentient Toaster','Mini Space Otter','Pixel Familiar','Doge Knight','Coffee Elemental','Rubber Duck Overlord','Void Cat','Hyperactive Hamster') NOT NULL,
  `personality` varchar(100) DEFAULT 'Chaotic Good',
  `power_level` int(11) DEFAULT 50 CHECK (`power_level` between 1 and 999),
  `special_ability` text DEFAULT NULL,
  `owner_id` int(11) DEFAULT NULL,
  `joined_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`companion_id`),
  KEY `owner_id` (`owner_id`),
  CONSTRAINT `companions_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `heroes` (`hero_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `companions`
--

LOCK TABLES `companions` WRITE;
/*!40000 ALTER TABLE `companions` DISABLE KEYS */;
INSERT INTO `companions` VALUES
(1,'Smaugy McToast','Sentient Toaster','Grumpy but loyal',420,'Burns toast perfectly + launches bagels as projectiles',1,'2026-05-07 12:08:08'),
(2,'Debug Duck','Rubber Duck Overlord','Wise & judgmental',777,'Stares at code until bugs commit seppuku',5,'2026-05-07 12:08:08'),
(3,'Floof von Squeak','Mini Space Otter','Derpy Genius',666,'Can quantum tunnel through walls (and into snacks)',2,'2026-05-07 12:08:08'),
(4,'Rickroll.exe','SassBot AI','Troll Supreme',888,'Autoplays Never Gonna Give You Up at the worst moments',4,'2026-05-07 12:08:08'),
(5,'Sir Borks-a-Lot','Doge Knight','Very Good Boy',350,'Immune to dark magic, extremely flammable to treats',3,'2026-05-07 12:08:08'),
(6,'Nullvoid','Void Cat','Mysterious',950,'Can delete small objects from existence (mostly socks)',5,'2026-05-07 12:08:08'),
(7,'Espresso Lord','Coffee Elemental','Hyperactive',520,'Grants temporary +100 speed but causes crash later',NULL,'2026-05-07 12:08:08'),
(8,'Toastimus Prime','Sentient Toaster','Heroic',600,'Transforms into a battle toaster',NULL,'2026-05-07 12:09:05'),
(9,'MemeLord Jr','Pixel Familiar','Sarcastic',450,'Generates reaction images on demand',3,'2026-05-07 12:09:05'),
(10,'Quantum Nibbler','Hyperactive Hamster','Chaotic Neutral',520,'Runs so fast he phases through dimensions',2,'2026-05-07 12:09:05');
/*!40000 ALTER TABLE `companions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `current_game_status`
--

DROP TABLE IF EXISTS `current_game_status`;
/*!50001 DROP VIEW IF EXISTS `current_game_status`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `current_game_status` AS SELECT
 1 AS `hero`,
  1 AS `class`,
  1 AS `level`,
  1 AS `hp`,
  1 AS `active_quests`,
  1 AS `companions`,
  1 AS `last_location`,
  1 AS `last_event` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `hero_companions`
--

DROP TABLE IF EXISTS `hero_companions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `hero_companions` (
  `hero_id` int(11) NOT NULL,
  `companion_id` int(11) NOT NULL,
  PRIMARY KEY (`hero_id`,`companion_id`),
  KEY `companion_id` (`companion_id`),
  CONSTRAINT `hero_companions_ibfk_1` FOREIGN KEY (`hero_id`) REFERENCES `heroes` (`hero_id`) ON DELETE CASCADE,
  CONSTRAINT `hero_companions_ibfk_2` FOREIGN KEY (`companion_id`) REFERENCES `companions` (`companion_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hero_companions`
--

LOCK TABLES `hero_companions` WRITE;
/*!40000 ALTER TABLE `hero_companions` DISABLE KEYS */;
INSERT INTO `hero_companions` VALUES
(1,1),
(1,7),
(1,8),
(2,3),
(2,10),
(3,5),
(3,9),
(4,4),
(5,2),
(5,6);
/*!40000 ALTER TABLE `hero_companions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `hero_stats`
--

DROP TABLE IF EXISTS `hero_stats`;
/*!50001 DROP VIEW IF EXISTS `hero_stats`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8mb4;
/*!50001 CREATE VIEW `hero_stats` AS SELECT
 1 AS `username`,
  1 AS `class`,
  1 AS `level`,
  1 AS `active_quests`,
  1 AS `companion_count`,
  1 AS `total_artifact_power`,
  1 AS `total_companion_power` */;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `heroes`
--

DROP TABLE IF EXISTS `heroes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `heroes` (
  `hero_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `real_name` varchar(100) DEFAULT NULL,
  `class` enum('Wizard','Hacker','Space Otter','Pixel Knight','Memelord','Chaotic Bard') NOT NULL,
  `level` int(11) DEFAULT 1 CHECK (`level` >= 1 and `level` <= 100),
  `hp` int(11) DEFAULT 100,
  `mana` int(11) DEFAULT 50,
  `catchphrase` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `reputation` int(11) DEFAULT 0,
  PRIMARY KEY (`hero_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `heroes`
--

LOCK TABLES `heroes` WRITE;
/*!40000 ALTER TABLE `heroes` DISABLE KEYS */;
INSERT INTO `heroes` VALUES
(1,'PixelSlayer42','Timmy Turner','Pixel Knight',42,420,69,'I cast \"sudo rm -rf reality\"','2026-05-07 12:07:03',500),
(2,'QuantumOtter','Otto von Floof','Space Otter',87,999,420,'Squeak goes the multiverse!','2026-05-07 12:07:03',920),
(3,'CatMemer','Sarah Chen','Memelord',25,150,200,'This is fine... in binary','2026-05-07 12:07:03',250),
(4,'VoidBard','Luna Eclipse','Chaotic Bard',66,333,666,'Never gonna give you up... in iambic pentameter','2026-05-07 12:07:03',0),
(5,'DebugWiz','Professor Null','Wizard',99,500,999,'Segmentation fault? More like segmentation... fun!','2026-05-07 12:07:03',0);
/*!40000 ALTER TABLE `heroes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `location_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `biome` enum('Neon Cyber-Forest','Floating Meme Castle','Quantum Donut Shop','Basement of Doom','Starship Otter','Vaporwave Beach','Error 404 Realm') NOT NULL,
  `danger_level` int(11) DEFAULT NULL CHECK (`danger_level` between 1 and 10),
  `has_wifi` tinyint(1) DEFAULT 1,
  `special_feature` text DEFAULT NULL,
  PRIMARY KEY (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES
(1,'The Lazy Server','Basement of Doom',3,1,'Infinite energy drinks in the fridge'),
(2,'Otter Nebula Lounge','Starship Otter',7,1,'Zero-gravity ping pong'),
(3,'404 Dream Castle','Floating Meme Castle',9,0,'Reality glitches every hour'),
(4,'Neon Code Grove','Neon Cyber-Forest',5,1,'Trees made of RGB lights');
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quests`
--

DROP TABLE IF EXISTS `quests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `quests` (
  `quest_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `difficulty` enum('Noob','Medium','Hard','Git Gud','Impossible') NOT NULL,
  `reward_xp` int(11) NOT NULL,
  `reward_item_id` int(11) DEFAULT NULL,
  `assigned_to` int(11) DEFAULT NULL,
  `status` enum('Available','In Progress','Completed','Failed') DEFAULT 'Available',
  `completed_at` timestamp NULL DEFAULT NULL,
  `completion_time` int(11) DEFAULT 0,
  `reputation_required` int(11) DEFAULT 0,
  `requires_battle` tinyint(1) DEFAULT 0,
  `battle_enemy` varchar(100) DEFAULT NULL,
  `battle_difficulty` enum('Easy','Medium','Hard','Extreme') DEFAULT 'Medium',
  PRIMARY KEY (`quest_id`),
  KEY `assigned_to` (`assigned_to`),
  KEY `reward_item_id` (`reward_item_id`),
  CONSTRAINT `quests_ibfk_1` FOREIGN KEY (`assigned_to`) REFERENCES `heroes` (`hero_id`),
  CONSTRAINT `quests_ibfk_2` FOREIGN KEY (`reward_item_id`) REFERENCES `artifacts` (`artifact_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quests`
--

LOCK TABLES `quests` WRITE;
/*!40000 ALTER TABLE `quests` DISABLE KEYS */;
INSERT INTO `quests` VALUES
(1,'Debug the Ancient Mainframe','The old server in the basement is possessed by a demon... or just Windows XP','Hard',5000,3,5,'In Progress',NULL,0,300,0,NULL,'Medium'),
(2,'Deliver 1000 Memes to the Void','The Chaos Realm is hungry for fresh copypasta','Medium',2500,5,2,'Completed','2026-05-10 05:04:05',120,100,1,'SassyBot AI','Medium'),
(3,'Rescue the Floating Donut Shop','It\'s drifting into a black hole made of bad coffee','Git Gud',15000,1,NULL,'Available',NULL,0,700,0,NULL,'Medium'),
(4,'Teach an Otter Quantum Physics','Otto keeps eating the Schrödinger\'s cat treats','Noob',420,4,2,'Completed','2026-05-10 04:48:12',3600,0,0,NULL,'Medium'),
(5,'Rescue the Floating Donut Shop Again','A Git Gud level chaos awaits. Even the rubber ducks are scared.','Git Gud',7667,NULL,NULL,'Available',NULL,0,700,0,NULL,'Medium'),
(6,'Retrieve the Lost WiFi Password of Eternity','A Impossible level chaos awaits. Reward includes snacks and existential dread.','Impossible',20660,NULL,NULL,'Available',NULL,0,1500,1,'Chaos Dragon','Extreme'),
(7,'Translate Ancient Copypasta Runes','A Noob level chaos awaits. Even the rubber ducks are scared.','Noob',561,NULL,5,'Available',NULL,0,0,0,NULL,'Medium'),
(8,'Defeat the Lag Demon in the Basement','A Git Gud level chaos awaits. Your companions are already memeing about it.','Git Gud',6736,2,NULL,'Available',NULL,0,700,1,'Lag Demon','Hard'),
(9,'Teach Physics to a Hyperactive Hamster','A Hard level chaos awaits. Even the rubber ducks are scared.','Hard',3220,NULL,NULL,'Available',NULL,0,300,1,'Coffee Elemental','Hard'),
(10,'Collect 1000 Rare Pepe Shards','A Noob level chaos awaits. Your companions are already memeing about it.','Noob',209,NULL,2,'In Progress',NULL,0,0,0,NULL,'Medium');
/*!40000 ALTER TABLE `quests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tavern_log`
--

DROP TABLE IF EXISTS `tavern_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `tavern_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `hero_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `event_text` text NOT NULL,
  `happened_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`log_id`),
  KEY `hero_id` (`hero_id`),
  KEY `location_id` (`location_id`),
  CONSTRAINT `tavern_log_ibfk_1` FOREIGN KEY (`hero_id`) REFERENCES `heroes` (`hero_id`),
  CONSTRAINT `tavern_log_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tavern_log`
--

LOCK TABLES `tavern_log` WRITE;
/*!40000 ALTER TABLE `tavern_log` DISABLE KEYS */;
INSERT INTO `tavern_log` VALUES
(1,1,1,'PixelSlayer42 tried to cast \"format c:\" on the tavern jukebox','2026-05-07 12:07:03'),
(2,2,2,'QuantumOtter won 47 games of zero-g ping pong in a row','2026-05-07 12:07:03'),
(3,3,4,'CatMemer posted a meme so powerful it crashed the local reality node','2026-05-07 12:07:03'),
(4,2,4,'QuantumOtter fed espresso to a hyperactive hamster... consequences were felt','2026-05-07 12:12:42'),
(5,5,3,'DebugWiz won a dance battle against a sentient vending machine','2026-05-07 12:12:58'),
(6,1,1,'PixelSlayer42 tried to \"rm -rf\" the tavern fridge and summoned 47 angry pizza gremlins','2026-05-07 12:12:58'),
(7,1,2,'PixelSlayer42 tried to rickroll the Void and the Void rickrolled back','2026-05-07 12:15:28'),
(8,1,3,'PixelSlayer42 You find a shiny shard... but it\'s guarded by Sir Borks-a-Lot\'s evil twin: Sir Borksalot the Destroyer!','2026-05-07 12:18:56'),
(9,1,3,'PixelSlayer42 went MAX POWER against Sir Borksalot! Smaugy McToast joins the fight and launches flaming bagels! You win, but your eyebrows are now gone.','2026-05-07 12:20:53');
/*!40000 ALTER TABLE `tavern_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'nerdverse'
--
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `fight_borksalot` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `fight_borksalot`(IN p_hero_id INT)
BEGIN
    DECLARE v_hero_name VARCHAR(50);
    DECLARE v_outcome TEXT;
    DECLARE v_shards INT;
    DECLARE v_roll INT;

    SELECT username INTO v_hero_name FROM heroes WHERE hero_id = p_hero_id;

    SET v_roll = FLOOR(RAND() * 10) + 1;

    SET v_shards = CASE 
        WHEN v_roll >= 8 THEN 42
        WHEN v_roll >= 5 THEN 18
        ELSE 7 
    END;

    SET v_outcome = CASE 
        WHEN v_roll >= 9 THEN 'You deliver a devastating "sudo smash" with your keyboard! Sir Borksalot explodes into a shower of Rare Pepe shards and dog treats. VICTORY!'
        WHEN v_roll >= 6 THEN 'Smaugy McToast joins the fight and launches flaming bagels! You win, but your eyebrows are now gone.'
        WHEN v_roll >= 4 THEN 'Espresso Lord goes hyper and you both defeat the boss in a caffeine-fueled blur. Success... kind of.'
        WHEN v_roll = 3 THEN 'You almost win... but Sir Borksalot counters with the legendary "Zoomies Attack". You escape with some shards.'
        ELSE 'The fight turns into a chaotic dance battle. You lose the shard but gain +10 respect from the castle.'
    END;

    INSERT INTO tavern_log (hero_id, location_id, event_text)
    VALUES (p_hero_id, 
            (SELECT location_id FROM locations WHERE name LIKE '%Meme%' OR name LIKE '%Castle%' LIMIT 1),
            CONCAT(v_hero_name, ' went MAX POWER against Sir Borksalot! ', v_outcome));

    SELECT 
        '⚔️ BATTLE RESULT!' AS title,
        v_hero_name AS hero,
        v_outcome AS result,
        CONCAT('You collected ', v_shards, ' Rare Pepe Shards!') AS shards_gained,
        CONCAT('Total Shards: ', v_shards, ' / 1000') AS progress,
        'What do you do next?' AS next_action;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `generate_random_event` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_random_event`(
    IN p_hero_id INT, 
    IN p_location_id INT
)
BEGIN
    DECLARE v_hero_id INT;
    DECLARE v_location_id INT;
    DECLARE v_event_text TEXT;
    DECLARE v_random INT;

    IF p_hero_id = -1 OR p_hero_id IS NULL THEN
        SELECT hero_id INTO v_hero_id FROM heroes ORDER BY RAND() LIMIT 1;
    ELSE
        SET v_hero_id = p_hero_id;
    END IF;

    IF p_location_id = -1 OR p_location_id IS NULL THEN
        SELECT location_id INTO v_location_id FROM locations ORDER BY RAND() LIMIT 1;
    ELSE
        SET v_location_id = p_location_id;
    END IF;

    SET v_random = FLOOR(RAND() * 12);

    SET v_event_text = CASE v_random
        WHEN 0 THEN 'tried to "rm -rf" the tavern fridge and summoned 47 angry pizza gremlins'
        WHEN 1 THEN 'won a dance battle against a sentient vending machine'
        WHEN 2 THEN 'accidentally cast "sudo make me a sandwich" and got a sentient sandwich'
        WHEN 3 THEN 'posted a meme so powerful it caused a temporary reality glitch'
        WHEN 4 THEN 'taught a rubber duck quantum mechanics and it achieved sentience'
        WHEN 5 THEN 'played ping-pong in zero gravity and broke the sound barrier with a squeak'
        WHEN 6 THEN 'debugged the jukebox by yelling at it in binary'
        WHEN 7 THEN 'tried to rickroll the Void and the Void rickrolled back'
        WHEN 8 THEN 'fed espresso to a hyperactive hamster... consequences were felt'
        WHEN 9 THEN 'discovered that the Basement of Doom now has better WiFi than reality'
        WHEN 10 THEN 'challenged Sir Borks-a-Lot to a treat-eating contest and lost'
        ELSE 'triggered a buffer overflow in the laws of physics'
    END;

    INSERT INTO tavern_log (hero_id, location_id, event_text)
    VALUES (v_hero_id, v_location_id, 
            CONCAT((SELECT username FROM heroes WHERE hero_id = v_hero_id), ' ', v_event_text));

    SELECT 'Random Event Generated!' AS message, 
           (SELECT username FROM heroes WHERE hero_id = v_hero_id) AS hero,
           (SELECT name FROM locations WHERE location_id = v_location_id) AS location,
           v_event_text AS what_happened;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `generate_random_quest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_random_quest`(IN p_count INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE v_title VARCHAR(150);
    DECLARE v_desc TEXT;
    DECLARE v_diff ENUM('Noob','Medium','Hard','Git Gud','Impossible');
    DECLARE v_xp INT;
    DECLARE v_reward_id INT;

    IF p_count IS NULL OR p_count < 1 THEN 
        SET p_count = 1; 
    END IF;

    WHILE i <= p_count DO
        SET v_diff = ELT(FLOOR(RAND()*5)+1, 'Noob','Medium','Hard','Git Gud','Impossible');
        
        SET v_xp = CASE v_diff
            WHEN 'Noob'      THEN FLOOR(200 + RAND()*800)
            WHEN 'Medium'    THEN FLOOR(800 + RAND()*1200)
            WHEN 'Hard'      THEN FLOOR(1500 + RAND()*2000)
            WHEN 'Git Gud'   THEN FLOOR(4000 + RAND()*6000)
            ELSE                  FLOOR(10000 + RAND()*15000)
        END;

        SELECT artifact_id INTO v_reward_id FROM artifacts ORDER BY RAND() LIMIT 1;
        IF RAND() > 0.6 THEN SET v_reward_id = NULL; END IF;

        SET v_title = ELT(FLOOR(RAND()*8)+1,
            'Retrieve the Lost WiFi Password of Eternity',
            'Defeat the Lag Demon in the Basement',
            'Translate Ancient Copypasta Runes',
            'Rescue the Floating Donut Shop Again',
            'Debug the Sentient Toaster Rebellion',
            'Collect 1000 Rare Pepe Shards',
            'Teach Physics to a Hyperactive Hamster',
            'Survive the Great Rickroll Apocalypse');

        SET v_desc = CONCAT('A ', v_diff, ' level chaos awaits. ',
            ELT(FLOOR(RAND()*5)+1, 
                'The multiverse is buffering...',
                'Even the rubber ducks are scared.',
                'Your companions are already memeing about it.',
                'Reward includes snacks and existential dread.',
                'Warning: May cause spontaneous dance battles.'));

        INSERT INTO quests (title, description, difficulty, reward_xp, reward_item_id, status)
        VALUES (v_title, v_desc, v_diff, v_xp, v_reward_id, 'Available');

        SET i = i + 1;
    END WHILE;

    SELECT CONCAT('Generated ', p_count, ' new random quest(s)!') AS message;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `StartBattle` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `StartBattle`(
    IN p_hero_id INT,
    IN p_quest_id INT
)
BEGIN
    DECLARE v_quest_id INT;
    DECLARE v_battle_enemy VARCHAR(100);
    DECLARE v_battle_difficulty VARCHAR(20);
    DECLARE v_hero_hp INT;
    DECLARE v_enemy_hp INT;

    -- Get quest details
    SELECT quest_id, battle_enemy, battle_difficulty, reward_xp
    INTO v_quest_id, v_battle_enemy, v_battle_difficulty, v_hero_hp
    FROM quests
    WHERE quest_id = p_quest_id;

    -- Insert battle record
    INSERT INTO battles (hero_id, quest_id, enemy_name, enemy_level, hero_hp, enemy_hp, battle_status)
    VALUES (p_hero_id, p_quest_id, v_battle_enemy,
            CASE v_battle_difficulty
                WHEN 'Easy' THEN 1
                WHEN 'Medium' THEN 3
                WHEN 'Hard' THEN 5
                WHEN 'Extreme' THEN 7
            END,
            100, 50, 'in_progress');

    SELECT LAST_INSERT_ID() as battle_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `start_adventure` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `start_adventure`(IN p_hero_id INT)
BEGIN
    DECLARE hero_name VARCHAR(50);
    
    IF p_hero_id = -1 OR p_hero_id IS NULL THEN
        SELECT hero_id INTO p_hero_id FROM heroes ORDER BY RAND() LIMIT 1;
    END IF;
    
    SELECT username INTO hero_name FROM heroes WHERE hero_id = p_hero_id;
    
    SELECT CONCAT('=== ', hero_name, ' begins a new adventure! ===') AS welcome_message;
    
    CALL generate_random_event(p_hero_id, -1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `start_quest_encounter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `start_quest_encounter`(IN p_hero_id INT)
BEGIN
    DECLARE v_hero_name VARCHAR(50);
    DECLARE v_event VARCHAR(200);
    DECLARE v_roll INT;

    SELECT username INTO v_hero_name 
    FROM heroes WHERE hero_id = p_hero_id;

    SET v_roll = FLOOR(RAND() * 6) + 1;

    SET v_event = CASE v_roll
        WHEN 1 THEN 'A swarm of low-resolution Pepe ghosts appears and starts memeing at you aggressively!'
        WHEN 2 THEN 'You find a shiny shard... but it''s guarded by Sir Borks-a-Lot''s evil twin: Sir Borksalot the Destroyer!'
        WHEN 3 THEN 'Your companion Smaugy McToast gets excited and accidentally burns 47 shards into perfectly crispy toast.'
        WHEN 4 THEN 'A Rickroll trap activates! The entire castle starts blasting Never Gonna Give You Up in 8-bit.'
        WHEN 5 THEN 'Espresso Lord drinks 3 energy potions and enters hyper-speed mode. Everything is now a blur.'
        ELSE 'You discover a hidden cache of 42 shards... but they''re protected by a CAPTCHA from 2007.'
    END;

    INSERT INTO tavern_log (hero_id, location_id, event_text)
    SELECT p_hero_id, 
           (SELECT location_id FROM locations WHERE name LIKE '%Meme%' OR name LIKE '%Castle%' LIMIT 1),
           CONCAT(v_hero_name, ' ', v_event);

    SELECT 
        'Quest Progress!' AS title,
        v_hero_name AS hero,
        'Floating Meme Castle' AS location,
        v_event AS encounter,
        'You currently have 0 / 1000 Pepe Shards' AS score,
        'What do you do next?' AS question;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
/*!50003 DROP PROCEDURE IF EXISTS `take_random_quest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb3 */ ;
/*!50003 SET character_set_results = utf8mb3 */ ;
/*!50003 SET collation_connection  = utf8mb3_general_ci */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `take_random_quest`(IN p_hero_id INT)
BEGIN
    DECLARE v_quest_id INT;
    DECLARE v_hero_name VARCHAR(50);
    DECLARE v_title VARCHAR(150);

    -- Get hero name
    SELECT username INTO v_hero_name 
    FROM heroes WHERE hero_id = p_hero_id;

    -- Find a random available quest
    SELECT quest_id, title INTO v_quest_id, v_title
    FROM quests 
    WHERE status = 'Available'
    ORDER BY RAND() 
    LIMIT 1;

    IF v_quest_id IS NULL THEN
        SELECT 'No quests available right now! Generate more with: CALL generate_random_quest(3);' AS result;
    ELSE
        UPDATE quests 
        SET assigned_to = p_hero_id, 
            status = 'In Progress'
        WHERE quest_id = v_quest_id;

        SELECT 
            'Quest Accepted!' AS status,
            v_hero_name AS hero,
            v_title AS quest_title,
            'Go forth and cause glorious chaos!' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Current Database: `nerdverse`
--

USE `nerdverse`;

--
-- Final view structure for view `current_game_status`
--

/*!50001 DROP VIEW IF EXISTS `current_game_status`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `current_game_status` AS select `h`.`username` AS `hero`,`h`.`class` AS `class`,`h`.`level` AS `level`,`h`.`hp` AS `hp`,count(distinct `q`.`quest_id`) AS `active_quests`,count(distinct `hc`.`companion_id`) AS `companions`,`l`.`name` AS `last_location`,`tl`.`event_text` AS `last_event` from ((((`heroes` `h` left join `quests` `q` on(`h`.`hero_id` = `q`.`assigned_to` and `q`.`status` = 'In Progress')) left join `hero_companions` `hc` on(`h`.`hero_id` = `hc`.`hero_id`)) left join `tavern_log` `tl` on(`h`.`hero_id` = `tl`.`hero_id`)) left join `locations` `l` on(`tl`.`location_id` = `l`.`location_id`)) where `tl`.`happened_at` = (select max(`tavern_log`.`happened_at`) from `tavern_log` where `tavern_log`.`hero_id` = `h`.`hero_id`) group by `h`.`hero_id`,`h`.`username`,`h`.`class`,`h`.`level`,`h`.`hp`,`l`.`name`,`tl`.`event_text` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `hero_stats`
--

/*!50001 DROP VIEW IF EXISTS `hero_stats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb3 */;
/*!50001 SET character_set_results     = utf8mb3 */;
/*!50001 SET collation_connection      = utf8mb3_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `hero_stats` AS select `h`.`username` AS `username`,`h`.`class` AS `class`,`h`.`level` AS `level`,count(distinct `q`.`quest_id`) AS `active_quests`,count(distinct `hc`.`companion_id`) AS `companion_count`,coalesce(sum(`a`.`power_level`),0) AS `total_artifact_power`,coalesce(sum(`comp`.`power_level`),0) AS `total_companion_power` from ((((`heroes` `h` left join `quests` `q` on(`h`.`hero_id` = `q`.`assigned_to` and `q`.`status` = 'In Progress')) left join `artifacts` `a` on(`h`.`hero_id` = `a`.`current_owner_id`)) left join `hero_companions` `hc` on(`h`.`hero_id` = `hc`.`hero_id`)) left join `companions` `comp` on(`hc`.`companion_id` = `comp`.`companion_id`)) group by `h`.`hero_id`,`h`.`username`,`h`.`class`,`h`.`level` */;
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

-- Dump completed on 2026-05-16 13:55:33
