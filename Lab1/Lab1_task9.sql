WITH RiversAndTheirFeed AS (
	WITH RECURSIVE result AS(
		SELECT name, length AS l, river
			FROM River
			WHERE river IS NULL
		UNION ALL
		SELECT r.name, l + r.length AS l, r.river
			FROM River r 
			INNER JOIN result AS res ON res.name = r.river) 
	SELECT river as LongestFeed, max(l) AS length
		FROM result
		GROUP BY river)

SELECT *
	FROM RiversAndTheirFeed
	WHERE LongestFeed = 'Nile' OR LongestFeed = 'Rhein' OR LongestFeed = 'Amazonas';

/*
RiversAndTheirFeed: Firtsly in our recursion we find all rivers and their respective 
length where the river is the main river and is not a feed to another river using the
where clause which makes sure the river is not a part of another river "WHERE river IS NULL".

Afterwards in our recursion we add the length of each river which is a part of the main river
to the length and constract the total length of the river feed.

Again as we group our result by the river we have to have some sort of aggregate function and
MAX does the trick.

At the last where clause we give the results for the required river feeds only.
*/