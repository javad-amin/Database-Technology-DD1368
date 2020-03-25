SELECT name 
	FROM Country 
	WHERE code 
	NOT IN (SELECT country FROM geo_island);

/* 
First we are selecting all countries codes which has an island from the list geo_island 
and then we look in the list of countries for all country codes which are not present in
the selection of coutries with islands. The result will be all countries that do not have
any islands. 
*/


/* Alternative solutions */

/*
SELECT name 
	FROM country
	LEFT JOIN geo_island ON geo_island.country = country.code
	WHERE island IS NULL;
*/

/*
SELECT name 
	FROM country
	WHERE name NOT IN
	(SELECT country.name FROM country
	INNER JOIN geo_island ON geo_island.country = country.code);
*/
