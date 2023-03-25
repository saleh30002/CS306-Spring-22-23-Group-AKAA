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
    FOREIGN KEY (countryCode) REFERENCES countries(countryCode),
    PRIMARY KEY (countryCode, Year)
);