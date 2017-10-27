module Lens.Try3.Exercises.Head exposing
  ( lens
  )

import Lens.Try3.Lens as Lens

lens : Lens.Humble (List val) val
lens = Lens.humble List.head (::)
