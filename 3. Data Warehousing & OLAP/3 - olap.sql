-- ------------------ --
-- Roll-up / Drill-up --
-- ------------------ --

-- Display number of operational nuclear power plants and their capacity for every continent based on the year they were constructed.
-- Dimensions: Power Plants, Lifespans, and Locations

SELECT 
con.`name` AS 'Continent',
YEAR(lif.`construction_start_at`) AS 'Construction Year',
COUNT(fact.`location_id`) AS '# Total', 
SUM(fact.`capacity`) AS 'Total Capacity (in MWe)'
FROM `nuclear_power_plant_facts` fact
JOIN `locations` loc ON fact.`location_id` = loc.`location_id`
JOIN `countries` ctr ON loc.`country_code` = ctr.`code`
JOIN `continents` con ON ctr.`continent_code` = con.`code`
JOIN `power_plants` pow ON fact.`power_plant_id` = pow.`power_plant_id`
JOIN `status` sta ON pow.`status_id` = sta.`id`
JOIN `lifespans` lif ON fact.`lifespan_id` = lif.`lifespan_id` 
WHERE sta.`type` = 'Operational'
GROUP BY con.`code`, YEAR(lif.`construction_start_at`) WITH ROLLUP;

-- Display number of nuclear power plants and their total capacity based on country and reactor type that began construction during and after Cold War era.
-- Dimensions: Reactors, Locations and Lifespans

SELECT
IF (
    lif.`construction_start_at` > '1991-12-26',
    'Post-Cold War', 
    'Cold War'
) AS 'Era',
ctr.`name` AS 'Country',
rty.`description` AS 'Reactor Type',
COUNT(fact.`location_id`) AS '# Total', 
SUM(fact.`capacity`) AS 'Total Capacity (in MWe)'
FROM `nuclear_power_plant_facts` fact
JOIN `reactors` rea ON fact.`reactor_id` = rea.`reactor_id`
JOIN `reactor_types` rty ON rea.`reactor_type_id` = rty.`id`
JOIN `locations` loc ON fact.`location_id` = loc.`location_id`
JOIN `countries` ctr ON loc.`country_code` = ctr.`code`
JOIN `lifespans` lif ON fact.`lifespan_id` = lif.`lifespan_id`
WHERE lif.`construction_start_at` > '1947-03-12'
GROUP BY rty.`type`, ctr.`code`
ORDER BY lif.`construction_start_at`, ctr.`name`, rty.`description`;



-- ---------------------- --
-- Roll-down / Drill-down --
-- ---------------------- --

-- Display the construction year, number of operational nuclear power plants and their total capacity for every country with at least a nuclear power plant based on the year they were constructed.
-- Dimensions: Power Plants, Reactors and Locations

SELECT 
ctr.`name` AS 'Country',
YEAR(lif.`construction_start_at`) AS 'Constructed in',
COUNT(fact.`location_id`) AS '# Total', 
SUM(fact.`capacity`) AS 'Total Capacity (in MWe)'
FROM `nuclear_power_plant_facts` fact
JOIN `locations` loc ON fact.`location_id` = loc.`location_id`
JOIN `countries` ctr ON loc.`country_code` = ctr.`code`
JOIN `continents` con ON ctr.`continent_code` = con.`code`
JOIN `power_plants` pow ON fact.`power_plant_id` = pow.`power_plant_id`
JOIN `status` sta ON pow.`status_id` = sta.`id`
JOIN `lifespans` lif ON fact.`lifespan_id` = lif.`lifespan_id` 
WHERE sta.`type` = 'Operational'
GROUP BY ctr.`code`, YEAR(lif.`construction_start_at`) WITH ROLLUP;

-- Display number of nuclear power plants and their total capacity based on country and reactor type for every year after Cold War.
-- Dimensions: Reactors, Locations and Lifespans

