module IVBits.ValidatorsSolution exposing
  ( ValidatedString
  , hours
  , minutes
  )

import Maybe.Extra as Maybe

type alias ValidatedString a =
  { literal : String
  , value : Maybe a
  }

validated : String -> Maybe a -> ValidatedString a
validated literal value =
  { literal = literal
  , value = value
  }

-- Exported functions

-- version before refactoring
originalHours : String -> ValidatedString Int
originalHours candidate =
  let
    positive = \i -> i >= 0 -- could be ((<=) 0) but ick.
  in
    candidate
      |> String.trim 
      |> String.toInt 
      |> Result.toMaybe
      |> Maybe.filter positive
      |> validated candidate


createVia : (Int -> Bool) -> String -> ValidatedString Int
createVia filter candidate =
  candidate
    |> String.trim
    |> String.toInt
    |> Result.toMaybe
    |> Maybe.filter filter
    |> validated candidate
         
hours : String -> ValidatedString Int
hours =
  createVia (\i -> i >= 0)

minutes : String -> ValidatedString Int
minutes =
  createVia (\i -> i >= 0 && i <= 59)
