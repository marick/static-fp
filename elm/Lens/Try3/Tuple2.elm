module Lens.Try3.Tuple2 exposing
  ( first
  , second
  )

import Lens.Try3.Lens as Lens exposing (ClassicLens)

first : ClassicLens (focus, a) focus
first =
  Lens.classic
    (\ (first, _) -> first)
    (\ first (_, second) -> (first, second))
      
second : ClassicLens (a, focus) focus
second =
  Lens.classic
    (\ (_, second) -> second)
    (\ second (first, _) -> (first, second))
