CREATE TABLE countries (
    countryName CHAR(100),
    countryCode CHAR(5),
    PRIMARY KEY (countryCode)
);

CREATE TABLE mentalIllnessPerCountry(
	countryCode CHAR(5),
    Year INT,
    DALY DOUBLE,
    prevalenceEating DOUBLE,
    prevalenceDepressive DOUBLE,
    FOREIGN KEY (countryCode)
    REFERENCES countries(countryCode),
    PRIMARY KEY (countryCode, Year)
);
