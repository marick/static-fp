module IVBits.ValidatorsSolution exposing
  ( ValidatedString
  , dripRate
  , hours
  , minutes
  )

import Maybe.Extra as Maybe
import Random exposing (maxInt)

-- Elm creates a `ValidatedString` constructor, which I'll reimplement
-- because PureScript doesn't do the same.
type alias ValidatedString a =
  { literal : String
  , value : Maybe a
  }

asValidated : String -> Maybe a -> ValidatedString a
asValidated literal value =
  { literal = literal
  , value = value
  }

-- Exported functions

dripRate : String -> ValidatedString Float
dripRate candidate =
  { literal = "", value = Nothing}

{-      
  Note: there's a bug in 0.18 Elm such that `String.toInt "-"`
  produces a `NaN` rather than an error. Moreover, `isNan` doesn't
  work on it - it expects a Float.
  https://github.com/elm-lang/core/issues/831

  Because NaN is larger than any value, `a >= 0` check succeeds
  for the input "-". NaN is smaller than any value, so we ask
  if the parse result is less than maxint which, alas, is only
  available from Random.
-}
      
hours : String -> ValidatedString Int
hours candidate = 
  { literal = "", value = Nothing}

      
minutes : String -> ValidatedString Int
minutes candidate = 
  { literal = "", value = Nothing}

