-- Status
INSERT INTO `nuclear_olap`.`status`
SELECT * FROM `nuclear`.`nuclear_power_plant_status_type`;

-- Power Plants
INSERT INTO `nuclear_olap`.`power_plants` (`name`, `status_id`)
SELECT `name`, `status_id` FROM `nuclear`.`nuclear_power_plants`;

-- Reactor Types
INSERT INTO `nuclear_olap`.`reactor_types`
SELECT * FROM `nuclear`.`nuclear_reactor_type`;

-- Reactors
INSERT INTO `nuclear_olap`.`reactors` (`reactor_type_id`, `reactor_model`)
SELECT `reactor_type_id`, `reactor_model` FROM `nuclear`.`nuclear_power_plants`;

-- Continents
INSERT INTO `nuclear_olap`.`continents`
SELECT * FROM `nuclear`.`continents`;

-- Countries
INSERT INTO `nuclear_olap`.`countries`
SELECT * FROM `nuclear`.`countries`;

-- Locations
INSERT INTO `nuclear_olap`.`locations` (`latitude`, `longitude`, `country_code`)
SELECT `latitude`, `longitude`, `country_code` FROM `nuclear`.`nuclear_power_plants`;

-- Lifespans
INSERT INTO `nuclear_olap`.`lifespans` (`construction_start_at`, `operational_from`, `operational_to`)
SELECT `construction_start_at`, `operational_from`, `operational_to` FROM `nuclear`.`nuclear_power_plants`;

-- Nuclear Power Plant Facts
INSERT INTO `nuclear_olap`.`nuclear_power_plant_facts` (`power_plant_id`, `reactor_id`, `location_id`, `lifespan_id`, `capacity`)
SELECT p.`id`, p.`id`, p.`id`, p.`id`, p.`capacity`
FROM `nuclear`.`nuclear_power_plants` p
WHERE p.`capacity` > 0



