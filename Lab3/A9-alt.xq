declare function local:riverandfeeds($rivers, $myriver, $length) {
  if (count($rivers)=0)then
  <river>{$myriver/name} 
  <length>{$length}</length>
  </river>
  else if (subsequence($rivers, 1, 1) = $myriver or
           data(subsequence($rivers, 1, 1)/to/@water) = data($myriver/@id) )then
    local:riverandfeeds(subsequence($rivers, 2), $myriver, $length + data(subsequence($rivers, 1, 1)/length))
  else 
    local:riverandfeeds(subsequence($rivers, 2), $myriver, $length)
};

let $rivers := doc("mondial.xml")/mondial/river

return
  <result>
  {local:riverandfeeds($rivers, 
      $rivers[name="Nile"], 0)}
  {local:riverandfeeds($rivers, 
      $rivers[name="Rhein"], 0)}
  {local:riverandfeeds($rivers, 
      $rivers[name="Amazonas"], 0)}         
  </result>
