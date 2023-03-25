CREATE TABLE Countries (
    countryName CHAR(255),
    countryCode CHAR(5),
    PRIMARY KEY (countryCode)
);

CREATE TABLE Deaths (
    countryCode CHAR(5),
    Year INT,
    cause CHAR(255),
    numberOfDeaths INT,
    FOREIGN KEY (countryCode)
        REFERENCES countries (countryCode), 
	Primary Key (countryCode, Year, cause)
);

SET FOREIGN_KEY_CHECKS=0;