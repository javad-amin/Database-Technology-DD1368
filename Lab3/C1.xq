declare function local:union-borders($allcountries, $country) {
  for $cid in distinct-values(for $c in $country
      return data($country/border/@country))
    return $allcountries[@car_code=$cid]
};

declare function local:recursive-borders($allcountries, $countrylist, $crossing, $crossedcountry) {
  ( let $unionborders := local:union-borders($allcountries except $countrylist, $countrylist)
  return if (not(empty($unionborders)))then
    <borders crossing="{$crossing}"> {for $c in $unionborders return $c/name} </borders>
  else () ),
  let $unionborders := local:union-borders($allcountries except $countrylist, $countrylist)
  return  if (count($countrylist) > 0) then
    local:recursive-borders($allcountries except $countrylist,
    $unionborders except $crossedcountry,
    $crossing + 1,
    $crossedcountry union $unionborders)
    else
      () (: DONE :)
};

let $allcountries := doc("mondial.xml")/mondial/country

return <root>
  {let $sweden := ($allcountries[name="Sweden"])
  return local:recursive-borders(for $c in $allcountries where $c != $sweden return $c,
  $sweden,
  1,
  $sweden)}
</root> 