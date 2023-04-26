CREATE VIEW meatmanagementpercountry AS
    SELECT 
        *
    FROM
        foodmanagementpercountry F
    WHERE
        F.typeOfFood LIKE 'Meat';
        
CREATE VIEW vegetablesmanagementpercountry AS
    SELECT 
        *
    FROM
        foodmanagementpercountry F
    WHERE
        F.typeOfFood LIKE 'Vegetables';
        
        
SELECT 
    M.year,
    M.countryCode,
    M.production_1000_tonnes AS Meat_production_1000_tonnes,
    M.domestic_supply_quantity_1000_tonnes AS Meat_domestic_supply_quantity_1000_tonnes,
    V.production_1000_tonnes AS Veg_production_1000_tonnes,
    V.domestic_supply_quantity_1000_tonnes AS Veg_domestic_supply_quantity_1000_tonnes
FROM
    cs306project.meatmanagementpercountry M
        INNER JOIN
    cs306project.vegetablesmanagementpercountry V ON M.countryCode = V.countryCode
        AND M.year = V.year;