module IVFinal.View.AppSvg exposing
  ( (^^)
  , rect
  )

import Svg exposing (svg, Svg, Attribute)
import Svg.Attributes exposing (..)
import IVFinal.Generic.EuclideanTypes exposing (Rectangle) 

(^^) : (String -> Attribute msg) -> number -> Attribute msg
(^^) f n =
  f <| toString n

rect : Rectangle -> List (Svg.Attribute msg) -> Svg msg    
rect coordinates appearance =
  Svg.rect
      (appearance ++ defaultRect coordinates) []

--- Private
defaultRect : Rectangle -> List (Attribute msg)
defaultRect {origin, size} =
  [ x ^^ origin.x
  , y ^^ origin.y
  , width ^^ size.width
  , height ^^ size.height
  ]

