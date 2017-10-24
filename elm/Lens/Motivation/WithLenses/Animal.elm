module Lens.Motivation.WithLenses.Animal exposing (..)

import Array exposing (Array)
import Lens.Try3.Lens as Lens exposing (ClassicLens)

type alias Id = Int
type alias Tags = Array String

type alias Animal =
  { tags : Tags
  , id : Id
  }

tags : ClassicLens Animal Tags
tags = Lens.classic .tags (\tags animal -> { animal | tags = tags })
  
-- Note: let's make it the UI's job to disallow duplicate tags.
addTagToAnimal : String -> Animal -> Animal
addTagToAnimal tag animal = 
  Lens.update tags (Array.push tag) animal

addTagToTags : String -> Tags -> Tags
addTagToTags = Array.push 
