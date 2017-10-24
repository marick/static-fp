module Lens.Try3.Array exposing
  ( lens
  )

import Lens.Try3.Lens as Lens
import Array exposing (Array)

lens : Int -> Lens.Iffy (Array val) val
lens index =
  Lens.iffy (Array.get index) (Array.set index)