SELECT
YEAR(lif.`construction_start_at`) AS 'Construction Year',
ctr.`name` AS 'Country',
rty.`description` AS 'Reactor Type',
COUNT(fact.`location_id`) AS '# Total', 
SUM(fact.`capacity`) AS 'Total Capacity (in MWe)'
FROM `nuclear_power_plant_facts` fact
JOIN `reactors` rea ON fact.`reactor_id` = rea.`reactor_id`
JOIN `reactor_types` rty ON rea.`reactor_type_id` = rty.`id`
JOIN `locations` loc ON fact.`location_id` = loc.`location_id`
JOIN `countries` ctr ON loc.`country_code` = ctr.`code`
JOIN `lifespans` lif ON fact.`lifespan_id` = lif.`lifespan_id`
WHERE lif.`construction_start_at` > '1947-03-12'
GROUP BY YEAR(lif.`construction_start_at`), rty.`type`, ctr.`code`
ORDER BY lif.`construction_start_at`, rty.`description`, ctr.`name`;



-- ------- --
-- Slicing --
-- ------- --

-- List all nuclear power plants in the United States.
-- Dimensions: Power Plants, Locations, and Lifespans
-- Condition: Country is the United States

SELECT 
pow.`name` AS 'US Nuclear Power Plant', 
fact.`capacity` AS 'Capacity (in MWe)',
sta.`type` AS 'Status', 
IF(
    lif.`construction_start_at` IS NOT NULL, 
    YEAR(lif.`construction_start_at`), '-'
) AS 'Constructed in',
CONCAT(
    IF(lif.`operational_from` IS NOT NULL, YEAR(lif.`operational_from`), 'n.d'), 
    ' - ',
    IF(
        lif.`operational_to` IS NOT NULL, 
        YEAR(lif.`operational_from`), 
        IF(sta.`type` = 'Operational', 'Present', 'n.d')
    )
) AS 'Operation',
loc.`latitude` AS 'Latitude',
loc.`longitude` AS 'Longitude'
FROM `nuclear_power_plant_facts` fact
JOIN `locations` loc ON fact.`location_id` = loc.`location_id`
JOIN `countries` ctr ON loc.`country_code` = ctr.`code`
JOIN `power_plants` pow ON fact.`power_plant_id` = pow.`power_plant_id`
JOIN `status` sta ON pow.`status_id` = sta.`id`
JOIN `lifespans` lif ON fact.`lifespan_id` = lif.`lifespan_id`  
WHERE ctr.`name` = 'United States'
ORDER BY sta.`type`;

-- Display all nuclear power plants with reactor type of Pressurised Water Reactor.
-- Dimensions: Power Plants, Reactors and Locations
-- Condition: Reactor type is Pressurised Water Reactor 

SELECT 
pow.`name` AS 'Nuclear Power Plant',  
sta.`type` AS 'Status', 
fact.`capacity` AS 'Capacity (in MWe)',  
loc.`latitude` AS 'Latitude', 
loc.`longitude` AS 'Longitude', 
ctr.`name` AS 'Country'
FROM `nuclear_power_plant_facts` fact
JOIN `power_plants` pow ON fact.`power_plant_id` = pow.`power_plant_id`
JOIN `status` sta ON pow.`status_id` = sta.`id`
JOIN `reactors` rea ON fact.`reactor_id` = rea.`reactor_id`
JOIN `reactor_types` rty ON rea.`reactor_type_id` = rty.`id`
JOIN `locations` loc ON fact.`location_id` = loc.`location_id`
JOIN `countries` ctr ON loc.`country_code` = ctr.`code`
WHERE rty.`type` = 'PWR'
ORDER BY fact.`capacity`;



-- ------ --
-- Dicing --
-- ------ --

-- List of all shutdown or nuclear power plants in post-Soviet nations
-- Dimensions: Power Plants, Locations, and Lifespans
-- Conditions: country is a post-Soviet nation, and status is either 'Shutdown' or 'Suspended Operation'

