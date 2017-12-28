module Lens.Motivation.WithLenses.Animal exposing
  ( Animal
  , Id
  , named
  , addTag
  , clearTags
  )

import Array exposing (Array)
import Lens.Final.Lens as Lens

type alias Id = Int
type alias Tags = Array String

type alias Animal =
  { id : Id
  , name : String
  , tags : Tags
  }

named : String -> Id -> Animal
named name id =
  { id = id
  , name = name
  , tags = Array.empty
  }


tags : Lens.Classic Animal Tags
tags = Lens.classic .tags (\tags animal -> { animal | tags = tags })

       

clearTags : Animal -> Animal
clearTags = Lens.set tags Array.empty 

-- Note: let's make it the UI's job to disallow duplicate tags.
addTag : String -> Animal -> Animal
addTag tag animal = 
  Lens.update tags (Array.push tag) animal
