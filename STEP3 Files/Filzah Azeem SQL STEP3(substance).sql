CREATE TABLE countries(
countryCode CHAR(5),
countryName CHAR(100),
PRIMARY KEY (countryCode)
);

CREATE TABLE substanceAbusePerCountry(
	countryCode CHAR(5),
    Year INTEGER,
    prevalenceAlcoholUseDisorder_Percent DOUBLE,
    prevalenceDrugUseDisorder_Percent DOUBLE,
    FOREIGN KEY (countryCode) REFERENCES countries(countryCode) ON DELETE CASCADE,
    PRIMARY KEY (countryCode, Year)
);

#create views

 CREATE VIEW countries_with_alcohol_higher_than_2 AS
 SELECT countryCode, Year, prevalenceAlcoholUseDisorder_Percent
 FROM substanceabusepercountry
 WHERE prevalenceAlcoholUseDisorder_Percent >= 2;
 
 CREATE VIEW countries_with_drug_higher_than_alcohol AS
 SELECT countryCode, Year, prevalenceAlcoholUseDisorder_Percent, prevalenceDrugUseDisorder_Percent
 FROM substanceabusepercountry
 WHERE prevalenceDrugUseDisorder_Percent >= prevalenceAlcoholUseDisorder_Percent;

#Aggregate Operator (COUNT)
SELECT DISTINCT D.countryCode, COUNT(D.Year)
FROM countries_with_alcohol_higher_than_2 A, countries_with_drug_higher_than_alcohol D
WHERE D.countryCode = A.countryCode
GROUP BY D. countryCode, D.Year
HAVING ( SELECT COUNT(D.Year)
		FROM countries_with_alcohol_higher_than_2 A, countries_with_drug_higher_than_alcohol D
		WHERE A.prevalenceAlcoholUseDisorder_Percent <= D.prevalenceAlcoholUseDisorder_Percent)




