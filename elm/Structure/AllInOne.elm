module Structure.AllInOne exposing
  ( One(..)
  , Two(..)
  , interleave
  )

import List.Extra as List

type One 
  = LinkOne String Two
  | Stop

type Two
  = LinkTwo Float One

interleave : List String -> List Float -> One
interleave strings floats =
  interleavePairs <| List.zip strings floats

interleavePairs : List (String, Float) -> One    
interleavePairs pairs = 
  case pairs of
    [] ->
      Stop
    (string, float) :: tail ->
      LinkOne string
              (LinkTwo float
                       (interleavePairs tail))
