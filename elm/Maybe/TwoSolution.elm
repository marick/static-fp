module Maybe.TwoSolution exposing (..)

secondCharacter : String -> Maybe Char
secondCharacter string =
  string
    |> String.uncons
    |> Maybe.map Tuple.second
    |> Maybe.andThen String.uncons
    |> Maybe.map Tuple.first
