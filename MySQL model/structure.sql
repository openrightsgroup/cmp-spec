SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema bowdlerize
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `bowdlerize` DEFAULT CHARACTER SET latin1 ;
USE `bowdlerize` ;

-- -----------------------------------------------------
-- Table `bowdlerize`.`isp_aliases`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bowdlerize`.`isp_aliases` ;

CREATE TABLE IF NOT EXISTS `bowdlerize`.`isp_aliases` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ispID` INT(10) UNSIGNED NULL DEFAULT NULL,
  `alias` VARCHAR(64) NULL DEFAULT NULL,
  `created` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `isp_aliases_alias` (`alias` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bowdlerize`.`isp_cache`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bowdlerize`.`isp_cache` ;

CREATE TABLE IF NOT EXISTS `bowdlerize`.`isp_cache` (
  `ip` VARCHAR(16) NOT NULL,
  `network` VARCHAR(64) NOT NULL,
  `created` DATETIME NOT NULL,
  PRIMARY KEY (`ip`, `network`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bowdlerize`.`isps`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bowdlerize`.`isps` ;

CREATE TABLE IF NOT EXISTS `bowdlerize`.`isps` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL,
  `created` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `name` (`name` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bowdlerize`.`modx_copy`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bowdlerize`.`modx_copy` ;

CREATE TABLE IF NOT EXISTS `bowdlerize`.`modx_copy` (
  `id` INT(10) UNSIGNED NOT NULL,
  `last_id` INT(10) UNSIGNED NOT NULL,
  `last_checked` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `bowdlerize`.`probes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bowdlerize`.`probes` ;

CREATE TABLE IF NOT EXISTS `bowdlerize`.`probes` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` VARCHAR(32) NOT NULL,
  `userID` INT(11) UNSIGNED NULL DEFAULT NULL,
  `publicKey` TEXT NULL DEFAULT NULL,
  `secret` VARCHAR(128) NULL DEFAULT NULL,
  `type` ENUM('raspi','android','atlas','web') NOT NULL,
  `lastSeen` DATETIME NULL DEFAULT NULL,
  `gcmRegID` TEXT NULL DEFAULT NULL,
  `isPublic` TINYINT(1) UNSIGNED NULL DEFAULT '1',
  `countryCode` VARCHAR(3) NULL DEFAULT NULL,
  `probeReqSent` INT(11) UNSIGNED NULL DEFAULT '0',
  `probeRespRecv` INT(11) UNSIGNED NULL DEFAULT '0',
  `enabled` TINYINT(1) UNSIGNED NULL DEFAULT '1',
  `frequency` INT(11) UNSIGNED NULL DEFAULT '2',
  `gcmType` INT(11) UNSIGNED NULL DEFAULT '0',
  PRIMARY KEY (`uuid`, `id`),
  UNIQUE INDEX `probeUUID` (`uuid` ASC),
  INDEX `id` (`id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bowdlerize`.`queue`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bowdlerize`.`queue` ;

CREATE TABLE IF NOT EXISTS `bowdlerize`.`queue` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ispID` INT(10) UNSIGNED NOT NULL,
  `urlID` INT(10) UNSIGNED NOT NULL,
  `priority` SMALLINT(5) UNSIGNED NOT NULL DEFAULT '5',
  `lastSent` DATETIME NULL DEFAULT NULL,
  `results` INT(10) UNSIGNED NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE INDEX `queue_unq` (`ispID` ASC, `urlID` ASC),
  INDEX `cvr` (`ispID` ASC, `priority` ASC, `results` ASC, `lastSent` ASC, `urlID` ASC, `id` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bowdlerize`.`queue_length`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bowdlerize`.`queue_length` ;

CREATE TABLE IF NOT EXISTS `bowdlerize`.`queue_length` (
  `created` DATETIME NOT NULL DEFAULT '0000-00-00 00:00:00',
  `isp` VARCHAR(64) NOT NULL DEFAULT '',
  `type` VARCHAR(8) NOT NULL DEFAULT '',
  `length` INT(10) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`type`, `isp`, `created`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bowdlerize`.`requests`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bowdlerize`.`requests` ;

CREATE TABLE IF NOT EXISTS `bowdlerize`.`requests` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `urlID` INT(11) NOT NULL,
  `userID` INT(11) NOT NULL,
  `submission_info` TEXT NULL DEFAULT NULL,
  `created` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bowdlerize`.`results`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bowdlerize`.`results` ;

CREATE TABLE IF NOT EXISTS `bowdlerize`.`results` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `urlID` INT(11) NOT NULL,
  `probeID` INT(11) NOT NULL,
  `config` INT(11) NOT NULL,
  `ip_network` VARCHAR(16) NULL DEFAULT NULL,
  `status` VARCHAR(8) NULL DEFAULT NULL,
  `http_status` INT(11) NULL DEFAULT NULL,
  `network_name` VARCHAR(64) NULL DEFAULT NULL,
  `created` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `result_idx` (`urlID` ASC, `network_name` ASC, `status` ASC, `created` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bowdlerize`.`tempURLs`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bowdlerize`.`tempURLs` ;

CREATE TABLE IF NOT EXISTS `bowdlerize`.`tempURLs` (
  `tempID` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `URL` TEXT NULL DEFAULT NULL,
  `hash` VARCHAR(32) NULL DEFAULT NULL,
  `headers` TEXT NULL DEFAULT NULL,
  `content_type` TEXT NULL DEFAULT NULL,
  `code` INT(11) UNSIGNED NULL DEFAULT NULL,
  `fullFidelityReq` TINYINT(1) UNSIGNED NULL DEFAULT '0',
  `urgency` INT(11) UNSIGNED NULL DEFAULT '0',
  `source` ENUM('social','user','canary','probe') NULL DEFAULT NULL,
  `targetASN` INT(11) UNSIGNED NULL DEFAULT NULL,
  `status` ENUM('pending','failed','ready','complete') NULL DEFAULT NULL,
  `lastPolled` DATETIME NULL DEFAULT NULL,
  `inserted` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `polledAttempts` INT(11) UNSIGNED NULL DEFAULT '0',
  `polledSuccess` INT(11) UNSIGNED NULL DEFAULT '0',
  PRIMARY KEY (`tempID`),
  UNIQUE INDEX `tempurl_url` (`URL`(255) ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `bowdlerize`.`urls`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bowdlerize`.`urls` ;

CREATE TABLE IF NOT EXISTS `bowdlerize`.`urls` (
  `urlID` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `URL` VARCHAR(2048) CHARACTER SET 'latin1' COLLATE 'latin1_bin' NOT NULL,
  `hash` VARCHAR(32) NULL DEFAULT NULL,
  `source` ENUM('social','user','canary','probe','alexa') NULL DEFAULT NULL,
  `lastPolled` DATETIME NULL DEFAULT NULL,
  `inserted` DATETIME NOT NULL,
  `polledAttempts` INT(10) UNSIGNED NULL DEFAULT '0',
  `polledSuccess` INT(10) UNSIGNED NULL DEFAULT '0',
  PRIMARY KEY (`urlID`),
  UNIQUE INDEX `urls_url` (`URL`(767) ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `bowdlerize`.`users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `bowdlerize`.`users` ;

CREATE TABLE IF NOT EXISTS `bowdlerize`.`users` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(128) NOT NULL,
  `password` VARCHAR(255) NULL DEFAULT NULL,
  `preference` TEXT NULL DEFAULT NULL,
  `fullName` VARCHAR(60) NULL DEFAULT NULL,
  `isPublic` TINYINT(1) UNSIGNED NULL DEFAULT '0',
  `countryCode` VARCHAR(3) NULL DEFAULT NULL,
  `probeHMAC` VARCHAR(32) NULL DEFAULT NULL,
  `status` ENUM('pending','ok','suspended','banned') NULL DEFAULT 'pending',
  `pgpKey` TEXT NULL DEFAULT NULL,
  `yubiKey` VARCHAR(12) NULL DEFAULT NULL,
  `publicKey` TEXT NULL DEFAULT NULL,
  `secret` VARCHAR(128) NULL DEFAULT NULL,
  `createdAt` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email` (`email` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
