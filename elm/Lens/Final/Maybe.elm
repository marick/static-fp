module Lens.Final.Maybe exposing
  ( just
  )

import Lens.Final.Lens as Lens

just : Lens.OneCase (Maybe a) a
just =
  Lens.oneCase identity Just

