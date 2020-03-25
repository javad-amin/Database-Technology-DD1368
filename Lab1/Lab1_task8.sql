WITH
DistanceCalc AS (
	SELECT A.name AS FirstCity, B.name AS SecondCity,
		MAX( SQRT( ( (A.latitude * 111) - (B.latitude * 111) )^2 + 
		( (A.longitude * 111 * COS(RADIANS(A.latitude))) - (B.longitude * 111 * COS(RADIANS(B.latitude))) )^2 )) AS distance
			FROM city AS A
			INNER JOIN city AS B ON A.name != B.name
			WHERE A.population > 5000000 AND B.population > 5000000 
			GROUP BY A.name, B.name ),
CityTriangle AS (
	SELECT DISTINCT 
		A.FirstCity AS Name1, B.FirstCity AS Name2, C.FirstCity AS Name3, 
		SUM(A.distance + B.distance + C.distance) AS TotDist
			FROM DistanceCalc AS A, DistanceCalc AS B, DistanceCalc AS C 
			WHERE A.FirstCity = B.SecondCity AND B.FirstCity = C.SecondCity AND C.FirstCity = A.SecondCity 
			GROUP BY A.FirstCity, B.FirstCity, C.FirstCity ),
MaxTotal AS (
	SELECT MAX(TotDist) AS MaxTot 
		FROM CityTriangle )
		
SELECT A.Name1, A.Name2, A.Name3, A.TotDist  
	FROM CityTriangle AS A 
	INNER JOIN MaxTotal AS B ON A.TotDist = B.MaxTot;

/* 
(a) Distance between two points-> $ sqrt{(x_2 - x_1)^2 + (y_2 - y_1)^2} $ 

The approximate conversions from deg to km: 
(b) Latitude: 1 deg = 111 km
(c) Longitude: 1 deg = 111 * cos(latitude) km
https://stackoverflow.com/questions/1253499/simple-calculations-for-working-with-lat-lon-km-distance

DistanceCalc: We join the relation city with itself where the city name is not the same in order to get two diffrent cities.
We make sure both cities have above 500000 inhabitants in our where clause and then group by the name of the cities. 
In our calculation we use MAX because GROUP BY clause requires one of the aggregate functions (COUNT, MAX, MIN, SUM, AVG) to
work. We use the distance formula between two points on a plane (a) and convert the latitude and longitude from degrees to
kilometer using (b) and (c) (Gives us an estimate).

CityTriangle: We make a triangle of the cities in our where clause, where vertices of the triangle is made from three
cities from the three DistanceCalc tables which we take as A,B and C. In our where clause we make sure the we always get three
diffrent cities and then calculate the sum of distances between them as TotDist.

MaxTotal: Simply ouputs the maximum of total distance in out city triangle.

At last we find the maximum and output the result of the cities involved and the total distance.
*/
			
/* fialed attempts:
	MAX( SQRT( ((A.latitude-B.latitude) * 111 )^2 + 
	((A.longitude * 111 * COS(RADIANS(A.latitude))) - (B.longitude * 111 * COS(RADIANS(B.latitude))))^2 ) ) AS distance
	
	MAX( SQRT( 6371*(A.latitude-B.latitude)^2 + 
	6371*( LN( ABS( TAN( (3.14159265359/4) + (RADIANS(A.longitude)/2) ))) 
	- LN( ABS( TAN( (3.14159265359/4) + (RADIANS(B.longitude)/2) ))) )^2 ) ) AS distance*/