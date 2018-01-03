module Lens.Final.Maybe exposing
  ( justLens
  )

import Lens.Final.Lens as Lens

justLens : Lens.OneCase (Maybe a) a
justLens =
  Lens.oneCase identity Just
