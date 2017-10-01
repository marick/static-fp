module Choose.Common.Tuple2 exposing
  ( first
  , second
  )

import Choose.Part as Part exposing (Part)

first : Part (focus, a) focus
first =
  Part.make
    (\ (first, _) -> first)
    (\ first (_, second) -> (first, second))
      
second : Part (a, focus) focus
second =
  Part.make
    (\ (_, second) -> second)
    (\ second (first, _) -> (first, second))
