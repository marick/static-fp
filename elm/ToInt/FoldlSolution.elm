module ToInt.FoldlSolution exposing (..)

import Char

-- Problem 1:

toInt : String -> Int
toInt string =
  let
    step char acc =
      10 * acc + charToDigit char
  in
    String.foldl step 0 string

charToDigit : Char -> Int 
charToDigit char =
  Char.toCode char - Char.toCode '0'
      

-- Problem 2:

reverse : List a -> List a
reverse list =
  List.foldl (::) [] list

-- Problem 3:

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


-- Problem 4:

subtractAll : number -> List number -> number
subtractAll startingValue subtrahends =
  List.foldl (flip (-)) startingValue subtrahends
