SELECT COUNT(*) FROM `cs306-project`.airpollution;
#DISCOVERING INSIGHTS FOR AIR POLLUTION


# a - Creating Views:
#View (1)
CREATE VIEW more_population_exposed AS
SELECT  `PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`, countryCode
FROM `cs306-project`.airpollution
WHERE `PM2.5, pop. exposed to levels > WHO guideline value (% TOT)` >= 50 AND Year = 2017;

ALTER VIEW more_population_exposed AS 
SELECT countryCode, Year, `PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`
FROM `cs306-project`.airpollution
WHERE `PM2.5, pop. exposed to levels > WHO guideline value (% TOT)` >= 50;

#View (2)
CREATE VIEW dangerous_pollution_levels AS
SELECT countryCode, `PM2.5, mean annual exposure (μg/m³)`
FROM `cs306-project`.airpollution
WHERE `PM2.5, mean annual exposure (μg/m³)` >= 40 AND Year = 2017;

ALTER VIEW dangerous_pollution_levels AS 
SELECT countryCode, Year, `Total including LUCF in tonnes`
FROM `cs306-project`.airpollution
WHERE `Total including LUCF in tonnes` >= 50000000;

# Having a look at the Views created
SELECT COUNT(*) FROM more_population_exposed;
SELECT COUNT(*) FROM dangerous_pollution_levels;
SELECT * FROM more_population_exposed;
SELECT * FROM dangerous_pollution_levels;

#b - Join and Set Operators 
# Using Set Operators: NOT IN (because MySQL has no EXCEPT)
SELECT P.countryCode, P.`PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`, P.Year
FROM more_population_exposed P
WHERE P.countryCode NOT IN (
	SELECT 	P.countryCode
	FROM more_population_exposed P, dangerous_pollution_levels D
	WHERE P.countryCode = D.countryCode);

# Using Joins Operators: LEFT OUTER JOIN
SELECT P.countryCode, P.`PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`, P.Year
FROM more_population_exposed P LEFT OUTER JOIN dangerous_pollution_levels D
ON P.countryCode = D.countryCode
WHERE D.countryCode IS NULL;

#c - IN and EXISTS
#IN
SELECT P.countryCode, P.`PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`, P.Year
FROM more_population_exposed P
WHERE P.countryCode IN (
							SELECT D.countryCode
                            FROM dangerous_pollution_levels D
                            WHERE P.countryCode = D.countryCode);

# EXISTS
SELECT P.countryCode,  P.`PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`, P.Year
FROM more_population_exposed P
WHERE EXISTS (
				SELECT D.countryCode
				FROM dangerous_pollution_levels D
				WHERE P.countryCode = D.countryCode);
                

#d- Aggregate Operators
#AVG Operator:
SELECT D.countryCode,
	AVG(D.`Total including LUCF in tonnes`) AS `Average Pollution Production Over 1990-2017`,
	AVG(P.`PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`) AS `Average Percentage of Population In Danger over 1990-2017`
FROM dangerous_pollution_levels D, more_population_exposed P
WHERE D.countryCode = P.countryCode #without this I get wrong results for the 3rd column
GROUP BY D.countryCode
HAVING 90 < (SELECT AVG(P.`PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`)
			 FROM more_population_exposed P
			 WHERE P.countryCode = D.countryCode);
                    

