module Lens.Motivation.WithoutLenses.Animal exposing (..)

import Array exposing (Array)

type alias Id = Int

type alias Animal =
  { id : Id
  , name : String
  , tags : Array String
  }

addTag : String -> Animal -> Animal
addTag tag animal = 
  { animal | 
      tags = Array.push tag animal.tags
  }
