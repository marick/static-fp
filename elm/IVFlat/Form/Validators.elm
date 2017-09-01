module IVFlat.Form.Validators exposing
  ( dripRate
  , hours
  , minutes
  )

{- The logic backing the three form input fields. Each is a `ValidatedString`,
but they're given their own type aliases for convenience.
-}

import IVFlat.Generic.Measures as Measure
import IVFlat.Generic.ValidatedString as ValidatedString exposing (ValidatedString)
import IVFlat.Generic.Measures as Measure
import Maybe.Extra as Maybe
import Random

-- Exported functions

{- Create a DripRate from a string. The string must parse into a
Float strictly greater than zero.
-}
dripRate : String -> ValidatedString Measure.DropsPerSecond
dripRate =
  createVia
    String.toFloat
    (\ float -> not (isInfinite float) && float > 0)
    Measure.dripRate

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
      
{- Create a `Minutes` from a string. The string must parse into an
int >= 0
-}
hours : String -> ValidatedString Measure.Hours
hours = 
  createVia
    String.toInt
    (\ i -> i >= 0 && i <= Random.maxInt)
    Measure.hours
      
{- Create a `Minutes` from a string. The string must parse into an
an integer in the range [0, 59].
-}
minutes : String -> ValidatedString Measure.Minutes
minutes =
  createVia
    String.toInt
    (\i -> i >= 0 && i < 60)
    Measure.minutes



-- Util      

createVia : (String -> Result err base)  -- string parser
         -> (base -> Bool)               -- parses, but is it valid?
         -> (base -> measure)            -- convert to measure
         -> String                       -- single argument to created function.
         -> ValidatedString measure
createVia parser validator converter string =
  string
    |> String.trim
    |> parser
    |> Result.toMaybe
    |> Maybe.filter validator
    |> Maybe.map converter
    |> ValidatedString.checked string
