module Lens.Try4.Maybe exposing
  ( just
  )

import Lens.Try4.Lens as Lens

just : Lens.OneCase (Maybe a) a
just =
  Lens.oneCase identity Just

