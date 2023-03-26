USE `cs306-project`;

CREATE TABLE Countries(
	countryName CHAR(100),
    countryCode CHAR(5),
    PRIMARY KEY (countryCode)
);



CREATE TABLE AirPollution (
	countryCode CHAR(5),
    Year INT,
    totalPollution DOUBLE,
    meanAnnualExposure DOUBLE,
    levelsExceedingWHO DOUBLE,
    PRIMARY KEY (countryCode, Year),
    FOREIGN KEY (countryCode) REFERENCES Countries(countryCode) ON DELETE CASCADE
    );
  
    
