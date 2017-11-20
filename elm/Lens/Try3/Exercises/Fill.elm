module Lens.Try3.Exercises.Fill exposing (..)

import Color exposing (Color)
import Lens.Try3.Lens as Lens
type Point = Point Float Float
type Fill
  = Solid Color
  | LinearGradient Color Color Float
  | RadialGradient Color Color Point
  | NoFill


solid : Lens.OneCase Fill Color
solid =
  let 
    get big =
      case big of
        Solid color ->
          Just color
        _ ->
          Nothing
  in
    Lens.oneCase get Solid
