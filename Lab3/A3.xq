declare variable $lakes-with-islands :=
    for $lake-id in distinct-values(doc('mondial.xml')//island/@lake)
    return doc('mondial.xml')//lake[@id = $lake-id];

let $doc := doc("mondial.xml")/mondial

return <root>{
for $country in $doc/country
let $lakes-in-country :=
    $lakes-with-islands[contains-token(@country, $country/@car_code)]
for $encompassed in $country/encompassed
let $proportional-areas :=
    for $lake in $lakes-in-country
    return $lake/area * $encompassed/@percentage div 100
group by $continent := $encompassed/@continent
return <continent name="{$continent}">{sum($proportional-areas)}</continent>
}</root>