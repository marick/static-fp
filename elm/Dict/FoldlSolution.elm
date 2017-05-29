module Dict.FoldlSolution exposing (..)

import Dict exposing (Dict)
import Date exposing (Date)
import Date.Extra as Date
import Dict.PropertyValue as Value exposing (PropertyValue)


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

properties : Dict String PropertyValue
properties =
  Dict.fromList [
      ("int1", Value.Int 1)
    , ("int2", Value.Int 2)
    , ("date", Value.Date <| Date.fromCalendarDate 2017 Date.May 26)
    , ("false", Value.Bool False)
    , ("true", Value.Bool True)
    ]

toInts : Dict String PropertyValue -> Dict String Int
toInts properties =
  let
    step k v acc =
      case v of
        (Value.Int i) ->
          Dict.insert k i acc
        _ ->
          acc
  in
    Dict.foldl step Dict.empty properties

-- Exercise 5

uncurry : (a1 -> a2 -> r) -> (a1, a2) -> r
uncurry twoArgF (arg1, arg2) =
  twoArgF arg1 arg2

curry : ( (a1, a2) -> r) -> a1 -> a2 -> r
curry tupleF arg1 arg2 =
  tupleF (arg1, arg2)


-- Exercise 6

map : (comparable -> a -> b) -> Dict comparable a -> Dict comparable b
map f dict =
  let
    step (key, value) acc =
      Dict.insert key (f key value) acc
  in
    dict
      |> Dict.toList
      |> List.foldl step Dict.empty
  
