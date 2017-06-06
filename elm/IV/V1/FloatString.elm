module IV.V1.FloatString exposing
  ( FloatString
  , fromFloat
  , fromString
  )

import Tagged exposing (Tagged(..))
import IV.Common.Tagged exposing (UnusableConstructor)

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

