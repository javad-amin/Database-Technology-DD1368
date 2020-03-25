WITH population_change AS (
	SELECT  encompasses.continent,
			SUM(country.population) AS current_population,
			SUM(country.population * ( (1.0 + population.population_growth / 100)^50 )) AS population_in_50_Years,
			SUM(country.population * ( (1.0 + population.population_growth / 100)^50 )) / SUM(country.population) AS change_ratio,
			SUM(country.population * ( (1.0 + population.population_growth / 100)^50 )) - SUM(country.population) AS population_increase
		FROM ((country
		INNER JOIN encompasses ON country.code = encompasses.country)
		INNER JOIN population ON country.code = population.country)
		GROUP BY encompasses.continent
)
	
SELECT continent, current_population, population_in_50_Years, change_ratio, population_increase, 
	population_increase / current_population * 100 AS growth_rate
	FROM population_change
	WHERE change_ratio >= ALL( SELECT change_ratio FROM population_change) 
	OR change_ratio <= ALL( SELECT change_ratio FROM population_change); 

/* 
(a) Population Projections calculation -> population * (1 + (population_growth / 100)^years) 
(b) Growth Rate in percentage -> ( (present-past) / past ) * 100

As our population is recorded by country in the database and the population growth is 
in the poplulation relation by country as a foreign key in order to use the poplulation
projection (a) in future by continent we first join the three mentioned relations and group
them by the continents. We make our calculation by country before it's grouped by continent.
The resulting table would contain each continent and the current population, population in 
50 years from now, the change ratio y dividing the current population with future population
and lastly the amount of increase in population.

In the second part we use the growth rate in percentage formula (b) using the results of
our population_change calculations finding out the growth rate for each continent. Lastly we
make sure to output only the continents with maximum and minimum change in population ratio in
our very last WHERE clause.
*/
