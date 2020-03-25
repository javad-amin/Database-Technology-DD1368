WITH LakesWithIslands AS (
	SELECT DISTINCT IslandIn.lake, Lake.area, geo_lake.country
	FROM ((IslandIn
	INNER JOIN Lake ON IslandIn.lake = Lake.name)
	INNER JOIN geo_lake ON IslandIn.lake = geo_lake.lake)
	WHERE IslandIn.lake IS NOT NULL
	) 

SELECT B.continent, SUM(B.percentage * A.area / 100)
	FROM LakesWithIslands as A
	INNER JOIN encompasses as B ON A.country = B.country
	GROUP BY B.continent;

/*
Firstly a list of lakes which contains islands in them is needed which can be
extracted from IslandIn relation. We also need the information about the lake
area and it's location. The area is stored in the Lake relation and the whereabout
is stored in geo_lake as countries.
In our common table expression LakesWithIslands we sort of merge the mentioned 
three relations and from there we select the lake, lake area and country where
the lake exists in the IslandIn relation. Meaning the lake contains an island.

In the second part we calculate the total area from our LakesWithIslands with 
consideration of the continent which the lake is located on. Of course the calculation
would be an estimate since we are using encompasses relation which gives the percentage
of which each country is located in the continents. 
From there we merge the encompasses with LakesWithIslands to be able to use the percentage
mentioned above in our calculation we lastly group our list by the continent and make the 
calculation by the aggregate functions "SUM" for each continent. 
*/


/*SELECT *
FROM LakesWithIslands as A
INNER JOIN encompasses as B ON A.country = B.country*/

/*select distinct lake from LakesWithIslands;*/