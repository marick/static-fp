module Choose.ExampleWith.Animal exposing (..)

import Choose.Lens as Lens exposing (Lens)
import Array exposing (Array)

type alias Id = Int
type alias Tags = Array String

type alias Animal =
  { tags : Tags
  , id : Id
  }

tags : Lens Animal Tags
tags = Lens.make .tags (\tags animal -> { animal | tags = tags })

addTag : String -> Tags -> Tags
addTag = Array.push
