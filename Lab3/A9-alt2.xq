declare function local:riverandtheirfeeds($allrivers, $rivers) {
  if(count($allrivers) < 2) then
     for $river in $rivers
       return 
       <river>
       {($river/@id, $river/name)}
       <length>
         {data($river/length) + 
         sum(for $r in $allrivers where data($r/to/@water)=data($river/@id) return data($r/length))}
       </length>
     </river>
  else
     local:riverandtheirfeeds(fn:subsequence($allrivers, 2),
       local:riverandtheirfeeds(fn:subsequence($allrivers, 1, 1), $rivers))
};

let $allrivers := doc("mondial.xml")/mondial/river

return
<root>
{local:riverandtheirfeeds($allrivers, 
    for $river in $allrivers
    where $river/name = "Nile"
    or $river/name = "Rhein"
    or $river/name = "Amazonas" return $river)}
</root>
  