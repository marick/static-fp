module Lens.Final.Array exposing
  ( humbleLens
  , pathLens
  )

import Lens.Final.Lens as Lens
import Array exposing (Array)

humbleLens : Int -> Lens.Humble (Array val) val
humbleLens index =
  Lens.humble (Array.get index) (Array.set index)

pathLens : Int -> Lens.Path (Array val) val
pathLens index =
  Lens.path index (Array.get index) (Array.set index)


