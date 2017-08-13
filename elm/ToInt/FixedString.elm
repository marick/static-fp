module ToInt.FixedString exposing
  (toInt
  )

import ToInt.FixedStringSupport as S
import Maybe.Extra as Maybe

toInt : String -> Result String Int
toInt original =
  original
    |> S.componentize S.maxLength
    |> Maybe.andThen S.calculate
    |> Maybe.unwrap (S.err original) Ok