SELECT 
pow.`name` AS 'Nuclear Power Plant', 
ctr.`name` AS 'Country', 
sta.`type` AS 'Status', 
fact.`capacity` AS 'Achieved Capacity (in MWe)',
lif.`operational_from` AS "Started Operation", 
lif.`operational_to` AS "Shutdown / Suspended Operation", 
TIMESTAMPDIFF(YEAR, lif.`operational_from`, lif.`operational_to`) AS "Total Operational Years"
FROM `nuclear_power_plant_facts` fact
JOIN `locations` loc ON fact.`location_id` = loc.`location_id`
JOIN `countries` ctr ON loc.`country_code` = ctr.`code`
JOIN `power_plants` pow ON fact.`power_plant_id` = pow.`power_plant_id`
JOIN `status` sta ON pow.`status_id` = sta.`id`
JOIN `lifespans` lif ON fact.`lifespan_id` = lif.`lifespan_id`  
WHERE ctr.`name` IN ('Russian Federation', 'Ukraine', 'Georgia', 'Belarus', 'Uzbekistan', 'Armenia', 
'Azerbaijan', 'Kazakhstan', 'Kyrgyzstan', 'Moldova, Republic of', 'Turkmenistan', 'Tajikistan', 'Latvia')
AND (sta.`type` = 'Shutdown' OR sta.`type` = 'Suspended Operation')
ORDER BY ctr.`name`, sta.`type`;

-- List of operational nuclear power plants that started operating after 2000 in People's Republic of China
-- Dimensions: Power Plants, Locations, and Lifespans
-- Conditions: status is 'Operational', country is People's Republic of China, and operational_from >= '2000-01-01' 

SELECT
pow.`name` AS 'Nuclear Power Plant', 
rty.`description` AS 'Reactor Type', 
loc.`latitude` AS 'Latitude', 
loc.`longitude` AS 'Longitude', 
fact.`capacity` AS 'Capacity (in MWe)', 
lif.`operational_from` AS 'Started Operating'
FROM `nuclear_power_plant_facts` fact
JOIN `power_plants` pow ON fact.`power_plant_id` = pow.`power_plant_id`
JOIN `status` sta ON pow.`status_id` = sta.`id`
JOIN `locations` loc ON fact.`location_id` = loc.`location_id`
JOIN `countries` ctr ON loc.`country_code` = ctr.`code`
JOIN `lifespans` lif ON fact.`lifespan_id` = lif.`lifespan_id`
JOIN `reactors` rea ON fact.`reactor_id` = rea.`reactor_id`
JOIN `reactor_types` rty ON rea.`reactor_type_id` = rty.`id`
WHERE sta.`type` = 'Operational' AND ctr.`name` = "People's Republic of China" 
AND lif.`operational_from` > '1995-12-15'
ORDER BY lif.`operational_from`;



-- -------- --
-- Pivoting --
-- -------- --

-- Display number of nuclear power plants and total capacity for every status based on reactor type
-- Dimensions: Power Plants and Reactors

SELECT 
rty.`description` AS 'Type of Reactor',
COUNT(CASE WHEN sta.`id` = 0 THEN 1 ELSE null END) AS 'Unknown',
COUNT(CASE WHEN sta.`id` = 1 THEN 1 ELSE null END) AS 'Planned',
COUNT(CASE WHEN sta.`id` = 2 THEN 1 ELSE null END) AS 'Under Construction',
COUNT(CASE WHEN sta.`id` = 3 THEN 1 ELSE null END) AS 'Operational',
COUNT(CASE WHEN sta.`id` = 4 THEN 1 ELSE null END) AS 'Suspended Operation',
COUNT(CASE WHEN sta.`id` = 5 THEN 1 ELSE null END) AS 'Shutdown',
COUNT(CASE WHEN sta.`id` = 6 THEN 1 ELSE null END) AS 'Unfinished',
COUNT(CASE WHEN sta.`id` = 7 THEN 1 ELSE null END) AS 'Never Built',
COUNT(CASE WHEN sta.`id` = 8 THEN 1 ELSE null END) AS 'Suspended Construction',
COUNT(CASE WHEN sta.`id` = 9 THEN 1 ELSE null END) AS 'Cancelled Construction',
COUNT(fact.`location_id`) AS '# Total', SUM(fact.`capacity`) AS 'Total Capacity (in MWe)'
FROM `nuclear_power_plant_facts` fact
JOIN `power_plants` pow ON fact.`power_plant_id` = pow.`power_plant_id`
JOIN `status` sta ON pow.`status_id` = sta.`id`
JOIN `reactors` rea ON fact.`reactor_id` = rea.`reactor_id`
JOIN `reactor_types` rty ON rea.`reactor_type_id` = rty.`id`
GROUP BY rty.`id`;

