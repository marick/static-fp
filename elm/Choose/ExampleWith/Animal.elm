module Choose.ExampleWith.Animal exposing (..)

import Choose.Part as Part exposing (Part)
import Array exposing (Array)

type alias Id = Int

type alias Animal =
  { tags : Array String
  , id : Id
  }

tags : Part Animal (Array String)
tags = Part.make .tags (\tags animal -> { animal | tags = tags })
