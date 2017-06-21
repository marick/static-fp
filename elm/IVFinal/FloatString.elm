module IVFinal.FloatString exposing
  ( FloatString
  , fromFloat
  , fromString
  )

import Tagged exposing (Tagged(..))
import IVFinal.Util.AppTagged exposing (UnusableConstructor)

type alias FloatString = Tagged FloatStringTag String

fromFloat : Float -> FloatString
fromFloat float =
  Tagged (toString float)

fromString : FloatString -> String -> FloatString
fromString default string =
  case String.toFloat string of
    Err _ -> default
    Ok float -> fromFloat float

--- Support for tagging

type FloatStringTag = FloatStringTag UnusableConstructor

