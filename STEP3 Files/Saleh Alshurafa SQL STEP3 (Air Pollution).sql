SELECT COUNT(*) FROM `cs306-project`.airpollution;
#DISCOVERING INSIGHTS FOR AIR POLLUTION


# a - Creating Views:
#View (1)
CREATE VIEW population_exposed AS
SELECT countryCode, Year, `PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`
FROM `cs306-project`.airpollution
WHERE `PM2.5, pop. exposed to levels > WHO guideline value (% TOT)` >= 50;

#View (2)
CREATE VIEW pollution_production AS
SELECT countryCode, Year, `Total including LUCF in tonnes`
FROM `cs306-project`.airpollution
WHERE `Total including LUCF in tonnes` >= 50000000;

# Having a look at the Views created
SELECT COUNT(*) FROM population_exposed;
SELECT COUNT(*) FROM pollution_production;
SELECT * FROM population_exposed;
SELECT * FROM pollution_production;

#b - Join and Set Operators 
# Using Set Operators: NOT IN (because MySQL has no EXCEPT)
SELECT E.countryCode, E.`PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`, E.Year
FROM population_exposed E
WHERE E.countryCode NOT IN (
	SELECT 	E.countryCode
	FROM population_exposed E, pollution_production P
	WHERE E.countryCode = P.countryCode);

# Using Joins Operators: LEFT OUTER JOIN
SELECT E.countryCode, E.`PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`, E.Year
FROM population_exposed E LEFT OUTER JOIN pollution_production P
ON E.countryCode = P.countryCode
WHERE P.countryCode IS NULL;

#c - IN and EXISTS
#IN
SELECT E.countryCode, E.`PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`, E.Year
FROM population_exposed E
WHERE E.countryCode IN (
							SELECT P.countryCode
                            FROM pollution_production P
                            WHERE E.countryCode = P.countryCode);

# EXISTS
SELECT E.countryCode,  E.`PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`, E.Year
FROM population_exposed E
WHERE EXISTS (
				SELECT P.countryCode
				FROM pollution_production P
				WHERE E.countryCode = P.countryCode);
                

#d- Aggregate Operators
#AVG Operator:
SELECT P.countryCode,
	AVG(P.`Total including LUCF in tonnes`) AS `Average Pollution Production Over 1990-2017`,
	AVG(E.`PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`) AS `Average Percentage of Population In Danger over 1990-2017`
FROM pollution_production P, population_exposed E
WHERE P.countryCode = E.countryCode #without this I get wrong results for the 3rd column
GROUP BY P.countryCode
HAVING 90 < (SELECT AVG(E.`PM2.5, pop. exposed to levels > WHO guideline value (% TOT)`)
			 FROM population_exposed E
			 WHERE E.countryCode = P.countryCode);
                    

