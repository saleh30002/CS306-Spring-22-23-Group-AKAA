CREATE TABLE countries (
    countryName CHAR(100),
    countryCode CHAR(5),
    PRIMARY KEY (countryCode)
);


CREATE TABLE foodManagementPerCountry (
    countryCode CHAR(5),
    typeOfFood CHAR(150),
    year INT,
    domestic_supply_quantity_1000_tonnes DOUBLE,
    production_1000_tonnes DOUBLE,
    FOREIGN KEY (countryCode)
        REFERENCES countries (countryCode)
        ON DELETE CASCADE,
    PRIMARY KEY (countryCode, typeOfFood, year)
);