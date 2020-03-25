let $doc := doc("mondial.xml")/mondial

let $inter-orgs := (
  for $o in $doc/organization
  let $name := xs:string($o/data(name))
  where contains($name,xs:string("International"))
  return $o
)

let $inter-orgs-eu := (
  for $o in $inter-orgs
  let $hq := $o/data(@headq)
  let $city := $doc/country/id($hq)
  let $cCode := $city/data(@country)
  let $country := $doc/country[data(@car_code)=$cCode]
  where $country/encompassed/data(@continent) = 'europe'
  return $o
)

let $memberCounts := (
  for $o in $inter-orgs-eu
  let $memCountries := $doc/country[contains(data(@memberships), $o/data(@id))]
  let $euMemCountries :=(
    for $m in $memCountries
    where $m/encompassed/data(@continent) = 'europe'
    return $m
  )
  return <org name="{$o/data(@id)}">{count($euMemCountries)}</org>
)

let $memberCountsOrdered :=(
  for $m in $memberCounts
  order by xs:integer(data($m)) descending
  return $m
)

return <root>
  {$memberCountsOrdered[1]}
</root>