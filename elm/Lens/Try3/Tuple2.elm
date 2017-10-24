module Lens.Try3.Tuple2 exposing
  ( first
  , second
  )

import Lens.Try3.Lens as Lens

first : Lens.Classic (focus, a) focus
first =
  Lens.classic
    (\ (first, _) -> first)
    (\ first (_, second) -> (first, second))
      
second : Lens.Classic (a, focus) focus
second =
  Lens.classic
    (\ (_, second) -> second)
    (\ second (first, _) -> (first, second))
