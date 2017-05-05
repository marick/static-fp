module Maybe.ThreeSolution exposing (..)

values : List (Maybe a) -> List a
values xs =
  List.filterMap identity xs
