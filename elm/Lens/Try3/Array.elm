module Lens.Try3.Array exposing
  ( lens
  , alarmistLens
  )

import Lens.Try3.Lens as Lens
import Lens.Try3.Compose as Compose
import Array exposing (Array)

lens : Int -> Lens.Humble (Array val) val
lens index =
  Lens.humble (Array.get index) (Array.set index)

alarmistLens : Int -> Lens.Alarmist (Array val) val
alarmistLens index =
  Lens.alarmist index (Array.get index) (Array.set index)


