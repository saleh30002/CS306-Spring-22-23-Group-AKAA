SELECT * FROM `cs306-project`.airpollution;

ALTER TABLE airpollution CHANGE totalPollution `Total including LUCF in tonnes` DOUBLE;
ALTER TABLE airpollution CHANGE meanAnnualExposure `PM2.5, mean annual exposure (μg/m³)` DOUBLE;
ALTER TABLE airpollution CHANGE levelsExceedingWHO `PM2.5, pop. exposed to levels > WHO guideline value (% TOT)` DOUBLE;
