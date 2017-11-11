module Dict.FoldlSolution exposing (..)

import Dict exposing (Dict)

-- Exercise 1

fromList : List (comparable, v) -> Dict comparable v
fromList list = 
  let
    step (k, v) acc =
      Dict.insert k v acc
  in
    List.foldl step Dict.empty list

-- Exercise 2

reverse : Dict comparableKey comparableVal
       -> Dict comparableVal comparableKey
reverse dict = 
  let
    step k v acc =
      Dict.insert v k acc
  in
    Dict.foldl step Dict.empty dict

-- Exercise 3
      
toList : Dict comparable val -> List (comparable, val)
toList dict =
  let
    step k v acc =
      (k, v) :: acc
  in
    dict
      |> Dict.foldl step []
      |> List.foldl (::) [] -- or `List.reverse`


-- Exercise 4

uncurry : (a1 -> a2 -> r) -> (a1, a2) -> r
uncurry fnTaking2Args (arg1, arg2) =
  fnTaking2Args arg1 arg2

curry : ( (a1, a2) -> r) -> a1 -> a2 -> r
curry fnTakingTuple arg1 arg2 =
  fnTakingTuple (arg1, arg2)


-- Exercise 5

map : (comparable -> a -> b) -> Dict comparable a -> Dict comparable b
map f dict =
  let
    step (key, value) acc =
      Dict.insert key (f key value) acc
  in
    dict
      |> Dict.toList
      |> List.foldl step Dict.empty
  

-- Exercise 6

withValue : (value -> result) -> (key -> value -> result)
withValue f key = f 
  
