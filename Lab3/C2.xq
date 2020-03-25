declare function local:union-borders($allcountries, $country) {
  for $cid in distinct-values(for $c in $country
      return data($country/border/@country)) (: Immediate border :)
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

declare function local:longestpath($allcountries, $startc) {
  <starting>{$startc/name}
  {local:recursive-borders(for $c in $allcountries where $c != $startc return $c,
  $startc,
  1,
  $startc)[last()]}</starting>
};

let $allcountries := doc("mondial.xml")/mondial/country


let $allcrossing := (for $c in $allcountries
  return local:longestpath($allcountries, $c))
    
return <root>
  {for $r in $allcrossing
  where $r/borders/data(@crossing) = max($allcrossing/borders/data(@crossing))
  return $r}
</root> 