module ToInt.FixedString exposing (toInt)

import ToInt.TestAccess.FixedString exposing (..)
import Maybe.Extra as Maybe

toInt : String -> Result String Int
toInt original =
  original
    |> componentize maxLength
    |> Maybe.andThen calculate
    |> Maybe.unwrap (err original) Ok

