SELECT 
    M.year, M.countryCode
FROM
    meatmanagementpercountry M
WHERE
    M.year = 2000
        AND M.production_1000_tonnes IN (SELECT 
            M2.production_1000_tonnes
        FROM
            meatmanagementpercountry M2
        WHERE
            M2.year = 2000
                AND M.production_1000_tonnes > (SELECT 
                    AVG(M2.production_1000_tonnes)
                FROM
                    meatmanagementpercountry M2
                WHERE
                    M2.year = 2000));

SELECT 
    M.year, M.countryCode
FROM
    meatmanagementpercountry M
WHERE
    EXISTS( SELECT 
            M2.production_1000_tonnes
        FROM
            meatmanagementpercountry M2
        WHERE
            M2.year = 2000 AND M.year = 2000
                AND M.production_1000_tonnes = M2.production_1000_tonnes
                AND M.production_1000_tonnes > (SELECT 
                    AVG(M3.production_1000_tonnes)
                FROM
                    meatmanagementpercountry M3
                WHERE
                    M3.year = 2000));