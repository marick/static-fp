module Structure.GoodSplit.Main exposing (..)

import List.Extra as List
import Structure.GoodSplit.One as One exposing (One)
import Structure.GoodSplit.Two as Two exposing (Two)

interleave : List String -> List Float -> One Two
interleave strings floats =
  interleavePairs <| List.zip strings floats

interleavePairs : List (String, Float) -> One Two
interleavePairs pairs = 
  case pairs of
      (string, float) :: remainder ->
        One.Link string (Two.Link float (interleavePairs remainder))
      _ ->
        One.Stop
