module Lens.Try3.Exercises.ComposeLenses.Array exposing
  ( lens
  )

-- This file has a predefined lens for the Compose exercise.

import Lens.Try3.Exercises.Compose as Lens
import Array exposing (Array)

lens : Int -> Lens.Humble (Array val) val
lens index =
  Lens.humble (Array.get index) (Array.set index)

