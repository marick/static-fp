module IVBits.Validator exposing
  ( minutes
  , hours
  , dripRate
  )

import IVBits.ValidatedString as ValidatedString exposing (ValidatedString)
import Maybe.Extra as Maybe

minutes : String -> ValidatedString Int
minutes string = 
  string
    |> String.toInt
    |> Result.toMaybe
    |> Maybe.filter (\i -> i >= 0 && i < 60)
    |> ValidatedString.make string

-- Placeholders for readers who want to work more with validation.       

hours : String -> ValidatedString Int
hours string =
  ValidatedString.make string Nothing


dripRate : String -> ValidatedString Float
dripRate string =
  ValidatedString.make string Nothing
    
