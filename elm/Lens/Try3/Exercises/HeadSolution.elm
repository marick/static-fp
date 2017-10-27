module Lens.Try3.Exercises.HeadSolution exposing
  ( lens
  )

import Lens.Try3.Lens as Lens

lens : Lens.Humble (List val) val
lens =
  let 
    set small big =
      case big of
        [] ->
          big
        _ :: xs -> 
          small :: xs
  in
    Lens.humble List.head set
