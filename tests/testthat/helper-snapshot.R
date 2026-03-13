transform_polish <- function(x) {
  x <- gsub('r:embed=".*"', 'r:embed="[...]"', x)
  x <- gsub('a:blip cstate="print"', 'a:blip', x)
  x <- gsub('w:stlname', 'w:psltname', x)
  x <- gsub('p:cNvPr id=".*"', 'p:cNvPr id="[...]"', x)
  x <- gsub('r:id=".*"', 'r:id="[...]"', x)
  x <- gsub('a:ext cx="[0-9]+" cy="[0-9]+"', 'a:ext cx="[...]" cy="[...]"', x)
  x <- gsub('a:off x="[0-9]+" y="[0-9]+"', 'a:off x="[...]" y="[...]"', x)
  x <- gsub('a:tr h="[0-9]+"', 'a:tr h="[...]"', x)
  x <- gsub('a:cs typeface=".*"', 'a:cs typeface="[...]"', x)
  x <- gsub('a:ea typeface=".*"', 'a:ea typeface="[...]"', x)
  x <- gsub('a:sym typeface=".*"', 'a:sym typeface="[...]"', x)
  x <- gsub('a:latin typeface=".*"', 'a:latin typeface="[...]"', x)
  x <- gsub('a:gridCol w=".*"', 'a:gridCol w="[...]"', x)

  x
}
