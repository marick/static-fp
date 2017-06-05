module IvArchitecture.Common.Measures exposing (..)

import Tagged exposing (Tagged(..))
import IvArchitecture.Common.Tagged exposing (UnusableConstructor)

type alias DropsPerSecond = Tagged DropsPerSecondTag Float
type alias FloatString = Tagged FloatStringTag String

dripRate : Float -> DropsPerSecond
dripRate = Tagged
  
toDripRate : DropsPerSecond -> String -> DropsPerSecond
toDripRate default candidate =
  case String.toFloat candidate of
    Err _ ->
      default
    Ok float ->
      dripRate float

toFloatString : Float -> FloatString
toFloatString float =
  Tagged (toString float)

--- Support for tagging

type FloatStringTag = FloatStringTag UnusableConstructor
type DropsPerSecondTag = DropsPerSecondTag UnusableConstructor

