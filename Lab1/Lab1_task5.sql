WITH 
euOrg AS (
	SELECT organization.name, organization.country, organization.abbreviation
		FROM organization
		INNER JOIN encompasses ON organization.country = encompasses.country
		WHERE encompasses.continent = 'Europe' AND organization.name LIKE '%International%'),
isMemberEU AS (
	SELECT isMember.organization, isMember.country
		FROM isMember
		INNER JOIN encompasses ON isMember.country = encompasses.country
		WHERE encompasses.continent = 'Europe'), 
MemberEUCounts AS (
	SELECT COUNT(isMemberEU.country) AS NrOfMembers ,name AS OrgName
		FROM isMemberEU
		INNER JOIN euOrg ON isMemberEU.organization = euOrg.abbreviation
		GROUP BY OrgName
		ORDER BY COUNT(isMemberEU.country) DESC
)

SELECT OrgName NrOfMembers
	FROM MemberEUCounts
	WHERE NrOfMembers >= ALL(SELECT NrOfMembers FROM MemberEUCounts);
	
/*
euOrg: First we get a list of all organizations which are in europian countries
and has the word international anywhere in their name.
isMemberEU: Here we get a list of organizations and their membership in diffrent
countries and we make sure to choose only europian countries by our where clause.
MemberEUCounts: At this point we count how many europian countries each of the organizations
are with met condition are member of.
Lastly we output only the organization which has the most membership counts in MemberEUCounts.
*/