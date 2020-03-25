let $doc := doc("songs.xml")/music
let $songs := $doc/song
let $artists := $doc/artist
let $albums := $doc/album

let $inverse-songs :=(
  for $s in $songs
  let $name := $s/data(name)
  let $nr := $s/data(nr)
  let $genre := $s/data(@genre)
  let $album := $s/data(@album)
  let $artist := $s/data(@artist)
  let $id := $s/data(@id)
  return <song name="{$name}" nr="{$nr}"><genre>{$genre}</genre><album>{$album}</album><artist>{$artist}</artist><id>{$id}</id></song>
)

let $inverse-artists := (
  for $a in $artists
  let $value := data($a)
  let $id := $a/data(@id)
  let $isband := $a/data(@isband)
  return <artist value="{$value}"><id>{$id}</id><isband>{$isband}</isband></artist>  
)

let $inverse-albums := (
  for $a in $albums
  let $value := data($a)
  let $issued := $a/data(@issued)
  let $id := $a/data(@id)
  let $label := $a/data(@label)
  let $performers := $a/data(@performers)
  return if(exists($performers))
  then <album value="{$value}"><issued>{$issued}</issued><id>{$id}</id><label>{$label}</label><performers>{$performers}</performers></album>
  else <album value="{$value}"><issued>{$issued}</issued><id>{$id}</id><label>{$label}</label></album>
 
)

return <music>{$inverse-songs}{$inverse-artists}{$inverse-albums}</music>