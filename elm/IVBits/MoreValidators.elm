module IVBits.MoreValidators exposing
  ( dripRate
  , hours
  , minutes
  )

import IVBits.ValidatedString as ValidatedString exposing (ValidatedString)
import Maybe.Extra as Maybe

dripRate : String -> ValidatedString Float
dripRate =
  createVia
    String.toFloat
    (\ float -> float > 0 && float <= 100.0)

hours : String -> ValidatedString Int
hours = 
  createVia
    String.toInt
    (\ i -> i >= 0 && i <= 24)       -- over a day is just being silly.
      
minutes : String -> ValidatedString Int
minutes =
  createVia
    String.toInt
    (\i -> i >= 0 && i < 60)



-- Util      

createVia : (String -> Result err a)  -- string parser
         -> (a -> Bool)               -- parses, but is it valid?
         -> String                    -- single argument to created function.
         -> ValidatedString a
createVia parser validator string =
  string
    |> String.trim
    |> parser
    |> Result.toMaybe
    |> Maybe.filter validator
    |> ValidatedString.make string
