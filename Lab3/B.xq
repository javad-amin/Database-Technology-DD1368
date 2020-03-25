let $doc := doc("mondial.xml")/mondial

let $inter-orgs := (
  for $o in $doc/organization
  let $name := xs:string($o/data(name))
  where starts-with($name,xs:string("International"))
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

let $countries := (
  for $c in $doc/country
  let $memShipsSet := $c/tokenize(data(@memberships), '\s')
  let $orgSet := $inter-orgs-eu/data(@id)
  let $orgsNotInMemSet := distinct-values($orgSet[not(.=$memShipsSet)])
  where empty($orgsNotInMemSet)
  return <country code="{$c/data(@car_code)}">{$c/data(name)}</country>
)

return <root>
 {$countries}
</root>

(: return empty(distinct-values($inter-orgs-eu/data(@id)[not(.= ('org-ITUC','org-ITU','org-OIF','org-ISO','org-IOM','org-IOC','org-IMSO','org-IMO','org-ILO','org-IFAD','org-IFRCS','org-IEA','org-Interpol','org-ICCt','org-ICJ','org-ICC','org-IAEA','org-BIS','org-Anor','org-SHI') )])) :)