module Structure.BadSplit.Main exposing (..)

import List.Extra as List
import Structure.BadSplit.One as One exposing (One)
import Structure.BadSplit.Two as Two exposing (Two)

interleave : List String -> List Float -> One
interleave strings floats =
  interleavePairs <| List.zip strings floats

interleavePairs : List (String, Float) -> One    
interleavePairs pairs = 
  case pairs of
      [] ->
        One.Stop
      (string, float) :: tail ->
        One.Link string
                 (Two.Link float
                           (interleavePairs tail))
