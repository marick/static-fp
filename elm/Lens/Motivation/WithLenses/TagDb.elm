module Lens.Motivation.WithLenses.TagDb exposing
  ( TagDb
  , empty
  , tags
  , ids
  , addAnimal
  , addTag
  )

import Lens.Motivation.WithLenses.TestAccess.TagDb as Support exposing (..)

import Lens.Motivation.WithLenses.Animal as Animal
import Lens.Try3.Lens as Lens
import Dict exposing (Dict)
import Array exposing (Array)


type alias TagDb = Support.TagDb

empty : TagDb  
empty =
  { allTags = Dict.empty
  , allIds = Dict.empty
  }

tags : Animal.Id -> TagDb -> Maybe (Array String)
tags = idTags >> Lens.get

ids : String -> TagDb -> Maybe (Array Animal.Id)
ids = tagIds >> Lens.get
    
addAnimal : Animal.Id -> List String -> TagDb -> TagDb
addAnimal id tags db =
  let
    withId =
      Lens.set (idTags_upsert id) (Just Array.empty) db
  in
    List.foldl (addTag id) withId tags
  

addTag : Animal.Id -> String -> TagDb -> TagDb
addTag id tag db = 
    db
      |> updateIdTags id (Array.push tag)
      |> updateTagIds tag (Array.push id)


--- Helpers

type alias StringsMapper = Array String -> Array String
type alias IdsMapper = Array Animal.Id -> Array Animal.Id

updateIdTags : Animal.Id -> StringsMapper -> TagDb -> TagDb
updateIdTags id = 
  Lens.update (idTags id)

updateTagIds: String -> IdsMapper -> TagDb -> TagDb
updateTagIds tag =
  Lens.updateWithDefault (tagIds_upsert tag) Array.empty

    
         
