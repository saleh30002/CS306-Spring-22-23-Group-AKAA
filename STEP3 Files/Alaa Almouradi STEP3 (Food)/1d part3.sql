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
        AND M.year = V.year
WHERE
    M.production_1000_tonnes IN (SELECT 
            MAX(M2.production_1000_tonnes)
        FROM
            cs306project.meatmanagementpercountry M2
                INNER JOIN
            cs306project.vegetablesmanagementpercountry V2 ON M2.countryCode = V2.countryCode
                AND M2.year = V2.year
        WHERE
            M2.countryCode NOT LIKE 'CHN'
        GROUP BY M2.year
        HAVING (SUM(M2.production_1000_tonnes) - SUM(M2.domestic_supply_quantity_1000_tonnes)) > (SUM(V2.production_1000_tonnes) - SUM(V2.domestic_supply_quantity_1000_tonnes)))