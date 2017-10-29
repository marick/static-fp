module Lens.Motivation.WithLenses.Animal exposing (..)

import Array exposing (Array)
import Lens.Try3.Lens as Lens

type alias Id = Int
type alias Tags = Array String

type alias Animal =
  { tags : Tags
  , id : Id
  }

tags : Lens.Classic Animal Tags
tags = Lens.classic .tags (\tags animal -> { animal | tags = tags })
  
-- Note: let's make it the UI's job to disallow duplicate tags.
addTag : String -> Animal -> Animal
addTag tag animal = 
  Lens.update tags (Array.push tag) animal

addTagToTags : String -> Tags -> Tags
addTagToTags = Array.push 

emptyTags : Animal -> Animal
emptyTags = Lens.set tags Array.empty 
