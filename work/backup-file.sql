-- MariaDB dump 10.17  Distrib 10.4.12-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: ambitorio
-- ------------------------------------------------------
-- Server version	10.4.12-MariaDB-1:10.4.12+maria~bionic

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
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `wallet_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `favorite` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `fk_user_id_contacts` (`user_id`),
  KEY `contacts_wallet_id_foreign` (`wallet_id`),
  CONSTRAINT `contacts_wallet_id_foreign` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`),
  CONSTRAINT `fk_user_id_contacts` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `download_access`
--

DROP TABLE IF EXISTS `download_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `download_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `temp_user_id` int(11) DEFAULT NULL,
  `unique_id` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `token` varchar(32) CHARACTER SET latin1 DEFAULT NULL,
  `transaction_id` varchar(36) CHARACTER SET latin1 DEFAULT NULL,
  `ready` tinyint(1) DEFAULT 0,
  `remove_after` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `download_access`
--

LOCK TABLES `download_access` WRITE;
/*!40000 ALTER TABLE `download_access` DISABLE KEYS */;
/*!40000 ALTER TABLE `download_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `encrypted_keys`
--

DROP TABLE IF EXISTS `encrypted_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `encrypted_keys` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `wallet_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_id` int(11) NOT NULL,
  `data` blob NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `encrypted_keys_data_unique` (`data`) USING HASH,
  KEY `encrypted_keys_wallet_id_foreign` (`wallet_id`),
  KEY `encrypted_keys_file_id_foreign` (`file_id`),
  CONSTRAINT `encrypted_keys_file_id_foreign` FOREIGN KEY (`file_id`) REFERENCES `files` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `encrypted_keys_wallet_id_foreign` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `encrypted_keys`
--

LOCK TABLES `encrypted_keys` WRITE;
/*!40000 ALTER TABLE `encrypted_keys` DISABLE KEYS */;
/*!40000 ALTER TABLE `encrypted_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fcm_tokens`
--

DROP TABLE IF EXISTS `fcm_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fcm_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `fcm_token` varchar(2000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `unique_id` varchar(120) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `isMaster` int(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fcm_tokens`
--

LOCK TABLES `fcm_tokens` WRITE;
/*!40000 ALTER TABLE `fcm_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `fcm_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_access`
--

DROP TABLE IF EXISTS `file_access`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` int(11) NOT NULL,
  `wallet_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `amount` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_file_id_file_access` (`file_id`),
  KEY `file_access_wallet_id_foreign` (`wallet_id`),
  CONSTRAINT `file_access_wallet_id_foreign` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`),
  CONSTRAINT `fk_file_id_file_access` FOREIGN KEY (`file_id`) REFERENCES `files` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_access`
--

LOCK TABLES `file_access` WRITE;
/*!40000 ALTER TABLE `file_access` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_access` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_keys`
--

DROP TABLE IF EXISTS `file_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `iv` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `file_key` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nonce` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `transfer_date` datetime NOT NULL DEFAULT current_timestamp(),
  `transaction_id` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_id` int(11) NOT NULL,
  `public_key_id` int(11) NOT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `receiver_id` int(11) DEFAULT NULL,
  `temp_sender_id` int(11) DEFAULT NULL,
  `temp_receiver_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_file_id_file_keys` (`file_id`),
  KEY `fk_public_key_id_file_keys` (`public_key_id`),
  KEY `fk_sender_id_file_keys` (`sender_id`),
  KEY `fk_receiver_id_file_keys` (`receiver_id`),
  KEY `fk_temp_sender_id_file_keys` (`temp_sender_id`),
  KEY `fk_temp_receiver_id_file_keys` (`temp_receiver_id`),
  CONSTRAINT `fk_file_id_file_keys` FOREIGN KEY (`file_id`) REFERENCES `files` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_public_key_id_file_keys` FOREIGN KEY (`public_key_id`) REFERENCES `public_keys` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_receiver_id_file_keys` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_sender_id_file_keys` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_temp_receiver_id_file_keys` FOREIGN KEY (`temp_receiver_id`) REFERENCES `temp_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_temp_sender_id_file_keys` FOREIGN KEY (`temp_sender_id`) REFERENCES `temp_users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_keys`
--

LOCK TABLES `file_keys` WRITE;
/*!40000 ALTER TABLE `file_keys` DISABLE KEYS */;
/*!40000 ALTER TABLE `file_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `file_tags`
--

DROP TABLE IF EXISTS `file_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `file_tags` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `label` varchar(32) DEFAULT NULL,
  `color_code` varchar(12) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `file_tags`
--

LOCK TABLES `file_tags` WRITE;
/*!40000 ALTER TABLE `file_tags` DISABLE KEYS */;
INSERT INTO `file_tags` VALUES (1,'silver','#cfd8dc'),(2,'red','#ff0000'),(3,'gold','#ffb800'),(4,'teal','#62c6cf'),(5,'green','#4fd36b');
/*!40000 ALTER TABLE `file_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `files`
--

DROP TABLE IF EXISTS `files`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tempname` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `downloads` bigint(20) NOT NULL DEFAULT 0,
  `upload_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_download` datetime DEFAULT NULL,
  `link` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `md5_hash` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CL_asset_id` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 0,
  `ipfs_hash` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_tag_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_owner_id_files` (`owner_id`),
  KEY `files_file_tag_id_foreign` (`file_tag_id`),
  CONSTRAINT `files_file_tag_id_foreign` FOREIGN KEY (`file_tag_id`) REFERENCES `file_tags` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `files_owner_id_foreign` FOREIGN KEY (`owner_id`) REFERENCES `wallets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `files`
--

LOCK TABLES `files` WRITE;
/*!40000 ALTER TABLE `files` DISABLE KEYS */;
/*!40000 ALTER TABLE `files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `files_shared`
--

DROP TABLE IF EXISTS `files_shared`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `files_shared` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` int(11) NOT NULL,
  `link` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokens` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fiat_cost` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `active` tinyint(4) NOT NULL DEFAULT 1,
  `expiry` datetime DEFAULT NULL,
  `CL_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_file_id_files_shared` (`file_id`),
  CONSTRAINT `fk_file_id_files_shared` FOREIGN KEY (`file_id`) REFERENCES `files` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `files_shared`
--

LOCK TABLES `files_shared` WRITE;
/*!40000 ALTER TABLE `files_shared` DISABLE KEYS */;
/*!40000 ALTER TABLE `files_shared` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knex_migrations`
--

DROP TABLE IF EXISTS `knex_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knex_migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `batch` int(11) DEFAULT NULL,
  `migration_time` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knex_migrations`
--

LOCK TABLES `knex_migrations` WRITE;
/*!40000 ALTER TABLE `knex_migrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `knex_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `knex_migrations_lock`
--

DROP TABLE IF EXISTS `knex_migrations_lock`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `knex_migrations_lock` (
  `index` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `is_locked` int(11) DEFAULT NULL,
  PRIMARY KEY (`index`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `knex_migrations_lock`
--

LOCK TABLES `knex_migrations_lock` WRITE;
/*!40000 ALTER TABLE `knex_migrations_lock` DISABLE KEYS */;
/*!40000 ALTER TABLE `knex_migrations_lock` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `sender_id` int(11) DEFAULT NULL,
  `object` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `fk_user_id_notifications` (`user_id`),
  KEY `fk_sender_id_notifications` (`sender_id`),
  CONSTRAINT `fk_sender_id_notifications` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_id_notifications` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `printer_rights`
--

DROP TABLE IF EXISTS `printer_rights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `printer_rights` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `printer_id` int(11) NOT NULL,
  `permission` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user_id_printer_rights` (`user_id`),
  KEY `fk_pritner_id_printer_rights` (`printer_id`),
  CONSTRAINT `fk_pritner_id_printer_rights` FOREIGN KEY (`printer_id`) REFERENCES `printers` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_id_printer_rights` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `printer_rights`
--

LOCK TABLES `printer_rights` WRITE;
/*!40000 ALTER TABLE `printer_rights` DISABLE KEYS */;
/*!40000 ALTER TABLE `printer_rights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `printers`
--

DROP TABLE IF EXISTS `printers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `printers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` varchar(400) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `api_key` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `printers`
--

LOCK TABLES `printers` WRITE;
/*!40000 ALTER TABLE `printers` DISABLE KEYS */;
/*!40000 ALTER TABLE `printers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `public_keys`
--

DROP TABLE IF EXISTS `public_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `public_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `public_key` varchar(5000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_master` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `public_keys`
--

LOCK TABLES `public_keys` WRITE;
/*!40000 ALTER TABLE `public_keys` DISABLE KEYS */;
/*!40000 ALTER TABLE `public_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_receipts`
--

DROP TABLE IF EXISTS `purchase_receipts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `purchase_receipts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `store` varchar(16) COLLATE utf8mb4_unicode_ci NOT NULL,
  `purchase_data` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `state` int(11) DEFAULT 3,
  `receipt` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `signature` text COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_receipts`
--

LOCK TABLES `purchase_receipts` WRITE;
/*!40000 ALTER TABLE `purchase_receipts` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_receipts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_invites`
--

DROP TABLE IF EXISTS `team_invites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_invites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  `invitee_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_user_id_team_invites` (`user_id`),
  KEY `fk_team_id_team_invites` (`team_id`),
  KEY `fk_invitee_id_team_invites` (`invitee_id`),
  CONSTRAINT `fk_invitee_id_team_invites` FOREIGN KEY (`invitee_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_team_id_team_invites` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_id_team_invites` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_invites`
--

LOCK TABLES `team_invites` WRITE;
/*!40000 ALTER TABLE `team_invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `team_invites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `team_members`
--

DROP TABLE IF EXISTS `team_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `team_members` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `team_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `wallet_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `permission` int(11) NOT NULL,
  `role` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_team_id_team_members` (`team_id`),
  KEY `fk_user_id_team_members` (`user_id`),
  KEY `team_members_wallet_id_foreign` (`wallet_id`),
  CONSTRAINT `fk_team_id_team_members` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_id_team_members` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `team_members_wallet_id_foreign` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team_members`
--

LOCK TABLES `team_members` WRITE;
/*!40000 ALTER TABLE `team_members` DISABLE KEYS */;
/*!40000 ALTER TABLE `team_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `teams` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` mediumtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teams`
--

LOCK TABLES `teams` WRITE;
/*!40000 ALTER TABLE `teams` DISABLE KEYS */;
/*!40000 ALTER TABLE `teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temp_users`
--

DROP TABLE IF EXISTS `temp_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temp_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `public_key_id` int(11) NOT NULL,
  `last_login` datetime NOT NULL DEFAULT current_timestamp(),
  `uuid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_users_id_temp_users` (`user_id`),
  KEY `fk_public_key_id_temp_users` (`public_key_id`),
  CONSTRAINT `fk_public_key_id_temp_users` FOREIGN KEY (`public_key_id`) REFERENCES `public_keys` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_id_temp_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temp_users`
--

LOCK TABLES `temp_users` WRITE;
/*!40000 ALTER TABLE `temp_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `temp_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction_list`
--

DROP TABLE IF EXISTS `transaction_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `transaction_list` (
  `transaction_id` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `blockchain_id` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `file_id` int(11) DEFAULT NULL,
  `checked_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`transaction_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction_list`
--

LOCK TABLES `transaction_list` WRITE;
/*!40000 ALTER TABLE `transaction_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `transaction_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `token` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `wallet_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firstname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `lastname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `currency` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `public_key_id` int(11) DEFAULT NULL,
  `unique_id` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sub` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `permission` int(2) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_id` (`unique_id`),
  KEY `fk_public_key_id_users` (`public_key_id`),
  KEY `users_wallet_id_foreign` (`wallet_id`),
  CONSTRAINT `users_wallet_id_foreign` FOREIGN KEY (`wallet_id`) REFERENCES `wallets` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (7,'lennartschoettker@hotmail.com','b5384c269030a26336fc79490af6b3d2007950eed0c4f9399c90e2244c0872d9','4f0c1ec4-2441-41eb-b3bd-222790bb818c','Lennart','Schtttttttker',NULL,NULL,250,'342f924d-29db-46bb-b6b0-c5c4534e9d8c','lennartschoettker@hotmail.com.png','287a10ad-3c75-4b96-8e9d-42cefa2d65b9',0),(8,'67e79dc6-b88c-42bb-a75d-73d3dca0c5db','2143fcadfa5e696c24b6a7f031097b561cc9bc47e4fd88f993a6c54e7555372f','4a0948df-50c4-4fd4-806c-164c686b9c02','Second Phone','Dev',NULL,NULL,226,'1514fb5f-7fad-4615-bd97-6fbe13e38993',NULL,'be6e40b8-0f63-471e-b80e-9fa49de9d522',0),(9,'21a14f37-68d0-4e30-a45f-454c9c99d888',NULL,NULL,'Doogee','Y6',NULL,NULL,NULL,'e2735afd-6374-4de1-84cc-d6ee70aa2636',NULL,'1b1c33ac-3ec9-4214-a7f4-d4daf8f6ff84',0),(10,'970b3879-b8e5-424a-9826-cf812f1e61b8',NULL,NULL,'ambi','beta',NULL,NULL,NULL,NULL,NULL,'e5b95819-fea0-4692-9ba3-366f5da3b009',0),(11,NULL,NULL,NULL,'Test','Acc',NULL,NULL,NULL,NULL,NULL,'6f34913f-4eb9-455e-8f14-bff6c271e7b0',0),(12,NULL,NULL,NULL,'Test','Acc2',NULL,NULL,NULL,NULL,NULL,'13adffed-db88-4698-ac6c-9c9ae79b53f7',0),(13,'c3035d1e-b2a9-4213-8511-90ec6cf199ec',NULL,NULL,'hh','zzz',NULL,NULL,NULL,NULL,NULL,'3fabdcff-00c0-4fce-9de7-092ad0fec899',0),(14,'042f550b-121a-49b4-902d-bb728c398d4c',NULL,NULL,'a','b',NULL,NULL,NULL,NULL,NULL,'00fa74b5-f6c1-4370-8a4e-a16a8e42b735',0),(15,'89c64e82-412c-458c-9313-f45fe89258f0',NULL,NULL,'c','d',NULL,NULL,NULL,NULL,NULL,'d7aca0d7-8796-4264-9b72-ad112229df28',0),(16,'d8680dc8-4d62-4c62-b335-0859d118c9f7',NULL,NULL,'x','z',NULL,NULL,NULL,NULL,NULL,'992c90e7-f302-4dab-bc02-e315f390c4ce',0),(17,'a30a0914-f2a1-4a4c-bbf5-896db0c1d5ec',NULL,NULL,'hh','gg',NULL,NULL,NULL,NULL,NULL,'7c9d47f5-4997-458d-a99f-6c4191536269',0),(18,'a7f9d753-7e9e-4f8a-b631-f274fb583fb0',NULL,NULL,'a','d',NULL,NULL,239,'3d749528-28ab-4df1-8f6b-94dab9acac8d',NULL,'800eb384-b8c6-422b-b8b8-d7e16c8d92c6',0),(19,'18ea7979-649e-4b7a-ade0-2a613f52e4dc',NULL,NULL,'w','e',NULL,NULL,NULL,NULL,NULL,'012a7e3a-026e-48e5-8ee6-7531758fd5fb',0),(20,'666e3fc7-ea4f-496f-8d02-f70c3707f136',NULL,'7b880ba9-92dc-457c-bd51-1b839c77f2e4','q','w',NULL,NULL,240,'9e2c6d95-3694-4d89-9146-f83ce1446dbe',NULL,'1e141729-6164-4215-8bd6-e88c255a6b5d',0),(21,'6ec34498-99a6-4db9-824d-dc9160ec0a02',NULL,NULL,'z','z',NULL,NULL,NULL,NULL,NULL,'7a9af5a0-185c-4669-8cb4-13f8a5c68596',0),(22,'ca343ec4-eb0b-447a-99eb-6b2949cfcf76',NULL,NULL,'q','w',NULL,NULL,NULL,NULL,NULL,'c1736148-cc8b-444c-84ee-e0eb6b21303e',0),(23,'4fc6b3ea-69a0-4893-bece-4025d79c5f17',NULL,NULL,'q','e',NULL,NULL,NULL,NULL,NULL,'1980866f-a120-4546-be15-bfb5d8465a4b',0),(24,'6972cfc2-cbab-4f25-98bb-2a763b01fe23',NULL,NULL,'s','t',NULL,NULL,NULL,NULL,NULL,'96f287c9-358d-4153-b617-4705d12e5ab1',0),(25,'36e807fa-3c1c-4833-be97-b359cbe5f14a',NULL,NULL,'q','r',NULL,NULL,NULL,NULL,NULL,'cd905f3b-524d-47e8-b252-5ea4b21b7c14',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wallets`
--

DROP TABLE IF EXISTS `wallets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wallets` (
  `id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `seed_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `blocked` tinyint(1) DEFAULT 0,
  `user_id` int(11) DEFAULT NULL,
  `creation_date` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `wallets_user_id_foreign` (`user_id`),
  CONSTRAINT `wallets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wallets`
--

LOCK TABLES `wallets` WRITE;
/*!40000 ALTER TABLE `wallets` DISABLE KEYS */;
INSERT INTO `wallets` VALUES ('1ae3b622-bc5f-49a8-af16-7fb4b76d12a4','dc703663-d4b1-4477-87e3-bb43cb3eaf07','0x0352c8426e0CdBcfb67106EC21da3d007E5Db957','LSmak',0,7,'2020-02-14 09:35:05'),('1d80a063-325a-47cb-9137-de678b0ce26c','f4178cb8-e828-4a98-a8b5-8d3b2dcef567','0x5ceF643a70623132c2Ec1432Ba9Ed7D47391eE8D','devo',0,7,'2020-02-14 11:56:02'),('1fdf7c97-8616-4a28-92b9-734b4362f16a','827bc139-7fec-4ca6-9b10-5afc8833b446','0xD56F79815288411184567584fede92B9b496c148','h',0,7,'2020-02-27 13:07:52'),('3c0ab677-0236-4bac-b6df-59b056b0ecfa','a1f74ee9-3f7f-440e-b24b-8cfac360d0cb','0x709A0a206dcef68B7a8b15d732f3caEa001bd77C','aagg',0,7,'2020-02-27 14:32:37'),('3cdafe43-ebdc-4031-956d-422a226a267f','f4178cb8-e828-4a98-a8b5-8d3b2dcef567','0x20421b01961e01a57f8467678853702F93333cE0','faulty',0,7,'2020-02-26 11:36:11'),('4a0948df-50c4-4fd4-806c-164c686b9c02','20222d2e-0dbc-4361-a549-397e202c8a81','0x0511F8B6979C5a52685dB71fd7b87AB278c8D2b1','Dev 2 Wallet (Note 7)',0,8,'2019-12-18 17:02:41'),('4f0c1ec4-2441-41eb-b3bd-222790bb818c','4636c861-3ffe-470d-8860-66bf839d9594','0xE640E66Def1443008fb9c5d11A1FcBFA4D96a473','gg',0,7,'2020-02-27 14:48:48'),('59e8965a-fdff-4ce8-acf4-bfc3ef4d303e','7159b270-df88-419a-810f-10b0b28f9dd3','0xC1520cbA32A93013762372A6859866258863F22b','bb',0,7,'2020-02-27 11:20:16'),('5afa483e-670f-4672-a170-ca5b9dfba271','4bdfe9a4-0353-4756-a693-3ea829d977f9','0xf948E89fcFE353B5f17099D57206E4F6Fe00654F','Redmi',0,7,'2019-12-18 16:51:22'),('6537f5e2-a6a4-4228-acdc-cae5977479d4','f4178cb8-e828-4a98-a8b5-8d3b2dcef567','0x6EFB431264Da9123B01F39bcBb93E97A055fE638','faulty2',0,7,'2020-02-26 11:43:31'),('6adf0564-02c5-423c-98ae-3e27a9514603','80a7d71b-b78d-40ad-9213-46a157b1518b','0x003B355c1d9594ed5848C2D6B9eF834F2d05C8e3','asd',0,7,'2020-02-27 10:49:40'),('7b880ba9-92dc-457c-bd51-1b839c77f2e4','227a742c-04d7-4403-87a6-a656d186a0e4','0x5493D1dDD0931C206ef75d7177203aADa305c07C','kk',0,20,'2020-02-13 15:33:07'),('82decd9e-f3a6-419c-b6ec-0c9f62987814','50a61cae-21aa-41c7-9611-6714c92eb418','0x2ce013645c2a108C07A5FEAbB40925CE64d897CE','Generic Address',0,7,'2019-12-17 09:51:24'),('87f2b3c2-d945-4728-8679-668b473deefb','bbcf958d-d37a-45ad-b7ba-b603e742b83b','0x0Ee086193883F3364525Ec114993DE542D03aD19','faulty',0,7,'2020-02-26 11:48:32'),('d096b468-bc24-48a5-9402-821385f835ed','3f38476f-cbf5-46b7-b8b5-9d710b1ec896','0xeC90c56ba7F6749955711220aaf00250307a9719','lolo',0,7,'2020-02-26 17:05:43'),('dc75dc3c-e2da-4969-bcb4-3874b9c3f3cb','e4cf7cc8-1743-4034-8e99-bd4df5a649b8','0x8EbC19038e37e213C72c5170CA9968871936B826','devooo',0,7,'2020-02-26 14:53:01');
/*!40000 ALTER TABLE `wallets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2020-03-17 15:37:44
