module Choose.ExampleWith.Animal exposing (..)

import Choose.Part as Part exposing (Part)
import Array exposing (Array)

type alias Id = Int
type alias Tags = Array String

type alias Animal =
  { tags : Tags
  , id : Id
  }

tags : Part Animal Tags
tags = Part.make .tags (\tags animal -> { animal | tags = tags })

addTag : String -> Tags -> Tags
addTag = Array.push
