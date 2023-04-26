# years with the countries that were above average production of meat in them
(SELECT 
    M.year, M.countryCode
FROM
    cs306project.meatmanagementpercountry M
        JOIN
    (SELECT 
        AVG(production_1000_tonnes) AS Avgprod, year
    FROM
        cs306project.meatmanagementpercountry M
    GROUP BY year) b ON M.year = b.year
WHERE
    M.production_1000_tonnes > b.Avgprod)
    
EXCEPT

# years with the countries that were above average production of vegetables in them
(SELECT 
    V.year, V.countryCode
FROM
    cs306project.vegetablesmanagementpercountry V
        JOIN
    (SELECT 
        AVG(production_1000_tonnes) AS Avgprod, year
    FROM
        cs306project.vegetablesmanagementpercountry V
    GROUP BY year) b ON V.year = b.year
WHERE
    V.production_1000_tonnes > b.Avgprod);
    
    
SELECT A.year, A.countryCode
FROM 
(SELECT 
    M.year, M.countryCode
FROM
    cs306project.meatmanagementpercountry M
        JOIN
    (SELECT 
        AVG(production_1000_tonnes) AS Avgprod, year
    FROM
        cs306project.meatmanagementpercountry M
    GROUP BY year) b ON M.year = b.year
WHERE
    M.production_1000_tonnes > b.Avgprod) A
LEFT JOIN 
(SELECT 
    V.year, V.countryCode
FROM
    cs306project.vegetablesmanagementpercountry V
        JOIN
    (SELECT 
        AVG(production_1000_tonnes) AS Avgprod, year
    FROM
        cs306project.vegetablesmanagementpercountry V
    GROUP BY year) b ON V.year = b.year
WHERE
    V.production_1000_tonnes > b.Avgprod) B
    
ON A.year = B.year AND A.countryCode = B.countryCode 
WHERE B.countryCode IS NULL;
    
    
    
    