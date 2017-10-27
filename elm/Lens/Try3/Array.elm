module Lens.Try3.Array exposing
  ( lens
  )

import Lens.Try3.Lens as Lens
import Array exposing (Array)

lens : Int -> Lens.Humble (Array val) val
lens index =
  Lens.humble (Array.get index) (Array.set index)

