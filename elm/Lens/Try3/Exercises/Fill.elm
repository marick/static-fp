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


linearGradient : Lens.OneCase Fill (Color, Color, Float)
linearGradient =
  let 
    get big =
      case big of
        LinearGradient c1 c2 f ->
          Just (c1, c2, f)
        _ ->
          Nothing

    set (c1, c2, f) =
      LinearGradient c1 c2 f
  in
    Lens.oneCase get set
      
