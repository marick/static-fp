module Lens.Final.Exercises.Head exposing
  ( lens
  )

import Lens.Final.Lens as Lens

lens : Lens.Humble (List val) val
lens = Lens.humble List.head (::)
