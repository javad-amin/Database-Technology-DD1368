let $doc := doc("mondial.xml")/mondial
let $islands := distinct-values($doc/island/@country/tokenize(.)) (: Country code for countries with islands :)
return <root>{
for $country in $doc/country
let $c_code := $country/data(@car_code)
let $c_name := $country/name
where not($c_code=$islands)
order by $c_name
return $c_name
}</root>