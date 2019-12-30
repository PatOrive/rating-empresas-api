-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema EnterpriseRanking
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema EnterpriseRanking
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `EnterpriseRanking` DEFAULT CHARACTER SET latin1 ;
USE `EnterpriseRanking` ;

-- -----------------------------------------------------
-- Table `EnterpriseRanking`.`regions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EnterpriseRanking`.`regions` (
  `id` CHAR(2) NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EnterpriseRanking`.`provinces`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EnterpriseRanking`.`provinces` (
  `id` CHAR(2) NOT NULL,
  `name` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EnterpriseRanking`.`cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EnterpriseRanking`.`cities` (
  `id` CHAR(36) NOT NULL,
  `name` VARCHAR(60) NOT NULL,
  `region_id` CHAR(2) NOT NULL,
  `province_id` CHAR(2) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `cities_fk_region_id_regions_id_idx` (`region_id` ASC),
  INDEX `cities_fk_province_id_provinces_id_idx` (`province_id` ASC),
  CONSTRAINT `fk_cities_region_id_region_id`
    FOREIGN KEY (`region_id`)
    REFERENCES `EnterpriseRanking`.`regions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_cities_province_id_province_id`
    FOREIGN KEY (`province_id`)
    REFERENCES `EnterpriseRanking`.`provinces` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EnterpriseRanking`.`sectors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EnterpriseRanking`.`sectors` (
  `id` CHAR(36) NOT NULL,
  `sector` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `EnterpriseRanking`.`companies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EnterpriseRanking`.`companies` (
  `id` CHAR(36) NOT NULL,
  `name` VARCHAR(60) NOT NULL,
  `description` VARCHAR(1000) NULL,
  `sector_id` VARCHAR(36) NOT NULL,
  `url_web` VARCHAR(255) NULL,
  `linkedin` VARCHAR(255) NULL,
  `address` VARCHAR(60) NULL,
  `sede_id` CHAR(36) NULL,
  `url_logo` VARCHAR(255) NULL,
  PRIMARY KEY (`id`),
  INDEX `companies_fk_sector_id_idx` (`sector_id` ASC),
  INDEX `fk_companies_sede_id_city_id_idx` (`sede_id` ASC),
  CONSTRAINT `fk_companies_sector_id_sector_id`
    FOREIGN KEY (`sector_id`)
    REFERENCES `EnterpriseRanking`.`sectors` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_companies_sede_id_city_id`
    FOREIGN KEY (`sede_id`)
    REFERENCES `EnterpriseRanking`.`cities` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `EnterpriseRanking`.`companies_cities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EnterpriseRanking`.`companies_cities` (
  `city_id` CHAR(36) NOT NULL,
  `company_id` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`city_id`, `company_id`),
  INDEX `companies_cities_fk_company_id_idx` (`company_id` ASC),
  CONSTRAINT `fk_companies_cities_city_id_city_id`
    FOREIGN KEY (`city_id`)
    REFERENCES `EnterpriseRanking`.`cities` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_companies_cities_company_id_company_id`
    FOREIGN KEY (`company_id`)
    REFERENCES `EnterpriseRanking`.`companies` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `EnterpriseRanking`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EnterpriseRanking`.`users` (
  `id` CHAR(36) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password_hash` VARCHAR(45) NOT NULL,
  `linkedin` VARCHAR(255) NULL,
  `is_admin` TINYINT(1) NOT NULL,
  `created_at` TIMESTAMP NOT NULL,
  `modified_at` TIMESTAMP NULL,
  `deleted_at` TIMESTAMP NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `EnterpriseRanking`.`positions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EnterpriseRanking`.`positions` (
  `id` CHAR(36) NOT NULL,
  `name` VARCHAR(60) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `EnterpriseRanking`.`reviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `EnterpriseRanking`.`reviews` (
  `id` CHAR(36) NOT NULL,
  `user_id` VARCHAR(36) NOT NULL,
  `position_id` VARCHAR(36) NOT NULL,
  `start_year` DATE NOT NULL,
  `end_year` DATE NULL,
  `salary` DECIMAL(10,0) NOT NULL,
  `inhouse_training` CHAR(1) NOT NULL,
  `growth_opportunities` CHAR(1) NOT NULL,
  `work_enviroment` CHAR(1) NOT NULL,
  `personal_life` CHAR(1) NOT NULL,
  `company_culture` CHAR(1) NOT NULL,
  `comment_title` VARCHAR(30) NOT NULL,
  `comment` VARCHAR(1000) NOT NULL,
  `created_at` DATETIME NOT NULL,
  `deleted_at` DATETIME NULL,
  `city_id` CHAR(3) NULL,
  `company_id` VARCHAR(36) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_reviews_1_idx` (`user_id` ASC),
  INDEX `fk_positions_position_id_position_id_idx` (`position_id` ASC),
  INDEX `fk_reviews_city_id_city_id_idx` (`city_id` ASC),
  INDEX `fk_reviews_company_id_company_id_idx` (`company_id` ASC),
  CONSTRAINT `fk_reviews_user_id_user_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `EnterpriseRanking`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reviews_position_id_position_id`
    FOREIGN KEY (`position_id`)
    REFERENCES `EnterpriseRanking`.`positions` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reviews_city_id_city_id`
    FOREIGN KEY (`city_id`)
    REFERENCES `EnterpriseRanking`.`companies_cities` (`city_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reviews_company_id_company_id`
    FOREIGN KEY (`company_id`)
    REFERENCES `EnterpriseRanking`.`companies_cities` (`company_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;