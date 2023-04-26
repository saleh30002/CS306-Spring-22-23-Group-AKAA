-- this select statement finds the year with the minimum value of prevalenceAlcoholUseDisorder_Percent for each countryCode from the table called substanceAbusePerCountry and then finds the numberOfDeaths with cause = Alcohol Use Disorders in the year with the minimum value of prevalenceAlcoholUseDisorder_Percent.
SELECT
    sac.countryCode,
    sac.Year AS YearWithMinPrevalence,
    sac.prevalenceAlcoholUseDisorder_Percent AS MinPrevalence,
    d.numberOfDeaths AS NumberOfDeathsWithMinPrevalence
FROM
    substanceAbusePerCountry sac
JOIN
    Deaths d ON sac.countryCode = d.countryCode AND sac.Year = d.Year
WHERE
    sac.prevalenceAlcoholUseDisorder_Percent = (
        SELECT
            MIN(prevalenceAlcoholUseDisorder_Percent)
        FROM
            substanceAbusePerCountry
        WHERE
            countryCode = sac.countryCode
    )
    AND d.cause = 'Alcohol Use Disorders'
GROUP BY
    sac.countryCode,
    sac.Year,
    sac.prevalenceAlcoholUseDisorder_Percent
HAVING sac.prevalenceAlcoholUseDisorder_Percent <= 1;

-- view that would calculate the average of DALY from 1990 to 2015 and sort them in descending order of country
CREATE VIEW avgDalyPerCountrySorted AS
SELECT c.countryName, AVG(DALY) AS avgDaly
FROM mentalIllnessPerCountry m, countries c
WHERE c.countryCode = m.countryCode
GROUP BY m.countryCode
ORDER BY avgDaly DESC;