-- Display number of nuclear power plants and total capacity for every reactor type based on status
-- Dimensions: Power Plants and Reactors

SELECT 
sta.`type` AS 'Status',
COUNT(CASE WHEN rty.`id` = 1 THEN 1 ELSE null END) AS 'Advanced Boiling Water Reactor',
COUNT(CASE WHEN rty.`id` = 2 THEN 1 ELSE null END) AS 'Advanced Power Reactor',
COUNT(CASE WHEN rty.`id` = 3 THEN 1 ELSE null END) AS 'Advanced Pressurised Water Reactor',
COUNT(CASE WHEN rty.`id` = 4 THEN 1 ELSE null END) AS 'Advanced Gas-cooled Reactor',
COUNT(CASE WHEN rty.`id` = 5 THEN 1 ELSE null END) AS 'Boiling Water Reactor',
COUNT(CASE WHEN rty.`id` = 6 THEN 1 ELSE null END) AS 'Evolutionary Power Reactor',
COUNT(CASE WHEN rty.`id` = 7 THEN 1 ELSE null END) AS 'Fast Breeder Reactor',
COUNT(CASE WHEN rty.`id` = 8 THEN 1 ELSE null END) AS 'Gas-Cooled Reactor',
COUNT(CASE WHEN rty.`id` = 9 THEN 1 ELSE null END) AS 'High-Temperature Gas-cooled Reactor',
COUNT(CASE WHEN rty.`id` = 10 THEN 1 ELSE null END) AS 'High Temperature Reactor - Pebble Module',
COUNT(CASE WHEN rty.`id` = 11 THEN 1 ELSE null END) AS 'Heavy Water Gas Cooled Reactor',
COUNT(CASE WHEN rty.`id` = 12 THEN 1 ELSE null END) AS 'Heavy Water Light Water Reactor',
COUNT(CASE WHEN rty.`id` = 13 THEN 1 ELSE null END) AS 'Heavy Water Organic Cooled Reactor',
COUNT(CASE WHEN rty.`id` = 14 THEN 1 ELSE null END) AS 'Lead-cooled Fast Reactor',
COUNT(CASE WHEN rty.`id` = 15 THEN 1 ELSE null END) AS 'Liquid Metal Fast Breeder Reactor',
COUNT(CASE WHEN rty.`id` = 16 THEN 1 ELSE null END) AS 'Liquid Metal Fast Reactor',
COUNT(CASE WHEN rty.`id` = 17 THEN 1 ELSE null END) AS 'Light Water Graphite Reactor',
COUNT(CASE WHEN rty.`id` = 18 THEN 1 ELSE null END) AS 'Molten Salt Reactor',
COUNT(CASE WHEN rty.`id` = 19 THEN 1 ELSE null END) AS 'Organic Cooled Reactor',
COUNT(CASE WHEN rty.`id` = 20 THEN 1 ELSE null END) AS 'Pressurised Heavy Water Reactor',
COUNT(CASE WHEN rty.`id` = 21 THEN 1 ELSE null END) AS 'Pressurised Water Reactor',
COUNT(CASE WHEN rty.`id` = 22 THEN 1 ELSE null END) AS 'High Power Channel-Type Reactor (Reaktor Bolshoy Moshchnosti Kanalniy)',
COUNT(CASE WHEN rty.`id` = 23 THEN 1 ELSE null END) AS 'Sodium-Graphite Reactor',
COUNT(CASE WHEN rty.`id` = 24 THEN 1 ELSE null END) AS 'Steam Generating Heavy Water Reactor',
COUNT(CASE WHEN rty.`id` = 25 THEN 1 ELSE null END) AS 'Traveling-Wave Reactor',
COUNT(fact.`location_id`) AS '# Total', 
SUM(fact.`capacity`) AS 'Total Capacity (in MWe)'
FROM `nuclear_power_plant_facts` fact
JOIN `reactors` rea ON fact.`reactor_id` = rea.`reactor_id`
JOIN `reactor_types` rty ON rea.`reactor_type_id` = rty.`id`
JOIN `power_plants` pow ON fact.`power_plant_id` = pow.`power_plant_id`
JOIN `status` sta ON pow.`status_id` = sta.`id`
GROUP BY sta.`id`;


