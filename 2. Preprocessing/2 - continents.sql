USE `nuclear`;

-- Create a table `continents`
DROP TABLE IF EXISTS `continents`;
CREATE TABLE `continents` (
    `code` char(2) COLLATE utf8_unicode_ci NOT NULL,
    `name` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
    PRIMARY KEY (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `continents` VALUES ('AF', 'Africa');
INSERT INTO `continents` VALUES ('AN', 'Antarctica');
INSERT INTO `continents` VALUES ('AS', 'Asia');
INSERT INTO `continents` VALUES ('EU', 'Europe');
INSERT INTO `continents` VALUES ('NA', 'North America');
INSERT INTO `continents` VALUES ('OC', 'Oceania');
INSERT INTO `continents` VALUES ('SA', 'South America');

-- Add a new column called continent
ALTER TABLE `countries`
ADD COLUMN continent_code VARCHAR(2) AFTER name;

-- -- Add foreign key constraint
ALTER TABLE `countries`
ADD FOREIGN KEY (continent_code) REFERENCES `continents`(code);