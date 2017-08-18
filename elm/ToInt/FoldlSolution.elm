module ToInt.FoldlSolution exposing (..)

-- Problem 1
reverse : List a -> List a
reverse list =
  List.foldl (::) [] list

-- Problem 2:

map1 : (a -> b) -> List a -> List b
map1 f list =
  let
    step : a -> List b -> List b
    step a acc =
      (f a) :: acc
  in
    list
      |> List.foldl step []
      |> reverse

map2 : (a -> b) -> List a -> List b
map2 f list =
  let
    step : a -> List b -> List b
    step a acc =
      acc ++ [(f a)]
  in
    List.foldl step [] list


-- Problem 3

subtractAll : number -> List number -> number
subtractAll startingValue subtrahends =
  List.foldl (flip (-)) startingValue subtrahends