-- Display number of nuclear power plants that began construction in top nuclear nations based on decade
-- Dimensions: Locations and Lifespans

SELECT 
ctr.`name` AS 'Country',
COUNT(CASE WHEN lif.`construction_start_at` BETWEEN '1950-01-01' AND '1960-01-01' THEN 1 ELSE null END) AS '1950s',
COUNT(CASE WHEN lif.`construction_start_at` BETWEEN '1960-01-01' AND '1970-01-01' THEN 1 ELSE null END) AS '1960s',
COUNT(CASE WHEN lif.`construction_start_at` BETWEEN '1970-01-01' AND '1980-01-01' THEN 1 ELSE null END) AS '1970s',
COUNT(CASE WHEN lif.`construction_start_at` BETWEEN '1980-01-01' AND '1990-01-01' THEN 1 ELSE null END) AS '1980s',
COUNT(CASE WHEN lif.`construction_start_at` BETWEEN '1990-01-01' AND '2000-01-01' THEN 1 ELSE null END) AS '1990s',
COUNT(CASE WHEN lif.`construction_start_at` BETWEEN '2000-01-01' AND '2010-01-01' THEN 1 ELSE null END) AS '2000s',
COUNT(CASE WHEN lif.`construction_start_at` BETWEEN '2010-01-01' AND '2020-01-01' THEN 1 ELSE null END) AS '2010s',
COUNT(CASE WHEN lif.`construction_start_at` > '2020-01-01' THEN 1 ELSE null END) AS '2020s',
COUNT(fact.`location_id`) AS '# Total', 
SUM(fact.`capacity`) AS 'Total Capacity (in MWe)'
FROM `nuclear_power_plant_facts` fact
JOIN `locations` loc ON fact.`location_id` = loc.`location_id`
JOIN `countries` ctr ON loc.`country_code` = ctr.`code`
JOIN `lifespans` lif ON fact.`lifespan_id` = lif.`lifespan_id` 
WHERE ctr.`code` IN ('US', 'RU', 'GB', 'FR', 'CN', 'IR', 'PK')
GROUP BY ctr.`code`
ORDER BY ctr.`name`;

-- Display number of nuclear power plants that began construction in top nuclear nations based on decade
-- Dimensions: Locations and Lifespans

SELECT
CONCAT(SUBSTRING(lif.`construction_start_at`, 1, 3), 0, 's') AS decade,
COUNT(CASE WHEN ctr.`code` = 'US' THEN 1 ELSE null END) AS 'United States',
COUNT(CASE WHEN ctr.`code` = 'RU' THEN 1 ELSE null END) AS 'Russia',
COUNT(CASE WHEN ctr.`code` = 'GB' THEN 1 ELSE null END) AS 'United Kingdom',
COUNT(CASE WHEN ctr.`code` = 'FR' THEN 1 ELSE null END) AS 'France',
COUNT(CASE WHEN ctr.`code` = 'CN' THEN 1 ELSE null END) AS 'China',
COUNT(CASE WHEN ctr.`code` = 'IR' THEN 1 ELSE null END) AS 'India',
COUNT(CASE WHEN ctr.`code` = 'PK' THEN 1 ELSE null END) AS 'Pakistan',
COUNT(fact.`location_id`) AS '# Total', 
SUM(fact.`capacity`) AS 'Total Capacity (in MWe)'
FROM `nuclear_power_plant_facts` fact
JOIN `locations` loc ON fact.`location_id` = loc.`location_id`
JOIN `countries` ctr ON loc.`country_code` = ctr.`code`
JOIN `lifespans` lif ON fact.`lifespan_id` = lif.`lifespan_id`
WHERE lif.`construction_start_at` > '1950-01-01'
GROUP BY decade
ORDER BY lif.`construction_start_at`;
