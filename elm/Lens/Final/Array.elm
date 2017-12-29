module Lens.Final.Array exposing
  ( lens
  , pathLens
  )

import Lens.Final.Lens as Lens
import Array exposing (Array)

lens : Int -> Lens.Humble (Array val) val
lens index =
  Lens.humble (Array.get index) (Array.set index)

pathLens : Int -> Lens.Path (Array val) val
pathLens index =
  Lens.path index (Array.get index) (Array.set index)


