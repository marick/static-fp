module Lens.Motivation.WithLenses.Animal exposing
  ( Animal
  , Id
  , addTag
  )

import Array exposing (Array)
import Lens.Try3.Lens as Lens

type alias Id = Int
type alias Tags = Array String

type alias Animal =
  { id : Id
  , name : String
  , tags : Tags
  }

tags : Lens.Classic Animal Tags
tags = Lens.classic .tags (\tags animal -> { animal | tags = tags })
  
-- Note: let's make it the UI's job to disallow duplicate tags.
addTag : String -> Animal -> Animal
addTag tag animal = 
  Lens.update tags (Array.push tag) animal
