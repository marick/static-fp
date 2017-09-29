module Dict.Foldl exposing (..)

import Dict exposing (Dict)

-- Exercise 1

fromList : List (comparable, v) -> Dict comparable v
fromList list =
  Dict.empty

-- Exercise 2
    
reverse : Dict comparableKey comparableVal
       -> Dict comparableVal comparableKey
reverse dict =
  Dict.empty


-- Exercise 3
      
toList : Dict comparable val -> List (comparable, val)
toList dict =
  []


-- Exercise 4

-- These are commented out because I can't think of a way to write
-- functions that match the type annotation that *isn't* correct.

{-
uncurry : (a1 -> a2 -> r) -> (a1, a2) -> r
uncurry twoArgF (arg1, arg2) =

curry : ( (a1, a2) -> r) -> a1 -> a2 -> r
curry tupleF arg1 arg2 =
-}
    
-- Exercise 5

map : (comparable -> a -> b) -> Dict comparable a -> Dict comparable b
map f dict =
  Dict.empty


-- Exercise 6

