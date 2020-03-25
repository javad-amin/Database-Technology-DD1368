let $doc := doc("mondial.xml")/mondial

let $res :=(
  for $a in $doc/airport
  let $aElev := xs:integer($a/data(elevation))
  let $cityid := $a/data(@city)
  let $countryid := $a/data(@country)
  let $country := $doc/country[data(@car_code) = $countryid]
  let $city :=(
    if(exists($country/province))
    then $country/province/city[data(@id) = $cityid]
    else $country/city[data(@id) = $cityid]
  )
  let $cityPop := xs:integer((
    for $p in $city/population
    order by $p/data(@year) descending
    return data($p)
  )[1]) 
  where (exists($city)) and ($aElev > 500) and ($country/encompassed/data(@continent) = 'america') and ($cityPop >= 100000)
  return <airport country="{$country/data(@car_code)}" city="{$city/data(@id)}">{$a/	data(name)}</airport>
)

return <root>
  {$res}
</root>