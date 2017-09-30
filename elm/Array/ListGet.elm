module Array.ListGet exposing (..)


-- This shows that lists are
-- traversed in linear time.

get : Int -> (List a) -> Maybe a
get n list =
  case compare n 0 of
    LT -> Nothing
    EQ -> List.head list
    GT ->
      case list of
        [] -> Nothing
        _ :: tail -> get (n-1) tail

