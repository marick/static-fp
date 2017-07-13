module IVFlat.App.Svg exposing
  ( (^^)
  , rect
  )

{- Some helpers for constructing SVG shapes.
-}

import IVFlat.Generic.EuclideanRectangle exposing (Rectangle) 
import Svg exposing (svg, Svg, Attribute)
import Svg.Attributes exposing (..)

{- SVG attributes are strings. But positions and lengths and whatnot
are best represented by numbers so they can easily be added, etc.

This operator is used between an `Svg` function and its numeric argument:

  , y ^^ origin.y
  -- instead of 
  , y <| toString origin.y
-}
(^^) : (String -> Attribute msg) -> number -> Attribute msg
(^^) f n =
  f <| toString n
infixl 0 ^^

{- Convert a Platonic (abstract, Euclidean) rectangle into an SVG rect.

      platonic = Rectangle.fromOrigin 120 200
      svg = rect platonic 
              [ fill "red"
              , stroke "green"
              ]
-}
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

