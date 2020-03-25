WITH 
MaxMinYear AS (
	SELECT country, MAX(year) AS LatestYear, MIN(year) AS EarliestYear
		FROM countrypops 
		GROUP BY country ),
LatestPop AS (
	SELECT MaxMinYear.country, population 
		FROM MaxMinYear 
		INNER JOIN Countrypops ON MaxMinYear.country = countrypops.country
		WHERE countrypops.year = MaxMinYear.LatestYear),
EarliestPop AS (
	SELECT MaxMinYear.country, population 
		FROM MaxMinYear 
		INNER JOIN Countrypops ON MaxMinYear.country = countrypops.country
		WHERE countrypops.year = MaxMinYear.EarliestYear ),
LatEarRatio AS (
	SELECT LatestPop.country, ROUND((LatestPop.population/EarliestPop.population) ::numeric,1) AS ratio 
		FROM LatestPop
		INNER JOIN EarliestPop ON LatestPop.country = EarliestPop.country)
		
SELECT * 
	FROM LatEarRatio
	WHERE ratio > 10;
	
/*
MaxMinYear: Filtering out the years in between the eailiest and latest population report.
LatestPop: A list of all countries and their population in the latest year which the population where recorded.
EarliestPop: A list of all countries and their population in the earliest year which the population where recorded.
LatEarRatio: Calculation of the ratio between the population of the latest and earliest record which is rounded to
one decimal point.
Lastly it is filtered to provide only the countries which has the ratio more than 10 in the very last where clause.
*/