SELECT 1.00 * 
	(SELECT COUNT(*)
		FROM Province 
		WHERE name 
		NOT IN (SELECT province FROM geo_sea))
	/ 
	(SELECT COUNT(*) FROM Province) 
	AS inland_total_ratio;
	
/*
(a) SELECT COUNT(*) FROM Province -> The number of provinces.
(b) SELECT province FROM geo_sea  -> Provinces which are bordered by sea.
We start from the inside out the first selection is selecting all the provinces which
are borders by sea in (b) and then from the Province relation or table we select the 
count of all names which are not in (b) (Not bordering any sea). 
We devide then our result by (a) to get the ratio.
1.00 is there to convert the integer type of count to be able to calculate the division.
*/