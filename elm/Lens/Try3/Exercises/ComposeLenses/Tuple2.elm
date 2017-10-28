module Lens.Try3.Exercises.ComposeLenses.Tuple2 exposing
  ( first
  )

-- This file has a predefined lens for the Compose exercise.

import Lens.Try3.Exercises.Compose as Lens

first : Lens.Classic (focus, a) focus
first =
  Lens.classic
    (\ (first, _) -> first)
    (\ first (_, second) -> (first, second))
