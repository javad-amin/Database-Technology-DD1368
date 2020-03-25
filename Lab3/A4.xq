let $doc := doc("mondial.xml")/mondial

let $countries :=(
  for $c in $doc/country
  let $pop := (
    for $p in $c/population
    order by $p/data(@year) descending
    return data($p)
  )[1]
  let $pop-growth :=(
    if(exists(data($c/population_growth))) 
    then data($c/population_growth)
    else 0.0
  ) 
  
  for $e in $c/encompassed
  let $percent := $e/data(@percentage)
  let $continent := $e/data(@continent)
  return <country name="{$c/data(name)}" continent="{$continent}" pop-growth="{$pop-growth}" pop="{xs:integer($pop*($percent div 100))}"></country>
)

let $pop-change := (
  for $c in $countries
  let $continent := $c/data(@continent)
  let $pop := xs:integer($c/data(@pop))
  let $pop-growth := xs:float($c/data(@pop-growth))
  let $pop-in-50y := xs:integer($pop * math:pow(1.0 + ($pop-growth div 100), 50))
  group by $continent
  return <pop-change 
  continent="{$continent}" 
  curr-pop="{sum($pop)}"
  pop-in-50y="{sum($pop-in-50y)}"
  change-ratio="{sum($pop-in-50y) div sum($pop)}"
  pop-inc="{sum($pop-in-50y) - sum($pop)}"
  ></pop-change>
)

let $pop-change-final :=(
  for $p in $pop-change
  order by xs:integer($p/data(@pop-inc)) descending
  return <continent name="{$p/data(@continent)}">{$p/data(@pop-in-50y) div $p/data(@curr-pop)}</continent>
)

return <root>
  {$pop-change-final[1]}
  {$pop-change-final[last()]}
</root>
