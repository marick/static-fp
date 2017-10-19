module Lens.Motivation.WithLenses.Animal exposing (..)

import Array exposing (Array)
import Lens.Try2.Lens as Lens exposing (Lens)

type alias Id = Int
type alias Tags = Array String

type alias Animal =
  { tags : Tags
  , id : Id
  }

tags : Lens Animal Tags
tags = Lens.lens .tags (\tags animal -> { animal | tags = tags })
  

addTagToAnimal : String -> Animal -> Animal
addTagToAnimal tag animal = 
  Lens.update tags (Array.push tag) animal

addTagToTags : String -> Tags -> Tags
addTagToTags = Array.push 

    
