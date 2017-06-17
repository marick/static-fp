module Animation.A2Tidy.AppAnimation exposing (..)

import Animation.A2Tidy.Types exposing (AnimationModel)

import Svg exposing (Svg)
import Animation

-- Tag attributes (including styles) that a particular shape
-- never animates.
type FixedPart msg =
  HasFixedPart (List (Svg.Attribute msg))

type alias Shape msg =
  List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg
  
animatable : Shape msg -> FixedPart msg -> AnimationModel
          -> Svg msg
animatable shape (HasFixedPart attributes) animatedPart =
  shape
    (attributes ++ Animation.render animatedPart)
    []
