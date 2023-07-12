CREATE DATABASE IF NOT EXISTS `nuclear_olap`;
USE `nuclear_olap`;

-- Dimension Tables

-- 1. Power Plant
DROP TABLE IF EXISTS `status`;
CREATE TABLE `status` (
    `id` tinyint(4) unsigned NOT NULL,
    `type` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


DROP TABLE IF EXISTS `power_plants`;
CREATE TABLE `power_plants` (
    `power_plant_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
    `name` varchar(64) NOT NULL,
    `status_id` tinyint(4) unsigned DEFAULT NULL,
    PRIMARY KEY (`power_plant_id`),
    CONSTRAINT `fk_status_id` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- 2. Reactor
DROP TABLE IF EXISTS `reactor_types`;
CREATE TABLE `reactor_types` (
    `id` tinyint(4) unsigned NOT NULL,
    `type` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
    `description` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `reactors`;
CREATE TABLE `reactors` (
    `reactor_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
    `reactor_type_id` tinyint(4) unsigned DEFAULT NULL,
    `reactor_model` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
    PRIMARY KEY (`reactor_id`),
    CONSTRAINT `fk_reactor_type` FOREIGN KEY (`reactor_type_id`) REFERENCES `reactor_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- 3. Location
DROP TABLE IF EXISTS `continents`;
CREATE TABLE `continents` (
    `code` char(2) COLLATE utf8_unicode_ci NOT NULL,
    `name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
    PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `countries`;
CREATE TABLE `countries` (
    `code` char(2) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'ISO 3166-1 alpha-2 codes',
    `name` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
    `continent_code` char(2) COLLATE utf8_unicode_ci DEFAULT NULL,
    PRIMARY KEY (`code`),
    CONSTRAINT `fk_continent` FOREIGN KEY (`continent_code`) REFERENCES `continents` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `locations`;
CREATE TABLE `locations` (
    `location_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT,
    `latitude` decimal(10,6) DEFAULT NULL,
    `longitude` decimal(10,6) DEFAULT NULL,
    `country_code` char(2) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'ISO 3166-1 alpha-2 codes',
    PRIMARY KEY (`location_id`),
    CONSTRAINT `fk_country` FOREIGN KEY (`country_code`) REFERENCES `countries` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- 4. Lifespan
DROP TABLE IF EXISTS `lifespans`;
CREATE TABLE `lifespans` (
    `lifespan_id` smallint(6) unsigned NOT NULL AUTO_INCREMENT, 
    `construction_start_at` date DEFAULT NULL,
    `operational_from` date DEFAULT NULL,
    `operational_to` date DEFAULT NULL,
    PRIMARY KEY (`lifespan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- Fact Table
DROP TABLE IF EXISTS `nuclear_power_plant_facts`;
CREATE TABLE `nuclear_power_plant_facts` (
    `power_plant_id` smallint(6) unsigned DEFAULT NULL,
    `reactor_id` smallint(6) unsigned DEFAULT NULL,
    `location_id` smallint(6) unsigned DEFAULT NULL,
    `lifespan_id` smallint(6) unsigned DEFAULT NULL,
    `capacity` int(5) unsigned DEFAULT NULL COMMENT 'in MWe',
    CONSTRAINT `fk_power_plant` FOREIGN KEY (`power_plant_id`) REFERENCES `power_plants` (`power_plant_id`),
    CONSTRAINT `fk_reactor` FOREIGN KEY (`reactor_id`) REFERENCES `reactors` (`reactor_id`),
    CONSTRAINT `fk_location` FOREIGN KEY (`location_id`) REFERENCES `locations` (`location_id`),
    CONSTRAINT `fk_lifespan` FOREIGN KEY (`lifespan_id`) REFERENCES `lifespans` (`lifespan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
