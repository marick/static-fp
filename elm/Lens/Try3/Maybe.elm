module Lens.Try3.Maybe exposing
  ( just
  )

import Lens.Try3.Lens as Lens

just : Lens.OneCase (Maybe a) a
just =
  Lens.oneCase identity Just

