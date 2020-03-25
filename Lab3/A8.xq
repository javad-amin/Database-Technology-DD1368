declare function local:distancecalc($city1, $city2) {
math:sqrt( 
math:pow( (data($city2/latitude) * 111) - (data($city1/latitude) * 111), 2 ) +
math:pow( (data($city2/longitude) * 111 ) - (data($city1/longitude) * 111), 2 ) 
)
};

let $doc := doc("mondial.xml")/mondial

let $cities := (
  for $city in $doc//city
    let $latest-pop := (
      for $pop in $city/population
      order by $pop/data(@year) descending
      return <latest-pop>{data($pop)}</latest-pop>
    )[1]
  where $latest-pop > 5000000
  return $city
)

let $city-pair := (
  for $city1 in $cities, $city2 in $cities
  where $city1 != $city2
  return <pair><city1>{$city1}</city1>
  <city2>{$city2}</city2></pair>
)

let $city-triangle := (
    for $a in $city-pair, $b in $cities
    where $a/city1 != $b and $a/city2 != $b
    let $result := (
      <city1>{$a/city1//data(name[1])}</city1>,
      <city2>{$a/city2//data(name[1])}</city2>,
      <city3>{$b/data(name[1])}</city3> 
    )
    let $total-dis := (local:distancecalc($a/city1//city, $a/city2//city)
      + local:distancecalc($a/city1//city, $b)
      + local:distancecalc($a/city2//city, $b)
    )
    return <city-triangle distance="{$total-dis}">{$result}</city-triangle>
)

let $max-dist := (
  max($city-triangle/@distance)
)

return (
  for $tri in $city-triangle
  where $tri/@distance = $max-dist
  return <root>{$tri}</root>
)