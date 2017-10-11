module Lens.Tuple2 exposing
  ( first
  , second
  )

import Lens.Lens as Lens exposing (Lens)

first : Lens (focus, a) focus
first =
  Lens.make
    (\ (first, _) -> first)
    (\ first (_, second) -> (first, second))
      
second : Lens (a, focus) focus
second =
  Lens.make
    (\ (_, second) -> second)
    (\ second (first, _) -> (first, second))
