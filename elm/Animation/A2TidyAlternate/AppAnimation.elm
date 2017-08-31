module Animation.A2TidyAlternate.AppAnimation exposing (..)

import Animation.A2Tidy.Types exposing (AnimationModel)

import Svg exposing (Svg)
import Animation

-- Tag attributes (including styles) that a particular shape
-- never animates.
type FixedPart msg =
  HasFixedPart (List (Svg.Attribute msg))

type alias ShapeFunction msg =
  List (Svg.Attribute msg) -> List (Svg msg) -> Svg msg

type Shape msg =
  Shape (ShapeFunction msg)
  
animatable : Shape msg -> FixedPart msg -> AnimationModel
          -> Svg msg
animatable (Shape shape) (HasFixedPart attributes) animationModel =
  shape
    (attributes ++ Animation.render animationModel)
    []
