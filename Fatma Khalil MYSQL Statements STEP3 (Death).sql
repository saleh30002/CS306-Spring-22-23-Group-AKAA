CREATE TABLE TotalCountryDeaths AS
    SELECT 
        countryCode, SUM(numberOfDeaths) AS totalDeaths
    FROM
        deaths
    GROUP BY countryCode;
    
CREATE VIEW DeathByAlcoholDisorders AS
    SELECT 
        countryCode, cause,
        SUM(numberOfDeaths) AS totalDeaths
    FROM
        deaths
    WHERE
        cause = 'Alcohol Use Disorders'
    GROUP BY countryCode;
    
CREATE VIEW DeathByDrugs AS
    SELECT 
        countryCode, cause, SUM(numberOfDeaths) AS totalDeaths
    FROM
        deaths
    WHERE
        cause = 'Drug Use Disorders'
    GROUP BY countryCode;
    
SELECT D.countryCode, D.Year, D.cause, D.numberOfDeaths FROM deaths D, deathbyalcoholdisorders A where D.cause != A.cause 
INTERSECT
SELECT D.countryCode, D.Year, D.cause, D.numberOfDeaths FROM deaths D, deathbydrugs S where D.cause = S.cause;

SELECT DISTINCT
    D.countryCode, D.Year, D.cause, D.numberOfDeaths
FROM
    deaths D
        INNER JOIN
    deathbydrugs S ON D.cause = S.cause;

SELECT 
    *
FROM
    deaths D
WHERE
    cause IN (SELECT 
            cause
        FROM
            deathbyalcoholdisorders A
        WHERE
            D.cause = A.cause);

SELECT 
    *
FROM
    deaths D
WHERE
    EXISTS( SELECT 
            *
        FROM
            deathbyalcoholdisorders A
        WHERE
            D.cause = A.cause);

CREATE VIEW DeathBySubstances AS
    SELECT 
        D.cause,
        SUM(S.totalDeaths + A.totalDeaths) AS DeathBySubstances
    FROM
        deaths D,
        DeathByAlcoholDisorders A,
        DeathByDrugs S
            INNER JOIN
        DeathByAlcoholDisorders Alcohol ON Alcohol.countryCode = S.countryCode
    GROUP BY D.cause
    HAVING deathbysubstances > 0;

select min(totalDeaths) from totalcountrydeaths;
select max(totalDeaths) from totalcountrydeaths;

#SHOW FULL PROCESSLIST;

ALter table totalcountrydeaths ADD constraint totalDeaths check( totalDeaths >= 299 AND totalDeaths <= 252783134);
insert into totalcountrydeaths(countryCode, totalDeaths) values('CCK', 252783135);

delimiter \ 
create trigger beforeUpdate before update on totalcountrydeaths
for each row 
begin
 if NEW.totalDeaths < 299 then set New.totalDeaths = 299;
 elseif NEW.totalDeaths > 252783134 then set New.totalDeaths = 252783134; end if; end \ 
 delimiter ;
 
 delimiter \ 
create trigger beforeInsert before insert on totalcountrydeaths
for each row 
begin
 if NEW.totalDeaths < 299 then set New.totalDeaths = 299;
 elseif NEW.totalDeaths > 252783134 then set New.totalDeaths = 252783134; end if; end \ 
 delimiter ;
 
insert into totalcountrydeaths(countryCode, totalDeaths) values('CCK', 252783135);

delimiter \
CREATE PROCEDURE showCountryDeaths(in ISOCode char(5), Out countryDeaths int)  
BEGIN  
    SELECT totalDeaths INTO countryDeaths FROM totalcountrydeaths WHERE countryCode = ISOCode;   
END \  
delimiter ;

call showCountryDeaths('AFG', @countryDeaths);
select @countryDeaths;

call showCountryDeaths('USA', @countryDeaths);
select @countryDeaths;