SELECT DISTINCT airport.city, airport.name AS AirportName
	FROM ((airport
		INNER JOIN encompasses ON airport.country = encompasses.country)
		INNER JOIN city ON airport.city = city.name) 
		WHERE encompasses.continent LIKE 'America' 
		AND city.population > 100000 
		AND airport.elevation > 500; 
		
/*
easy peasy lemon squeezy
*/