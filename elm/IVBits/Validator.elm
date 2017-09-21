module IVBits.Validator exposing
  ( minutes
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
