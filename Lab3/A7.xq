let $doc := doc("mondial.xml")/mondial

let $filtered := (
  for $c in $doc//country
    let $latest-report := (
      for $pop in $c/population
      order by $pop/data(@year) descending
      return <latest-pop>{data($pop)}</latest-pop>
    )[1]
    let $earliest-report := (
      for $pop in $c/population
      order by $pop/data(@year) ascending
      return <earliest-pop>{data($pop)}</earliest-pop>
    )[1]
    let $ratio := (
      <ratio>{xs:double(round-half-to-even($latest-report div $earliest-report, 1))}</ratio>
    )
  return <country>{($c/name, $ratio)}</country>
)

return <root>
{
  for $c in $filtered
  where $c/data(ratio) > 10
  order by $c/data(ratio)
  return $c
}
</root>