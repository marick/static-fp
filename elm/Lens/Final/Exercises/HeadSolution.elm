module Lens.Final.Exercises.HeadSolution exposing
  ( lens
  )

import Lens.Final.Lens as Lens

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
