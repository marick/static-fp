module Choose.ExampleWithout.Animal exposing (..)

import Array exposing (Array)

type alias Id = Int

type alias Animal =
  { tags : Array String
  , id : Id
  }

addTag : String -> Animal -> Animal
addTag tag animal = 
  { animal | 
      tags = Array.push tag animal.tags
  }
