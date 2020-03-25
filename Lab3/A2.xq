let $doc := doc("mondial.xml")/mondial
let $provinces := distinct-values($doc/country/province/data(@id))
let $provincesCount := count($provinces)
let $outProv := distinct-values($doc/sea/located/@province/tokenize(.))
let $inProv := distinct-values($provinces[not(.=$outProv)])
let $inProvCount := count($inProv)
return <root>{
<output>{$inProvCount div $provincesCount}</output>
}</root>