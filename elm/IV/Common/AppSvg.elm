module IV.Common.AppSvg exposing
  ( (^^)
  , rect
  , canvas
  )

import Svg exposing (svg, Svg, Attribute)
import Svg.Attributes exposing (..)
import IV.Common.EuclideanTypes exposing (Rectangle) 

(^^) : (String -> Attribute msg) -> number -> Attribute msg
(^^) f n =
  f <| toString n

rect : Rectangle -> List (Svg.Attribute msg) -> Svg msg    
rect coordinates appearance =
  Svg.rect
      (appearance ++ defaultRect coordinates) []

canvas : Rectangle -> List (Svg msg) -> Svg msg        
canvas rectangle content =
  svg ((version "1.1") :: (defaultRect rectangle)) content


--- Private
defaultRect : Rectangle -> List (Attribute msg)
defaultRect {origin, size} =
  [ x ^^ origin.x
  , y ^^ origin.y
  , width ^^ size.width
  , height ^^ size.height
  ]

