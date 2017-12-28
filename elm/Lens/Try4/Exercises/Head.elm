module Lens.Try4.Exercises.Head exposing
  ( lens
  )

import Lens.Try4.Lens as Lens

lens : Lens.Humble (List val) val
lens = Lens.humble List.head (::)
